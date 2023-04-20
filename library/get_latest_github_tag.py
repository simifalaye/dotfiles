#!/usr/bin/env python3
from ansible.module_utils.basic import AnsibleModule
import requests

def get_latest_github_tag(owner, repo):
    url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
    response = requests.get(url)
    if response.status_code != 200:
        return {"failed": True, "msg": "Failed to retrieve latest tag from Github API."}
    latest_tag = response.json()["tag_name"]
    return {"changed": True, "latest": latest_tag}

def main():
    module_args = dict(
        owner=dict(type='str', required=True),
        repo=dict(type='str', required=True)
    )
    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)
    owner = module.params['owner']
    repo = module.params['repo']
    result = get_latest_github_tag(owner, repo)
    module.exit_json(**result)

if __name__ == '__main__':
    main()
