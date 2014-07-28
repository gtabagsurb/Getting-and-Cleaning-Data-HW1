library(data.table)
library(plyr)

tst=read.table("./UCI HAR Dataset/test/X_test.txt")
trn=read.table("./UCI HAR Dataset/train/X_train.txt")

#adding column names from features.txt
features<-read.table("./UCI HAR Dataset/features.txt")
colnames(tst)<-features[,2]
colnames(trn)<-features[,2]

#adding column with subject from subject_*.txt
tst_sbj = read.table("./UCI HAR Dataset/test/subject_test.txt")
tst$subject = tst_sbj[,1]
trn_sbj = read.table("./UCI HAR Dataset/train/subject_train.txt")
trn$subject = trn_sbj[,1]

#adding activities column from y_*.txt
tst_act = read.table("./UCI HAR Dataset/test/y_test.txt")
trn_act = read.table("./UCI HAR Dataset/train/y_train.txt")
activities=read.table("./UCI HAR Dataset/activity_labels.txt")
tst$activity = factor(tst_act$V1,levels = activities$V1,labels = activities$V2)
trn$activity = factor(trn_act$V1,levels = activities$V1,labels = activities$V2)

#union of 2 data frames
merged_data=rbind(tst, trn)

#extracting of measurements on the mean and standard deviation for each measurement
n=names(merged_data)
merged_data <- merged_data[,c(c("subject","activity"),n[grepl("-mean()",n) | grepl("-std()",n)])]

#output merged data set
write.table(merged_data, "merged_data.txt",row.names=FALSE)

#calculating average of each variable for each activity and each subject
tidy_data<-ddply(merged_data, c("subject","activity"), function(x) colMeans(x[c(colnames(merged_data)[3:81])]))

#output tidy data set
write.table(tidy_data, "tidy_data.txt",row.names=FALSE)