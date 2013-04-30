#!/bin/bash

echo "1..3"

. t/common_functions.sh

CMD=src/checkSIPTransferType.sh

$CMD t
RETVAL=$?
equals $RETVAL 1 Check directory

$CMD t/sip_test_files/csc_sip_testpackage_01.zip
RETVAL=$?
equals $RETVAL 2 Check ZIP file

$CMD t/sip_test_files/false_zip.zip
RETVAL=$?
equals $RETVAL 255 Check invalid ZIP file
