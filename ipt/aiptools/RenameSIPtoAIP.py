"""
Created on 30.5.2013

@author: ttoppari
"""
import logging
import os
import sys
import shutil


def move_aip(AIPBase, AIPName, SIPBase, SIPName):
    """
    Move AIP.
    """
    logging.info('Checking command-line parameter validity')

    assert os.path.isdir(AIPBase + str(AIPName))
    assert os.path.isdir(str(SIPBase + SIPName))

    # Moving SIP_ID/ directory with subfolders under SIP_ID
    shutil.move(str(SIPBase + SIPName), str(AIPBase + AIPName))

if __name__ == "__main__":

    logging.info('Start moving reorganized SIP to AIP')
    logging.info('Reading options and parameters')

    if len(sys.argv) != 5:
        sys.stderr.write("Too few arguments\n")
        sys.exit(1)
    else:
        AIPBaseDir = sys.argv[1]
        AIPID = sys.argv[2]
        SIPBaseDir = sys.argv[3]
        SIPDir = sys.argv[4]
        move_aip(AIPBaseDir, AIPID, SIPBaseDir, SIPDir)
        sys.exit(0)
