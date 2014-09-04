#!/bin/bash -e
#
# Bashhub.com Installation shell script
#
# Ryan Caloras (ryan@bashhub.com)
#
# It must work everywhere, including on systems that lack
# a /bin/bash, map 'sh' to ksh, ksh97, bash, ash, or zsh,
# and potentially have either a posix shell or bourne
# shell living at /bin/sh.
#
# See this helpful document on writing portable shell scripts:
# http://www.gnu.org/s/hello/manual/autoconf/Portable-Shell.html
#
# The only shell it won't ever work on is cmd.exe.


install_bashhub () {
    check_dependencies
    check_already_installed
    setup_bashhub_files
}


download_and_install_env () {
    # Select current version of virtualenv:
    VERSION=1.9.1
    # Name your first "bootstrap" environment:
    INITIAL_ENV=env
    # Options for your first environment:
    ENV_OPTS='--no-site-packages --distribute'
    # Set to whatever python interpreter you want for your first environment:
    PYTHON=$(which python)
    URL_BASE=http://pypi.python.org/packages/source/v/virtualenv

    # --- Real work starts here ---
    echo $URL_BASE/virtualenv-$VERSION.tar.gz
    wget --no-check-certificate $URL_BASE/virtualenv-$VERSION.tar.gz
    tar xzf virtualenv-$VERSION.tar.gz
    # Create the first "bootstrap" environment.
    $PYTHON virtualenv-$VERSION/virtualenv.py $ENV_OPTS $INITIAL_ENV
    # Don't need this anymore.
    rm -rf virtualenv-$VERSION
    # Install the environment.
    $INITIAL_ENV/bin/pip install virtualenv-$VERSION.tar.gz
    # Don't need this anymore either.
    rm virtualenv-$VERSION.tar.gz
}

check_dependencies () {
    if [ -z "$(which wget)" ]; then
        die "\n Sorry you need to have wget instaleld. Please install wget and rerun this script." 1
    fi
}

check_already_installed () {
    if [ -e ~/.bashhub ]; then
        die "\nLooks like the bashhub client is already installed.
        \nrm -r ~/.bashhub to install again" 1
    fi
}

setup_bashhub_files () {

   local bashprofile=`find_users_bash_file`

    mkdir ~/.bashhub
    cd ~/.bashhub
    download_and_install_env
    # For SetupTools Branch
    # wget --no-check-certificate https://github.com/rcaloras/bashhub-client/tarball/SetupTools -O client.tar.gz

    wget --no-check-certificate https://github.com/rcaloras/bashhub-client/tarball/master -O client.tar.gz
    tar -xvf client.tar.gz
    cd rcaloras*
    cp src/shell/bashhub.sh ~/.bashhub/
    cp src/shell/.config ~/.bashhub/.config

    # install our packages. bashhub and dependencies.
    ../env/bin/pip install .

    # Setup our config file
    ../env/bin/bashhub-setup

    # Add our file to .bashrc or .profile
    echo "source ~/.bashhub/bashhub.sh" >> $bashprofile

    #Clean up what we downloaded
    cd ~/.bashhub
    rm client.tar.gz
    rm -r rcaloras*
    echo "should be good to go"
}

find_users_bash_file () {

    # possible bash files to use, order matters
    bash_file_array=( ~/.bashrc ~/.bash_profile ~/.profile)

    for file in "${bash_file_array[@]}"
    do
        if [ -e $file ]; then
            echo $file
            return 0
        fi
     done

     die "No bashfile (e.g. .profile, .bashrc, ect) could be found" 1
}

die () { echo -e $1; exit $2; }

install_bashhub
