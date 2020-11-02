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
* Clone the source code present [here](https://github.com/Priya2698/slurm_changes). To install SLURM follow the instructions provided at the [official site](https://slurm.schedmd.com/quickstart_admin.html). Alternatively, the script `install_slurm.sh` can be used for the complete setup.
* In order to execute the proposed algorithms, we use the environment variable JOBAWARE. Add -DJOBAWARE to CFLAGS in the following Makefiles:
```
/src/common/Makefile
/src/plugins/sched/backfill/Makefile
/src/slurmctld/Makefile
/src/plugins/topology/tree/Makefile
```
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
