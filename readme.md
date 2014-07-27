#Getting & Cleaning Data Course Project
##Brief description.


### 30 subjects were provided with Samsung Galaxy S smartphones and their Gyro and acceleration sensors were recorded over a period of time, while performing various activities.

###the requirement for the project are:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###below are the details, with the code used to process the data.

###only "plyr" package was used to arrange and join the data

    library(plyr)

### First the environment was cleared
    
    rm(list=ls())


###Data files were read into datasets

    activity_lables = read.table("activity_labels.txt") 
    features = read.table("features.txt")
    X_test = read.table("./test/X_test.txt")
    y_test = read.table("./test/y_test.txt")
    subject_test = read.table("./test/subject_test.txt")
    X_train = read.table("./train/X_train.txt")
    y_train = read.table("./train/y_train.txt")
    subject_train = read.table("./train/subject_train.txt")


###As the data was provided in 2 separate categories, they were combined
    X = rbind(X_test, X_train)
    y = rbind(y_test, y_train)
    subject = rbind(subject_test, subject_train)


### To get the activity labels, a join between activity_id from y files was used
    y = join(x = activity_lables, y = y)
    data = X
    colnames(data) = features$V2
    data = cbind(subject, y, data )

### Proper column names were assigned 
    colnames(data)[1:3] = c("subject", "activity_id","activity")


###The mean and Standard deviation columns were extracted
    project_data = data[c(1,3, grep(("mean"), colnames(data)), grep(("std"), colnames(data)))]
    project_data = arrange(project_data, subject, activity)

###Finally Project data in to a TXT file. 
write.table(project_data,file="project_data.txt", row.names=FALSE)



###A separate Tidy data was prepared from the source data using "aggregate" function

    averages = aggregate(data[,c(-1, -3)], by=list(subject=data[,1], activity=data[,3]), FUN = mean)
    averages = arrange(averages, subject, activity_id)

###The averages were written to a TXT file
    write.table(averages,file="averages.txt", row.names=FALSE)
