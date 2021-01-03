library(dplyr)
filename <- "CourseraFinalassingment.zip"

# Checking if download file already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)#we will not use method = curl when working in windows
}  

# Checking if the given folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#Assigning the names to all the data frames

features <- read.table("UCI HAR Dataset/features.txt",col.names = c("number","functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("S.no","activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt",col.names = "S.no")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt",col.names = "S.no")

#merging the data 

X <- rbind(X_train,X_test)  
Y <- rbind(Y_train,Y_test)
subject <- rbind(subject_train,subject_test)
merged_data <- cbind(X,Y,subject)

#Extracting measurement on the mean and standard deviation of each measurement

data <- merged_data %>% select(subject,S.no,contains("mean"),contains("std"))

#using descriptive activity names to name the activities of the data set

data$S.no <- activity[data$S.no,2]

#labeling the data set with a variable name

names(data)[2] <- "Activity"
names(data) <- gsub("Acc","Acclerometer",names(data))
names(data) <- gsub("Gyro","Gyroscope",names(data))
names(data) <- gsub("Mag","Magnitude",names(data))
names(data) <- gsub("^f","frequency",names(data))

#obtaining final data which we obtain from extracting merged_data

finaldata <- data %>%
  group_by(subject,Activity)%>%
  summarise_all(funs(mean))
write.table(finaldata,"finaldata.txt",row.names = FALSE)

