#!/bin/bash

# This is a script to list all users in the Unix system.
# Tested through under Bash.
# 
# By lfqy.
# Finished on 20141220_1512
# 
# Running step:
# Making sure you are using BASH.
# chmod a+x user_print.sh
# ./user_group_info_print.sh
# All user(apart from system user) on the system will be listed.


#Print a table head with printf, String Left Aligning with fixed length.
printf "%-7s %-4s %-13s  %-15s\n" User UID "PrimaryGroup" "SecondaryGroup"
#Get the user info, user name, uid and gid, from /etc/passwd
awk -F: '$3>=500 {print $1,$3,$4}' /etc/passwd | while read user uid gid
do
    #Get the primary group name from /etc/group, using gid.
	priGro=`awk -F: '$3=="'$gid'" {print $1}' /etc/group`
	secGro=''

    #Get all the group not reserved for operating system.
    #For every group, test if it is the secondary group of $user.
	for gro_mem in `awk -F: 'BEGIN{OFS=":"}$3>="'$gid'" {print $1,$4}' /etc/group`
	do
        #Get the group member
		secMem=":${gro_mem#*:}"
        #Get the group name
		groName=${gro_mem%%:*}
        #Testing, ':' existing for the case lfqy and lfqy0
		if ([[ $secMem = *",$user,"* ]] || [[ $secMem = *",$user" ]]) || ([[ $secMem = *":$user" ]] || [[ $secMem = *":$user,"* ]])
		then
            #Append a group name to the secondary group string
			secGro=$secGro","$groName
		fi
	done
    #Print a line of user information.
	printf "%-7s %-4s %-13s  %s\n" $user $uid $priGro ${secGro#*,}
done
