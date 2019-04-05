# Getting and cleaning data course assignment

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

The data for this assignment is collected from the accelerometers from the Samsung Galaxy S smartphone. The goal is to prepare tidy data that can be used for later analysis.

The repository contains 4 files:

  - Readme.md
  - tidy_data.txt
  - run_analysis.R
  - Codebook.md

# run_anlysis.R

The script is used to create the tidy data set. It runs with the following steps:

  - Get the data
  - Read the data
  - Merges the training and the test sets to create one data set.
  - Extracts only the measurements on the mean and standard deviation for each measurement.
  - Uses descriptive activity names to name the activities in the data set
  - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
