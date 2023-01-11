import json
import re


class logger(object):

    def __init__(self, logger_print):
        self.LOGGER_PRINT = logger_print

    def log_pattern(self, url, local, headers, method):
        if "CURL" in self.LOGGER_PRINT:
            self.curl_pattern(url, local, headers, method)

    def curl_pattern(self, url, local, headers, method):
        command = 'curl "{url}" -X {method}'.format(method=method.upper(), url=url)
        keys = list(local)
        
        if 'files' in keys: 
            fileKeys = local['files'].keys()
            for fileKey in fileKeys:
                files = str(local['files'][fileKey])
                data = re.findall("(\\\.+)'", files)
                if not data:
                    command += ' -F "{1}={0}"'.format(str(local['files'][fileKey]), fileKey)
                else:
                    command += ' -F "{1}=@{0}"'.format(data[0], fileKey)
            keys.remove('files')
        
        if 'json' in keys or 'data' in keys:
            payload = local['json'] if 'json' in keys else None
            payload = local['data'] if 'data' in keys else payload
            if headers.get("content-type") and headers['content-type'] == 'application/json':
                payload = json.dumps(payload) if type(payload) == dict else payload
            command += ' -d "{payload}"'.format(payload=payload)
            keys = [key for key in keys if key != 'data' and key != 'json']

        if 'verify' in keys:
            command += " -k" if not local['verify'] else ""
            keys.remove('verify')
        
        for key in keys:
            command += ' --{0} "{1}"'.format(key.lower(), local[key])

        headers = ['"{0}: {1}"'.format(k.lower(), v) for k, v in headers.items()]
        command = "{command} -H {headers}".format(command=command, headers=" -H ".join(headers))

        print(command)