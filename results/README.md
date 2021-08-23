The directory is organised as follows:
- **Continuous**: Contains final results from `continuous` runs
- **Individual**: Contains final results from `individual` runs`
- **Logs**: Contains the log files used for obtaining the results

The results contain all relevan metrics for the respective experiments. 

The naming convention of the files is as: `[log]_[algorithm]`, 
where `[log]` is anl (Intrepid), theta, or mira corresponding to each of the three job logs, and `[alogrithm]` is one of `greedy/bal/ada/inter` corresponding to greedy, 
balanced, adaptive, and interference-aware node-allocation algorithms.

They include all information about the runtime, wait time, node hours, tunraround times for all communication patterns and the 
improvements when compared with default. `[pattern]` below is one of `rhvd/rd/bin/cmc` corresponding to recursive doubling vector halving, recursive doubling,
binomial, and CMC-2D communication patterns. `ja` specifies jobaware algoritm which is one of `greedy/bal/ada/inter`, and is known from the file name.

The columns are:
1. `Job_name` : Job ID according to the job logs
2. `Submit`: Submit time 
3. `Runtime`: Original or default runtime
4. `Nodes`: Nodes requested
5. `Comment`: Compute(0)/Communication(1)
6. `Perc`: Communication Percent (10/30/50/70/90)
7. `mod_[pattern]`: Modified runtime under the jobaware algorithm using the specified communication pattern. Here, `[pattern]` is one o
8. `def_cost_[pattern]`: Cost of communication for default algorithm and different patterns
9. `ja_cost_[pattern]`: Cost of communication for jobaware algorithm and different patterns
10. `def_wait`: Wait time of the job under default algorithm
11. `[pattern]_wait`: Wait time of the job under jobaware algorithm for different patterns
12. `def_nh` : Nodehours under default algorithm
13. `[pattern]_nh`: Nodehours of the job under jobaware algorithm for different patterns
14. `improv_[pattern]`: % improvement in runtime
15. `improv_wait_[pattern]`: % improvement in wait time
16. `improv_cost_[pattern]`: % improvement in cost
17. `improv_nh_[pattern]`: % improvement in nodehours
18. `def_turn`: Default turnaround time
19. `[pattern]_turn`: Turnaround time of the job under jobaware algorithm for different patterns
20. `improv_turn_[pattern]`: % improvement in turnaround time

The rows contain a specific job. The last two rows are sum and max. The sum row contains the sum of the particular metric for all 3000 jobs (sum of all runtime/wait time and so on).
For the columns which contain % improvement, it does not contain the sum of individual improvements. It contains the overall percentage improvement calculated using total sum across all 3000 jobs.
For instance, for the column, improv_rhvd, the rows have individual job % improvements. The sum row contains 100*(Total Runtime under Default - Total Runtime under jobware)/Total Runtime under Default.
