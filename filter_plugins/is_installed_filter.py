#!/usr/bin/env python
import subprocess


def is_installed_filter(app_name):
    try:
        subprocess.check_call(["which", app_name])
        return True
    except subprocess.CalledProcessError:
        return False


class FilterModule(object):
    def filters(self):
        return {
            "is_installed": is_installed_filter,
        }
