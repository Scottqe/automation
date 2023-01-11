import requests
from logger import logger
from robot.libraries.BuiltIn import BuiltIn
import urllib3
urllib3.disable_warnings()

class _init_(object):

    def __init__(self, host='INTERNAL_API_HOST', basepath='/api'):
        self.BuiltIn = BuiltIn()
        self.HOST = self.BuiltIn.get_variable_value('${0}'.format(host))
        self.HOST = '{}{}'.format(self.HOST, basepath)
        self.SESSION = requests.Session()
        self.TOKEN = self.BuiltIn.get_variable_value('${TOKEN}')
        self.SESSION.headers.update({
            'X-Requested-With': 'XMLHttpRequest',
            'accept': 'application/json',
        })
        
        self.logger = logger("CURL")

    def request(self, method, append='', **kwargs):
        url = self.HOST + append
        self.logger.log_pattern(url, locals()["kwargs"], self.SESSION.headers, method)
        resp = self.SESSION.request(method, url, **kwargs)
        return resp

    def addHeaders(self, others):
        if type(others) == dict:
            self.SESSION.headers.update(others)