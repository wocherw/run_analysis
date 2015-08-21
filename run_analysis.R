## --------------------------------------------------------------------------------------------------------------
## 1.	Merges the training and the test sets to create one data set.
## --------------------------------------------------------------------------------------------------------------
  
	## set directory
	setwd("D:/Coursera/03 Getting And Cleaning Data/Project/UCI HAR Dataset")

	##library(reshape2)
	##library(dplyr)
	
	## get features file with the column headings
	features <- read.table("features.txt", header=F, fill=T) 
	col_feature <- tolower(unname(unlist(features[[2]])))
	col_feature <- gsub("\\(","", col_feature)
	col_feature <- gsub("\\)","", col_feature)
	col_feature <- gsub("\\,","", col_feature)
	col_feature <- c("id","activity", col_feature)
	 
	rm(features)
	
	## get test base files
	test_data <- read.table("./test/subject_test.txt", header=F,fill=T)
	X_test <- read.table("./test/X_test.txt", header=F,fill=T)
	y_test_activity <- read.table("./test/y_test.txt", header=F,fill=T)

	test_data <- cbind(test_data, y_test_activity)
	test_data <- cbind(test_data, X_test)
	rm(y_test_activity)
	rm(X_test)

	## get train base files
	train_data <- read.table("./train/subject_train.txt", header=F,fill=T)
	X_train <- read.table("./train/X_train.txt", header=F,fill=T)
	y_train_activity <- read.table("./train/y_train.txt", header=F,fill=T)

	train_data <- cbind(train_data, y_train_activity)
	train_data <- cbind(train_data, X_train)
	rm(y_train_activity)
	rm(X_train)

	## combine the data
	all_data <- rbind(test_data, train_data)
	rm(test_data)
	rm(train_data)

	## assign column names
	names(all_data) <- col_feature

## --------------------------------------------------------------------------------------------------------------
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## --------------------------------------------------------------------------------------------------------------
	## get the names of the columns with mean or std in it
	col_mean_std <- col_feature[grep("mean|std",col_feature)]
	col_mean_std <- c("id","activity", col_mean_std)

	mean_std_data <- all_data[,c(col_mean_std)]
	rm(all_data)

## --------------------------------------------------------------------------------------------------------------
## 3. Uses descriptive activity names to name the activities in the data set
## --------------------------------------------------------------------------------------------------------------
	mean_std_data$activity = 
		ifelse(mean_std_data$activity == 1, "Walking"
			   , ifelse(mean_std_data$activity == 2, "Walking Upstairs"
					, ifelse(mean_std_data$activity == 3, "Walking Downstairs"
						 , ifelse(mean_std_data$activity == 4, "Sitting"
							, ifelse(mean_std_data$activity == 5, "Standing", "Laying")
						 )
					)
			   )
		  )
  
## --------------------------------------------------------------------------------------------------------------
## 4. Appropriately labels the data set with descriptive variable names. 
## --------------------------------------------------------------------------------------------------------------
	col_final <- gsub("\\-","\\.", col_mean_std)
	col_final <- gsub("bodybody","body", col_final)
	col_final <- gsub("std","standard.deviation", col_final)
	col_final <- gsub("body",".body", col_final)
	col_final <- gsub("acc",".acceleration", col_final)
	col_final <- gsub("jerk",".jerk", col_final)
	col_final <- gsub("gyro",".gyro", col_final)
	col_final <- gsub("mag",".mag", col_final)
	col_final <- gsub("freq",".freq", col_final)
	col_final <- gsub("gravity",".gravity", col_final)
	col_final <- gsub("mean",".mean", col_final)
	col_final <- gsub("anglet","angle.t", col_final)
	col_final <- gsub("angley","angle.y", col_final)
	col_final <- gsub("anglex","angle.x", col_final)
	col_final <- gsub("anglez","angle.z", col_final)
	col_final <- gsub("\\.\\.","\\.", col_final)

	names(mean_std_data) <- col_final
  
## --------------------------------------------------------------------------------------------------------------
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
## --------------------------------------------------------------------------------------------------------------
	mean_std_data$id_activity = paste(mean_std_data$id, mean_std_data$activity, sep=":")
	mean_std_data <- subset(mean_std_data, select = -c(id, activity))

	mean_std_melt <- melt(mean_std_data, id=c("id_activity"), na.rm=TRUE)
	rm(mean_std_data)

	mean_std_group_summary <- dcast(mean_std_melt, id_activity~variable, mean)
	rm(mean_std_melt)

	mean_std_done <- mean_std_group_summary %>% separate(id_activity, c("id","activity"), sep=":")
	rm(mean_std_group_summary)

	mean_std_done$id <- as.numeric(mean_std_done$id)
	mean_std_done <- mean_std_done[with(mean_std_done, order(id, activity)),]
  
## --------------------------------------------------------------------------------------------------------------
## 6. write the results to a file
## --------------------------------------------------------------------------------------------------------------
	library(lubridate)

	tidy_file <- paste("mean_std_tidy_data ",ymd_hms(now()) ,".txt", sep="")
	tidy_file <- gsub("\\:","", tidy_file)
	tidy_file <- gsub("\\-","", tidy_file)
	tidy_file <- gsub(" ","_", tidy_file)
	write.table(mean_std_done, file=tidy_file, row.name=FALSE, col.name=TRUE)

	tidy_input <- read.table(tidy_file, header=T, fill=T) 

	## remove objects
	rm(col_feature)
	rm(col_final)
	rm(col_mean_std)
	rm(mean_std_done)
	rm(tidy_file)
	