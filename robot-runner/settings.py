import os
from os.path import join, dirname
from dotenv import load_dotenv
dotenv_path = join(dirname(__file__), '.env')
load_dotenv(dotenv_path)

AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
REGION_NAME = os.getenv("REGION_NAME")

TESTRAIL_ACCOUNT = os.getenv("TESTRAIL_ACCOUNT")
TESTRAIL_PASSWORD = os.getenv("TESTRAIL_PASSWORD")

DOCKERFILE_LIST = {
    "firefox": "selenium/standalone-firefox:latest",
    "chrome": "selenium/standalone-chrome:latest",
    "testing": "haru3613/robot_runner:latest"
}