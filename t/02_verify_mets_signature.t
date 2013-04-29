#!/bin/sh

# TAP test plan

echo "1..1"

CWD="$(pwd)"
TMPDIR="$(mktemp -d)" || exit 1
EXTRACT="$CWD/src/extractZippedFile.sh"
VERIFY="$CWD/src/verifyMetsSignature.sh"
TESTFILES="$CWD/t/sip_test_files"

echo ok 1 - Test OK

mkdir -p "$TMPDIR"
cd "$TMPDIR"
$EXTRACT "$TESTFILES/csc_sip_testpackage_01.zip" "$TMPDIR"

rm -rf "$TMPDIR"
