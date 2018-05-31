"""

Schematron validation using iso-schematron-xslt1 reference implementation.

XSLT template converts are done with xsltproc / libxslt C Library for
Gnome. This is because Python xml libraries are not stable enough for
Schematron.

    http://xmlsoft.org/XSLT/

Schematron XSLT files must be installed at path

    /usr/share/dpres-xml-schemas/schematron_xslt1/

Schematron XSLT files can be downloaded from

    http://www.schematron.com/implementation.html

Schematron templates are cached at

    ~/.dpres-ipt/schematron-cache/<md5 of schematron schema>.xslt

This reduces need to sequentially compile Schematron schemas into XSLT
templates.

"""

import os
import shutil
import tempfile
import lxml.etree as etree

import ipt.fileutils.checksum
from ipt.validator.basevalidator import Shell


class SchematronValidator(object):
    """Schematron validator
    """

    def __init__(self):
        """Initialize instance.
        """
        self.verbose = False
        self.cache = True
        self.cachepath = os.path.expanduser('~/.dpres-ipt/schematron-cache')
        self.schematron_dirname = '/usr/share/dpres-xml-schemas/schematron/schematron_xslt1'
        self.messages = None
        self.errors = None
        self.returncode = None

    def document_valid(self):
        """Check if document resulted errors
        """
        return self.messages.find('<svrl:failed-assert ') < 0 \
            and self.returncode == 0

    def schematron_validation(self, document, schematron_file):
        """Do the Schematron validation.
        :document: Document to be validated
        :schematron_file: Schematron file used in validation
        """
        xslt_filename = self._compile_schematron(schematron_file)

        # The actual validation
        shell = self._compile_phase(
            stylesheet=xslt_filename,
            inputfile=document, valid_codes=[0, 6])

        self.returncode = shell.returncode
        self.errors = shell.stderr

        if not self.verbose and shell.returncode == 0:
            self.messages = self._filter_duplicate_elements(shell.stdout)
        else:
            self.messages = shell.stdout

    def _filter_duplicate_elements(self, result):
        """Filter duplicate elements from the result
        :result: Result as string
        """
        SVRL = {'svrl': 'http://purl.oclc.org/dsdl/svrl'}
        root = etree.fromstring(result)
        patterns = root.xpath('./svrl:active-pattern', namespaces=SVRL)
        for pattern in patterns:
            prev = pattern.xpath('preceding-sibling::svrl:active-pattern[1]',
                                 namespaces=SVRL)
            if prev and pattern.get('id') == prev[0].get('id'):
                pattern.getparent().remove(pattern)

        rules = root.xpath('svrl:fired-rule', namespaces=SVRL)
        for rule in rules:
            prev = rule.xpath('preceding-sibling::svrl:fired-rule[1]',
                              namespaces=SVRL)
            if prev and rule.get('context') == prev[0].get('context'):
                rule.getparent().remove(rule)

        return etree.tostring(
            root, pretty_print=True, xml_declaration=False,
            encoding='UTF-8', with_comments=True)

    def _compile_phase(self, stylesheet, inputfile, valid_codes,
                       outputfile=None, outputfilter=False):
        """Compile one phase
        :stylesheet: XSLT file to used in the conversion
        :inputfile: Input document filename
        :outputfile: Filename of the resulted document, stdout if None
        :outputfilter: Use outputfilter parameter with value only_messages
        :validation: True - the actual validation / False - compilation step
        """
        cmd = ['xsltproc']
        if outputfile:
            cmd = cmd + ['-o', outputfile]
        if outputfilter and not self.verbose:
            cmd = cmd + ['--stringparam', 'outputfilter', 'only_messages']
        cmd = cmd + [os.path.join(self.schematron_dirname, stylesheet),
                     inputfile]
        shell = Shell(cmd)
        if shell.returncode not in valid_codes:
            raise SchematronValidatorError(
                "Error %s\nstdout:\n%s\nstderr:\n%s" % (
                    shell.returncode, shell.stdout, shell.stderr))
        return shell

    def _compile_schematron(self, schematron_file):
        """Compile a schematron file
        :schematron_file: Schematron file
        """
        xslt_filename = self._generate_xslt_filename(schematron_file)
        tempdir = tempfile.mkdtemp()

        if self.cache:
            if os.path.isfile(xslt_filename):
                return xslt_filename

        try:
            self._compile_phase(
                stylesheet='iso_dsdl_include.xsl',
                inputfile=schematron_file,
                outputfile=os.path.join(tempdir, 'step1.xsl'),
                valid_codes=[0])
            self._compile_phase(
                stylesheet='iso_abstract_expand.xsl',
                inputfile=os.path.join(tempdir, 'step1.xsl'),
                outputfile=os.path.join(tempdir, 'step2.xsl'),
                valid_codes=[0])
            self._compile_phase(
                stylesheet='optimize_schematron.xsl',
                inputfile=os.path.join(tempdir, 'step2.xsl'),
                outputfile=os.path.join(tempdir, 'step3.xsl'),
                valid_codes=[0])
            self._compile_phase(
                stylesheet='iso_svrl_for_xslt1.xsl',
                inputfile=os.path.join(tempdir, 'step3.xsl'),
                outputfile=os.path.join(tempdir, 'validator.xsl'),
                outputfilter=not(self.verbose),
                valid_codes=[0])

            shutil.move(os.path.join(tempdir, 'validator.xsl'),
                        xslt_filename)

        finally:
            shutil.rmtree(tempdir)

        return xslt_filename

    def _generate_xslt_filename(self, schematron_schema):
        """ Example filename:

            /var/cache/schematron-validation/<schema.sch>.<sha digest>.xslt

        """
        try:
            os.makedirs(self.cachepath)
        except OSError:
            if not os.path.isdir(self.cachepath):
                raise

        checksum = ipt.fileutils.checksum.BigFile('sha1')
        schema_digest = checksum.hexdigest(schematron_schema)
        schema_basename = os.path.basename(schematron_schema)

        return os.path.join(self.cachepath, '%s.%s.validator.xsl' % (
            schema_basename, schema_digest))


class SchematronValidatorError(Exception):
    """Throw error in compilation failure
    """
    pass
