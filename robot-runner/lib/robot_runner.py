import os
import subprocess
from constants import *
from lib import message
from lib.docker_runner import DockerRunner
from lib.execution_checker import ExecutionChecker
from lib.robot_parser import RobotReportParser
from robot.api import ExecutionResult, ResultVisitor

class RobotRunner(object):
    
    def __init__(self, project_name, robot_option, container_name, browser='chrome', executor='robot', retest_count=0, test_type='web', docker_skip=False, listener=False, docker_broswer=False):
        self.executor = executor
        self.docker_root_path = '/home/robot'
        self.message = message
        self.root_path = os.getcwd()
        self.retest_count = retest_count
        self.execution_checker = ExecutionChecker()
        self.robot_report = RobotReportParser()
        self.docker_runner = DockerRunner()
        self.robot_option = robot_option
        self.browser = browser
        self.browser_port = 4444
        self.docker_skip = docker_skip
        self.container_name = container_name
        self.listener = listener
        self.docker_broswer = docker_broswer
        if docker_skip:
            self.outputdir = os.path.join(
                self.root_path, 'report', project_name, test_type)
            self.source = os.path.join(
                self.root_path, project_name, test_type)
        else:
            self.outputdir = os.path.join(
                self.root_path, 'report', project_name, test_type)
            self.source = os.path.join(
                self.docker_root_path, project_name, test_type)
        

    def __setup_cmd(self, retest=False, retesting_file=None):
        cmd = []

        if self.docker_skip == False:
            cmd.extend(['docker', 'exec', '-it', self.container_name])

        robot_cmd = [self.executor, '--outputdir', f'{self.outputdir}']
        cmd.extend(robot_cmd)

        if not retesting_file:
            cmd.extend(['--output', 'output.xml'])
        else:
            cmd.extend(['--output', 'retest{}.xml'.format(self.retest_count),
                        '--rerunfailed', os.path.join(self.outputdir, retesting_file)])

        if self.listener:
            cmd.extend(['--listener', os.path.join(self.source , 'bin', 'RobotListener.py')])
        
        for option in self.robot_option:
            if not retest:
                cmd.extend([str(option['option']), str(option['value'])])
            else:
                if str(option['option']) not in ('-t', '-s', '--test', '--suite'):
                    cmd.extend([str(option['option']), str(option['value'])])

        if self.browser in ['chrome', 'firefox', 'edge']:
            cmd.extend(['--variable', f'DEFAULT_BROWSER:{self.browser}'])
        
        cmd.extend([f'{self.source}'])

        self.message.show_msg(cmd)
        
        return cmd

    def __run_cmd(self, cmd):
        try:
            if OS == "Windows":
                subprocess.check_call(cmd, shell=True)
            else:
                subprocess.check_call(cmd)
            return 0
        except Exception as e:
            print(str(e))
            return e.returncode

    def run_test(self, retest=False, retesting_file=None):
        if self.docker_broswer:
            self.build_browser_container(self.browser, self.browser_port)
        cmd = self.__setup_cmd(retest, retesting_file)
        rc = self.__run_cmd(cmd)
        if rc == 252:
            self.message.warn_message('Run command line got some error !')
            return rc
        result_outputdir = os.path.join(self.outputdir, 'output.xml')
        
        result = ExecutionResult(result_outputdir)
        result.visit(self.execution_checker)

        return self.execution_checker.is_allpass

    
    def retest(self, retry_count=0):
        if self.retest_count < retry_count:
            retesting_file = 'output.xml'
            if self.retest_count != 0:
                retesting_file = 'retest{}.xml'.format(self.retest_count)

            self.message.retest(self.retest_count)
            self.retest_count += 1
            self.run_test(retest=True, retesting_file=retesting_file)

            try:
                result_outputdir = os.path.join(
                    self.outputdir, 'retest{}.xml'.format(self.retest_count))
                self.robot_report.parser(result_outputdir)
            except Exception as e:
                return True

            if self.robot_report.is_allpass == False:
                self.retest()
        else:
            print('over retesttimes, exit retest process')
        
        if retry_count >=1:
            self.merge_reports()
    
    def merge_reports(self):
        self.message.report_merge()

        for i in range(1, self.retest_count + 1):
            try:
                subprocess.check_call(['rebot', '--outputdir', '%s' % self.outputdir, '--output', 'output.xml',
                                       '--merge', os.path.join(self.outputdir, 'output.xml'), os.path.join(self.outputdir, 'retest%d.xml' % i)])
            except Exception as e:
                print(str(e))
            i = i + 1
    
    def build_browser_container(self, browser, browser_port):
        browser_container = '{}-{}'.format(browser, browser_port)
        self.docker_runner.run_browser(
            browser_container, self.root_path, browser_port, browser)
        # try:
        #     if OS in ["Linux", "Mac"]:
        #         self.__run_cmd(['sudo', 'chmod', '-R', '777',
        #                       '{}/selenium/'.format(self.root_path)])
        #     elif OS == "Windows":
        #         pass
        # except Exception as e:
        #     print(str(e))