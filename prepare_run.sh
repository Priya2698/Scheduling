#!bin/bash
algo=$1

echo "Checking branch, status and setting Makefile"
cd ~/slurm_changes/src/plugins/select/linear
if [[ $algo = "default" ]];
then
    echo "Default"
    git checkout master
    git branch
    cp Makefile_default Makefile

elif [[ $algo = "greedy" ]];
then
    echo "greedy"
    git checkout master
    git branch
    cp Makefile_greedy Makefile

elif [[ $algo = "bal" ]];
then
    echo "balanced"
    git checkout algo2
    git branch
    cp Makefile_bal Makefile
elif [[ $algo = "ada" ]];
then
    echo "adaptive"
    git checkout algo2
    git branch
    cp Makefile_ada Makefile
elif [[ $algo = "inter" ]];
then
    echo "interference"
    git checkout interference
    git branch
    cp Makefile_greedy Makefile
fi
make clean
make
cd ../../../..

echo " Running make "
make
echo " Running make install "
sudo make install
echo " Restarting and checking slurmctld status"
sudo systemctl restart slurmctld
sudo systemctl status slurmctld
echo " Restarting and checking slurmd status"
sudo systemctl restart slurmd
sudo systemctl status slurmd
