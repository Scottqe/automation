from xml.etree.ElementInclude import include
import click
import os
import sys
import zipfile
from lib.robot_runner import RobotRunner
from lib.docker_runner import DockerRunner
from lib.resource_name import ResourceName
from lib.filter_testcase import FilterTestCase
from lib.robot_parser import RobotReportParser
from lib.testrail import TestRail
# from lib.slack import Slack
from lib.aws import AWS
from lib.zip_folder import ZipFolder
from lib import message
from settings import *

__dirname = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(__dirname, '../'))
from constants import *

@click.group()
def cli():
    """Robot Runner"""

@cli.command('run', short_help='run robot test')
@click.option('-s', '--docker_skip', is_flag=True, default=False)
@click.option('-p', '--path', default=os.getcwd())
@click.option('-P', '--project_name', help="It should be match project name folder name")
@click.option('-i', '--include_tag', multiple=True, help="Run test cases by tag")
@click.option('-e', '--exclude_tag', help="Exclude test cases by tag")
@click.option('-r', '--retry_count', default=0, help="Input retry count, if test cases failed and it will retry")
@click.option('-O', '--robot_option', help='Setup robot option', multiple=True)
@click.option('-b', '--browser', default='chrome', help='Set target browser (e.g. chrome, firefox, edge)')
@click.option('-t', '--run_testrail', is_flag=True, default=False, help='Run TestRail')
@click.option('-m', '--milestone_name', default=None, help='It should match TestRail milestone name')
@click.option('-l', '--listener', is_flag=True, default=False, help='Run robotframework listener')
@click.option('-d', '--docker_broswer', is_flag=True, default=False, help='Run browser in docker container')
@click.option('-s3', '--upload_s3', is_flag=True, default=False, help='Upload automation test result to S3')
@click.option('-run', '--run_name', default=None, help='It should match TestRail test run name')
def run(project_name, docker_skip, path, include_tag, exclude_tag, retry_count, robot_option, browser, run_testrail, milestone_name, listener, docker_broswer, upload_s3, run_name):

    # Check project existing
    projects = os.listdir(path)
    if project_name not in projects:
        print(f'{project_name} is not in directory')
        exit()

    project_config = FilterTestCase.fetch_config(path, project_name)

    for sub_project in project_config['sub_project']:
        test_flag = FilterTestCase.check_test_status(
                include_tag, exclude_tag, sub_project
        )
        options_list = FilterTestCase.convert_option(robot_option)

        if test_flag:
            if docker_skip == False:
                try:
                    docker_runner = DockerRunner()
                    image_name = DOCKERFILE_LIST['testing']
                    docker_runner.pull_image(image_name)
                    random_str = ResourceName.id_generator()
                    container_name = f'testing-{random_str}'
                    docker_runner.run(container_name, path, image_name)
                except:
                    message.warn_message('Docker is not installed')
            else:
                container_name = None

            robot_runner = RobotRunner(project_name=project_name, robot_option=options_list, container_name=container_name, browser=browser, test_type=sub_project['tag'], docker_skip=docker_skip, listener=listener, docker_broswer=docker_broswer)
            result_code = robot_runner.run_test()
            
            if isinstance(result_code, bool) and result_code == False:
                robot_runner.retest(retry_count)
            
            if upload_s3 == True:
                try:
                    aws = AWS(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, REGION_NAME)
                    aws.upload_folder_to_s3(robot_runner.outputdir)
                except:
                    message.warn_message('Upload to S3 failed')

            if docker_skip == False:
                docker_runner.remove_container(container_name)
            
            if run_testrail and milestone_name:
                try:
                    message.info_message("Get automated test case from TestRail.")
                    testrail_url = "https://qlieer.testrail.io"
                    testrail = TestRail(testrail_url, TESTRAIL_ACCOUNT, TESTRAIL_PASSWORD)
                    project = testrail.get_specific_project("Beauty")

                    message.info_message("Start report test status to TestRail...")
                    message.info_message(f"Milestone: {milestone_name}")
                    robot_report = RobotReportParser()
                    robot_report.parser(os.path.join(robot_runner.outputdir, 'output.xml'))
                    
                    milestone = testrail.get_specific_milestone(project["id"], milestone_name)
                    if run_name == None:
                        run_name = ResourceName.get_current_date()
                        target_run = testrail.add_run(project_id=project["id"], name=run_name, milestone_id=milestone["id"], include_all=True, case_ids=[])
                    else:
                        target_run = testrail.get_specific_run(project["id"], milestone["id"], run_name)

                    message.info_message(f"Run name: {run_name}")
                    for case in robot_report.pass_list:
                        try:
                            for tag in case.tag:
                                tag = str(tag)
                                testrail.add_result_for_case(run_id=target_run["id"], case_id=int(tag[1:]), status_id=1, comment="PASS", version="1")
                        except Exception as e:
                            message.warn_message('Add result to TestRail failed')
                    
                    for case in robot_report.fail_list:
                        try:
                            for tag in case.tag:
                                tag = str(tag)
                                testrail.add_result_for_case(run_id=target_run["id"], case_id=int(tag[1:]), status_id=5, comment="FAIL", version="1")
                        except Exception as e:
                            message.warn_message('Add result to TestRail failed')
                    
                    zip_path = os.path.join(path, 'report', 'regression_log.zip')
                    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                        ZipFolder.zipdir(robot_runner.outputdir, zipf)
                    testrail.add_attachment_to_run(target_run["id"], zip_path)
                    
                    message.info_message("Report test status to TestRail successfully.")
                except Exception as e:
                    print(e)
                    message.warn_message('Run TestRail failed')

                # try:
                #     slack = Slack()
                #     pretext = f"```{testrail_url}/index.php?/runs/view/{target_run['id']}```\n <!here> Please check TestRail report\nMilestone: {milestone_name}"
                #     payloads = slack.generate_payload(pretext, robot_report.pass_list, robot_report.fail_list)
                #     resp = slack.request('POST', json=payloads)
                #     message.info_message("Send slack message successfully.")
                # except Exception as e:
                #     print(e)
                #     message.warn_message('Send slack message failed')

if __name__ == '__main__':
    cli()
