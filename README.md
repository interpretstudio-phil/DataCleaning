# Data Cleaning Assignment
*Phil Ryan 16/11/2018*

This readme describes the files in this repo and their intended use

To run this script:
1. set working directory to the root of the UCI zip file extract location.  The README.txt file should be present in that directory along with the Features and Activitiy
2. run the run_analysis.R script 
3. review the file sumdata.txt created in the working directory

File| Description
----|-----------------------------------------------------
**sumdata.txt**| contains the summarised dataset, grouped by the subject, the activty and the feature/variable and averging both the mean and the std deviation captured. The file is space spearated and all strings are quoted
**run_analysis.R**| contains the R code to load, cleanse and transform the test and train data.  The script creates a tidy dataset based on the loaded data and then creates a summarised data set sumdata.txt as described above.
**codeBook.md**| contains details of  all the variables and summaries calculated, along with units, and any other relevant information

### Data Source
The data source used by the script is downloadable at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and further details describing the original source data and how it was captured can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 