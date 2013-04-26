#!/bin/sh

# Test count
echo 1..5

CWD="$(pwd)"
CMD="$CWD/src/unzip.sh"
TESTDIR="/tmp/ziptestdir.123214"
TESTFILES="$CWD/t/testfiles"
COMMENT_OUTPUT="2>&1 | sed 's/^/# /g'"

clean() {
cd $CWD
rm -rf "$TESTDIR"
}

init() {
mkdir "$TESTDIR"
cd "$TESTDIR"
}

clean; init

# Test broken content zip file
$CMD $TESTFILES/test-broken-content.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 1 Recognized broken content zip
[ $RETVAL -ne 0 ] || echo not ok 1 Failed to recognize broken content zip



clean; init

# Test broken header zip file
$CMD $TESTFILES/test-broken-header.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 2 Recognized broken header zip
[ $RETVAL -ne 0 ] || echo not ok 2 Failed to recognize broken header zip

clean; init

# Test long name zip file
$CMD $TESTFILES/test-longname.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -eq 0 ] && echo ok 3 Recognized long name zip
[ $RETVAL -eq 0 ] || echo not ok 3 Failed to recognize broken header zip


clean; init

# Test not a zip file
$CMD $TESTFILES/test-notazip.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 4 Recognized not a zip file
[ $RETVAL -ne 0 ] || echo not ok 4 Failed to recognize not a zip file

clean; init

# Test correct zip file
$CMD $TESTFILES/test-absolute.zip -d $TESTDIR 2>&1 > /dev/null
RETVAL=$?
[ $RETVAL -ne 0 ] && echo ok 5 Zip extracted succesfully
[ $RETVAL -ne 0 ] || echo not ok 5 Zip extraction failed

 #[ -f $TESTDIR/test.txt ] && echo ok 6 Content file found
#[ -f $TESTDIR/test.txt ] || echo not ok 6 Content file found

clean



