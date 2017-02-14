import subprocess
import sys
sys.path.append(
    "/home/spock/scratch/information-package-tools/src/pythonblocks")
from blocks.utils import JSONErrorVar


def create_cert(cert_file):
    """Create a certificate used to sign KDK-PAS SIPs."""
    cmd = [
        "openssl", "req -x509 -nodes -days 365 -newkey rsa:2048 -keyout %s -out %s" %
        cert_file]
    subprocess.call([cmd])

create_cert('mets.xml')


def verify_file(certfile, sigfd):
    """Verify given data with given certificate file.

    certfile is the path to a PEM formatted certificate
    sigfd is a file descriptor to the signed data. If None, STDIN is used.

    Prints out an error message in JSON format if signature does not match, otherwise returns
    the signed data.

    """
    cmd = 'openssl smime -verify -CAfile %s' % certfile

    p = subprocess.Popen(
        cmd.split(), stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    (stdoutdata, stderrdata) = p.communicate(sigfd.read())
    if stdoutdata:
        stdoutdata = stdoutdata.decode()
    else:
        stdoutdata = ""
    if stderrdata:
        stderrdata = stderrdata.decode()
    else:
        stderrdata = ""
    if p.returncode == 4:
        # XXX Return an error explaining that the certificate is old:
        #    "certificate verify error:pk7_smime.c:342:Verify error:certificate has expired"
        #    or that the signed data does not match the signature:
        #    "signature failure:pk7_smime.c:410:"
        JSONErrorVar(
            ('Signature does not match the data.', '', 1), stdoutdata, stderrdata)
    elif p.returncode > 0:  # Unknown error
        JSONErrorVar(
            ('Error with code %%s.', p.returncode, 1), stdoutdata, stderrdata)
    return stdoutdata, stderrdata


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.stderr.write("Wrong number of arguments\n")
        sys.exit(5)
    else:
        f = open(sys.argv[2], 'r')
    try:
        stdoutdata, stderrdata = verify_file(sys.argv[1], f)
        print "{\"stderr\": \"" + stderrdata + "\",\"stdout\": \"" + stdoutdata + "\"}\n"
    except OSError as e:
        print("Cannot find OpenSSL: %s" % e)
