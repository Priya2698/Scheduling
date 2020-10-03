ssh-keygen -t rsa
cd ~/.ssh
cat id_rsa.pub >>  authorized_keys
echo "StrictHostKeyChecking no" >> config
rm -f known_hosts

for i in `seq 1 50`
do
ssh csews$i uptime
done
