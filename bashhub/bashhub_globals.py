"""
This file should be used for declaring any global variables that need to be
pulled in from environment variables or are just used across multiple files.
"""

import os


# Optional environment variable to configure for development
BH_URL = "http://bashhub.com" if "BH_URL" not in os.environ.keys() \
        else os.environ["BH_URL"]

BH_USER_ID = os.environ["BH_USER_ID"]
BH_SYSTEM_ID = os.environ["BH_SYSTEM_ID"]
BH_HOME = "~/.bashhub/" if "HOME" not in os.environ.keys() \
        else os.environ["HOME"] + '/.bashhub'
