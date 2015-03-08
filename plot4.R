## Exploratory Data Analysis (Coursera Data Scientist Signature Track)
## 07-03-2015
##
## Project #1, Plot 4

##setwd("~/coursera/data_scientist/exploratory-data-analysis/project1")

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

## New Combined DateTime Variable
data$UTC <- strptime(paste(data$Date, " ", data$Time), format="%d/%m/%Y %H:%M:%S")

## Convert to POSIX date format so we can use it as dates
data$Date <- as.Date(strptime(data$Date, format="%d/%m/%Y"))

## Subset out the dates we want
data <- data[data$Date=="2007-02-01" | data$Date=="2007-02-02", ]

## Open the device (aka PNG file)
png("plot4.png", width=480, height=480)

## Setup the 2x2 plotting area
par(mfrow=c(2,2))
with(data, {
        ## 1) Top, Left -> Global active power vs. Time
        plot(UTC, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
        
        ## 2) Top, Right -> Voltage vs. Time
        plot(UTC, Voltage, type="l", xlab="datetime", ylab="Voltage")
        
        ## 3) Bottome, Left -> Submetering vs. Time
        plot(UTC, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", yaxp=c(0,30,3))
        lines(data$UTC, data$Sub_metering_2, col="red")
        lines(data$UTC, data$Sub_metering_3, col="blue")
        legend("topright", pch="_", col=c("black", "red", "blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex=.68, bty="n")
        
        ## 4) Bottom, Right -> Global_reactive_power vs. Time
        plot(UTC, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power", yaxt="n")
        axis(2, cex.axis=".8")
})

## Close the device
dev.off()