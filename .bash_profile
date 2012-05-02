# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
export PS1="[\u@\h \W]\$ "

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
export PATH=/usr/local/rvm/bin:$PATH
export PATH=/usr/java/latest/bin:$PATH
export JAVA_HOME=/usr/java/jdk1.6.0_25
export PATH=/root/opt/ssoadmin/openam/bin:$PATH
export PATH=/etc/pki/tls/misc:$PATH
