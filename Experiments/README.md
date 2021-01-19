The files theta_bal.csv and theta_inter.csv contain all information about the balanced and interference-aware experiments for theta log. 
They include all information about the runtime, wait time, node hours, tunraround times for all communication patterns and the improvements when compared with default.
The columns are:
1. 'Job_name' : Job ID according to the job logs
2. 'Submit': Submit time 
3. 'Runtime': Original or default runtime
4. 'Nodes': Nodes requested
5. 'Comment': Compute(0)/Communication(1)
6. 'Perc': Communication Percent (10/30/50/70/90)
7. 'mod_rhvd','mod_rd', 'mod_bin', 'mod_cmc': Modified runtime under the jobaware algorithm
8. 'def_cost_rhvd', 'def_cost_rd','def_cost_bin', 'def_cost_cmc': Cost of communication for default algorithm and different patterns
9. 'ja_cost_rhvd', 'ja_cost_rd', 'ja_cost_bin', 'ja_cost_cmc': Cost of communication for jobaware algorithm and different patterns
10. 'def_wait': Wait time of the job under default algorithm
11. 'rhvd_wait', 'rd_wait', 'bin_wait', 'cmc_wait': Wait time of the job under jobaware algorithm for different patterns
12. 'def_nh' : Nodehours under default algorithm
13. 'rhvd_nh', 'rd_nh', 'bin_nh', 'cmc_nh': Nodehours of the job under jobaware algorithm for different patterns
14. 'improv_rhvd', 'improv_rd', 'improv_bin', 'improv_cmc': % improvement in runtime
15. 'improv_wait_rhvd', 'improv_wait_rd', 'improv_wait_bin', 'improv_wait_cmc': % improvement in wait time
16. 'improv_cost_rhvd', 'improv_cost_rd', 'improv_cost_bin', 'improv_cost_cmc' :% improvement in cost
17. 'improv_nh_rhvd', 'improv_nh_rd', 'improv_nh_bin', 'improv_nh_cmc': % improvement in nodehours
18. 'def_turn': Default turnaround time
19. 'rhvd_turn', 'rd_turn', 'bin_turn', 'cmc_turn': Turnaround time of the job under jobaware algorithm for different patterns
20. 'improv_turn_rhvd', 'improv_turn_rd', 'improv_turn_bin', 'improv_turn_cmc': % improvement in turnaround time

The rows contain individual jobs. The last two rows are sum and max. The sum row contains the sum of the particular metric for all 3000 jobs (sum of all runtime/wait time and so on).
For the columns which contain % improvement, it does not contain the sum of individual improvements. It contains the overall percentage improvement calculated using total sum across all 3000 jobs.
For instance, for the column, improv_rhvd, the rows have individual job % improvements. The sum row contains 100*(Total Runtime under Default - Total Runtime under jobware)/Total Runtime under Default.
