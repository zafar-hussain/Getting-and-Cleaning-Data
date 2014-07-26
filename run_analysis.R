###load plyr package
library(plyr)

### Clear environment
rm(list=ls())


### read data files 
activity_lables = read.table("activity_labels.txt")
features = read.table("features.txt")
X_test = read.table("./test/X_test.txt")
y_test = read.table("./test/y_test.txt")
subject_test = read.table("./test/subject_test.txt")
X_train = read.table("./train/X_train.txt")
y_train = read.table("./train/y_train.txt")
subject_train = read.table("./train/subject_train.txt")


###conbind similar test and train data
X = rbind(X_test, X_train)
y = rbind(y_test, y_train)
subject = rbind(subject_test, subject_train)


### a get the activity lables vai a join between activity_id from y files
y = join(x = activity_lables, y = y)
data = X
colnames(data) = features$V2
data = cbind(subject, y, data )

### assign colnames 
colnames(data)[1:3] = c("subject", "activity_id","activity")


###prepare project data by extracting mean and Std solumns from the data
project_data = data[c(1,3, grep(("mean"), colnames(data)), grep(("std"), colnames(data)))]
project_data = arrange(project_data, subject, activity)

### write teh project data in to a csv file
write.csv(project_data,file="project_data.csv", row.names=FALSE)



###prepare averages from the source data usinf aggregate function

averages = aggregate(data[,c(-1, -3)], by=list(subject=data[,1], activity=data[,3]), FUN = mean)
averages = arrange(averages, subject, activity_id)

###write averages to averages.csv file
write.csv(averages,file="averages.csv", row.names=FALSE)