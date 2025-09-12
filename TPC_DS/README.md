# TPC-DS Benchmark Setting Script (for MySQL)

- This is TPC-DS benchmark setting script.
- Before running this script, You must download TPCDS-Tools from [TPC Website.](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp) (Registeration Required.)

## How to setting up?
### Step 1. Download TPC-DS Tools (archive file) from [this page](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp), and unzip it. (Registeration Required.)

### Step 2. Move "DSGen-software-code-4.0.0/tools" directory, and run the "make" command, and Generate the files for the population.
- Makefile is already written.
- This step requires gcc-9 compiler. (Compilation errors can occur in versions higher than gcc-9)
```
make
```
```
./dsdgen <SF>
```
- It can consumes a lot of time by case.
- The -s option means the scale factor(SF).
- You can find defined value in TPC-DS Documentation, and minimum value is "1". (It represents 1GB)
- TPC-DS Documentation is in "DSGen-software-code-4.0.0/tools". (How to Guide DS-V2.0.0.docx)

### Step 3. Clone this repository, and move all file to TPC-DS DSGen-software-code-4.0.0/tools Directory. 
```
git clone https://github.com/wjdqh6544/MySQL_TPC_Benchmark.git
```
- After finish to clone, You must check the directory name. Here we use files stored in the TPC_DS directory.
- CAUTION! Change directory to "TPC_DS", and move all file in that directory.

※ This step requires git package. (You can install using "apt install git")

### Step 4. Pre-processing for created data
```
sudo sh ./preprocess_data.sh
```
- It remove NULL. (|| -> |0|, Null Date -> 1111-11-11)
- It can consumes a lot of time by case.

### Step 5. Execute "import_TPC_DS_to_MySQL.sh" file with DB root user.
```
sudo sh ./import_TPC_DS_to_MySQL.sh root
```
- This shell script creates a database, and puts the data(*.dat) to that DB automatically.
- It consumes a lot of time by case. You can check running Query using this command in <b>DB</b>.
- If an error occurs, try running this script again.
```
show processlist;
``` 
- If cannot execute this file, try to run this command
```
chmod +x import_TPC_DS_to_MySQL.sh
```

### Step 6. When the execution is finished, The DB configuration is finished.
- If an error occurs, try "Step 5" again.
- From now on, You can configure benchmarking as needed.
- Also you can run my simple benchmark with below command.
```
./execute_benchmark.sh <The number of Iterations>
```
- It measures the running time, and the query is in "queries" directory. (It based on TPC-DS Tools)
- The result is saved to file. (It is in "result" directory / filename is *.out)
- I think you should change the root user password in MySQL to your environment. (at head of shell script.)
- If cannot execute this file, try to run this command
```
chmod +x import_TPC_DS_to_MySQL.sh
```

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
- Ubuntu 20.04.6 (Linux 5.15.0-139)
- Mysql 8.0.42
- TPC-DS Tools v4.0.0
- GCC Compiler v9.4.0
