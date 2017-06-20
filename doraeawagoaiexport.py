#!/usr/bin/python

###
 # Copyright (c) 2016, 2017 d-r-p <d-r-p@users.noreply.github.com>
 #
 # Permission to use, copy, modify, and distribute this software for any
 # purpose with or without fee is hereby granted, provided that the above
 # copyright notice and this permission notice appear in all copies.
 #
 # THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 # WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 # MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 # ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 # WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 # ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 # OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###

### load stuff we need

import os
import codecs
import requests
import xmltodict # @TODO: avoid using this (use ElementTree instead) for greater cross-platform compatibility out-of-the-box
import sys
from collections import OrderedDict
from optparse import OptionParser
from re import sub, search, findall
from tempfile import NamedTemporaryFile

### define the webserver name (will be accessed via ssh-publickey; behaviour for password authentication is untested) and the path

#webserver = "webserver.somedomain.tld" # UNCOMMENT AND CHANGE THIS!!
#webpath = "/var/www/somepath" # no trailing slash! # UNCOMMENT AND CHANGE THIS!!

### define file names

oaimods2refworksxml_xsl = "oaimods2refworksxml.xsl"

output1   = "output_utf8.xml"
output2   = "output_utf8_lint.xml"
output2o  = "output_utf8_lint_old.xml"
output2oo = "output_utf8_lint_older.xml"
# interchange commenting of the two lines below when going productive!
output3   = "RefList-DORA.xml" # N.B.: NEW FILE NAME
#output3   = webserver + ":" + webpath + "/RefList-DORA.xml" # N.B.: NEW FILE NAME

### some constants

STDIN   = sys.stdin  #'/dev/stdin'
STDOUT  = sys.stdout #'/dev/stdout'
testing = True
testing = False # uncomment this if you are done testing

### redirect all output to stderr

oldstdout = sys.stdout
sys.stdout = sys.stderr

### say that we are testing, if we are

if testing:
  print "Notice: testing mode is active!"

### parse (and validate) the command line

if testing:
  print "Notice: \"" + " ".join(sys.argv) + "\" called"

usage = "Usage: %prog [-h|-v]"
parser = OptionParser(usage)
parser.add_option("-v", "--verbose",
  action = "store_true", dest = "verbose", default = False,
  help = "show what I'm doing [default=false]")
  
(opts, args) = parser.parse_args()

verbose = testing or opts.verbose # always be verbose while testing

if verbose:
  print "Notice: parsing command line"

if len(args) > 0:
  parser.error("no arguments allowed")

### check for cli-tools

if verbose:
  print "Notice: checking availability of command line tools"

last_osexec_rv = None # global variable that will store the last return value of executed shell command
def osexec(cmd, bufsize=256):
  cmd_suf = r'2>&1'
  cmd_redirs = len(findall(">", cmd))
  if cmd_redirs == 1 and search("[^12]>[^&]", cmd):
    cmd = sub("([^12])>", r'\1 ' + cmd_suf + r' >', cmd)
  elif cmd_redirs == 0:
    cmd = cmd + " " + cmd_suf
  cmd_fd = os.popen(cmd, 'r', bufsize)
  cmd_out = sub("\n$", "", cmd_fd.read())
  if cmd_out == None:
    cmd_out = ""
  cmd_rv = cmd_fd.close()
  if cmd_rv == None:
    cmd_rv = 0
  global last_osexec_rv
  last_osexec_rv = cmd_rv
  return cmd_out

which = "/usr/bin/which" # this should be o.k. on all platforms...

def get_clitool_uri(tool):
  if not isinstance(tool, basestring):
    return False
  uri = osexec(which + " " + tool)
  retval = last_osexec_rv
  if not retval == 0 or uri == "":
    return False
  return uri

def cli_uri(tool):
  uri = get_clitool_uri(tool)
  if uri == False:
    print "Error: CLI-tool \"" + tool + "\" not found."
    exit(1)
  return uri

test = cli_uri('test')
xsltproc = cli_uri('xsltproc')
xmllint = cli_uri('xmllint')
scp = cli_uri('scp')

### define access to DORA Eawag via OAI-PMH

if verbose:
  print "Notice: obtaining metadata through OAI-PMH"

base_url = "https://www.dora.lib4ri.ch/eawag/oai2"
verb = "ListRecords"
mdPrefix = "mods"

initial_payload = {'verb': verb, 'metadataPrefix': mdPrefix}

r = requests.get(base_url, params=initial_payload)
if r.status_code != 200:
  print "Error: something went wrong (got HTTP" + str(r.status_code) + ")";
  exit(1)
r.encoding = 'utf-8' # ensure utf8
r_dict = xmltodict.parse(r.text, encoding='utf-8')

if "error" in r_dict["OAI-PMH"]:
  print "Error: the OAI-server returned \"" + r_dict["OAI-PMH"]["error"]["@code"] + ": " + r_dict["OAI-PMH"]["error"]["#text"] + "\""
  exit(1)

record_list = []

for record in r_dict["OAI-PMH"]["ListRecords"]["record"]:
  record_list.append(record)

got = len(record_list)
total = (int(r_dict["OAI-PMH"]["ListRecords"]["resumptionToken"]["@completeListSize"]) if "resumptionToken" in r_dict["OAI-PMH"]["ListRecords"] else got)
to_go = total-got

