import docker
from lib import message
import time
import requests
from settings import *

class DockerRunner(object):

    def __init__(self):
        try:
            self.client = docker.from_env()
            self.message = message
        except Exception as e:
            print("Can't import docker from env")
    
    def pull_image(self, image_name):
        self.client.images.pull(image_name)
        self.message.info_message('Pull robot-runner image successfully.')

    def start_container(self, container_name):
        try:
            container = self.client.containers.get(container_name)
            container.start()
            self.message.show_cmd(['docker', 'start', container_name])
        except Exception as e:
            self.message.warn_msg(
                ['docker', 'start', 'fail', 'with', '{}'.format(str(e))])

    def run(self, container_name, path, image_name):
        environment = ['TZ=Asia/Taipei']
        volumes = {
            '/var/run/docker.sock': {
                'bind': '/var/run/docker.sock', 'mode': 'rw'},
            path: {
                'bind': '/home/robot', 'mode': 'rw'}
        }

        if self.is_running(container_name) == False:
            container = self.client.containers.run(
                image_name, detach=True, environment=environment, name=container_name, network_mode='host', stdin_open=True, volumes=volumes)
            self.message.show_msg([image_name, 'container start.'])
            print(container.id, container.name)
        else:
            self.start_container(container_name)

    def remove_container(self, container_name):
        try:
            container = self.client.containers.get(container_name)
            container.remove(force=True)
            self.message.show_cmd(['docker', 'rm', '-f', container_name])
        except Exception as e:
            self.message.warn_msg(
                ['docker', 'remove containers', 'fail', 'with', '{}'.format(str(e))])
    
    def is_running(self, container_name):
        """
        verify the status of a sniffer container by it's name
        :param container_name: the name of the container
        :return: Boolean if the status is ok
        """
        try:
            container = self.client.containers.get(container_name)
        except:
            return False
        container_state = container.attrs["State"]
        return container_state["Status"] == "running"

    def run_browser(self, container_name, path, port, browser):
        """
        Run the browser container. It will volume the webdriver container 
        donwloads folder to Local folder, then we can use the download 
        item from webdriver.
        Command:
            docker run -d --name firefox-port \
            -v $PWD/selenium/Downloads:/home/seluser/Downloads \
            -v /dev/shm:/dev/shm \
            -e TZ=Asia/Taipei \
            -p local_port:4444 \
            -p local_port:5900 DOCKERFILE_LIST[browser]
        Args:
            container_name(str): Browser container name.
            path(str): Workplace folder.
            port(int): 4444 is browser port on local. 5900 is connect vnc port.
            browser(str): Browser name which was defined in DOCKER_SELENIUM_DRIVER
                of setting.py, you can specific image to build testing environment.
        """
        image_name = DOCKERFILE_LIST[browser]
        environment = ['TZ=Asia/Taipei']
        volumes = {
            '{}/selenium/Downloads'.format(path): {
                'bind': '/home/seluser/Downloads', 'mode': 'rw'
            },
            '/dev/shm': {
                'bind': '/dev/shm', 'mode': 'rw'
            }
        }
        ports = {
            '4444/tcp': port,
            '5900/tcp': port+1
        }
        if self.is_running(container_name) == False:
            container = self.client.containers.run(
                image_name, detach=True, environment=environment, name=container_name, ports=ports, volumes=volumes)
            self.message.show_msg([browser, 'container start.'])
            self.docker_container_connect_check(port, 30, browser)
            print(container.id, container.name)
        else:
            self.message.show_msg([browser, 'already exsited.'])
    
    def docker_container_connect_check(self, port, timeoute, container):
        start_time = time.time()
        while time.time() < start_time + timeoute:
            try:
                requests.get('http://127.0.0.1:{}'.format(port))
                break
            except:
                time.sleep(3)
                print('Connect {0} container fail. Retry.'.format(container))