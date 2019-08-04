==================================================================
Run_AnalysisVersion 1.0
==================================================================
Purpose -
Take data from the Human Activity Recognition Using Smartphones ("HARUS") Dataset and convert to 2 sets of data. The first is a easy to understand idy data set containing the mean and standard devition fields in a single comma-separated format.
The second is a summary of the mean values of of all of the felds in a separate file in comma-separated format.
==================================================================
Input/Output

Input -
The processing takes as input the following separate files stored in "HARUS". Note that training and testing data are specifically stored in separate files.

X_train: A data file that consists of the mesured and calculated data furing the training portion portion. This includes the result for each subject (participant) for each activity, with results for movements in direction of x, y, and z
directions.

X-test: Simliar to X_train, this  a data file that consists of the mesured and calculated data furing the testing portion portion. This includes the result for each subject (participant) for each activity, with results for movements in direction of x, y, and z
directions.

subject_train: A file containing the number corresponding to the subject for each row in X_train.

subject_test: A file containing the number corresponding to the subject for each row in X_test.
 
features: This is a file containing the named attributes for the different columns of data stored in X_train and X_test.

y_train: A data file containing the number of the activity corresponding to the rows of data in X_train.

y_test: A data file containing the number of the activity corresponding to the rows of data in X_test.

activities: The activity desriptions for each distinct ativity number used in both y_train and y_test.

features_info: This data file, which provides information regarding the attribute abbreviations, was initially intended to be used to convert to more meaningful column headers. This approach was abandoned in the later stages of
coding. However, manual inspection of the data was used in writing - rather thn processing - of the code.


Output -
The processing results in 2 files. The first is the resulting tidy data set. The second is a summary of the tidy data in a separate file. Note that the summary was grouped in a particular way. This was first by data set of
origin (train vs. test), then by subject, followed by activity, and lastly direction (x, y, or z) . There would have been other ways to group; however, this was the once chose for the summarization here.

HARUS_tidy.csv: This data, the result of the processing, includes only the columns representing "mean" and "std" (standard deviation) in a tidy data set. This data set includes rows separted by results for direction
(x, y, and z), with columnns added for dataset of origin (train or test), subject number, activity description, and direction (x, y, or z). The column headers containing meaningful attributes are also added. The data is
stored in comma-separated format.

HARUS_tidy_summary.csv: A summarization of the tidy data by dataset of origin, subject, activity description, and direction (x, y, and z), with a mean for each column in the tidy dataset (above).

Note: See HARUS_tidy.md for codebook.



