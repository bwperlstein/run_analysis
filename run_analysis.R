## run_analysis.R

## Process:
## 1. Set values of needed variables
## 2. Load standard R libraries
## 3. Create directory (if necessary) and set directory path. Download the .zip file containing the necessary files.
## 4. Get the names of all zipped in the .zip file. Unzip the list of files needed to create the tidy data table
## 5. Read in data from the needed text files. Then do the same for files with data (X_train and X_test)
## 6. Remove leading digits from: a. features and b. activities. Add column names from features to train and test 
## data frames.
## 7. Add origin data set name (TRAIN or TEST, subject and activity data columns for both the train and test data frames.
## 8. Synchronize column labels from subject and activity for expanded data frames.
## 9. Combine rows of train and text data.
## 10. Change numbers to labels in activity column.
## 11. Keep only columns with mean or standard deviation. Standardize and clean the column names of the remaining
## columns in the data frame.
## 12. Split all columns with directions x, y, and z values to rows for x, y, and z, distinctly
## 13. Output the resulting tidy data data frame to a .csv file called "HARUS_tidy.csv".
## 14. Group, summarize and store summary resuts. Output the resulting tidy data frame to "HARUS_tidy_summary.csv".

createDirectory_setPath <- function(dir.name) {
        ## 1. If directory dir.name does not exist, create
        ## 2. Set working directory to dir.name
        
        if(!exists(dir.name)) {
                dir.create(dir.name)    
        }
        setwd(dir.name)
}

retrieveZipFile <- function(url, zipname) {
        ## Download from the specified url the zip file (zipname)
        
        download.file(url, zipname, method = "wininet", mode = "wb")
}

getUnzipList <- function(zipname) {
        ## Obtain the list of all zipped files in file zipname
        
        UnzipList <- unzip(zipname, list = TRUE)
        return(UnzipList[, 1])
}

UnzipandSaveFiles <- function(file_names, Ziplist, Zipname) {
        ## Unzip files listed in file_names from Zipname
        ## 1. Add extension ".txt" to list in file_names
        ## 2. For each file name, find where it is located within the zip file (Zipname)
        ## 3. Unzip and read in the unzipped file
        ## 4. Save the result in a text file in the working directory
        ## 5. Return the file name list with extension added (from step 1.)
        
        file_names_ext <- paste(file_names, ".txt", sep = "")
        for(i in 1:length(file_names_ext)) {
                ptr <- grep(paste("/", file_names_ext[i], "$", sep = ""), Ziplist)
                filenm <- Ziplist[ptr]
                
                if(i <= 7) {
                        a <- unzip(Zipname, filenm)
                        con <- file(filenm, "rt")
                        df_temp <- readLines(con, skipNul = TRUE)
                        close(con)
                        filenm2 <- basename(filenm)
                        filenm2
                        con <- file(filenm2, "wt")
                        writeLines(df_temp, con)
                        close(con)
                } else {
                        a <- unzip(Zipname, filenm)
                        con <- file(filenm, "rb")
                        df_temp <- readLines(con)
                        close(con)
                        filenm2 <- basename(filenm)
                        filenm2
                        con <- file(filenm2, "wb")
                        writeLines(df_temp, con)
                        close(con)
                }
        }
        
        return(file_names_ext)
}

getTextLines <- function(filename) {
        con <- file(filename, "rt")
        vector_temp <- readLines(con)
        close(con)
        return(vector_temp)
}

getBinaryData <- function(filename){
        ## 1. Retrieve data from file of binary results
        ## 2. Convert lines of 561 values to data frame and return
        
        con <- file(filename, "rt")
        vector_temp <- readLines(con)
        close(con)
        
        df_temp <- data.frame()
        for(i in 1:length(vector_temp)) {
                for(j in 1:561) {
                        str_ptr <- 16 * (j - 1) + 3
                        df_temp[i, j] <- as.numeric(substr(vector_temp[i], str_ptr, (str_ptr + 14)))
                }
        }
        
        return(df_temp)
}


removeLeadingDigits <- function(df) {
        ## Remove leading digits from list of features
        
        df <- gsub("^[0-9]+ ", "", df)
        
}

addOrigin_SubjectandActivityNumber <- function(origin,subj_df, act_df, primary_df) {
        ## 1. Create vector naming origin dataset for data
        ## 2. Combine origin column, subject column, and activity column with results data frame 
        origin_vector <- rep(origin, times = nrow(primary_df))
        combined <- cbind(origin_vector, subj_df, act_df, primary_df)
        colnames(combined)[1] <- "dataset_origin"
        colnames(combined)[2] <- "subject"
        colnames(combined)[3] <- "activity"
        
        return(combined)
}

