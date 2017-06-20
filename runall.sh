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

SED="/bin/sed"
TIME="/usr/bin/time"
SORT="/usr/bin/sort"

DORAEXPORTCMD="./doraeawagoaiexport.py"
ANALYSEREFIDSCMD="./analyserefids.sh"
REFLIST2IDSCMD="./reflist2idcorrespondence.sed"

### define file names

DORAEXPORTFILE="RefList-DORA.xml"
ACTIVEREFIDSFILE="active_refids.txt"
IDFILE="refid-doraid.txt"

### do the jobs

$TIME $DORAEXPORTCMD -v
$ANALYSEREFIDSCMD -v -f "$DORAEXPORTFILE" "$ACTIVEREFIDSFILE"
$REFLIST2IDSCMD "$DORAEXPORTFILE" | $SORT -n | $SED '/^,eawag.*/ d;' > "$IDFILE"
