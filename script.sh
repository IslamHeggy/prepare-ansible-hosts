#!/bin/bash

#This script takes a file of ips and return a file of records

#Change username and password due to your environment
hosts_user=""
hosts_pass=""

#Change this value for your ips file path
ips_file=""

#Change this value for your results file path.
list_results=""

#Change this value for a valid path for reached ips.
reached_ips=""

#Change this for your ansible hosts file path.
ans_hosts=""

#This function checks the hosts via ping and ssh
check_host ()
{

ping -c 1 "$1" &> /dev/null

	if [ $? -ne 0 ]; then

		ping_status="NO"
		ssh_status="NO"
		machine_hostname="UNKNOWN HOSTNAME"
	else
		ping_status="YES"

                machine_hostname=$(sshpass -p "$hosts_pass" ssh "$hosts_user"@"$1" "hostname" 2> /dev/null )

			if [ $? -ne 0 ]; then

				ssh_status="NO"
				machine_hostname="UNKNOWN HOSTNAME"
			else
				ssh_status="YES"
				echo "$1" >> "$reached_ips"
			fi

	fi

	echo ""$1" "$machine_hostname"  ping: "$ping_status" ssh: "$ssh_status" $(date) " >> "$list_results"
}

###
# Main body of script starts here
###

while read ip_record
do
	check_host "$ip_record" &

done < $ips_file

org_count=$(wc -l $ips_file | cut -d' ' -f1)
res_count=$(wc -l $list_results | cut -d' ' -f1)


while [ $org_count -ne $res_count ]
do
	org_count=$(wc -l $ips_file | cut -d' ' -f1)
	res_count=$(wc -l $list_results | cut -d' ' -f1)
		sleep 5s
done

cp $reached_ips $ans_hosts
sed '1 s/^/[all]\n/' -i $ans_hosts
