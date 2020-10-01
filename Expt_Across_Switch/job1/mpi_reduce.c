#include<stdio.h>
#include<stdlib.h>  // To remove warning for atoi()
#include "mpi.h"
#include <time.h>
int main(int argc, char *args[]){
    int myrank, size, i, iter;
    double start_time, duration=0, maxtime;
    if(argc < 4){
        printf("Insufficient arguments...Please mention the #bytes to be sent");
        return -1;
    }
    // Getting the number of bytes to be transferred using command line args
    int D = atoi(args[1])/4;
    int runs = atoi(args[2]);
    // Initializing MPI
    MPI_Init(&argc,&args);
    // Getting the total number of processes in the communicator
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
    for(iter=0;iter<runs;iter++) {
        int *recvarr = (int *)malloc(D*sizeof(int));
        int *arr = (int *)malloc(D*sizeof(int));
        // Data initialisation
        for(i=0;i<D;i++) {
            arr[i] = myrank + i;
        }
        start_time = MPI_Wtime();
        MPI_Reduce(arr, recvarr, D, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
        duration += MPI_Wtime() - start_time;
        free(arr);
        free(recvarr);
    }
    duration /= runs;
    //Getting the time for MPI_Allgather
    MPI_Reduce(&duration, &maxtime, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);    
    if(myrank == 0) {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        printf("%d-%02d-%02d %02d:%02d:%02d MPI_Reduce(%s): %lf secs\n",tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, args[3],maxtime);
    }
    // Finalizing MPI -> destroying all data structures and other things created at the time of initialization
    MPI_Finalize();
    return 0;
}
