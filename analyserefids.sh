#!/bin/sh

###
 # Copyright (c) 2017 d-r-p <d-r-p@users.noreply.github.com>
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

### define programs

CAT="/bin/cat"
SED="/bin/sed"
GREP="/bin/grep"
SORT="/usr/bin/sort"
UNIQ="/usr/bin/uniq"
DIFF="/usr/bin/diff"

THIS="`echo $0 | $SED 's/.*\/\([^\/]*\)/\1/'`"

### define output files

UNIQDORAREFIDSFILE="dora_refids_uniq.txt"
MISSINGREFIDSFILE="dora_refids_missing.txt"
MULTREFIDSFILE="dora_refids_multiple.txt"

### define constants

NOFILE=1
QUIET=1
DORAEXPORTFILE="RefList-DORA.xml"

### define help strings

USAGE="$THIS [-h] | [-f DORAEXPORTFILE] [-v] ACTIVEREFIDSFILE"
usage() {
  echo "$USAGE" >&2
  exit 1
}

HELP="\t-f DORAEXPORTFILE\t The file containing the DORA-export in RefWorks XML format
\t\t\t (defaults to '$DORAEXPORTFILE')
\t-h\t\t Show this message
\t-v\t\t Be verbose
\tACTIVEREFIDSFILE\t The file containing the list of used RefWorks IDs (one per line)"

### parse command line options

OUTDIR="."
while getopts "f:hv" O
do
  case "$O" in
    f) # specifiy the DORA export file
      NOFILE=0
      DORAEXPORTFILE="$OPTARG"
      ;;
    h) # show help
      echo "$USAGE" >&2
      echo "$HELP" >&2
      exit 0
      ;;
    v) # be verbose
      QUIET=0
      ;;
    \?) # unknown option, so show the usage and exit
      usage
      ;;
  esac
done

shift $(($OPTIND - 1))

if [ $NOFILE -eq 0 ] && [ -z "$DORAEXPORTFILE" ]
then
  echo "Error: No or empty DORA export file name!" >&2
  usage
fi

if [ $# -ne 1 ]
then
  echo "Error: Exactly one file with active RefWorks IDs expected!" >&2
  usage
elif [ $# -eq 1 ]
then
  ACTIVEREFIDSFILE="$1"
fi

if [ ! -f "$DORAEXPORTFILE" ]
then
  echo "Error: File '$DORAEXPORTFILE' not found!" >&2
  exit 1
fi

if [ ! -f "$ACTIVEREFIDSFILE" ]
then
  echo "Error: File '$ACTIVEREFIDSFILE' not found!" >&2
  exit 1
fi

### generate output

$SED -n '/reference.*id="/ { s/^.*id="\([^"]*\)".*$/\1/; p; }' "$DORAEXPORTFILE" | $SORT -n | $UNIQ > "$UNIQDORAREFIDSFILE"
$DIFF "$ACTIVEREFIDSFILE" "$UNIQDORAREFIDSFILE" | $GREP "< " | $SED 's/< //' > "$MISSINGREFIDSFILE"
$SED -n '/reference.*id="/ { s/^.*id="\([^"]*\)".*$/\1/; p; }' "$DORAEXPORTFILE" | $SORT -n | $UNIQ -d > "$MULTREFIDSFILE"

exit 0