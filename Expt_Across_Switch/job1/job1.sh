#! /bin/bash 

TIMESTAMP=$(date)
# Array for specifying different data configuration
DATA_SIZE=(1024000)
# Number of nodes on which to run the jobs
NODES=8
# Counter for displaying number of readings in the log file
COUNT=0
# Name of log file to be created as a result of this script
LOG_FILE=job1_log
# For specifying number of iterations for mpi_allgather/mpi_reduce
RUNS=2000
# Sleep Time
# SLEEP_TIME=2h

make clean
make
if [ -e "$LOG_FILE" ]
then
    mv $LOG_FILE "logs/$TIMESTAMP.log"
fi
rm -f $LOG_FILE
echo "Switch1 and Switch3 used for the experiment with $NODES nodes(PPN=1):" >> $LOG_FILE


# Declare Nodes Under switch 1 and switch 3
SWITCH1=(csews1 csews2 csews3 csews4 csews5 csews6 csews7 csews8 csews9 csews10 csews11 csews12 csews14 csews15 csews16 csews31)
# SWITCH2=(csews13 csews17 csews18 csews19 csews20 csews21 csews22 csews23 csews24 csews25 csews26 csews27 csews28 csews29 csews30 csews32) 
SWITCH3=(csews33 csews34 csews35 csews36 csews37 csews38 csews39 csews40 csews41 csews42 csews43 csews44 csews46)
# SWITCH4=(csews45 csews47 csews48 csews49 csews50 csews51 csews52 csews53 csews54 csews55 csews56 csews57 csews58 csews59 csews60 csews61)
# Function to join array elements by comma
function join { local IFS="$1"; shift; echo "$*"; }

# Function to log cpu usagee of every live node given as parameter
function get_cpu_usage() {
    for node in $@
    do
        echo "$node:" >> $LOG_FILE
        ssh $node ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head >> $LOG_FILE
    done
}

# Infinite loop running configurations every 2h
while true
do
    ((COUNT++))
    liveNodes1=()
    liveNodes2=()
    # Getting active nodes under SWITCH1
    for i in ${SWITCH1[@]}
    do
        if ping -c1 -w1 $i &>/dev/null
            then liveNodes1+=($i)
        fi
    done
    # Getting active nodes under SWITCH3
    for i in ${SWITCH3[@]}
    do
        if ping -c1 -w1 $i &>/dev/null
            then liveNodes2+=($i)
        fi
    done 

    # Extracting 8 nodes from switches
    # Switch1
    # nodes1=$(join , ${liveNodes1[@]:0:8})
    # Switch1 + Switch3
    nodes2=$(join , ${liveNodes1[@]:0:4}),$(join , ${liveNodes2[@]:0:4})
    # Switch3
    # nodes3=$(join , ${liveNodes2[@]:0:8})

    TIMESTAMP=$(date)
    echo $TIMESTAMP
    # Logging reading count in log file
    echo "Reading $COUNT:" >> $LOG_FILE
    echo "//-----------$TIMESTAMP-----------//" >> $LOG_FILE
    
    echo "Total Active Nodes under Switch1=${#liveNodes1[@]} and Switch3=${#liveNodes2[@]}" >> $LOG_FILE
    # echo "> Operating Nodes for same switch1 case: $nodes1" >> $LOG_FILE
    echo "> Operating Nodes across switch 1 and 3: $nodes2" >> $LOG_FILE
    # echo "> Operating Nodes for same switch3 case: $nodes3" >> $LOG_FILE
    

    # CPU Usage before job execution for all nodes
    echo "CPU Usage before job execution($COUNT):" >> $LOG_FILE 
    get_cpu_usage ${liveNodes1[@]}
    get_cpu_usage ${liveNodes2[@]}

    # For running different data configurations
    for data_size in ${DATA_SIZE[@]}
    do
        echo "# Datasize = $data_size Bytes" >> $LOG_FILE
        # mpiexec for Switch1
        # echo ">> For nodes under same switch1:" >> $LOG_FILE
        # mpiexec -np 8 -ppn 1 --hosts $nodes1 ./mpi_allgather.o $data_size $RUNS switch1_$data_size >> $LOG_FILE
        # mpiexec -np 8 -ppn 1 --hosts $nodes1 ./mpi_reduce.o $data_size $RUNS switch1_$data_size >> $LOG_FILE
        # mpiexec for Switch1 + Switch3
        echo ">> For nodes across switch1 and switch3:" >> $LOG_FILE
        mpiexec -np 8 -ppn 1 --hosts $nodes2 ./mpi_allgather.o $data_size $RUNS across_$data_size >> $LOG_FILE
        # mpiexec -np 8 -ppn 1 --hosts $nodes2 ./mpi_reduce.o $data_size $RUNS across_$data_size >> $LOG_FILE
        # mpiexec for Switch3
        # echo ">> For nodes under same switch3:" >> $LOG_FILE
        # mpiexec -np 8 -ppn 1 --hosts $nodes3 ./mpi_allgather.o $data_size $RUNS switch3_$data_size >> $LOG_FILE
        # mpiexec -np 8 -ppn 1 --hosts $nodes3 ./mpi_reduce.o $data_size $RUNS switch3_$data_size >> $LOG_FILE
    done
    
    # CPU Usage after job execution
    echo "CPU Usage after job execution($COUNT):" >> $LOG_FILE 
    get_cpu_usage ${liveNodes1[@]}
    get_cpu_usage ${liveNodes2[@]}

    
    
    echo "$COUNT Readings completed"
    # Exit TimeStamp
    TIMESTAMP=$(date)
    echo "Exiting $TIMESTAMP"
    echo "Exiting $TIMESTAMP" >> $LOG_FILE
    echo -e "" >> $LOG_FILE
    # FIN_TIME=$(date +%s)
    # echo $FIN_TIME > timer
    # echo $FIN_TIME
    # sleep $SLEEP_TIME
done