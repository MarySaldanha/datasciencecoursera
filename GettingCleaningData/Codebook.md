# GettingCleaningData
This is the Getting Cleaning Data assignment

Input Data : 
Data files as mentioned in assignment. The training and test data sets are used. 

Script to Run : run_analysis.R 

How to run the script :
1. Download and extract the data files and script
2. Set the working directory so that the data files and scripts are in same location. Without this, the data files will not be read correctly. 
3. Invoke the script and assign the output to a variable. 
4. Use the latest version of R (version used is 3.3.2)

Transformations done :
1.Converted ids to Names if cross reference was available eg. activity_id is replaced with activity_names

Ouput / Summary  : 
1. Only observations which had mean or standard deviation for each of the dimensions/overall have been selected 
2. The output is average for each observation by the subject_id and activity_name.



