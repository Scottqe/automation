import random
import string
import datetime
import names
from dateutil.relativedelta import relativedelta

class ResourceName(object):

    def get_datetime_strftime(self, integer=False):
        nowTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S%f")
        if integer:
            return int(nowTime)
        return nowTime

    def get_current_time(self):
        nowTime = datetime.datetime.now().strftime("%Y-%m-%d")
        return nowTime

    def create_unique_text(self):
        nowTime = self.get_datetime_strftime("%d%H%M%S")
        text = 'QE' + nowTime
        return text
    
    def create_random_female_name(self):
        firstName = names.get_first_name(gender='female')
        lastName = names.get_last_name()
        return firstName,lastName
    
    def create_random_phone_number(self):
        start = '09'
        end = ''.join(random.sample(string.digits, 8))
        phoneNum = start + end
        return phoneNum

