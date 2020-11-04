# Scheduling
Job schedulers play an important role in selecting optimal resources for the submitted jobs. However, most of the current job schedulers do not consider job-specific characteristics such as communication patterns during resource allocation. This often leads to sub-optimal node allocations. We propose three node allocation algorithms that consider the job's communication behavior to improve the performance of communication-intensive jobs. 
We develop our algorithms for tree-based network topologies. 
The proposed algorithms aim at minimizing network contention by allocating nodes on the least contended switches. We also show that allocating nodes in powers of two leads to a decrease in inter-switch communication for MPI communications, which further improves performance. We implement and evaluate our algorithms using SLURM, a widely-used and well-known job scheduler.

## Academic Publications
- This work has been accepted at [49th International Conference on Parallel Processing - ICPP in  Edmonton, Canada, 2020](https://jnamaral.github.io/icpp20/) as workshop paper. The full text can be found [here](./ICPP_full_paper.pdf). The work was presented at the [16th International Workshop on Scheduling and Resource Management for Parallel and Distributed Systems](https://srmpds.github.io/). The slides for the presentation can be accessed [here](./SRMPDS_slides.pptx). The recorded presentation (20 min) can be accessed [here](https://www.youtube.com/watch?v=h5KQ1v3bWAQ&feature=youtu.be).

## Setup

### Installing and setting up SLURM
Our work proposes three algorithms which have been implemented in SLURM. We use SLURM version 19.05.0 in our work.
The following steps describe how to setup SLURM and use any of the proposed algorithms:
* Clone the source code present [here](https://github.com/Priya2698/slurm_changes). To install SLURM and its associated components follow the instructions provided at the [official site](https://slurm.schedmd.com/quickstart_admin.html). Instructions for installing SLURM have also been provided in the Appendix.
* In order to execute the proposed algorithms, we use the environment variable JOBAWARE. **Before running `make` while building SLURM**,add -DJOBAWARE to CFLAGS in the following Makefiles:
```
/src/plugins/sched/backfill/Makefile
/src/slurmctld/Makefile
/src/plugins/topology/tree/Makefile
```
Add the library `-lm` to `LIBS` in `/src/slurmctld/Makefile`.
* Run `make` and `make install` after making the above changes to the Makefiles.
* Run the script 'makefiles.py' outside the SLURM directory. This creates a copy of Makefile for each algorithms with appropraite environment varible.
```bash
python3 makefiles.py
```
### Running jobs
After setting up SLURM as described above, we can run the default SLURM algorithm or one of the proposed algorithm (greedy, balanced, adaptive). Run the script `prepare_run.sh` outside SLURM directory with appropriate input as shown to use the different algorithms.
* Default SLURM algorithm
```bash
bash prepare_run.sh default
```
* Greedy algorithm
```bash
bash prepare_run.sh greedy
```
* Balanced algorithm
```bash
bash prepare_run.sh bal
```
* Adaptive algorithm
```bash
bash prepare_run.sh ada
```
### Recording the Cost of Communication
The code calculates the cost of communication and writes it to a file. It also records the nodes allocated to a job on different switches. To record the cost of communication and the switch-wise node allocation information of all jobs in a file, provide a valid path in the `/src/slurmctld/calc_hops.c`. Modify the following lines with valid paths:
```
void hop(struct job_record *job_ptr){
        FILE *f;
        f = fopen ("File for recording hops", "a");
        .
        .
        FILE *info;
        info = fopen("File for recording switch-wise node allocation","a");

}
```
### Appendix
Follow these steps to install and build SLURM and its associate components:
#### Install Pre-requisites
```bash
sudo apt update
sudo apt install -y git gcc make libssl-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev
```
#### Install and enable MUNGE
```bash
sudo apt install -y libmunge-dev libmunge2 munge
sudo systemctl enable munge
sudo systemctl start munge
```
Check that MUNGE has installed correctly
```bash
munge -n | unmunge
```
The output should contain this line:
```
STATUS:     Success(0)
```
#### Install Mariadb and setup the database
```
sudo apt install -y mariadb-server
sudo systemctl enable mysql
sudo systemctl start mysql
```
Setup the database after installing Mariadb. Provide an appropriate username, database name and password in these commands.
```
sudo mysql -u root
create database slurm_acct_db;
create user 'ubuntu'@'localhost';
set password for 'ubuntu'@'localhost' = password('slurmdbpass');
grant usage on *.* to 'ubuntu'@'localhost';
grant all privileges on slurm_acct_db.* to 'ubuntu'@'localhost';
flush privileges;
select user from mysql.user;
```
The ouput from the last line should show the user added to the database.
#### Clone the repository and build SLURM
Clone the repository present [here](https://github.com/Priya2698/slurm_changes).
Switch to the code-repository (We are assuming it is named slurm_changes) and run configure.
```
cd slurm_changes
./configure --enable-debug --enable-front-end
```
Ensure that configure was successful and there was no error. If the configure failed then it maybe due to some missing pre-requisites. Please resolve those issues before moving ahead. You may refer to the [official site](https://slurm.schedmd.com/quickstart_admin.html) for troubleshooting errors.

**Make changes to the Makefile as [described above](#installing-and-setting-up-slurm).**
Run make and make install
```
make
sudo make install
```
Ensure that the build is successful.

#### Create the required directories
Create the required directories and change the owner to the SLURM user (here ubuntu).
```
sudo mkdir -p /var/spool/slurmctld /var/spool/slurmd /var/log/slurm
sudo chown ubuntu /var/spool/slurmctld /var/spool/slurmd /var/log/slurm
```
#### SLURM configuration files
SLURM requires `slurm.conf` and `topology.conf` files to be present in `/usr/local/etc`. The service files should be present at `/etc/systemd/system`. These files have also been provided in this repository [here]().
Copy them to the appropriate folders.
```
sudo cp slurm.conf topology.conf slurmdbd.conf /usr/local/etc
sudo cp slurmctld.service slurmdbd.service slurmd.service /etc/systemd/system
```
#### Start the SLURM daemons and check status
```
sudo systemctl enable slurmdbd
sudo systemctl enable slurmctld
sudo systemctl enable slurmd

sudo systemctl start slurmdbd
sudo systemctl status slurmdbd
sudo systemctl start slurmctld
sudo systemctl status slurmctld
sudo systemctl start slurmd
sudo systemctl status slurmd
```
If the build was successful, the status will show the daemons to be active and running.

#### Add Cluster
Add a cluster to SLURM (here the name is cluster)
```
sacctmgr add cluster cluster
sacctmgr show cluster
```
The output of the last line should show the cluster added.


