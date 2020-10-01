1) Extract the Experiment Archive
2) Run job1.sh and job2.sh after setting which two switches you want them to run on for across allgather
3) You will then get two output files as job1_log and job2_log which contains the all entries for the time till then they run.
4) Extract the entries for both log files corresponding to "MPI_Allgather" as:
cat job1_log | grep -e "MPI_Allgather(comm_across_1024000)" > data1
cat job2_log | grep -e "MPI_Allgather(comm_across_1024000)" > data2
5) Then to convert the above extracted data into csv files, use the "log_to_csv.ipynb" file present in graph_scripts folder of experiment.
Note: You need to edit the log_to_csv file for both extracted data files.
6) At last, use the "plot.ipynb" file to create the graph.
Note: In the "plot.ipynb" file, i have created a clipped graph so you to set the time window accordingly on this line:
clipped_data = main_data.loc[(main_data['Time Interval(secs)'] >= 22000) & (main_data['Time Interval(secs)'] <= 55000)]
