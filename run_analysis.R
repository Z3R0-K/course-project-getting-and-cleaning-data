library(data.table)
library(pylr)
setwd("C://Users/x/Downloads/UCI HAR Dataset")
## Here the data.table and plyr package are installed, which
## are necessary to process the data

subjectTest <- read.table("/test/subject_test.txt")
xTest <- read.table("/test/X_test.txt")
yTest <- read.table("/test/y_test.txt")

subjectTrain <- read.table("/train/subject_train.txt")
xTrain <- read.table("/train/X_train.txt")
yTrain <- read.table("/train/y_train.txt")

## Here the train and test are read from the earlier downloaded
## zip-container.

xData <- rbind(xTest, xTrain)
yData <- rbind(yTest, yTrain)
subjectData <- rbind(subjectTest, subjectTrain)

## The equivalent datasets are bond together here using rbind. 
## They will all be merged to one dataset later, in order to process
## the smaller sets easier.

features <- read.table("/Users/okc_rapid/Downloads/UCI HAR Dataset/features.txt")
mean.std <- xData[,grep("-(mean|std)\\(\\)", features[,2])]
names(mean.std) <- features[grep("-(mean|std)\\(\\)", features[,2]), 2]

## The expression in line 26 downloads the information about the various
## columns in the dataset. In line 27 the xData is subset
## to only contain information about mean and standard deviation.

yData <- gsub("1", "WALKING", yData[,1])
yData <- gsub("2", "WALKING_UPSTAIRS", yData[,1])
yData <- gsub("3", "WALKING_DOWNSTAIRS", yData[,1])
yData <- gsub("4", "SITTING", yData[,1])
yData <- gsub("5", "STANDING", yData[,1])
yData <- gsub("6", "LAYING", yData[,1])
names(yData) <- "Activity"

## Here the numbers 1 through 6 are replaced by the corresponding
## activity name using gsub.

names(subjectData) <- "Subject"
singleData <- cbind(mean.std, yData, subjectData)

## Here the subjectData receives a column-name and
## the remaining three data frames are merged
## using cbind.

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

## Here the abbreviation used are replaced by more appropiated names
## using the information from the features-info text file.

singleData2 <- aggregate(. ~Subject + Activity, singleData, mean)
singleData2 <- singleData2[order(singleData2$Subject,singleData2$Activity),]
write.table(singleData2, file = "tidydata.txt",row.name=FALSE)

## With the help of the aggregate function from the pylr package
## the new dataset is generated. In line 67 it is ordered according
## to Subject and Activity. In line 68 the file tidydata.txt is 
## written containing the second dataset.



