#*******************************************************************************
# Programming Assignment - Getting and Cleaning data
# ******************************************************************************
# Date: 28/04/21
# ******************************************************************************

# ==============================================================================
# BACKGROUND and AIMS
# ==============================================================================
# Script creates two clean and tidy data sets from test and train data recorded
# a smartphone accelerometer and gyroscope during an experiment investigating
# human activity. For more information see README file. 
# ==============================================================================
# SCRIPT OUTPUT:
# ==============================================================================
# Data set name: [mean_std_data]
# Description: Consists of the merged train and test data for 
# mean and standard deviation measurements recorded, labeled by activity
# Data set name: [avg_mean_std_data]
# Description: Consists of the merged train and test data for 
# mean and standard deviation measurements recorded, averaged by activity and
# and subject. Data is exported to "txt" file

# //////////////////////////////////////////////////////////////////////////////
# //////////////////////// SCRIPT //////////////////////////////////////////////
# //////////////////////////////////////////////////////////////////////////////

#Load libraries
library(dplyr)
library(plyr)
library(data.table)


# SET RAW DATA DIRECTORY
data_dir <- "./uci_har_data"

# ==============================================================================
# Import and Merge Train and Test Data Sets
# ==============================================================================

# define dataset names
data_set_type <- c("train","test")
data_names <- c("X","y","subject")

# create list for data
raw_data <- list()

#Import train and test data into list
for (dtype in data_set_type){
        for (dname in data_names){
                data_name <- paste(dname,dtype,sep="_")
                filename <- paste0(dtype,"/",data_name,".txt")
                filepath <- paste(data_dir,filename,sep="/")
                message("Importing data from: ",filepath)
                raw_data[[data_name]] <- read.table(filepath)
        }
}

#merge raw data
test_train_data <- cbind(rbind(raw_data$y_train,raw_data$y_test),
                         rbind(raw_data$subject_train,raw_data$subject_test),
                         rbind(raw_data$X_train,raw_data$X_test))
nrows_w_nan <- nrow(test_train_data)

#remove any nan rows
test_train_data <- data.frame(lapply(test_train_data, as.numeric)) 
test_train_data <- test_train_data[complete.cases(test_train_data),]
nrows_removed <- nrows_w_nan - nrow(test_train_data)

message("Number of rows with nan removed: ", nrows_removed)

#clear workspace of data
remove(raw_data)

# ==============================================================================
# Import and Assign Feature Names
# ==============================================================================

#define file path to feature list
filename <- "features.txt"
filepath <- paste(data_dir,filename,sep="/")

#import feature names for accelerometer data
feature_names <- read.table(filepath)

#define feature list/
feature_list <- c("activity_code","subject",feature_names[,2])

#assign feature names to dataset
names(test_train_data) <- feature_list

# ==============================================================================
# Select mean and standard deviation measurements
# ==============================================================================

#extract index of columns relating to mean and standard deviation measurements
col_index <- grep("(.*)(mean|std)\\(\\)(.*)",feature_list)

#create feature list vector of mean and standard deviation variable names 
mean_std_features <- feature_list[col_index]

#extract mean and standard deviation variable columns from merged data
mean_std_data <- test_train_data[,c("activity_code","subject",
                                    mean_std_features)]

#rename features
full_name_feature_list <- mean_std_features %>%
        {gsub("^t","time.domain.",.)} %>%
        {gsub("^f","frequency.domain.",.)} %>%
        {gsub("Body|BodyBody","body.",.)} %>%
        {gsub("Gravity","gravity.",.)} %>%
        {gsub("Acc","accelerometer.",.)} %>%  
        {gsub("Gyro","gyroscope.",.)} %>%  
        {gsub("Mag","magnitude.",.)} %>% 
        {gsub("Jerk","jerk.",.)}%>% 
        {gsub("-X",".X.direction",.)}%>% 
        {gsub("-Y",".Y.direction",.)}%>% 
        {gsub("-Z",".Z.direction",.)}%>% 
        {gsub("\\(\\)","",.)}%>% 
        {gsub("-","",.)}

#assign new feature names to data set
names(mean_std_data) <- c("activity_code","subject",full_name_feature_list) 

# ==============================================================================
# Import and Merge Activity Labels
# ==============================================================================

#define file path to activity list
filename <- "activity_labels.txt"
filepath <- paste(data_dir,filename,sep="/")

#import activity list
activity_list <- read.table(filepath)

#rename columns
names(activity_list) <- c("activity_code","activity")

#Merge activity names onto test_train data set (maintain row order)
mean_std_data <- join(mean_std_data,activity_list) %>%
                        select(-activity_code)

#reorder columns 
mean_std_data <- mean_std_data[,c("activity","subject",full_name_feature_list)]

# ==============================================================================
# Compute the average of mean and standard deviation measurements by activity
# and subject
# ==============================================================================

avg_mean_std_data <-  mean_std_data %>%
        group_by(activity, subject) %>% 
        summarise_each(funs(mean))

# ==============================================================================
# Export average of mean and standard deviation measurements by activity to file
# ==============================================================================

#define destination folder
destdir <- "./processed_data"
if(!(file.exists(destdir))){dir.create(destdir)}

#define file name and path
filename <- "avg_mean_std_activity_data.txt"
filepath <- paste(destdir,filename, sep="/")

#export data
write.table(avg_mean_std_data,filepath,row.name=FALSE)
