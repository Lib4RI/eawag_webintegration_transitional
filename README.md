# Eawag web-integration -- transitional

## Introduction

A set of tools related to obtaining all Eawag publications from the new institutional repository [DORA Eawag](https://www.dora.lib4ri.ch/eawag) via OAI and converting the resulting list into the format used at the moment for web-integration (a subset of RefWorks XML). In principle, one only needs `doraeawagoaiexport.py` and `oaimods2refworksxml.xsl`, the other files being tools. Notice also that some resources have to be downloaded separately.

## CAVEAT

THIS IS WORK IN PROGRESS!!! FOR THE MOMENT, IT SEEMS TO DO ITS JOB FOR US, BUT WE ARE AWARE THAT IT IS NOT CODED IN THE CORRECT WAY. DUE TO TIME CONSTRAINTS, THIS EVALUATION CODE WILL BE USED TEMPORARILY IN PRODUCTION, BUT WE HOPE TO UPDATE IT SOON. YOU SHOULD PROBABLY NOT USE THIS CODE YOURSELF, AS IT MIGHT NOT WORK FOR YOU OR EVEN BREAK YOUR SYSTEM (SEE ALSO 'License.md'). UNDER NO CIRCUMSTANCES WHATSOEVER ARE WE TO BE HELD LIABLE FOR ANYTHING. YOU HAVE BEEN WARNED.

## Requirements

This software was tested on x84_64 GNU/Linux using 
* [python](https://www.python.org) (2.7.9)
* [xmllint](http://xmlsoft.org) (20901)

## Installation

Clone this repository as usual. The minimum would be to download `doraeawagoaiexport.py` and `oaimods2refworksxml.xsl`.

## Usage (testing)

Run `runall.sh` to not only export the data from DORA, but also to analyse the available RefWorks IDs inside it (requires a file `active_refids.txt` containing the currently active RefWorks IDs!), as well as to generate a CSV list (`refid-doraid.txt`) containing the available RefWorks IDs and their corresponding DORA IDs.

## Usage (production)

1. Review `doraeawagoaiexport.py` and modify it according to your needs (especially webserver and file names, etc...)
2. Run `doraeawagoaiexport.py -v` and wait a few minutes (call with no option for less verbosity)
3. The resulting RefWorks XML can be found in the file held in variable `output3` (default is `RefList-DORA.xml`; in production, set this to your remote location on the webserver)

## Files in this repository

### `.gitignore`

This has been set to contain only the files currently in this repository. Specifically, it contains
```
/*

!/.gitignore
!/README.md
!/LICENSE.md
!/doraeawagoaiexport.py
!/oaimods2refworksxml.xsl
!/refworksxml2html.xsl
!/OtherResources.txt
!/unicodedata2utf8str.sh
!/analyserefids.sh
!/reflist2idcorrespondence.sed
!/runall.sh
```

### `README.md`

This file...

### `LICENSE.md`

The license under which this set of tools is distributed:
```
Copyright (c) 2016, 2017 d-r-p <d-r-p@users.noreply.github.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

### `doraeawagoaiexport.py`

The python script responsibe for the export.

Usage `doraeawagoaiexport.py [-v]`
* `-v`: Be verbose about what is going on

### `oaimods2refworksxml.xsl`

An extremely crude XSL to convert MODS XML nested in OAI XML into RefWorks XML. It tries to take care of different publication types and abbreviates first names, so that the resulting XML is populated in a way that will produce acceptable references. *CAVEAT*: It contains lots of UTF-8 characters, which can cause troubles with some editors (e.g. XEmacs).

@TODO: This XSL desperately needs to be re-written in a more state-of-the-art manner.

### `refworksxml2html.xsl`

An extremely crude XSL to convert RefWorks XML (as obtained from `oaimods2refworksxml.xml`, not the general one; the reason for that is that Eawag does only use a subset) into HTML citations that look similar to what is rendered on Eawag webpages. Additionally, different fields are coloured to make spotting mistakes a little easier. Note that this uses the file `EawagIconFont.woff` (see below).

@TODO: This XSL desperately needs to be re-written in a more state-of-the-art manner.

### `OtherResources.txt`

Locations of other files needed to make all tools run (or useful). Not needed in the minimum installation. Also, links will probably be broken... At the moment, the additional resources are:
* `EawagIconFont.woff`: Some icons used on the Eawag webpages; we only need the external link icon
* `UnicodeData.txt`: A list of all unicode characters (from [unicode.org](http://unicode.org)), used to get strings containing only certain types like uppercase characters (see below).

### `unicodedata2utf8str.sh`

A crude shell script printing unicode characters out of a unicode data file as `UnicodeData.txt` according to filters. It was used to generate strings of all uppercase and lowercase characters, which were needed in `oaimods2refworksxml.xsl`.

Usage `unicodedata2utf8str.sh [-f FILTER] [UNICODEDATAFILE]`
* `-f FILTER`: Specify the filter `FILTER` (e.g. `'Lu'`, `'Lc'`, ...; see [http://www.unicode.org/reports/tr44/#General_Category_Values](http://www.unicode.org/reports/tr44/#General_Category_Values) for details)
* `UNICODEDATAFILE`: A file in the format of `UnicodeData.txt`. If not specified, look for `UnicodeData.txt` in the current directory

### `analyserefids.sh`

This requires the file `active_refids.txt` (list of RefWorks IDs currently used on the webserver; one per line) and will generate three files that contain information about the RefWorks IDs inside DORA:
* `dora_refids_uniq.txt`: the list of unique RefWorks IDs currently in DORA
* `dora_refids_missing.txt`: the list of RefWorks IDs contained in the file `active_refids.txt`, but currently not in DORA
* `dora_refids_multiple.txt`: the list of RefWorks IDs present more than once inside DORA (helps finding duplicates)

### `reflist2idcorrespondence.sed`

Simple `sed` file that will generate a comma separated list of RefWorks IDs versus DORA IDs if run against the output file of `doraeawagoaiexport.py`.

### `runall.sh`

Basic tool that runs the other tools while preparing the migration. Exports (and times) the data in DORA, analyses the RefWorks IDs inside DORA and generates the ID-correspondence in the CSV file `refid-doraid.txt`. N.B.: You will need a file `active_refids.txt` containing all the RefWorks IDs currently used in the web pages (one per line).

## @TODO

* Re-write `oaimods2refworksxml.xsl` and `refworksxml2html.xsl`
* Split the download into two tools: one for retrieving and combining the OAI data, the other for the conversion
* Use `ElementParser` rather than `xmltodict` for parsing and combining the OAI data, as `xmltodict` does not seem to be easily available on all platforms


<br/><br/><br/>
> _This document is Copyright &copy; 2017 by d-r-p `<d-r-p@users.noreply.github.com>` and licensed under [CC&nbsp;BY&nbsp;4.0](https://creativecommons.org/licenses/by/4.0/)._