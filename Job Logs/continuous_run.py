#!/usr/bin/env python
import numpy as np
import pandas as pd
import os
import sys
import subprocess

logfile = sys.argv[1]
logname = sys.argv[2]
pattern = sys.argv[3] ## Patterns are: None(default/greedy/bal), rhvd,rd,bin,ring,cmc (In ada)
jobfile = sys.argv[4]

## Check if hops and debug files are present
## If present, warn and exit
## Else create files and write the column headers
def create_files():
    if os.path.exists('hops.txt'):
        sys.exit("Hops file exists. Please move content.")
    if os.path.exists('debug.txt'):
        sys.exit("Debug file exists. Please move content.")
    hops = open('hops.txt','w')
    hops.write('Job_name JobID Comment Fat_rhvd Tree_rhvd Fat_rd Tree_rd Binomial Ring\n')
    hops.close()
    debug = open('debug.txt','w')
    debug.close()
    print("Files created!")

## Scale down time and nodes
def scale(df):
    yes = {'yes','y', 'ye', ''}
    no = {'no','n'}
    sys.stdout.write("Log is %s?"%logname)
    choice = input().lower()
    if choice in yes:
        print("Logname is correct.")
    elif choice in no:
        sys.exit("Logname information was incorrect. Exit!")
    else:
        sys.stdout.write("Please respond with 'yes' or 'no'")
        sys.exit(0)

    if logname == 'anl':
        df['Submit'] = df['Submit']//10
        df['Runtime'] = df['Runtime']//10
        df['Nodes'] = df['Nodes']//4
    elif logname == 'theta':
        df['Submit'] = df['Submit']//10
        df['Runtime'] = df['Runtime']//10
        def check(x):
            if df.loc[x,'Nodes']>1:
                df.loc[x,'Nodes'] = df.loc[x,'Nodes']//2
        df.reset_index()['index'].apply(check)
    elif logname == 'mira':
        df['Submit'] = df['Submit']//10
        df['Runtime'] = df['Runtime']//10
        df['Nodes'] = df['Nodes']//4
    else:
        sys.exit("Logname is not provided")
    print("Logs are scaled!")
    return df

## Append pattern to comment if given (only in case of adaptive)
def add_pattern(df):
    yes = {'yes','y', 'ye', ''}
    no = {'no','n'}
    sys.stdout.write("Pattern is %s?"%pattern)
    choice = input().lower()
    if choice in yes:
        print("Pattern information is correct.")
    elif choice in no:
        sys.exit("Pattern information was incorrect. Exit!")
    else:
        sys.stdout.write("Please respond with 'yes' or 'no'")
        sys.exit(0)
    ## Now if pattern is not None, make changes
    pattern_dict = {'None':'','rhvd':':1','rd':':2','bin':':3','ring':':4','cmc':':5'}
    df['Comment'] = df['Comment'].astype(str) + pattern_dict.get(pattern)
    
    print(df['Comment'].unique())
    sys.stdout.write("Continue?")
    choice = input().lower()
    if choice in yes:
        print("Comments are correct.")
    elif choice in no:
        sys.exit("Comments are incorrect. Exit!")
    else:
        sys.stdout.write("Please respond with 'yes' or 'no'")
        sys.exit(0)

    return df

def submit_jobs(x,df):

    replace = 'sed -i "s/duration/'+df.loc[x,'Runtime']+'/" '+jobfile
    subprocess.call([replace],shell=True)
    
    cat = 'cat '+jobfile
    subprocess.call([cat],shell=True)
    
    cmd = 'sbatch --job-name='+ df.loc[x,'Job_name'] + ' --comment='+df.loc[x,'Comment']+' --begin=now+'+df.loc[x,'Submit']+ ' --nodes='+df.loc[x,'Nodes'] +' '+jobfile
    print(cmd + " duration=" +df.loc[x,'Runtime'])
    subprocess.call([cmd],shell=True)
    #print(cmd)
    replace = 'sed -i "s/'+df.loc[x,'Runtime']+'/duration/" '+jobfile
    subprocess.call([replace],shell=True)
    cat = 'cat '+jobfile
    subprocess.call([cat],shell=True)

def main():
    
    ## Check if everything is in order
    yes = {'yes','y', 'ye', ''}
    no = {'no','n'}
    sys.stdout.write("Are the following things in place:\n1. Makefile\
            \t2. Git branch\n3. Topology and algo 4. slurmctld.log")
    choice = input().lower()
    if choice in yes:
        print("Next: Check SLURM status")
    elif choice in no:
        sys.exit("Exit!")
    else:
        sys.stdout.write("Please respond with 'yes' or 'no'")
        sys.exit(0)

    subprocess.call(['sinfo'],shell=True)
    subprocess.call(['squeue'],shell=True)
    subprocess.call(['scontrol ping'],shell=True)
    subprocess.call(['scontrol show frontend'],shell=True)
   
    sys.stdout.write("Continue?")
    choice = input().lower()
    if choice in yes:
        print("Next: Read logfiles")
    elif choice in no:
        sys.exit("Exit!")
    else:
        sys.stdout.write("Please respond with 'yes' or 'no'")
        sys.exit(0)

    df = pd.read_csv(logfile,sep=' ')
    df['Submit'] = df['Submit'] - df.loc[0,'Submit']
    df = add_pattern(df)
    df = scale(df)
    create_files()
    print("Submitting jobs")
    df.reset_index()['index'].apply(submit_jobs,args=(df.astype('str'),)) 
    #subprocess.call(['sinfo'],shell=True)
    #subprocess.call(['squeue'],shell=True)
    subprocess.call(['scontrol ping'],shell=True)
    subprocess.call(['scontrol show frontend'],shell=True)

if __name__ == '__main__':
    main()

