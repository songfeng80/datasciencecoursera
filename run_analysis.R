
###############Data Cleaning Peer Assessment#####################
###############it contains 7 steps to clean and generate the tidy data#####################


######step 1: download and unzip files#########

download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
"D:\\DS\\data_cleaning\\getdata_projectfiles_UCI.zip")

unzip("D:\\DS\\data_cleaning\\getdata_projectfiles_UCI.zip", exdir="D:\\DS\\data_cleaning")


######step 2: read X_test,X_train.y_test,y_train,Subject_test,Subject_train,features and activity_lables text files into dataframes#########

X_test<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\test\\X_test.txt")
subject_test<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\test\\subject_test.txt")
Y_test<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\test\\Y_test.txt")
X_train<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\train\\X_train.txt")
subject_train<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\train\\subject_train.txt")
Y_train<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\train\\Y_train.txt")


######step 3: combine y_test and subject_test, and also combine y_train and subject_train by coloumn into dataframes####### 
###########and then concatenate the test and train data together####################

dataytest<-(cbind(Y_test,subject_test))
names(dataytest)<-c("Activity","Subject")
dataytrain<-(cbind(Y_train,subject_train))
names(dataytrain)<-c("Activity","Subject")

datayall<-rbind(dataytest,dataytrain)
dim(datayall)


######step 4: concatenate X_train and X_test data############

dataxall<-rbind(X_test,X_train)
dim(dataxall)


######step 5: read-in the features.txt, and then subset to those feature names with "mean()" and "std()"########
##########subset the combined X test and train data from step 4 to those subsetted features############

features<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\features.txt")

index<-sort(c(grep("mean()", features[,2],fixed=T),grep("std()", features[,2], fixed=T)))

dataxall_sub<-dataxall[,index]

names(dataxall_sub)<-features[index,2]


######step 6: Combine the X and Y data together and then calculate ##########################
#########the mean of each of the 66 columns for each of the 180 combinations of activity and subject######

data_all<-cbind(dataxall_sub, datayall)

act_sub_mean<-aggregate(data_all[,c(1:66)], by=list(data_all$Activity,data_all$Subject), FUN=mean)
colnames(act_sub_mean)[c(1,2)]=c("Activity","Subject")


######step 7: read-in the activity labels from activity_lables.txt and then merge to the data from step 6,######
######and then replace the activity with activity labels#############
######sorr the data based on activity and subject #######################

activity_labels<-read.table("D:\\DS\\data_cleaning\\UCI HAR Dataset\\activity_labels.txt")
names(activity_labels)<-c("Activity","Activity_Label")

data_out<-merge(act_sub_mean,activity_labels, by="Activity")

data_out<-data_out[order(data_out[,1],data_out[,2]), ]

data_out<-data_out[,c(69,2:68)]


######step 8: output the generated tidy data into a txt file###############

write.table(data_out, "D:\\DS\\data_cleaning\\data_cleaned.txt", sep="\t",row.names=FALSE)
