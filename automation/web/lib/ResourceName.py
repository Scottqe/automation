import random
import string
import datetime
from dateutil.relativedelta import relativedelta


class ResourceName(object):

    def get_datetime_strftime(self, integer=False):
        nowTime = datetime.datetime.now().strftime("%m%d%H%M%S")
        if integer:
            return int(nowTime)
        return nowTime

    def get_current_time(self):
        nowTime = datetime.datetime.now().strftime("%Y%m%d")
        year = int(nowTime[:4])
        month = int(nowTime[4:6])
        day = int(nowTime[6:])
        return year, month, day
    
    def create_unique_text(self):
        """ Create unique text """
        nowTime = self.get_datetime_strftime()
        text = 'qa-' + nowTime
        return text