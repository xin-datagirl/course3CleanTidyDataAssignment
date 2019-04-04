# file: run_analysis.R
# The purpose of this script is to use the data collect from
# the Samsung Galaxy S smartphone, work with the data and 
# get a clean and tidy data set. The output data will be written 
# into the file of tidy_data.txt

# Install and load packages
library(dplyr)

########## Get the data
sourceDataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
sourceDataFileName <- "UCI_HAR_Dataset.zip"
sourceDataPath <- "UCI HAR Dataset"

if(!file.exists(sourceDataFileName)) {
  download.file(sourceDataURL,sourceDataFileName,mode="wb")
}

if(!file.exists(sourceDataPath)) {
  unzip(sourceDataFileName)
}

########## Read the data
# read training data
trainingSubjects <- read.table(file.path(sourceDataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(sourceDataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(sourceDataPath, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(sourceDataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(sourceDataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(sourceDataPath, "test", "y_test.txt"))

# read features
features <- read.table(file.path(sourceDataPath, "features.txt"), as.is = TRUE)

# read activities
activities <- read.table(file.path(sourceDataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

########## Merges the training and the test sets to create one data set.
mergedActivity<-rbind(
  cbind(trainingSubjects,trainingValues,trainingActivity),
  cbind(testSubjects,testValues,testActivity)
)

rm(trainingSubjects, trainingValues, trainingActivity, 
   testSubjects, testValues, testActivity)

colnames(mergedActivity)<-c("subject",features[,2],"activity")

########## Extracts only the measurements on the mean and standard deviation for each measurement.
columnsKeep <- grepl("subject|activity|mean|std",colnames(mergedActivity))

mergedActivity <- mergedActivity[,columnsKeep]

########## Uses descriptive activity names to name the activities in the data set
mergedActivity$activity <- factor(mergedActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

# Appropriately labels the data set with descriptive variable names.
mergedActivityCols <- colnames(mergedActivity)

########## remove special characters
mergedActivityCols <- gsub("[\\(\\)-]","",mergedActivityCols)

mergedActivityCols <- gsub("^f", "frequencyDomain", mergedActivityCols)
mergedActivityCols <- gsub("^t", "timeDomain", mergedActivityCols)
mergedActivityCols <- gsub("Acc", "Accelerometer", mergedActivityCols)
mergedActivityCols <- gsub("Gyro", "Gyroscope", mergedActivityCols)
mergedActivityCols <- gsub("Mag", "Magnitude", mergedActivityCols)
mergedActivityCols <- gsub("Freq", "Frequency", mergedActivityCols)
mergedActivityCols <- gsub("mean", "Mean", mergedActivityCols)
mergedActivityCols <- gsub("std", "StandardDeviation", mergedActivityCols)
mergedActivityCols <- gsub("BodyBody", "Body", mergedActivityCols)

colnames(mergedActivity)<-mergedActivityCols

########## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

mergedActivityMeans <- mergedActivity %>%
  group_by(subject,activity) %>%
  summarise_each(list(mean))

write.table(mergedActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)