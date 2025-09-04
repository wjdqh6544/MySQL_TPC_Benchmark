# TPC-H Benchmark Setting Script (for MySQL)

- This is TPC-H benchmark setting script.
- Before running this script, You must download TPCH-Tools from [TPC Website.](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp) (Registeration Required.)

## How to setting up?
### Step 1. Download TPC-H Tools (archive file) from [this page](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp), and unzip it. (Registeration Required.)

### Step 2. Move "dbgen" directory, and Make a copy of the dummy makefile in uncompressed directory.
```
cp makefile.suite makefile
```

### Step 3. Open makefile with Editor, Find the values of CC, DATABASE, MACHINE, and WORKLOAD, and change them as follows:
```
################
## CHANGE NAME OF ANSI COMPILER HERE
################
CC      = gcc
# Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
#                                  SQLSERVER, SYBASE, ORACLE, VECTORWISE
# Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS, 
#                                  SGI, SUN, U2200, VMS, LINUX, WIN32 
# Current values for WORKLOAD are:  TPCH
DATABASE= ORACLE
MACHINE = LINUX
WORKLOAD = TPCH
```
※ This step requires gcc compiler. (You can install using "apt install gcc")

### Step 4. run the "make" command, and Generate the files for the population.
```
make
```
```
./dbgen -s <SF>
```
- It consumes a lot of time by case.
- The -s option means the scale factor(SF).
- You can find defined value in TPC-H Documentation, and minimum value is "1". (It represents 1GB)
- TPC-H Documentation is in TPC-H-Tools directory.

### Step 5. Clone this repository, and move all file to TPC-H Tools/dbgen Directory. 
```
git clone https://github.com/wjdqh6544/MySQL_TPC_Benchmark.git
```
- After finish to clone, You must check the directory name. Here we use files stored in the TPCH directory.
- CAUTION! Change directory to "TPCH", and move all file in that directory.

※ This step requires git package. (You can install using "apt install git")

### Step 6. Execute "import_TPC_H_to_MySQL.sh" file with DB root user.
```
sudo sh ./import_TPC_H_to_MySQL.sh root
```
- This shell script creates a database, and puts the data(*.tbl) to that DB automatically.
- It consumes a lot of time by case. You can check running Query using this command in <b>DB</b>.
- If an error occurs, Delete the tpch database and try again.
```
show processlist;
``` 
- If cannot execute this file, try to run this command
```
chmod +x import_TPC_H_to_MySQL.sh
```

### Step 7. When the execution is finished, The DB configuration is finished.
- If an error occurs, Delete the tpch database and try "Step 6" again.
- From now on, You can configure benchmarking as needed.
- Also you can run my simple benchmark with below command.
```
sh execute_benchmark.sh
```
- It measures the running time, and the query is in "queries" directory. (It based on TPC-H Tools)
- The result is saved to file. (It is in "result" directory / filename is *.result)

## Troubleshooting
```
ERROR 2068 (HY000): LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.
```
- Check the value of "local_infile" using this command in MySQL:
```
SHOW VARIABLES LIKE 'local_inflie';
```
- If the value is "False", Enable this option using this command:
```
SET GLOBAL local_infile = 1;
```
- If you still get an error, Add the following option in "/etc/mysql/conf.d/mysql.cnf", and restart MySQL server.
```
[client]
loose-local-infile=1
```

## Test Environment
- Ubuntu 25.04 (Linux 6.14.0-29)
- Mysql 8.4.6
- TPC-H Tools v3.0.1
