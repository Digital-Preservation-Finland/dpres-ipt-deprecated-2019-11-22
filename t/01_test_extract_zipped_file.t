#!/bin/sh

# TAP test plan
echo "1..8"

CWD="`pwd`"
CMD="$CWD/src/extractZippedFile.sh"
TESTDIR_CWD="`mktemp -d`"
TESTDIR="`mktemp -d`"
TESTFILES="$CWD/t/sip_test_files"

# import common functions
. t/common_functions.sh

clean() {
    cd "$CWD"
    rm -rf "$TESTDIR"
    rm -rf "$TESTDIR_CWD"
}

init() {
    mkdir -p "$TESTDIR_CWD"
    mkdir -p  "$TESTDIR"
    cd "$TESTDIR_CWD"
}


# Test broken content zip file
clean; init
$CMD "$TESTFILES/test-broken-content.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
not_equals $RETVAL 0 Extract zip with broken content

# Test broken header zip file
clean; init
$CMD "$TESTFILES/test-broken-header.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
not_equals $RETVAL 0 Extract zip with broken header

# Test long name zip file
clean; init
$CMD "$TESTFILES/test-longname.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
equals $RETVAL 0 EXtract zip with long filenames

# Test not a zip file
clean; init
$CMD "$TESTFILES/test-notazip.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
not_equals $RETVAL 0 Extract not a zip file

# Test correct zip files
test_zip() {
    clean ; init
    TESTFILE=$1
    $CMD "$TESTFILES/$TESTFILE" "$TESTDIR" 2>&1 > /dev/null
    RETVAL=$?
    equals $RETVAL 0 Extract good zip $TESTFILE
}

test_zip csc_sip_testpackage_01.zip
test_zip csc_sip_testpackage_02.zip
test_zip correct.zip
is_file "$TESTDIR/test.txt" Extracted file was found

clean


