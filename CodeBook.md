---
title: "CodeBook"
author: "Nikolas Rohrmann"
date: "1/23/2021"
output: html_document
---
## Introduction

This is a brief description of the transformations and variables in 
run_analysis.R


```library(data.table)
library(pylr)
setwd("C://Users/x/Downloads/UCI HAR Dataset")


subjectTest <- read.table("/test/subject_test.txt")
xTest <- read.table("/test/X_test.txt")
yTest <- read.table("/test/y_test.txt")

subjectTrain <- read.table("/train/subject_train.txt")
xTrain <- read.table("/train/X_train.txt")
yTrain <- read.table("/train/y_train.txt")


xData <- rbind(xTest, xTrain)
yData <- rbind(yTest, yTrain)
subjectData <- rbind(subjectTest, subjectTrain)


features <- read.table("/Users/okc_rapid/Downloads/UCI HAR Dataset/features.txt")
mean.std <- xData[,grep("-(mean|std)\\(\\)", features[,2])]
names(mean.std) <- features[grep("-(mean|std)\\(\\)", features[,2]), 2]


yData <- gsub("1", "WALKING", yData[,1])
yData <- gsub("2", "WALKING_UPSTAIRS", yData[,1])
yData <- gsub("3", "WALKING_DOWNSTAIRS", yData[,1])
yData <- gsub("4", "SITTING", yData[,1])
yData <- gsub("5", "STANDING", yData[,1])
yData <- gsub("6", "LAYING", yData[,1])
names(yData) <- "Activity"


names(subjectData) <- "Subject"
singleData <- cbind(mean.std, yData, subjectData)


names(singleData) <- make.names(singleData)
names(singleData) <- gsub('GyroJerk',"AngularAcceleration",names(singleData))
names(singleData) <- gsub('Gyro',"AngularSpeed",names(singleData))
names(singleData) <- gsub('Mag',"Magnitude",names(singleData))
names(singleData) <- gsub('^f',"FrequencyDomain.",names(singleData))
names(singleData) <- gsub('\\.mean',".Mean",names(singleData))
names(singleData) <- gsub('^t',"TimeDomain.",names(singleData))
names(singleData) <- gsub('\\.std',".StandardDeviation",names(singleData))
names(singleData) <- gsub('Freq\\.',"Frequency.",names(singleData))
names(singleData) <- gsub('Freq$',"Frequency",names(singleData))
names(singleData) <- gsub('Acc',"Acceleration",names(singleData))


singleData2 <- aggregate(. ~Subject + Activity, singleData, mean)
singleData2 <- singleData2[order(singleData2$Subject,singleData2$Activity),]
write.table(singleData2, file = "tidydata.txt",row.name=FALSE)
```

## Working directory and packages (lines 13-15) 

Here I installed the data.table and the pylr package and set my working
directory.

## Reading in the data (lines 18-24)

In this part  of the script I read in the data, from the files
subject_test.txt, X_test.txt, y_test.txt and subject_train.txt, 
X_train.txt, y_train.txt, which I saved in the variables subjectTest,
xTest, yTest and subjectTrain, xTrain, yTrain, respectively.

## Binding parts of the data (lines 27-29)

Here I bond the corresponding dataframes together using rbind and saving
them into new variables called xData, yData and subjectData.

## Only including mean and standard deviation (lines 32-34)

First the features.txt file is read in and saved in the variable features.
Then xData is subsetted to only include the columns containing information about mean or standard deviation using grep(), which is saved in mean.std and finally the column names from the features file are also used for xData.

## Activity Names (lines 37-43)

Here the numbers in yData are replaced by the corresponding activity names from activity_labels.txt using gsub(). Lastly the lone column of yData is names Activity.

## Single Dataset (lines 46-47)

After giving the lone column of subjectData the name Subject. Then the
three dataframes mean.std, yData and subjectData are merged using cbind() and save in a new variable called singleData.

## Appropiate column names (lines 50-60)

Using the features_info.txt file the various parts of the column names are replaced by more descriptive names. 

## Second dataframe (lines 63-65)

With the aggregate function from the pylr package a second data frame
with the means from the variables by Activity and Subject is created and attributed to the variable singleData2, which is then ordered by Activity and Subject. Finally the tidydata.txt file is created.





