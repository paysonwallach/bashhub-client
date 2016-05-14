from bashhub.bashhub import bashhub_globals
import ConfigParser
import os


def test_is_valid_regex():
    invalid_regex = '[a-2]'
    valid_regex = '(filter_me|ssh)'
    assert False == bashhub_globals.is_valid_regex(invalid_regex)
    assert True == bashhub_globals.is_valid_regex(valid_regex)


def test_write_to_config_file(tmpdir):
    bashhub_globals.BH_HOME = tmpdir.mkdir('.bashhub').strpath
    bashhub_globals.write_to_config_file("access_token", 'some-auth-token')
    config = ConfigParser.ConfigParser()
    config.read(bashhub_globals.BH_HOME + '/config')
    assert config.get('bashhub', 'access_token') == 'some-auth-token'
