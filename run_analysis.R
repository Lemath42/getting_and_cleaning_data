library(reshape2)

X_test <- read.table("./Assignment4/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Assignment4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Assignment4/UCI HAR Dataset/test/subject_test.txt")
test_data <- cbind(subject_test, y_test, X_test)

X_train <- read.table("./Assignment4/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Assignment4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Assignment4/UCI HAR Dataset/train/subject_train.txt")
train_data <- cbind(subject_train, y_train, X_train)

names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
featureNames <- read.table("./Assignment4/UCI HAR Dataset/features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

data = rbind(test_data, train_data)

meanstdcols <- grepl("mean\\(\\)", names(data)) |
    grepl("std\\(\\)", names(data))

meanstdcols[1:2] <- TRUE

data <- data[, meanstdcols]

data$activity <- factor(data$activity, labels=c("Walking",
    "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

melted <- melt(data, id=c("subjectID","activity"))
tidy_dataset <- dcast(melted, subjectID+activity ~ variable, mean)

write.table(tidy_dataset, "./Assignment4/tidy_dataset.txt", row.names=FALSE)