combineSingleFrame <- function(df_1, df_2) {
        ## 1. Change column names of 1st 3 columns from two data fames to the same value
        ## This will allow rowbinding of the train and test results
        ## 2. Combine rows to create single data from df_1 & df_2
        
        colnames(df_1)[1:3] <- c("dataset_origin", "subject", "activity")
        colnames(df_2)[1:3] <- c("dataset_origin", "subject", "activity")
        
        return(rbind(df_1, df_2))
}

subActivityDescription <- function(description, df) {
        ## Convert activity numbers in character vector in column 2 to the description of the activity
        
        df[, 3] <- description[as.integer(df[, 3])]
        return(df)
}

keepMeanandSTDColumns <- function(full_df) {
        ## 1. Create vector of column indexes where column name has either "mean" or "std
        ## 2. Return data frame, selecting just those columns
        
        mean_ptr <- grep("mean", colnames(full_df))
        std_ptr <- grep("std", colnames(full_df))
        ptr <- c(1, 2, 3)                                                       ## Keep 1st 3 id columns 
        ptr[(length(ptr) + 1):(length(ptr) + length(mean_ptr))] <- mean_ptr     ## Keep mean columns
        ptr[(length(ptr) + 1):(length(ptr) + length(std_ptr))] <- std_ptr       ## Keep standard deviation columns
        ptr <- sort(unique(ptr))
        full_temp <- full_df[ptr]
        
        return(full_temp)
}

cleanHeaderNames <- function(df_temp) {
        ## 1. convert all column data to lower case
        ## 2. convert all short words in descriptions to full words, add spaces, remove punctuation ("()", "-")
        ## 3. Remove unnecessary ".1" endings
        ## 4. Removeleading "t" or "f" from column names and replace with time or frequency just before firt hyphen        

        colnames(df_temp) <- tolower(colnames(df_temp))
        
        colnames(df_temp) <- gsub("gyro", "gyroscope_", colnames(df_temp))
        colnames(df_temp) <- gsub("body", "body_", colnames(df_temp))
        colnames(df_temp) <- gsub("acc", "acceleration_", colnames(df_temp))
        colnames(df_temp) <- gsub("jerk", "jerk_", colnames(df_temp))
        colnames(df_temp) <- gsub("mag", "magnitude_", colnames(df_temp))
        colnames(df_temp) <- gsub("gravity", "gravity_", colnames(df_temp))
        colnames(df_temp) <- gsub("-std", "standard_deviation", colnames(df_temp))
        colnames(df_temp) <- gsub("-meanfreq", "average", colnames(df_temp))
        colnames(df_temp) <- gsub("-mean", "mean", colnames(df_temp))
        colnames(df_temp) <- gsub("\\(\\)", "", colnames(df_temp))
        
        for(i in 1:length(colnames(df_temp))) {                                 ## Search each column heading for a
                for(j in 1:nchar(colnames(df_temp)[i])) {                       ## starting "f" or "t." Add "frequency"
                        if(str_sub(colnames(df_temp)[i], j, j) == "-") {        ## near end of heading for "f"; add "time"
                                 if (str_sub(colnames(df_temp)[i], 1, 1) == "f") {        ## for "t." Then remove the
                                        stringx <- str_sub(colnames(df_temp)[i], (j + 1)) ## add back remainder of string
                                        str_sub(colnames(df_temp)[i], j) <- "_frequency-" ## remove the leading "f" or "t"
                                        colnames(df_temp)[i] <- paste(colnames(df_temp)[i], 
                                                                      stringx, sep = "")  ## and add "frequency" or "time,"
                                        str_sub(colnames(df_temp)[i], 1, 1) <- ""         ## respectively, before "-".
                                } else if(str_sub(colnames(df_temp)[i], 1, 1) == "t") {
                                        stringx <- str_sub(colnames(df_temp)[i], (j + 1))
                                        str_sub(colnames(df_temp)[i], j) <- "_time-"
                                        colnames(df_temp)[i] <- paste(colnames(df_temp)[i], 
                                                                      stringx, sep = "")
                                        str_sub(colnames(df_temp)[i], 1, 1) <- ""
                                }
                                j <- nchar(colnames(df_temp)[i])
                        } else if(j == nchar(colnames(df_temp)[i])) {                     ## Similar to above but add
                                if (str_sub(colnames(df_temp)[i], 1, 1) == "f") {         ## "frequency" or "time" to the
                                        str_sub(colnames(df_temp)[i], j+1) <- "_frequency"## end, if no "-".
                                        str_sub(colnames(df_temp)[i], 1, 1) <- ""
                                } else if(str_sub(colnames(df_temp)[i], 1, 1) == "t") {
                                        str_sub(colnames(df_temp)[i], j+1) <- "_time"
                                        str_sub(colnames(df_temp)[i], 1, 1) <- ""
                                }
                        }
                }
        }
        
        return(df_temp)
}

