prepare_ansible_hosts
========================
This script prepares ansible hosts file by checking a list of provided hosts for available machines.


# Why to use?
So in case of running Ansible on a huge number of hosts, you should check if there are any hosts down or unreachable so you can avoid working on them or try to fix the problem.
This script identifies the unreachable hosts, extracts the available hosts and put them in Ansible hosts file. 


# How to use?

Just adjust the variables for your own file paths.

**NOTE:** Every host check runs in a background process so in case of huge number of hosts this can fill up your RAM, so take care before using it (6k hosts 2GB RAM).
