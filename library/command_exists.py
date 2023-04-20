#!/usr/bin/env python3

from ansible.module_utils.basic import AnsibleModule
import subprocess

def command_exists(command):
    try:
        subprocess.check_call(['which', command])
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    module = AnsibleModule(argument_spec={'command': {'type': 'str', 'required': True}})
    command = module.params['command']
    exists = command_exists(command)
    result = {'exists': exists}
    module.exit_json(**result)

if __name__ == '__main__':
    main()
