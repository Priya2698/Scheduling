#!bin/bash
echo 'Install Pre-requisites'
sudo apt-get update
sudo apt-get install -y git gcc make ruby ruby-dev libssl-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev python python3
sudo gem install fpm

echo 'Install and enable munge'
sudo apt-get install -y libmunge-dev libmunge2 munge
sudo systemctl enable munge
sudo systemctl start munge
munge -n | unmunge | grep STATUS

echo 'Install Mariadb'
sudo apt-get install -y mariadb-server
sudo systemctl enable mysql
sudo systemctl start mysql

echo ' Setting the database'
sudo mysql -u root << EOF
create database slurm_acct_db;
create user 'ubuntu'@'localhost';
set password for 'ubuntu'@'localhost' = password('slurmdbpass');
grant usage on *.* to 'ubuntu'@'localhost';
grant all privileges on slurm_acct_db.* to 'ubuntu'@'localhost';
flush privileges;
select user from mysql.user;
exit
EOF

echo 'Clone the repository'
git clone https://github.com/Priya2698/slurm_changes.git
echo 'Changing directory and configuring'
cd slurm_changes
./configure --enable-debug --enable-front-end
make
sudo make install

echo 'Create the required directories'
sudo mkdir -p /var/spool/slurmctld /var/spool/slurmd /var/log/slurm
sudo chown ubuntu /var/spool/slurmctld /var/spool/slurmd /var/log/slurm

echo 'Move files'
cd /home/ubuntu
sudo cp slurm.conf topology.conf slurmdbd.conf hpc2010.conf /usr/local/etc
sudo cp slurmctld.service slurmdbd.service slurmd.service /etc/systemd/system

echo 'Start and check status'
sudo systemctl enable slurmdbd
sudo systemctl enable slurmctld
sudo systemctl enable slurmd

sudo systemctl start slurmdbd
sudo systemctl status slurmdbd
sudo systemctl start slurmctld
sudo systemctl status slurmctld
sudo systemctl start slurmd
sudo systemctl status slurmd

scontrol ping
sinfo

echo 'Add cluster'
sacctmgr add cluster cluster
