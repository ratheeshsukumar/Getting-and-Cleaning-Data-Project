# Merges the training and the test sets to create one data set

datafiles <- file.path("D:/Educative/Coursera/3. Getting and Cleaning Data/Week3/Project" , "UCI HAR Dataset")
files<-list.files(datafiles, recursive=TRUE)
data_Activity_Test  <- read.table(file.path(datafiles, "test" , "Y_test.txt" ),header = FALSE)
data_Activity_Train <- read.table(file.path(datafiles, "train", "Y_train.txt"),header = FALSE
data_Subject_Train <- read.table(file.path(datafiles, "train", "subject_train.txt"),header = FALSE)
data_Subject_Test  <- read.table(file.path(datafiles, "test" , "subject_test.txt"),header = FALSE)
data_Features_Test  <- read.table(file.path(datafiles, "test" , "X_test.txt" ),header = FALSE)
data_Features_Train <- read.table(file.path(datafiles, "train", "X_train.txt"),header = FALSE)
Subject_All <- rbind(data_Subject_Train, data_Subject_Test)
Activity_All<- rbind(data_Activity_Train, data_Activity_Test)
Features_All<- rbind(data_Features_Train, data_Features_Test)
names(Subject_All)<-c("subject")
names(Activity_All)<- c("activity")
FeaturesNames <- read.table(file.path(datafiles, "features.txt"),head=FALSE)
names(Features_All)<- FeaturesNames$V2
Sub_Act_Data <- cbind(Subject_All, Activity_All)
Data <- cbind(Features_All, Sub_Act_Data)


# Extracts only the measurements on the mean and standard deviation for each measurement

subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)


# Uses descriptive activity names to name the activities in the data set

activity_Labels <- read.table(file.path(datafiles, "activity_labels.txt"),header = FALSE)
Data$activity<-factor(Data$activity)
Data$activity<- factor(Data$activity,labels=as.character(activity_Labels$V2))


# Appropriately labels the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# Creates a second,independent tidy data set and ouput it


if (!require("plyr")) {
  install.packages("plyr")
}
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


