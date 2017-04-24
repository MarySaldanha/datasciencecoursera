#This package gives an average for the mean() and std() variables

#load packages needed for script
library(dplyr)
library(reshape2)

run_analysis <- function(){ 

	# intialize the dataframes 
	df_finalobs = data.frame()
	df_label    = data.frame()
	df_subject  = data.frame()

	# get the id and observation variable names
	filename <- c("./GettingCleaningData/features.txt")
	df_var_names <- read.table( filename ,sep = " ", header=FALSE , colClasses=c("numeric","character"))
	names(df_var_names) <- c("id","name") 


	# get the id and activity names or labels  
	filename <- c("./GettingCleaningData/activity_labels.txt")
	df_activity_names <- read.table( filename ,sep = " ", header=FALSE , colClasses=c("numeric","character"))
	names(df_activity_names) <- c("activity_lbl_id","activity_lbl_name") 


	# Code below : Merge training and test data sets 
	path <- c("./GettingCleaningData/test/", "./GettingCleaningData/train/"  )
	
	#Look for X-train, X-test data files and merge 
	for ( dir_indx in 1:length(path)) 
	{ 
		filenames <- dir( path[dir_indx], pattern ="^[X][_a-zA-Z]+.txt")
		for ( file_indx in 1:length(filenames)) 
		{ 
			#df <- read.table( paste( path[dir_indx] , filenames[file_indx], sep = "") ,header=FALSE,sep=" ",colClasses=c(rep("numeric",128)))
			df <- read.fwf( paste( path[dir_indx] , filenames[file_indx], sep = "") ,widths = c(rep(16,561)), header=FALSE)
			df_finalobs <- rbind(df_finalobs, df )
		}
      }
	#assign names
	names(df_finalobs) <- c(df_var_names$name)
	
	#filter columns only for mean() and std()
	df_obs <- df_finalobs [ , grepl( "mean\\(\\)|std\\(\\)", names(df_finalobs)) ] 
	

	#read files for the activity_ids for the observations 
	for ( dir_indx in 1:length(path)) 
	{ 
		filenames <- dir( path[dir_indx], pattern ="^[y][_a-zA-Z]+.txt")
		for ( file_indx in 1:length(filenames)) 
		{ 
			df <- read.table( paste( path[dir_indx] , filenames[file_indx], sep = "") ,sep = "", header=FALSE , colClasses=c("numeric") , col.names = c("activity_lbl_id"))
			df_label <- rbind(df_label, df) 
		}
      }
	#merge the dataframes to replace activity_id with activity_names and assigned to new vector 
	df_actvty_obs <- merge ( df_label, df_activity_names, by.x = "activity_lbl_id", by.y = "activity_lbl_id" )
	df_actvty <- df_actvty_obs$activity_lbl_name
	names(df_actvty) <- c("activity_lbl_name")

 
	#loop thru to read the subject_ids for each observation 
	for ( dir_indx in 1:length(path)) 
	{ 
		filenames <- dir( path[dir_indx], pattern ="^subject[_a-zA-Z]+.txt")
		for ( file_indx in 1:length(filenames)) 
		{ 
			df <- read.table( paste( path[dir_indx] , filenames[file_indx], sep = "") ,sep = "", header=FALSE , colClasses=c("numeric") , col.names = c("subject_id"))
			df_subject <- rbind(df_subject, df) 
		}
      }

	#column bind the observations , subject_ids and activity_names 
	df_obs_1 <- cbind( df_obs, df_actvty , df_subject) 

	# assign columns names
	names(df_obs_1) <- c(names(df_obs), "activity_lbl_name", "subject_id")

	# find average b activity_name and subject_id 
	reslt_1 <- melt( df_obs_1, id = c("activity_lbl_name","subject_id") )
	reslt <- dcast( reslt_1, activity_lbl_name + subject_id ~ variable, mean) 
	
	#return the result
	reslt 
		
}