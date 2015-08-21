# What the Run Analysis Script Does
This is a guide explaining what the run_analysis.R script does. This document is broken into the following

	* Input Files
	* Processing Steps
	* Output File

	
The script was written for the Getting and Cleaning Data class offered by Coursera.

The goal is to prepare tidy data that can be used for later analysis.

## Input Files
	The following input files were provided in the assigment.  The comments associated with each of these files
	it taken directly from original README.txt and feature_infor.txt documents provided for the assignment.

	* 'README.txt'

	* 'features_info.txt': Shows information about the variables used on the feature vector.

	* 'features.txt': List of all features.

	* 'activity_labels.txt': Links the class labels with their activity name.

	* 'train/X_train.txt': Training set.

	* 'train/y_train.txt': Training labels.

	* 'test/X_test.txt': Test set.

	* 'test/y_test.txt': Test labels.

	* 'train/subject_train.txt' and 'test/subject_test': 
		Each row identifies the subject who performed the activity for each window sample. 
		Its range is from 1 to 30. 

	* 'train/Inertial Signals/*.*' and 'test/Inertial Signals/*.*': 
		These files contain additional information.
		These files were not included in the process of the script.	

## Processing Steps
	This sections provides an overview of the steps written in the code.
	
	Since I am new to R programming, it was not my goal to write "clever" code.  
	
	There is always more than one way to implement a process.  
	Some of my coding decisions were very basic and simple. 
	I know as time goes on and I gain more experience in R, then how I write code will also improve.
	
	The project provided the following five steps.
		Step 1.	Merge the training and the test sets to create one data set.
		Step 2.	Extract only the measurements on the mean and standard deviation for each measurement.
		Step 3.	Uses descriptive activity names to name the activities in the data set
		Step 4. Appropriately labels the data set with descriptive variable names. 
		Step 5. From the data set in step 4, create a second, independent tidy data set with the average 
				of each variable for each activity and each subject.

###	Step 1.	Merge the training and the test sets to create one data set.
		The values from the following files contained the different data captured in columns.
			subject_test			1 column data, 		2,947 rows
			X_test : features		561 columns data, 	2,947 rows
			y_test : activity		1 column data,		2,947 rows
			combined test 			563 columns, 		2,947 rows
			
			subject_train			1 column data, 		2,947 rows
			X_train : features		561 columns data, 	2,947 rows
			y_train : activity		1 column data, 		2,947 rows
			combined train			563 columns, 		2,947 rows

			The rows from both combinations were merged together.
				563 columns, 5,894 rows

###	Step 2.	Extract only the measurements on the mean and standard deviation for each measurement. 		
	A search was made for all columns with either mean or std in the name
		86 columns matched this criteria.
		The ID and Activity columns were also included
		
		The resulting data was
			88 columns, 5,894 rows

###	Step 3.	Uses descriptive activity names to name the activities in the data set
	The "activity_labels.txt" file provided contained the mappings of activity number to name.
	The activity column in the data set was updated to have the names instead of the numbers.

###	Step 4. Appropriately labels the data set with descriptive variable names. 
	
	I took a very simplistic approach to doing this.
	
	I ran several statements to 
		* replace dashes with periods
		* removed repeated words, like bodybody became body
		* put a period in between each part of the variable name to help with readability
		* the Code Book provides the details about each variable.
	

###	Step 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
	
	There were many ways to accomplish this.
	I took a very simplistic approach to doing this since my experience in R was limited 
	and there was a time frame for getting this done.

	The ID and Activity columns were merged into a single column : ID_Activity
	The two separate columns were dropped.
		89 columns, 5,894 rows

	The data was melted to generate 3 columns:
			ID_Activity, Variable, Value
				Variable contained the names of the columns
				
	The average was then calculated by the ID_Activity to Variable combination.

	To make the data more readable, the result was formatted back to the long format.
	This included separating the ID_Activity column back into 2 separate columns.


###	6.  The data was written to a file.
	A timestamp was appended to the name of the file to capture when it was generated.

## Output Files

	* README.md
		This is the file you are currently reading

	* CodeBook.md
		This contains the data dictionary of all the data in the output file.

	* run_analysis.R
		This is the script that was created to generate the tidy data.
	
	* mean_std_tidy_data_20150821_180530.txt
		The scripts creates a tiday data set.  
		The name of the file is appended with a date timestamp of when it was run.
		
### In order to review the tidy data, then run the following.
		
		fileUrl <- "https://s3.amazonaws.com/coursera-uploads/user-336e4c674785029e4191fdef/975115/asst-3/bc5be560485411e5b250c79c6630ec86.txt"
		download.file(fileUrl, destfile = "./mean_std_tidy_data_20150821_180530.txt", mode = "wb")

		tidy_data <-  read.table("./mean_std_tidy_data_20150821_180530.txt", header=T, fill=T) 
