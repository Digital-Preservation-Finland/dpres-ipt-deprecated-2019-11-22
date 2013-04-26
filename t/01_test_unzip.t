#!/bin/sh

# Test count
echo 1..3

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

# Test broken zip file
$CMD $TESTFILES/broken.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -eq 3 ] && echo ok 1 Recognized broken zip
[ $RETVAL -eq 3 ] || echo not ok 1 Failed to recognize broken zip


###################################
clean; init

# Test broken content zip file
$CMD $TESTFILES/test-broken-content.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -eq 3 ] && echo ok 1 Recognized broken content zip
[ $RETVAL -eq 3 ] || echo not ok 1 Failed to recognize broken content zip


clean; init

# Test broken header zip file
$CMD $TESTFILES/test-broken-header.zip -d $TESTDIR 2>&1 >/dev/null
RETVAL=$?
[ $RETVAL -eq 3 ] && echo ok 1 Recognized broken header zip
[ $RETVAL -eq 3 ] || echo not ok 1 Failed to recognize broken header zip



###################################

clean; init

# Test correct zip file
$CMD $TESTFILES/test-absolute.zip -d $TESTDIR 2>&1 > /dev/null
RETVAL=$?
[ $RETVAL -eq 0 ] && echo ok 2 Zip extracted succesfully
[ $RETVAL -eq 0 ] || echo not ok 2 Zip extraction failed

[ -f $TESTDIR/test.txt ] && echo ok 3 Content file found
[ -f $TESTDIR/test.txt ] || echo not ok 3 Content file found

clean



