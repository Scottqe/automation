import os
import boto3
import datetime
from lib import message

class AWS(object):
    def __init__(self, aws_access_key_id, aws_secret_access_key, region_name):
        self.aws_access_key_id = aws_access_key_id
        self.aws_secret_access_key = aws_secret_access_key
        self.region_name = region_name
        self.bucket_name = 'botrista-regression-log'
        try:
            self.session = boto3.Session(
                aws_access_key_id = self.aws_access_key_id,
                aws_secret_access_key = self.aws_secret_access_key,
                region_name = self.region_name
            )
        except Exception as e:
            message.info_message('Import aws access key error!')

    def upload_folder_to_s3(self, path):
            s3 = self.session.resource('s3')
            bucket = s3.Bucket(self.bucket_name)
            nowTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S%f")
            directory_name = 'db-log-' + nowTime
            message.info_message('Start upload logs to S3, please wait...')
            for subdir, dirs, files in os.walk(path):
                for file in files:
                    full_path = os.path.join(subdir, file)
                    with open(full_path, 'rb') as data:

                        bucket.put_object(Key=(directory_name + '/' + full_path[len(path)+1:]), Body=data)
