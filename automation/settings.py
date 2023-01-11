import os
import re
from dotenv import load_dotenv
load_dotenv()

TIMEOUT = os.getenv("TIMEOUT", 100)

# ANDROID_AUTOMATION_NAME = os.getenv("ANDROID_AUTOMATION_NAME", "UIAutomator2")
# ANDROID_PLATFORM_NAME = os.getenv("ANDROID_PLATFORM_NAME", "Android")

# -------- Broswer Setting --------
DEFAULT_BROWSER = os.getenv("DEFAULT_BROWSER", "chrome")
BROWSER_PORT = os.getenv("BROWSER_PORT", None)
CONTAINER_IP = os.getenv("CONTAINER_IP", None)
NOTWINDOWS = os.getenv("NOTWINDOWS", "false")
COMPANY_ID = os.getenv("COMPANY_ID", 1)

# -------- CrossBrowserTesting Settings --------
REMOTE = os.getenv("REMOTE", None)
CBT_EMAIL = os.getenv("CBT_EMAIL", "grdv_stage1@talfin.ai")
CBT_AUTHKEY = os.getenv("CBT_AUTHKEY", "u67959f3593e8a25")

# -------- Environmnet Settings --------
ENV = os.getenv("CI_COMMIT_BRANCH")
if ENV == "staging":
    INTERNAL_API_HOST = os.getenv("INTERNAL_API_HOST", "")
    GAME_API_HOST = os.getenv("GAME_API_HOST", "")
    HOST = os.getenv("HOST", "http://hq.qlieer.com:9487")
    AUTOTEST_SRORE_CODE = os.getenv("AUTOTEST_SRORE_CODE", "umai03")
    AUTOTEST_ACCOUNT = os.getenv("AUTOTEST_ACCOUNT", "autotest@ubitech.com.tw")
    AUTOTEST_PASSWORD = os.getenv("AUTOTEST_PASSWORD", "888888")
    
else:
    print("ENV is {}:".format(ENV))
    print("Environment setting error!")
    exit()

# -------- Rank Verification Settings --------

text_list = {

}

interviewee_list = []
all_permutations = [
    'max', 'high', 'medium', 'lower'
    ]
score_list = {
   
}
