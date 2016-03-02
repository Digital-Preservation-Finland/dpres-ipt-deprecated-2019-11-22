import os
import os.path
import json

import ipt
import ipt.validator.plugin.jhove
import ipt.validator.plugin.jhove2
import ipt.validator.plugin.libxml
import ipt.validator.plugin.filecommand
import ipt.validator.plugin.xmllint
import ipt.validator.plugin.warctools

CONFIG_FILENAME = os.path.join('/usr/share/',
                               'information-package-tools/validators',
                               'validators.json')


class Validator:

    def __init__(self, base_path=None):
        #FIXME: Remove basepath
        self.basepath = base_path
        self.validators_config = None

    def load_config(self, config_filename=None):
        if config_filename is None:
            config_filename = CONFIG_FILENAME
        json_data = open(config_filename)
        self.validators_config = json.load(json_data)
        json_data.close()

    def get_class_instance_by_name(self, path, params):
        """ Return instance of class declared in path argument """

        modules = path.split(".")
        instance = globals()[modules[0]]

        for module in modules[1:]:
            instance = getattr(instance, module)

        if params:
            return instance(params)

        return instance()

    def validate_file(self, fileinfo, validator_name):

        if self.basepath:
            fileinfo["filename"] = os.path.join(
                self.basepath, fileinfo["filename"])
        validate = self.get_class_instance_by_name(
            validator_name, fileinfo)

        (returnstatus, messages, errors) = validate.validate()

        return (returnstatus, messages, errors)

    def get_validators(self, fileinfo):
        """ Return list of possible validators for filetype and version """

        found_validators = []

        for config in self.validators_config["formatNameList"]:
            for format_mimetype, validator_configs in config.iteritems():
                if fileinfo['format']['mimetype'] == format_mimetype:
                    for validator in validator_configs:
                        if fileinfo['format']['version'] == \
                                validator["formatVersion"]:
                            if len(validator["validator"]) > 0:
                                found_validators.append(validator["validator"])

        return found_validators

    def validate_files(self, filelist):
        """
        Calls validator selector function for each file in SIPs manifest file
        """
        return_status = []
        messages = []
        errors = []
        validators = []

        def append_results(validator, ret, stdout, stderr):
            """A simple append function to avoid boilerplate."""
            validators.append(validator)
            return_status.append(ret)
            messages.append(stdout)
            errors.append(stderr)
        filelist_files = []


        # Validate files
        for file_ in filelist:

            # create a filelist
            filename = str(file_["filename"])
            if filename.startswith("./"):
                filename = filename[2:]
            filelist_files.append(filename)

            fileinfo = file_
            validators_for_file = self.get_validators(fileinfo)
            if len(validators_for_file) == 0:
                error = \
                    'INVALID:%s:No validator for mimetype:%s version:%s' % (
                    fileinfo['filename'], fileinfo['format']['mimetype'],
                    fileinfo['format']['version'])
                append_results(
                    validator="", ret=1, stdout="\n", stderr=error)

            for validator in validators_for_file:
                (status, message, error) = self.validate_file(
                    fileinfo, validator)
                append_results(validator, status, message, error)

        return (return_status, messages, errors, validators)
