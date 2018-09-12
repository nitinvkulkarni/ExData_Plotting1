file.name <- "./household_power_consumption.txt"
url       <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip.file  <- "./data.zip"

# Download data file from URL if not already present. Znzip file &
# remove zip file from working directory
if (!file.exists("./household_power_consumption.txt")) {
  download.file(url, destfile = zip.file)
  unzip(zip.file)
  file.remove(zip.file)
}

# Read the file
library(data.table)
DT <- fread(file.name,
            sep = ";",
            header = TRUE,
            colClasses = rep("character",9))

# Convert "?" in NAs
DT[DT == "?"] <- NA

# Apply filter
DT$Date <- as.Date(DT$Date, format = "%d/%m/%Y")
DT <- DT[DT$Date >= as.Date("2007-02-01") & DT$Date <= as.Date("2007-02-02"),]

# Convert column that we will use to correct class
DT$Global_active_power <- as.numeric(DT$Global_active_power)


# Add field posix in data frame as date & time combined
DT$posix <- as.POSIXct(strptime(paste(DT$Date, DT$Time, sep = " "),
                                format = "%Y-%m-%d %H:%M:%S"))

#Plot graph of sub metering 1, 2 & 3 on single plot alongwith labels
png(file = "plot3.png", width = 480, height = 480, units = "px")

with(DT,
     plot(posix,
          Sub_metering_1,
          type = "l",
          xlab = "",
          ylab = "Energy sub metering"))
with(DT,
     points(posix,
            type = "l",
            Sub_metering_2,
            col = "red")
)
with(DT,
     points(posix,
            type = "l",
            Sub_metering_3,
            col = "blue")
)
legend("topright", col = c("black", "blue", "red"),
       legend = c("Sub_metering_1","Sub_metering_2", 
                  "Sub_metering_3"), lty = 1)

dev.off()  # Close the png file device
