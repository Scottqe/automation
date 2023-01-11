from curses import noraw
import string
import random
import datetime
class ResourceName(object):
    
    @staticmethod
    def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
        return ''.join(random.choice(chars) for _ in range(size))

    @staticmethod
    def get_current_date(size=6, chars=string.ascii_uppercase + string.digits):
        nowTime = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
        return nowTime
