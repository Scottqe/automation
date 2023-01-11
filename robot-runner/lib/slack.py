# import requests

# class Slack(object):

#     def __init__(self, host=""):
#         self.HOST = host
#         self.SESSION = requests.Session()
#         self.SESSION.headers.update({
#             'Content-Type': 'application/json'
#         })
    
#     def request(self, method, **kwargs):
#         resp = self.SESSION.request(method, self.HOST, **kwargs)
#         return resp
    
#     def generate_payload(self, pretext, pass_case, fail_case, icon="", pass_color="#5F9EA0", fail_color="#f75000"):
#         pass_list = [f"- {i.case_name}" for i in pass_case]
#         pass_str = "\n".join(pass_list)
#         fail_list = [f"- {i.case_name}" for i in fail_case]
#         fail_str = "\n".join(fail_list)
#         payload = {
#             "username": "Automation report",
#             "icon_emoji": icon,
#             "attachments": [{
#                 "pretext": pretext
#             },{
#                 "color": fail_color,
#                 "title": f"Failed: {len(fail_list)}",
#                 "text": fail_str
#             },{
#                 "color": pass_color,
#                 "title": f"Passed: {len(pass_list)}",
#                 "text": pass_str
#             }],
#                 "channel": "#dqa-testing",
#                 "link_names": True
#             }

#         return payload