#!/usr/bin/python
import json
import sys
import requests
from requests import ConnectionError
import cli.app
import os

from model import Command
from model import UserContext
from bashhub_globals import *


@cli.app.CommandLineApp
def bashhub(app):

    pid = app.params.pid
    pid_start_time = app.params.pid_start_time
    command = app.params.command
    path = app.params.path

    context = UserContext(pid, pid_start_time, BH_USER_ID, BH_SYSTEM_ID)
    command = Command(command, path, context)
    url = BH_URL + "/command"
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    try:
        r = requests.post(url, data=command.to_JSON(), headers=headers)
    except ConnectionError as error:
        pass

bashhub.add_param("command", help="command to record", type=str)
bashhub.add_param("path", help="the path the command was executed in", type=str)
bashhub.add_param("pid", help="the pid of the shell this command executed in", type=long)
bashhub.add_param("pid_start_time", help="start time of the parent pid", type=long)

def main():
    try:
        bashhub.run()
    except Exception as e:
        print "Oops, look like an exception occured: " + str(e)

main()
