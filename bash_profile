# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

alias python=python3
alias pip=pip3

# iterm 2 title
function title {
    echo -ne "\033]0;"$*"\007"
}

alias h='cat /etc/hosts'

alias venv_activate='. venv/bin/activate'
alias venv_create='python -m venv venv'
alias venv_reqs='pip install -r requirements.txt'

# MySQL Path
#################################################
PATH="/usr/local/mysql/bin:${PATH}"
export PATH

#################################################
# Ansible Dev
#################################################

function ansible_update_fork {
  git clone https://github.com/kairoaraujo/ansible;
  cd ansible;
  git remote add upstream https://github.com/ansible/ansible.git;
  git pull upstream devel;
  git push;
}

# setup my dev ansible
function ansible_setup_dev {
  ansible_update_fork
  python3 -m venv venv; 
  pip install virtualenv; 
  . venv/bin/activate; 
  pip install -r requirements.txt; 
  . hacking/env-setup;
  echo -e "What is the new branch name?"
  read branch_name
  git checkout -b $branch_name

  title $(git branch | grep "*" | awk '{ print $2 }')
}

# initialize dev ansible
function ansible_init_dev_env {
  . venv/bin/activate 
  . hacking/env-setup;  
  title $(git branch | grep "*" | awk '{ print $2 }')
}

# download my specific branch
function ansible_download_dev { 
  echo -e "Which branch? "
  read branch_name
  git clone -b $branch_name http://github.com/kairoaraujo/ansible
  cd ansible
  python3 -m venv venv; 
  pip install virtualenv; 
  . venv/bin/activate; 
  pip install -r requirements.txt; 
  . hacking/env-setup;
  title $(git branch | grep "*" | awk '{ print $2 }')
}

# test module
function ansible_test_module { 
  if [ -z ${1} ] || [ -z ${2} ]; then
     echo "Use: ansible_test_module module_name module_dir"
  else
    for i in  docker pycodestyle mock voluptuous; do
        pip freeze | grep ${i}
        if [ $? -ne 0 ]; then
            pip install ${i}
        fi
    done

    echo "--docker --python 3.5"
    ansible-test sanity -v --docker --python 3.5 ${1}

    echo "sanity --test pep8"
    ansible-test sanity --test pep8 ${1}

    echo "sanity --test validate-modules"
    ansible-test sanity --test validate-modules  ${1}

    echo "validate-modules --format json for doc"
    test/sanity/validate-modules/validate-modules --format json lib/ansible/modules/${2}/${1}.py —exclude '^(lib/ansible/modules/utilities/logic/async_status.py|lib/ansible/modules/utilities/helper/_accelerate.py)' --base-branch origin/devel
  fi
}

function docker_ips {
  docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'
}
