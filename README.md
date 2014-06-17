# Coursera Getting and cleaning Data Project

## Rudy Pastel


This is a description of the cleaning process of a data set as required by the
june 2014 session of the Coursera class "Getting and cleaning data".
The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The cleaning script is run_analysis.R and assumes the unzipped downloaded files are in the same directory. The resulting tidy data set tidydataset.csv is described in Codebook.md .



### 1. Merge the training and the test sets to create one data set.
The data is originally split into a train split and a test split, themselves being chopped into  a subject part, an activity part a.k.a. y and a feature part a.k.a. X. We want to combine all these pieces it into one data.frame .

The splits are first combined into a training set and a test set using an an hoc function and then simply bound  by rows, taking advantage of their identical list of variables. 

Variables are named "activity" and "subject" plus based on "UCI HAR Dataset/features.txt". Though this later part does not respect R naming convention, they were kept because of their scientific meaning. This does not hinder later processes facilitates using the original code book for later purposes. 

The key steps are
- Build a function that loads the subject, measurements and activity datasets into R for the  named splits ("train" or "test") and name the variables.
- Combine  the loaded training split and the test split into the  data frame accelerometry.


### 2. Extract only the measurements on the mean and standard deviation for each measurement.
The variable of interest are  "subject","activity" and those referring to a standard deviation ("std") or a mean ("mean" or "Mean"). They are selected based on their names via a regular expression.

### 3. Use descriptive activity names to name the activities in the data set
The "activity" variable class is set from integer to factor and and levels are renamed in an human friendly way based on  "UCI HAR Dataset/activity_labels.txt"

### 4. Appropriately label the data set with descriptive variable names. 
Variables are named "activity" and "subject" plus based on "UCI HAR Dataset/features.txt". Though this later part does not respect R naming convention, they were kept because of their scientific meaning. This does not hinder later processes facilitates using the original code book for later purposes.

Naming was actually done in point one.
### 5. Create a independent tidy data set with the average of each variable for each activity and each subject.
The tidy data set average.measurements lists average values identified by the averaged measurement, the activity done at measurement time and the subject performing the activity. The tidy data set therefore has four variables "measurement", "activity", "subject" and "average". 

It is built as follows:
- Average.measurements is created empty with only names and types.
- The data frame accelerometry is split in pieces for which "activity" and "subject" are constant.
- For each piece the measurement are averaged and then appended to average.measurements row by row to respect the target format.
- Row names are removed and i.e. set to 1,2,3,...
- The resulting tidy data frame is written to the disk in csv format


