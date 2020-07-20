library(dplyr)

#read test data
subject_test <- read.table('./test/subject_test.txt')
x_test <- read.table('./test/X_test.txt')
y_test <- read.table('./test/y_test.txt')

#read train data
subject_train <- read.table('./train/subject_train.txt')
x_train <- read.table('./train/X_train.txt')
y_train <- read.table('./train/y_train.txt')

#read data description and activity labels
features <- read.table('./features.txt')
activity_labels <- read.table('./activity_labels.txt')

#1 Merges the training and the test sets to create one data set.
X <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
features_labels <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
x<-x[,features_labels[,1]]


#3 Uses descriptive activity names to name the activities in the data set
colnames(y) <- 'activityid'
colnames(activity_labels) <- c('activityid','activity') 
y$activity <- factor(y$activityid, labels = as.character(activity_labels[,2]))
activity <- y[,2]

#4 Appropriately labels the data set with descriptive variable names.
colnames(x) <- features_labels[,2]

#5 creates a second, independent tidy data set with the average of each variable for each activity and each subject
colnames(subject) <- "subject"
tidy_data <- cbind(subject,activity,x)
total <- tidy_data %>% group_by(activity, subject) %>% summarise_each(list(mean=mean))
write.table(total, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

