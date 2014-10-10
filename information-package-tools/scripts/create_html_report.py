#!/usr/bin/python
# vim:ft=python

"""
This commandline tool creates a html-report from premis-xml-report with xslt
transform.

Usage ::

	create-xml-report /path/to/premis/report.xml [/path/to/html/report.html]

	/path/to/html/report.html is optional, if it is left empty, report is created
	to same directory as premis-xml-report is.
	
"""

import optparse
import sip.signature
import os
import subprocess
import shlex

XSLT_PATH = "/usr/share/pas/microservice/report/xslt/stylesheet.xml"


def main(arguments=None):
    usage = "usage: %prog /path/to/premis/report.xml [/path/to/html/report.html]"

    parser = optparse.OptionParser(usage=usage)

    (_, args) = parser.parse_args(arguments)

    if len(args) < 1:
        print "ERROR: at least one argument needed"
        return 1

    if args[0] is None:
    	return 1
    if args[1] is not None:
    	html_path = args[1]
    else:
    	report_name = os.path.basename(args[0])
    	html_path = os.path.join(os.path.dirname(args[0]), report_name)

    cmd = "xsltproc " + XSLT_PATH + " " + args[0]
    print cmd
    cmd = shlex.split(cmd)
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=
                             subprocess.PIPE, stdout=subprocess.PIPE,
                             close_fds=True, shell=False)
    (stdout, stderr) = p.communicate()
    if len(stderr) > 0:
       print "xsltproc had stderr output:"
       print stderr

    if len(stdout) > 0:
        with open(html_path, "w") as html_file:
            html_file.write(stdout)

    ret = p.returncode
    return ret

if __name__ == '__main__':
    main()

