# Code Book
*Phil Ryan 16/11/2018


## Source Data


### Data Location
The data source used by the script is downloadable at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and further details describing the original source data and how it was captured can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Specifically the files processed are:

File Location|Content
--------------------|--------------------------------------------------
UCI HAR Dataset\/features.txt| List of features observed such as fBodyAcc. These are captured as individual variables in the source data set files but 'tidy'ed as part of this processing to become values of a variable called feature 
UCI HAR Dataset\/activity_labels.txt| List of the activities being performed by the subject at the time of the observation e.g. sitting, standing. The original source data is capitalised so this processing reduces these to lowercase
UCI HAR Dataset\/test\/X_test.txt    UCI HAR Dataset\/train\/X_train.txt| The raw data of the features measured during either training or testing.  Each observation contains over 500+ measurements across features, axes and various statistical functionas applied to them 
UCI HAR Dataset\/test\/y_test.txt    UCI HAR Dataset\/train\/y_train.txt| Contains the Subject ID for each of the observations in the X_<file> above

### Accelerometer and Gyroscope Features

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation



## Tidy Data Results Set
The script run_analysis.R contains R script to load data from the original data 
source produced by UCI noted above.  The script loads data from seperate source
files and merges the mean/std deviation measurements with subject and activity 
data.  The output of this first stage of processing is a wide data set containing 
over 500 variables.

The next stage of processing is to 'tidy' the data by melt'ing the variables to 
create a tall data set of just 8 variables, but considerably more rows or 
observations   

The resultant data set contained in the object *data* is described below

*\>str(data)*  
Classes 'tbl_df', 'tbl' and 'data.frame':	339867 obs. of  8 variables:  
 $ source       : chr  "train" "train" "train" "train" ...  
 $ observationID: chr  "1" "2" "3" "4" ...  
 $ subjectID    : int  1 1 1 1 1 1 1 1 1 1 ...  
 $ activity     : chr  "standing" "standing" "standing" "standing" ...  
 $ feature      : chr  "tBodyAcc" "tBodyAcc" "tBodyAcc" "tBodyAcc" ...  
 $ axis         : chr  "X" "X" "X" "X" ...  
 $ mean         : num  0.289 0.278 0.28 0.279 0.277 ...  
 $ sdev         : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...  

###Sample tidy data

n|source|observationID|subjectID|activity|feature|axis|mean|sdev
--|-----|--------------|----------|---------|--------|------|-------|-------
\.|\<chr\>|\<chr\>|\<int\>|\<chr\>|\<chr\>|\<chr\>|\<dbl\>|\<dbl\>
1|train|1|1|standing|tBodyAcc|X|0.289|-0.995
2|train|2|1|standing|tBodyAcc|X|0.278|-0.998
3|train|3|1|standing|tBodyAcc|X|0.280|-0.995
4|train|4|1|standing|tBodyAcc|X|0.279|-0.996
5|train|5|1|standing|tBodyAcc|X|0.277|-0.998
6|train|6|1|standing|tBodyAcc|X|0.277|-0.997


### Descriptions of tidy data Variables 

Variable|Description
--------|-----------------------------------------------------------
source|Contains either train or test to denote where the source of the observation
observationID| the row number within the source file that this observation was originally sourced from
subjectID| the ID of the subject from which the observation was captured
activity| the activity being performed during the observation.  Activities include laying, sitting, standing, walking etc
feature| the accelerometer or gyroscope measured. Features include fBodyAcc, fBodyAccJerk, fBodyAccMag, fBodyBodyAccJerkMag etc
axis| the X,Y or Z axis the feature observation was made upon.  Where there is no relevant axis, the axis value will be NA
mean| the mean value of the measurements captured during the observation, normalised between -1 and +1
sdev| the standard deviation of the measurements captured during the observation, normalised between -1 and +1

## Summary Tidy Data Results Set
The tidy data is then summarised to provide the average of each variable for each activity and each subject.

The resultant summary data set contained in the object sumdata  
*\> str(sumdata\)*  
Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	3060 obs. of  5 variables:  
 $ subjectID: int  1 1 1 1 1 1 1 1 1 1 ...  
 $ activity : chr  "laying" "laying" "laying" "laying" ...  
 $ feature  : chr  "fBodyAcc" "fBodyAccJerk" "fBodyAccMag" "fBodyBodyAccJerkMag" ...  
 $ grpbyMean: num  -0.896 -0.943 -0.862 -0.933 -0.942 ...  
 $ grpbySdev: num  -0.857 -0.952 -0.798 -0.922 -0.933 ...  
 - attr(*, "vars")= chr  "subjectID" "activity"  
 - attr(*, "drop")= logi TRUE  

###Sample summary tidy data
*\> sumdata*
\# A tibble: 3,060 x 5
\# Groups:   subjectID, activity  

subjectID|activity|feature|grpbyMean|grpbySdev
---------|------|------------|-------|-------
\<int\>|\<chr\>|\<chr\>|\<dbl\>|\<dbl\>
1|1|laying|fBodyAcc|-0.896|-0.857
2|1|laying|fBodyAccJerk|-0.943|-0.952
3|1|laying|fBodyAccMag|-0.862|-0.798
4|1|laying|fBodyBodyAccJerkMag|-0.933|-0.922
5|1|laying|fBodyBodyGyroJerkMag|-0.942|-0.933
6|1|laying|fBodyBodyGyroMag|-0.862|-0.824
7|1|laying|fBodyGyro|-0.904|-0.917
8|1|laying|tBodyAcc|0.0226|-0.864
9|1|laying|tBodyAccJerk|0.0319|-0.946
10|1|laying|tBodyAccJerkMag|-0.954|-0.928

\# ... with 3,050 more rows

The summary tidy data set is written to the following file as the concluding step of processing
*sumdata.txt*