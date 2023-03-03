#!/bin/sh

# Run Ansible
ansible-playbook -i ./hosts ./linux.yml --ask-become-pass
