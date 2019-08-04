---
title: "run_analysis.md"

---

## This document describes the code used to take files regarding test results stored in the Dataset.zip zipfile on the 
## Human Activity Recognition Using Smartphone site and transform them into a single tidy dataset and a summary dataset. ## The resulting tidy and summary datasets only contain the results "mean" and standard deviation ("std") columns. 
## However, it combnes both the training and test datasets; adds original dataset, subject number, and activity. It 
## breaks up the data ## by direction (x, y, and z). And it includes meaningful attribute names as column headers.

## Below are the seven steps (A. - G.) and the descriptions of the processing involved.

## Step A. Download zip file and extract necessary data.
## 1. Downloads the data from the website: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to a zipfile called Dataset.zip
## 2. Get a vector of the files in the zipfile.
## 3. Use a vector of specified files to use to unzip the necessary files. These are save as .txt files.
## The files include X_train and X_test, y_train and y_test, subjet_train and subject_text, activities, features, and 
## features_info.

## File notes: X_train and X_test contain results for the training and testing phases, respectively, of the study. 
## y_train and y_test contain the activitity number corresponding with row in X_train and X_test, respectively.
## subject_train and subject_text contain the subject number for each row in X_train and X_test, respectively.
## activities contains the key ## by number to the description of each activity. features contains the attribute names 
## for each of the 561 columns of data results in both X_train and X_test.
## features_info contains information regarding abrreviations of attributes used in features. Note that features_info 
## was extracted and manually inspected for abbreviations. However, the data within it was not further processed.

## Step B. Retrieve data from from .txt files.
## 1. Retrieve text data.
## The data for y_train, y_test, subject_train, subject_test, activities, and features is text. These files are opened
## using the open function with mode of "rt" tonote read-only and text. The text is retrieved for each using the 
## readLines function.
## 2. Retieve binary data. The files X_train and X_test contain binary data of fixed length with a space between them.
## The open function is used with mode "rb" to note read-only and binary. The data is retrieved using the read.csv 
## function with header = FALSE and sep = " ".

## Step C. Add headers and dataset of origin, subject number, and activity number columns for each row of both X-train and X_test.
## 1. Use attibutes for the 561 data columns and add using colnames to both X-train and X-test dataframes, repectively.
## 2. Create an array of equal row length with X-Train and X_test, respectively,
## 3. Use cbind to add dataset of origin, subject number, and activity number to the dataframe with X_train data.
## 3. Do the same as C.2. for the X_test data.

## Step D. Add column headers for the dataset of origin, subject, and activities and Combine training and testing data.
## 1. Standardize column names for these first 3 column names to both X-train and X_test respectively,
## 2. Use rbind to combine the rows of data from the train and test dataframes.

## Step E. Convert activity numbers to descriptions; cull columns for "mean" and "std" only; make column headers more 
## readable.
## 1. Use activities file to replace activity number in charater column with its corresponding description. Remove the 
## leading numbers listed in the activity file. Match descriptions with activity numbers by row in the activity file.
## 2. Use grep to search each column name for either "mean" or "std". Use array of pointers (ptr) to select only these ## columns the expanded dataframe (exp_df) to the minimized dataframe (min_df).
## 3. Clean the remaining headers
## a. Change "acc" to "acceleraion", "gyro" to "gyroscope", "mag" to "magnituede",  meanfreq" to "average frequency", and ## "std" to "standard deviation".
## b. Change formatting to eliminate parentheses "()" and unuseful dashes, and add approiate spaces. Also remove unneeded ## endings ".1", ".2", and ".3" that exist for some x, y, and z direction attributes.

## Step F. Split results for direction (x, y, z) for multiple attributes into separate rows for x results, y results, and ## z results only,
## 1. Get vector of columns whose headers end "-x".  (The "-y" and "-z" columns will immediately follow.)
## 2. Create list containing each group of columns for "x", "y", and "z"
## 3. Using the existing dataframe and dataset of origin, subject, and activitiy description and the id variables for 
## melt, use the melt function with the measures for the list of each st of x, y, and z columns to split these multiple ## sets into separate rows of x results, y results, and z results. Store in min_split_df.

## Step G. Output resulting dataframe as tidy dataset and summarize and output summary dataset
## 1. Open file "HARUS_tidy.csv" in "wt" mode. Write remaining tidy dataframe min_split_df to the opened file.
## 2. Use group_by to group the data by dataset of origin, subject, activity, and direction (x, y, and z). Use the 
## summarize_all command to produce the mean for all remaining columns
## 3. Open file "HARUS_tidy.summary.csv" in mode "wt" and output the summary data using write.csv.

```
