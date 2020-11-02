# Scheduling
Job schedulers play an important role in selecting optimal resources for the submitted jobs. However, most of the current job schedulers do not consider job-specific characteristics such as communication patterns during resource allocation. This often leads to sub-optimal node allocations. We propose three node allocation algorithms that consider the job's communication behavior to improve the performance of communication-intensive jobs. 
We develop our algorithms for tree-based network topologies. 
The proposed algorithms aim at minimizing network contention by allocating nodes on the least contended switches. We also show that allocating nodes in powers of two leads to a decrease in inter-switch communication for MPI communications, which further improves performance. We implement and evaluate our algorithms using SLURM, a widely-used and well-known job scheduler.

## Academic Publications
- This work has been accepted at [49th International Conference on Parallel Processing - ICPP in  Edmonton, Canada, 2020](https://jnamaral.github.io/icpp20/) as workshop paper. The full text can be found [here](./ICPP_full_paper.pdf). The work was presented at the [16th International Workshop on Scheduling and Resource Management for Parallel and Distributed Systems](https://srmpds.github.io/). The slides for the presentation can be accessed [here](./SRMPDS_slides.pptx). The recorded presentation (20 min) can be accessed [here](https://www.youtube.com/watch?v=h5KQ1v3bWAQ&feature=youtu.be).

## Setup
Our work proposes three algorithms which have been implemented in SLURM. We use SLURM version 19.05.0 in our work.
The following steps describe how to setup SLURM and use any of the proposed algorithms:
* Clone the source code present [here](https://github.com/Priya2698/slurm_changes). To install SLURM follow the instructions provided at the [official site](https://slurm.schedmd.com/quickstart_admin.html).
* In order to execute the proposed algorithms, we use the environment variable JOBAWARE. Add -DJOBAWARE to CFLAGS in the following Makefiles:
```
/src/common/Makefile
/src/plugins/sched/backfill/Makefile
/src/slurmctld/Makefile
/src/plugins/topology/tree/Makefile
```
* For ease of switching between the algorithms (default, 