if verbose:
  print "Notice: fetched " + str(got) + " records " + (" (" + (str(int(got*100/total)) + "%; " if total != 0 else "") + (str(to_go) + " to go" if to_go != 0 else "") + ")" if total != 0  and to_go != 0 else "")


while "resumptionToken" in r_dict["OAI-PMH"]["ListRecords"]:
  total  = int(r_dict["OAI-PMH"]["ListRecords"]["resumptionToken"]["@completeListSize"])
  cursor = int(r_dict["OAI-PMH"]["ListRecords"]["resumptionToken"]["@cursor"])
  if r_dict["OAI-PMH"]["ListRecords"]["resumptionToken"].has_key("#text"):
    rtoken = r_dict["OAI-PMH"]["ListRecords"]["resumptionToken"]["#text"]
  else:
    rtoken = ''
  payload = {'verb': verb, 'resumptionToken': rtoken}
  if payload['resumptionToken'] == '':
    break;
  r = requests.get(base_url, params=payload)
  if r.status_code != 200:
    print "Error: something went wrong (got HTTP" + str(r.status_code) + "); " + str(to_go) + " items were not retrieved"
    exit(1)
  r.encoding = 'utf-8' # ensure utf8
  r_dict = xmltodict.parse(r.text)
  if "error" in r_dict["OAI-PMH"]:
    print "Error: the OAI-server returned \"" + r_dict["OAI-PMH"]["error"]["@code"] + ": " + r_dict["OAI-PMH"]["error"]["#text"] + "\""
    exit(1)
  for record in r_dict["OAI-PMH"]["ListRecords"]["record"]:
    record_list.append(record)
  got_now = len(r_dict["OAI-PMH"]["ListRecords"]["record"])
  got = len(record_list)
  to_go  = total - got
  if verbose:
    print "Notice: fetched " + str(got_now) + " records" + (" (" + (str(int(got*100/total)) + "%; " if total != 0 else "") + (str(to_go) + " to go" if to_go != 0 else "") + ")" if total != 0 and to_go != 0 else "")
  if testing: # only do two rounds while testing
    break

if not testing and to_go != 0:
  print "Error: something went wrong:"; print str(to_go) + " items were not retrieved"
  exit(1)

### write references to a temporary file, prettyfied, then transform the XML

if verbose:
  print "Notice: writing dictionary with references to temporary XML file"

f_dict = r_dict
del f_dict["OAI-PMH"]["ListRecords"]
f_dict["OAI-PMH"]["ListRecords"] = OrderedDict()
f_dict["OAI-PMH"]["ListRecords"].update({'record' : record_list})

tmpfile_fd = NamedTemporaryFile(delete=False) # we need to keep the file since it is not opened correctly
tmpfile_fd.close()
f = codecs.open(tmpfile_fd.name, "w", "utf8")

success = False
try:
  f.write(xmltodict.unparse(f_dict, encoding='utf-8', pretty=True, indent='  '))
finally:
  success = True
  if verbose:
    print "Notice: successfully exported " + str(len(record_list)) + " references"
  f.close()
  if verbose:
    print "Notice: transforming XML file and storing result in \"" + output1 + "\""
  xsltproc_out = osexec(xsltproc + ' \'' + oaimods2refworksxml_xsl + '\' \'' + tmpfile_fd.name + '\' > \'' + output1 + '\'')
  if xsltproc_out != "":
    print xsltproc_out
  os.unlink(tmpfile_fd.name) # delete the temporary file (@TODO: make options to keep this file and re-use it)

if success == False or last_osexec_rv != 0:
  print "Error: something went wrong while transforming the OAI-export..."
  exit(1)

### reparse xml file with xmllint to ensure compatibility

if verbose:
  print "Notice: writing backups and reparsing XML files"

cmd = test + ' -f \'' + output2oo + '\' && /bin/rm \'' + output2oo + '\''
out = osexec(cmd)
if out != "":
  print out
if last_osexec_rv != 0:
  print "Warning: \"" + cmd + "\" returned " + str(last_osexec_rv)
cmd = test + ' -f \'' + output2o + '\' && /bin/mv \'' + output2o + '\' \'' + output2oo + '\''
out = osexec(cmd)
if out != "":
  print out
if last_osexec_rv != 0:
  print "Warning: \"" + cmd + "\" returned " + str(last_osexec_rv)
cmd = test + ' -f \'' + output2 + '\' && /bin/mv \'' + output2 + '\' \'' + output2o + '\''
out = osexec(cmd)
if out != "":
  print out
if last_osexec_rv != 0:
  print "Warning: \"" + cmd + "\" returned " + str(last_osexec_rv)
cmd = xmllint + ' \'' + output1 + '\' > \'' + output2 + '\''
out = osexec(cmd)
if out != "":
  print out
if last_osexec_rv != 0:
  print "Warning: \"" + cmd + "\" returned " + str(last_osexec_rv)

### upload to server

if verbose:
  print "Notice: uploading \"" + output2 + "\" to server"

cmd = scp + ' \'' + output2 + '\' \'' + output3 + '\''
out = osexec(cmd)
if out != "":
  print out
if last_osexec_rv != 0:
  print "Error: \"" + cmd + "\" returned " + str(last_osexec_rv)
  exit(1)

exit(0)
