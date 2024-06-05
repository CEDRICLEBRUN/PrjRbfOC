from robot.api.deco import keyword
import os
import sys
import time
import re
import unicodedata
from datetime import datetime
from robot.libraries.BuiltIn import BuiltIn


def clean_string_filename(str):
    clean1 = re.sub(r'[\\/*?:"<>| ]',"",str)
    clean2 = ''.join((c for c in unicodedata.normalize('NFD', clean1) if unicodedata.category(c) != 'Mn'))
    return clean2


@keyword('This is keyword with custom name')
def xxx():
    pass
