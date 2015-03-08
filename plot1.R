## Exploratory Data Analysis (Coursera Data Scientist Signature Track)
## 07-03-2015
##
## Project #1, Plot 1

## Variables
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"

## Get the data file if it does not already exist in the local directory
if (!file.exists(zipFile)) {
        download.file(fileURL, destfile=zipFile, method="curl")
        dataDownloaded <- date()
}

## Unzip the file so we can read it
zipFileInfo <- unzip(zipFile, list=TRUE)
if(nrow(zipFileInfo) > 1) {
        ## Stop, because there is more than 1 file in the zip archive
        stop("More than one data file inside zip")
} else {
        ## Read the entire file in and then delete it to save space
        data <- read.csv(unz(zipFile, as.character(zipFileInfo$Name)), sep=";", stringsAsFactors = FALSE, na.strings="?")
}

## Convert to POSIX date format so we can use it as dates
data$Date <- as.Date(strptime(data$Date, format="%d/%m/%Y"))

## Subset out the dates we want
data <- data[data$Date=="2007-02-01" | data$Date=="2007-02-02", ]

## Open the device (aka file)
png("plot1.png", width=480, height=480)

## Plot the histogram with red columns
hist(data$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

## Close the device
dev.off()