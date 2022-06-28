# Reads files on a local directory based on date patterns
# The time period for the files to read is based on a rolling window
# Also accounts for leading/non-leading zeroes

library(stringr)
library(purrr)
library(lubridate)

# Parameters
lag_n <- 30 # how many weeks should be aggregated?

path_data <- file.path("PATH")

# file pattern: sample-data-2022-CW-8.txt

# Determine which date range to extract
fun_lag_1 <- function(x) (x - as.numeric(x - 1 + 4) %% 7 - (7 * 1))
monday_lag_1 <- fun_lag_1(Sys.Date())

fun_lag_n <- function(x) (x - as.numeric(x - 1 + 4) %% 7 - (7 * lag_n))
monday_lag_n <- fun_lag_n(Sys.Date())

# First w/o leading zeroes, then with leading zeroes (to account for both cases)
extr_pattern_wo_leading_zeroes <-
  paste0(lubridate::isoyear(seq(ymd(monday_lag_n), ymd(monday_lag_1), by = '1 week')),
         "-CW-",
         lubridate::isoweek(seq(ymd(monday_lag_n), ymd(monday_lag_1), by = '1 week')))

extr_pattern_w_leading_zeroes <-
  paste0(lubridate::isoyear(seq(ymd(monday_lag_n), ymd(monday_lag_1), by = '1 week')),
         "-CW-",
         stringr::str_pad(lubridate::isoweek(seq(ymd(monday_lag_n), ymd(monday_lag_1), by = '1 week')), 2, pad = "0"))

# Combine into one vector
extr_pattern <- c(extr_pattern_wo_leading_zeroes, extr_pattern_w_leading_zeroes)

# List & Filter files
filelist = list.files(path = path_data, pattern = "txt$", full.names = TRUE)
filelist <- filelist[sapply(filelist, function(x) str_detect(x, paste0(extr_pattern, collapse = '|')))]

# Extract data
data <- purrr::map_dfr(filelist, read.delim)

