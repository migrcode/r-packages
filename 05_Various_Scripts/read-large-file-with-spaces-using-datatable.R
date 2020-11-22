library(data.table)
path <- file.path("C:/Users/...")
filelist <- list.files(path, pattern="sap_20*", full.names=TRUE)

read_data <- function(z){
  dat <- fread(z, skip = 1, drop = 1, blank.lines.skip = TRUE,
               colClasses = 'character', header = TRUE, fill = TRUE, dec = ",")
  return(dat)
}

datalist <- lapply(filelist, read_data)

bigdata <- rbindlist(datalist, use.names = TRUE)
str(bigdata)

#Define a list for columns to be replaced
mylist = c("MENGE", "QTY")

# Replace commas with dots
bigdata[, (mylist) := lapply(.SD, gsub, pattern = ",", replacement = "."), .SDcols = mylist]

# Transform to numeric
bigdata[, (mylist) := lapply(.SD, as.numeric), .SDcols = mylist]

str(bigdata)

