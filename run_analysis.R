library(dplyr)
library(plyr)
library(reshape2)

# Download Files
u <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")) {
  download.file(u, destfile = "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip",method = "curl")
}
unzip("getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

# Load All Data (Step 1) & Labels all variables (Step 4)
train_x <- read.table("UCI HAR Dataset/train/x_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_x, train_y, train_sub)
colnames(train) <- append(as.character(read.table("UCI HAR Dataset/features.txt")[[2]]),c("activity","subject"))

test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_x, test_y, test_sub)
colnames(test) <- append(as.character(read.table("UCI HAR Dataset/features.txt")[[2]]),c("activity","subject"))

# Merge One Data Set (Step 1)
Samsung <- rbind(train,test)

# Extract Measurements on Mean and Sd (Step 2)
Samsung_final <- Samsung[,grepl(".*[Mm]ean.*", colnames(Samsung))|grepl(".*[Ss]td.*", colnames(Samsung))
                         |grepl("activity", colnames(Samsung))|grepl("subject", colnames(Samsung))]

# Name The Activities (Step 3)
label_act <- read.table("UCI HAR Dataset/activity_labels.txt")
label_act <- arrange(label_act, V1)
Samsung_final <- mutate(Samsung_final, activity = label_act$V2[activity])

# Create a Tidy Dataset
Samsung_melt <- melt(Samsung_final, id = c("subject", "activity"))
Samsung_mean <- dcast(Samsung_melt, subject + activity ~ variable, mean)
write.table(Samsung_mean, file = "tidy.txt", row.names = FALSE, quote = FALSE)



