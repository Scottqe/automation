"""TestRail API binding for Python 3.x.

(API v2, available since TestRail 3.0)

Compatible with TestRail 3.0 and later.

Learn more:

http://docs.gurock.com/testrail-api2/start
http://docs.gurock.com/testrail-api2/accessing

Copyright Gurock Software GmbH. See license.md for details.
"""

import base64
import json
import re
import requests
import urllib3
urllib3.disable_warnings()


class TestRail:
    def __init__(self, base_url, user, password):
        self.user = user
        self.password = password
        if not base_url.endswith('/'):
            base_url += '/'
        self.__url = base_url + 'index.php?/api/v2/'

    def send_get(self, uri, filepath=None):
        """Issue a GET request (read) against the API.

        Args:
            uri: The API method to call including parameters, e.g. get_case/1.
            filepath: The path and file name for attachment download; used only
                for 'get_attachment/:attachment_id'.

        Returns:
            A dict containing the result of the request.
        """
        return self.__send_request('GET', uri, filepath)

    def send_post(self, uri, data):
        """Issue a POST request (write) against the API.

        Args:
            uri: The API method to call, including parameters, e.g. add_case/1.
            data: The data to submit as part of the request as a dict; strings
                must be UTF-8 encoded. If adding an attachment, must be the
                path to the file.

        Returns:
            A dict containing the result of the request.
        """
        return self.__send_request('POST', uri, data)

    def __send_request(self, method, uri, data):
        url = self.__url + uri
        auth = str(
            base64.b64encode(
                bytes('%s:%s' % (self.user, self.password), 'utf-8')
            ),
            'ascii'
        ).strip()
        headers = {'Authorization': 'Basic ' + auth}
        if method == 'POST':
            if uri[:14] == 'add_attachment':    # add_attachment API method
                files = {'attachment': (open(data, 'rb'))}
                response = requests.post(url, headers=headers, files=files, verify=False, timeout=10)
                files['attachment'].close()
            else:
                headers['Content-Type'] = 'application/json'
                payload = bytes(json.dumps(data), 'utf-8')
                response = requests.post(url, headers=headers, data=payload, verify=False, timeout=10)
        else:
            headers['Content-Type'] = 'application/json'
            response = requests.get(url, headers=headers, verify=False, timeout=10)

        if response.status_code > 201:
            try:
                error = response.json()
            except:     # response.content not formatted as JSON
                error = str(response.content)
            raise APIError('TestRail API returned HTTP %s (%s)' % (response.status_code, error))
        else:
            if uri[:15] == 'get_attachment/':   # Expecting file, not JSON
                try:
                    open(data, 'wb').write(response.content)
                    return (data)
                except:
                    return ("Error saving attachment.")
            else:
                try:
                    return response.json()
                except: # Nothing to return
                    return {}

    def add_project(self, project_name, description=None, condition=False, mode=1):
        resp = self.send_post(
            'add_project',
            {
                'name': project_name,
                'announcement': description,
                'show_announcement': condition,
                'suite_mode': mode
            }
        )
        return resp

    def add_milestone(self, project_id, name, description=None, due_on=None, parent_id=None, refs=None, start_on=None):
        resp = self.send_post(
            'add_milestone/{}'.format(project_id),
            {
                'name': name,
                'description': description,
                'due_on': due_on,
                'parent_id': parent_id,
                'refs': refs,
                'start_on': start_on
            }
        )
        return resp

    def add_run(self, project_id, name, milestone_id=None, include_all=None, case_ids=None, suite_id=13):
        resp = self.send_post(
            'add_run/{}'.format(project_id),
            {
                'suite_id': suite_id,
                'name': name,
                'milestone_id': milestone_id,
                'include_all': include_all,
                'case_ids': case_ids
            }
        )
        return resp

    def add_attachment_to_run(self, run_id, path):
        resp = self.send_post(
            'add_attachment_to_run/{}'.format(run_id), path
        )
        return resp

    def add_result_for_case(self, run_id, case_id, status_id=None, comment=None, version=None, elapsed=None, defects=None, assignedto_id=None):
        try:
            resp = self.send_post(
                'add_result_for_case/{}/{}'.format(run_id, case_id),
                {
                    'status_id': status_id,
                    'comment': comment,
                    'version': version,
                    'elapsed': elapsed,
                    'defects': defects,
                    'assignedto_id': assignedto_id
                }
            )
            return resp
        except:
            print("Not found the test case id: " + str(case_id))

    def add_section(self, project_id, name, description=None, suite_id=None, parent_id=None):
        resp = self.send_post(
            'add_section/{}'.format(project_id),
            {
                'description': description,
                'suite_id': suite_id,
                'parent_id': parent_id,
                'name': name
            }
        )
        return resp

    def add_case(self, section_id, title, template_id=None, type_id=None, priority_id=None, estimate=None, milestone_id=None, refs=None):
        resp = self.send_post(
            'add_case/{}'.format(section_id),
            {
                'title': title,
                'template_id': template_id,
                'type_id': type_id,
                'priority_id': priority_id,
                'estimate': estimate,
                'milestone_id': milestone_id,
                'refs': refs
            }
        )
        return resp

    def get_suites(self, project_id):
        resp = self.send_get(
            'get_suites/{}'.format(project_id)
        )
        return resp

    def get_automated_type_id(self):
        resp = self.send_get(
            'get_case_types'
        )
        result = list(filter((lambda x: re.search("Automated", str(x['name']))), resp))

        return result[0]["id"]

    def get_case_by_id(self, case_id):
        resp = self.send_get(
            f'get_case/{case_id}'
        )

        return resp

    def get_automated_cases(self, suite_id=13, project_id=2):
        resp = self.send_get(
            f'get_cases/{project_id}&suite_id={suite_id}'
        )
        
        result = list(filter((lambda x: re.search(str(3), str(x['custom_exection_type']))), resp["cases"]))
        option_array = []
        case_id_array = []
        for option in result:
            case_id_array.append(option['id'])
            option_array.append(
                {'option': '-i', 'value': f"C{str(option['id'])}"})
        
        option_array.append(
            {'option': '-e', 'value': 'exclude'}
        )

        return option_array, case_id_array

    def get_specific_case_id(self, project_id, case_name, section_id):
        resp = self.send_get(
            'get_cases/{}&filter={}'.format(project_id, case_name)
        )
        if not resp:
            resp = self.add_case(section_id, case_name)
            return resp['id']
        else:
            return resp[0]['id']

    def get_specific_project(self, project_name):
        resp = self.send_get(
            'get_projects'
        )
        
        result = list(filter((lambda x: re.search(project_name, str(x['name']))), resp["projects"]))
        
        if result:
            return result[0]
        else:
            result = self.add_project(project_name)
            return result
    
    def get_specific_milestone(self, project_id, milestone_name):
        resp = self.send_get(
            'get_milestones/{}'.format(project_id)
        )
        result = list(filter((lambda x: re.search(milestone_name, str(x['name']))), resp["milestones"]))

        if result:
            return result[0]
        else:
            return None

    def get_specific_run(self, project_id, milestone_id, run_name, completed_status=0):
        resp = self.send_get(
            'get_runs/{}&milestone_id={}&is_completed={}'.format(project_id, milestone_id, completed_status)
        )

        result = list(filter((lambda x: re.search(run_name, str(x['name']))), resp['runs']))

        if result:
            return result[0]
        else:
            return None

    def get_specific_section(self, project_id, section_name):
        resp = self.send_get(
            'get_sections/{}'.format(project_id)
        )
        result = list(filter((lambda x: re.search(section_name, str(x['name']))), resp))
        
        if result:
            return result[0]
        else:
            result = self.add_section(project_id, section_name)
            return result

    def close_run(self, run_id):
        resp = self.send_post(
            'close_run/{}'.format(run_id),
            {}
        )
        return resp

class APIError(Exception):
    pass
