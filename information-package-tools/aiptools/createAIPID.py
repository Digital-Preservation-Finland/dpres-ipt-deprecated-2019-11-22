"""
Created on 23.5.2013


@author: ttoppari

# Creates AIP ID 
Creates AIP ID from datetime and uuid

"""

# Commented out code that is not used...
# TODO: Remove this code after testing
#import logging
#import os
#import datetime
#import uuid
#import sys
#import mongoAPI.AIPDBFunctions
#
#def create_aipid(db,organization,SIPID,AIPBaseDir):
#
#	# AIP ID is created by combining to name AIP + date (in format YYYY-MM-DD) and
# generated UUID
#	logging.info('Creating AIP name') 
#	
#	myuuid = uuid.uuid4()
#	mydate = datetime.datetime.now()
#	myAIPID = "AIP-" + mydate.strftime("%Y-%m-%d-%H-%M-%S") + "_" + str(myuuid)
#
#	logging.debug('Created AIP name', '% myAIPID')
#	if os.path.isdir(AIPBaseDir):
#		os.chdir(AIPBaseDir)
#		os.makedirs(myAIPID)
#	# Store AIP vs. SIP mapping into database
#
#		myaip = mongoAPI.AIPDBFunctions.AIPCollection()
#		myaip.insert_aip_name(organization,SIPID,myAIPID)
#	
#		return myAIPID
#	return None
#
#if __name__ == "__main__":
#    if len(sys.argv) != 5:
#        sys.stderr.write("Wrong number of arguments\n");
#        sys.exit(5)
#    else:
#    	db = sys.argv[1]
#    	org = sys.argv[2]
#    	SIPName = sys.argv[3]
#    	AIPBaseDir = sys.argv[4]   	
#        aip_id = create_aipid(db,org,SIPName,AIPBaseDir)
#        sys.exit(0)
#
#