splitX_Y_and_Z_Columns <- function(df_var) {
        ## Split all separate measure columns for the same dataset (training or test), subject, and activity into
        ## separate rows.
        
        df_split <- gather(df_var, "measure", "value", 4:length(colnames(df_var))) 
        df_split <- as_tibble(df_split)
        df_split <- arrange(df_split, dataset_origin, subject, activity, measure)
        
        return(df_split)
}

outputResultstoCSV <- function(df_local, fname) {
        ## Write out results from data frame to named file
        
        con <- file(fname, "wt")
        write.table(df_local, fname, row.names = FALSE)
        close(con)
}

run_analysis <- function(dir.initial) {
        
        ## Set values of needed variables
        ## These include: a) the name of the directory; b) the URL containing the zip file; c) the downloaded zip file name;
        ## d) the list of files to be unzipped, stored, and read into data frames for transformation; e) the name of the
        ## output tidy file; and f) the name of the output summary file.
        direct <- "run_analysis"
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipf <- "Dataset.zip"
        extract_list <- c("features", "activity_labels", "subject_train", "subject_test", "y_train", "y_test",
                          "features_info", "X_train", "X_test")
        tidy_name <- "HARUS_tidy.txt"
        summary_name <- "HARUS_tidy_summary.txt"
        
        ## Load standrd libraries used
        library(plyr)
        library(dplyr)
        library(tidyr)
        library(reshape2)
        library(stringr)
        library(readr)
        
        ## Create directory (if necessary) and set directory path.
        ## Download the .zip file containing the necessary files.
        setwd(dir.initial)
        createDirectory_setPath(direct)
        retrieveZipFile(fileURL, zipf)

        ## Get the names of all zipped in the .zip file.
        ## Unzip the list of files needed to create the tidy data table
        full_file_list <- getUnzipList(zipf)
        extract_files <- UnzipandSaveFiles(extract_list, full_file_list, zipf)
        
        ## Read in data from the needed text files
        features_df <- getTextLines(extract_files[1])
        activity_df <- getTextLines(extract_files[2])
        subject_train_df <- getTextLines(extract_files[3])
        subject_test_df <- getTextLines(extract_files[4])
        activity_train_df <- getTextLines(extract_files[5])
        activity_test_df <- getTextLines(extract_files[6])
        features_info_df <- getTextLines(extract_files[7])
        
        ## Read in data results from data files (binary)
        train_df <- getBinaryData(extract_files[8])
        test_df <- getBinaryData(extract_files[9])
        
        ## Remove leading digits from: a. features and b. activities
        features_df <- removeLeadingDigits(features_df)
        activity_df <- removeLeadingDigits(activity_df)
        
        ## Add column names from features to train and test data frames
   
        colnames(train_df)[1:561] <- features_df[1:561]
        colnames(test_df)[1:561] <- features_df[1:561]
        
        ## Add origin data set name (TRAIN or TEST, subject and activity data columns for both the train and
        ## test data frames
        exp_train_df <- addOrigin_SubjectandActivityNumber("TRAIN", subject_train_df, activity_train_df, train_df)
        exp_test_df <- addOrigin_SubjectandActivityNumber("TEST", subject_test_df, activity_test_df, test_df)
        
        ## A. Synchronize column labels from subject and activity for expanded data frames, and
        ## B. Combine rows.
        exp_full_df <- combineSingleFrame(exp_train_df, exp_test_df)
        
        ## Change numbers to labels in activity column 
        exp_full_df <- subActivityDescription(activity_df, exp_full_df)
        
        ## Keep only columns with mean or standard deviation
        min_full_df <- keepMeanandSTDColumns(exp_full_df)
        
        ## Standardize and clean the column names of the remaining colimns in the data frame
        min_full_df <- cleanHeaderNames(min_full_df)
        
        ## Split all columns with x, y, and z values to rows for x, y, and z
        min_split_df <- splitX_Y_and_Z_Columns(min_full_df)
        
        ## Output the resulting tidy data data frame to a .csv file called "HARUS_tidy.csv"
        outputResultstoCSV(min_split_df, tidy_name)
        
        ## Group, summarize and store summary resuts
        ## 1. Group and summarize results by: data group ("TRAIN" vs. "TEST); subject; activity; x, y and z.
        ## 2. Output summarized results ro "HARUS_tidy_summary.csv"
        browser()
        sum_split_df <- min_split_df %>% group_by(dataset_origin, subject, activity, measure) %>%
                                  summarize(mean = mean(value, na.rm = TRUE))
        browser()
        outputResultstoCSV(sum_split_df, summary_name)
        
        setwd(dir.initial)
}