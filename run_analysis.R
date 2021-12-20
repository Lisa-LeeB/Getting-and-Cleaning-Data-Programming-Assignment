# import datasets 

train_x <- read.table("UCI HAR Dataset//train/X_train.txt", comment.char="")
train_sub <- read.table("UCI HAR Dataset//train/subject_train.txt", col.names=c("subject"))
train_y <- read.table("UCI HAR Dataset/train//y_train.txt", col.names=c("activity"))
train_data <- cbind(train_x, train_sub, train_y)

test_x <- read.table("UCI HAR Dataset//test/X_test.txt",comment.char = "")
test_sub <- read.table("UCI HAR Dataset//test/subject_test.txt", col.names = c("subject"))
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activity"))
test_data <- cbind(test_x,test_y,test_sub)

data <- rbind(train_data,test_data) 

# assign column names

feature <- read.table("UCI HAR Dataset//features.txt", colClasses = "character")
feature2 <- tolower(feature$V2)
feature_complete <- c(feature2,"subject","activity")
names(data) <- feature_complete

# select only columns with mean or standard deviation

ms <- grep("mean|std|activity|subject",names(data))
rm <- grep("meanfreq|angle",names(data))
joint <- c(ms,rm)
joint1 <- joint[!(duplicated(joint)|duplicated(joint, fromLast=TRUE))]
data1 <- data[,jonit1]

# Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)[1] <- "activity"
data2 <- merge.data.frame(data1,activity_labels,by = "activity")
data2 <- data2[-1]
colnames(data2)[68] <- "activity"

# Add descriptive variable names

names(data2) <- gsub("^t","time",names(data2))
names(data2) <- gsub("acc","accelerometer",names(data2))
names(data2) <- gsub("gyro","gyroscope",names(data2))
names(data2) <- gsub("mag","Magnitude",names(data2))
names(data2) <- gsub("^f","frequency domain",names(data2))
names(data2) <- gsub("bodybody","body",names(data2))
names(data2) <- gsub("std","standard deviation",names(data2))

# Create new dataset with average of subject and activity
DSaverage<-aggregate(. ~subject + activity, data2, mean)
write.table(DSaverage, file = "tidydata.txt",row.name=FALSE)
