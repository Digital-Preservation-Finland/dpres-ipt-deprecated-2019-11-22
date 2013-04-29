#!/bin/sh

# TAP test plan
echo "1..8"

CWD="`pwd`"
CMD="$CWD/src/extractZippedFile.sh"
TESTDIR_CWD="`mktemp -d`"
TESTDIR="`mktemp -d`"
TESTFILES="$CWD/t/sip_test_files"

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
[ $RETVAL -ne 0 ] && echo ok 1 Recognized broken content zip
[ $RETVAL -ne 0 ] || echo not ok 1 Failed to recognize broken content zip

# Test broken header zip file
clean; init
$CMD "$TESTFILES/test-broken-header.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 2 Recognized broken header zip
[ $RETVAL -ne 0 ] || echo not ok 2 Failed to recognize broken header zip


# Test long name zip file
clean; init
$CMD "$TESTFILES/test-longname.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -eq 0 ] && echo ok 3 Recognized long name zip
[ $RETVAL -eq 0 ] || echo not ok 3 Failed to recognize broken header zip

# Test not a zip file
clean; init
$CMD "$TESTFILES/test-notazip.zip" "$TESTDIR" 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 4 Recognized not a zip file
[ $RETVAL -ne 0 ] || echo not ok 4 Failed to recognize not a zip file


# Test correct zip files
test_zip() {
    clean ; init
    TESTNO=$1
    TESTFILE=$2
    $CMD "$TESTFILES/$TESTFILE" "$TESTDIR" 2>&1 > /dev/null
    RETVAL=$?
    [ $RETVAL -eq 0 ] && echo ok $TESTNO $TESTFILE extraction returned $RETVAL
    [ $RETVAL -eq 0 ] || echo not ok $TESTNO $TESTFILE extraction returned $RETVAL
}

test_zip 5 csc_sip_testpackage_01.zip
test_zip 6 csc_sip_testpackage_02.zip
test_zip 7 correct.zip
[ -f "$TESTDIR"/test.txt ] && echo ok 8 Extracted file was found
[ -f "$TESTDIR"/test.txt ] || echo not ok 8 Extracted file was found

clean



