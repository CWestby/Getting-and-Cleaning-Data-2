library(dplyr)
library(tidyr)
library(reshape2)

file <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "rundata.zip")
unzip("rundata.zip")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("Activity", "Activity Label")
features <- read.table("UCI HAR Dataset/features.txt")

test_data_x <- read.table("UCI HAR Dataset/test/X_test.txt")
names(test_data_x) <- features[, 2]
test_data_y <- read.table("UCI HAR Dataset/test/y_test.txt")
names(test_data_y) <- "Activity"
subject_test<- read.table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "Subject"
test_complete <- bind_cols(subject_test, test_data_y, test_data_x)

train_data_x <- read.table("UCI HAR Dataset/train/X_train.txt")
names(train_data_x) <- features[, 2]
train_data_y <- read.table("UCI HAR Dataset/train/y_train.txt")
names(train_data_y) <- "Activity"
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "Subject"
train_complete <- bind_cols(subject_train, train_data_y, train_data_x)

complete_data <- tbl_df(bind_rows(test_complete, train_complete))
complete_data$Activity <- activity_labels[complete_data$Activity, "Activity Label"]

mean_std_data <- select(complete_data, Subject, Activity, contains("mean"), contains("std"))
View(mean_std_data)

melted_data <- melt(mean_std_data, id = c("Subject", "Activity"))
averages <- dcast(melted_data, Subject + Activity ~ variable, mean)
View(averages)
         
              
