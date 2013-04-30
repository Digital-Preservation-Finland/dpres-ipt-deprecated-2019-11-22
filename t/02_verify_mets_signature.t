#!/bin/sh
# TAP test plan
echo "1..13"

# Common functions
. t/common_functions.sh || exit 1

CWD="$(pwd)"
TMPDIR="$(mktemp -d)" || exit 1
EXTRACT="$CWD/src/extractZippedFile.sh"
VERIFY="$CWD/src/verifyMetsSignature.sh"
TESTFILES="$CWD/t/sip_test_files"

equals 1 1 test equals

cd "$TMPDIR"

# Extract SIPs in zip file
mkdir $TMPDIR/SIP
$EXTRACT "$TESTFILES/csc_sip_testpackage_01.zip" "$TMPDIR/SIP" &> /dev/null

# Try to verify signature.
# This should fail because signature contained in test SIP is expired
cd $TMPDIR/SIP || exit 1
ls -d */ | while read sipdir ; do
    cd "$TMPDIR"
    $VERIFY "$TMPDIR/SIP/$sipdir" "$TESTFILES/../ssl/csc_test_expired_certificate.cert" &> /dev/null
    RETVAL=$?
    equals $RETVAL 1 Check expired signature
done

# Create fresh private key & certificate for signing SIP packages
SUBJ="/C=FI/ST=Uusimaa/L=Espoo/O=CSC/CN=ingest.localdomain"
CAFILE=$TMPDIR/ingest.localdomain.signature-test.cert
openssl req -new -newkey rsa:4096 -days 1 -nodes -x509 -subj "$SUBJ" -out $CAFILE -keyout $CAFILE &> /dev/null

# cat $CAFILE
# openssl x509 -in $CAFILE -text

# Calculate checksums for XML files to varmiste.sig
# and sign it with SMIME
cd $TMPDIR/SIP

ls -d */ | while read sipdir ; do
    cd "$TMPDIR/SIP/$sipdir"
    find . -name '*.xml' | while read filename ; do
        TMPFILE=`mktemp` || exit 2
        checksum=`sha1sum "${filename}" | awk '{ print $1 }'`
        echo "${filename}:sha1:$checksum" >> $TMPFILE
        openssl smime -sign -signer $CAFILE -in $TMPFILE  > varmiste.sig
        rm -f "$TMPFILE"
    done
done

# Verify new signed SIP signature
# This should return success because we have valid
# signature
cd "$TMPDIR/SIP"
ls -d */ | while read sipdir ; do
    cd "$TMPDIR"
    $VERIFY "$TMPDIR/SIP/$sipdir" "$CAFILE" &> /dev/null
    RETVAL=$?
    equals $RETVAL 0 Check good signature
done

# Alter some XML files and check signature
# This test should fail every time
cd "$TMPDIR/SIP"
ls -d */ | while read sipdir ; do
    cd "$TMPDIR"
    TEMPFILE="`mktemp`"
    cp "$TMPDIR/SIP/${sipdir}mets.xml" "$TEMPFILE"
    echo "broken" >> "$TMPDIR/SIP/${sipdir}mets.xml"
    $VERIFY "$TMPDIR/SIP/$sipdir" "$CAFILE" &> /dev/null
    RETVAL=$?
    equals $RETVAL 2 Check altered file mets.xml
    cp "$TEMPFILE" "$TMPDIR/SIP/${sipdir}mets.xml"
    rm -f "$TEMPFILE"
done

# Alter signature file varmiste.sig and check signature
# This test should fail every time
cd "$TMPDIR/SIP"
ls -d */ | while read sipdir ; do
    cd "$TMPDIR"
    TEMPFILE="`mktemp`"
    cp "$TMPDIR/SIP/${sipdir}varmiste.sig" "$TEMPFILE"
    sed -i 's/:sha1:/:sha2:/g' "$TMPDIR/SIP/${sipdir}varmiste.sig"
    $VERIFY "$TMPDIR/SIP/$sipdir" "$CAFILE" &> /dev/null
    RETVAL=$?
    equals $RETVAL 1 Check altered signature file varmiste.sig
    cp "$TEMPFILE" "$TMPDIR/SIP/${sipdir}varmiste.sig"
    rm -f "$TEMPFILE"
done

# Finally cleanup temporary files
rm -rf "$TMPDIR"
end_test


