#!/usr/bin/python

from distutils.core import setup
#from setuptools import setup,find_packages

NAME = "iptables-builder"
VERSION = "0.1"
SHORT_DESC = "Simple wrapper script that helps generate iptables configuration"
LONG_DESC = """
To help ease configuration management of iptables this script will read
ordered files from a directory and compile the system's iptables configuration
from them.
"""


if __name__ == "__main__":
 
        setup(
                name = NAME,
                version = VERSION,
                author = 'Greg Swift',
                author_email = 'gregswift@gmail.com',
                url = "https://github.comf/gregswift/%s" % NAME,
                license = "GPLv3",
                scripts = ["scripts/%s" % NAME],
                data_files = [("etc/%s" % NAME,  ["config"]),
                              ("etc/%s/available.d" % NAME, []),
                              ("etc/%s/enabled.d" % NAME, [])],
                description = SHORT_DESC,
                long_description = LONG_DESC
        )


