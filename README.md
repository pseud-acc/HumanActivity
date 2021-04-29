# **HUMAN ACTIVITY EXPERIMENTAL DATA**


## **Script**
run_analysis.R

## **Description**
Script creates two clean and tidy data sets from smartphone
data collected from 30 volunteers in a study to investigate human activity.
Human activities were split into six categories: WALKING, WALKING_UPSTAIRS,
WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. The smartphone accelerometer
and gyroscope recorded the 3-axial linear acceleration and 3-axial angular
velocity at a constant rate of 50Hz. This data was split into 70% and 30%
test and train data respectively.

## **Code Book**
For more information on variables see "./uci_har_data/features_info.txt". 

## **Script Outputs**

### [mean_std_data]
Description: Consists of the merged train and test data for
mean and standard deviation measurements recorded, labeled by activity

### [avg_mean_std_data]
Description: Consists of the merged train and test data for
mean and standard deviation measurements recorded, averaged by activity. 
Data is exported to a "txt" file:
"./processed_data/avg_mean_std_activity_data.txt"

## **Additional Links**
More information on the Human Activity experiment can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

