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
PRINTF="/usr/bin/printf"

THIS="`echo $0 | $SED 's/.*\/\([^\/]*\)/\1/'`"

### define constants

NOFILTER=1
QUIET=1
FILE="UnicodeData.txt" # get it from ftp://ftp.unicode.org/Public/UNIDATA/UnicodeData.txt and look at http://www.unicode.org/reports/tr44/#General_Category_Values

### define help strings

USAGE="$THIS [-h] | [-f FILTER] [-v] [UNICODEDATAFILE]"
usage() {
  echo "$USAGE" >&2
  exit 1
}

HELP="\t-f FILTER\t Filter out certain types (e.g. 'Lu', 'Lc')
\t-h\t\t Show this message
\t-v\t\t Be verbose
\tUNICODEDATAFILE\t The file containing the unicode data
\t\t\t (defaults to '$FILE')"

### parse command line options

OUTDIR="."
while getopts "f:hv" O
do
  case "$O" in
    f) # filter result
      NOFILTER=0
      FILTER="$OPTARG"
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

if [ $NOFILTER -eq 0 ] && [ -z "$FILTER" ]
then
  echo "Error: No or empty filter!" >&2
  usage
fi

if [ $# -gt 1 ]
then
  echo "Error: Too many files specified!" >&2
  usage
elif [ $# -eq 1 ]
then
  FILE="$1"
fi

if [ ! -f "$FILE" ]
then
  echo "Error: File '$FILE' not found!" >&2
  exit 1
fi

HEX="[0-9A-F]"
SEDSTRA="/$HEX.*;[^;]*;$FILTER/ {s/;.*$//; p;}"
SEDSTRB=":a; $ bb; N; ba; :b; s/\n/\\\\u/g; s/^/\\\\u/; s/\\u00\([0-9]\)/\\x\1/g; s/\\\\u\($HEX\{5\}\)/\\\\U000\1/g; p;"
SEDSTRC="s/\\(\\\\[xuU]$HEX*\\)/\\1\\n/g"

OUTPUT="$($CAT "$FILE" | $SED -n "$SEDSTRA" | $SED -n "$SEDSTRB" | $SED "$SEDSTRC")"

for c in $OUTPUT
do
  $PRINTF "$c"
done
$PRINTF "\n"

exit 0
