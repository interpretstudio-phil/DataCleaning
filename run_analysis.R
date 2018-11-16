##
## Script to tidy wearable computing data ready for further processing
##  Phil Ryan - 15/11/2018
##
# Steps performed
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the mean and standard deviation for each measurement.
# 3. Applies descriptive activity names to the activities in the data set
# 4. Labels the data set with descriptive variable names.
# 5. Creates a 2nd summary data set with the average of each variable for each
#    activity and subject.


# Setup environment including required libraries
# setwd('./UCI HAR Dataset')
library('dplyr')
library('tidyverse')
library('reshape2')

# Load the features which describe each of the columns in the X_<file> dataset
# Within the 561 features we are onlty interested in the mean and standard 
# deviation measurements so we capture these so we can drop the others 
features <- read.delim(
  'features.txt',
  header = FALSE,
  sep = " ",
  stringsAsFactors = FALSE,
  col.names = c('Num', 'Name')
)
all_features <- features[, "Name"]
desired_features <- grep('(mean\\(|std\\())', all_features)


# Load the activities list which will be joined in to provide clearer labels
# we will fix the values to lowercase as per convention  
activities <- read.delim(
  'activity_labels.txt',
  header = FALSE,
  sep = " ",
  stringsAsFactors = FALSE,
  col.names = c('activityID', 'activity')
)
activities$activity <- str_to_lower(activities$activity)


# Define the function to merge the 3 sets of data files into one, namely
# the X_<file>, y_<file> and subject_<file> files
#  During this process we also
#   1. remove undesired columns in the X_<file> keeping the mean & std measures
#   2. add a column 'source' to denote the original fileset either test or train
#   3. add a column 'observationID' to denote the record number in the X_<file>

MergeData <- function (datatype = 'train', colnames, colskeep) {
  Tdata <- read.fwf(
    paste0(datatype, '/X_', datatype, '.txt'),
    widths = rep.int(16, 561),
    #n = 1, #used during debug to limit the observations to be read
    colClasses = rep('numeric', 561)
  )
  
  Tdata <- select(Tdata, colskeep)
  names(Tdata) <- colnames[colskeep]
  
  Sdata <-
    read.fwf(
      paste0(datatype, '/subject_', datatype, '.txt'),
      widths = c(2),
      #n = 1, #used during debug to limit the observations to be read
      col.names = c('subjectID'),
      colClasses = c('integer')
    )
  Ydata <- read.fwf(
    paste0(datatype, '/y_', datatype, '.txt'),
    widths = c(1),
    #n = 1, #used during debug to limit the observations to be read
    col.names = c('activityID'),
    colClasses = c('integer')
  )
  
  rawData <- bind_cols(Tdata, Sdata, Ydata)
  rawData <- mutate(rawData,source=datatype)
  rawData <- rownames_to_column(rawData, 'observationID')
  
}


# Read in the training and test data using the file load function
data <-
  bind_rows(
    MergeData('train', all_features, desired_features),
    MergeData('test', all_features, desired_features)
  )


# Add in the activity descriptions based on the activity id
data <- left_join(data, activities, by = "activityID")


# Melt all mean variables into a single mean feature variable and value pair
meancols <- grep('mean', names(data), value = TRUE)
data <-
  melt(
    data,
    measure.vars = meancols,
    value.name = 'mean',
    variable.name = 'meanfeature'
  )

# Melt all stddev variables into a single sdev feature variable and value pair
sdevcols <- grep('std', names(data), value = TRUE)
data <-
  melt(
    data,
    measure.vars = sdevcols,
    value.name = 'sdev',
    variable.name = 'sdevfeature'
  )

# Create a new feature variable which is distilled from the composite variable
# meanvariable which contains the feature, the function applied and the axis
data <- filter(
  data,
  str_replace(meanfeature, '-mean()', '') ==
    str_replace(sdevfeature, '-std()', '')
)
data <- mutate(data, 
               feature = str_sub(data$meanfeature, 1,
                                 str_locate(data$meanfeature, '-')[,'start'] - 1))

# Create a new axis variable that will denote is the feature mean and std dev
# are related to the X,Y,Z or no axis (NA)
data <- mutate(data, axis = NA)
data[grep('X$', data$meanfeature), ]$axis <- 'X'
data[grep('Y$', data$meanfeature), ]$axis <- 'Y'
data[grep('Z$', data$meanfeature), ]$axis <- 'Z'

# Reorganise the order of the variables/columns and drop any unnecessary ones
data <- as_tibble(select(data,
                              c(
                                "source",
                                "observationID",
                                "subjectID",
                                "activity",
                                "feature",
                                "axis",
                                "mean",
                                "sdev"
                                )
                          )
                  )


# Create a summary dataset, based on the subject the activty and the feature/
# variable and averging both the mean and the std deviation captured 
sumdata <- group_by(data, subjectID,activity,feature)
sumdata <- summarise(sumdata,grpbyMean=mean(mean),grpbySdev=mean(sdev))

# write the summary data to a file
write.table(sumdata,file = 'sumdata.txt', row.names = FALSE)
