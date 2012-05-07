# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
export PS1="[\u@\h \W]\$ "

# User specific environment and startup programs

export PATH=/usr/local/rvm/bin:$PATH
export PATH=/usr/java/latest/bin:$PATH
export PATH=/usr/java/ant/bin:$PATH
export PATH=/root/opt/ssoadmin/openam/bin:$PATH
export PATH=/etc/pki/tls/misc:$PATH
export PATH=$HOME/bin:$PATH
export JAVA_HOME=/usr/java/jdk1.6.0_25
export ANT_HOME=/usr/java/ant

