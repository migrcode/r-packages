
# Script that detects length of zeroes in a time series (prototype)

library(dplyr)
library(data.table)
data <- 
  fread("data.csv")
setDT(data)
dt1 <- copy(data)

dt1[, dummy_zeroes := fcase(
  stock == 0, 1,
  stock != 0, 0
)]


dt1 %>%
  group_by(date) %>%
  slice(with(rle(dummy_zeroes == 0), sum(lengths[1:which.max(values)])) + 1)

r <- rle(dt1$dummy_zeroes)
dfa <- dt1[cumsum(r$lengths)[r$lengths > 1 & r$values==0]+1,]
dfb <- dt1[cumsum(r$lengths)[r$lengths > 0 & r$values==1]+0,]

# reduce NAs
dfa <- dfa[!is.na(date)]
dfb <- dfb[!is.na(date)]

# reduce clutter
dfa[, `:=` (stock = NULL, dummy_zeroes = NULL)]
dfb[, `:=` (stock = NULL, dummy_zeroes = NULL)]

# rename
setnames(dfa, old = "date", new = "date_begin")
setnames(dfb, old = "date", new = "date_end")

# add row ID
dfa[, ID := .I]
dfb[, ID := .I]

dfc <- merge(dfa, dfb, all.x = TRUE, by = "ID")

dfc$date_begin <- as.Date(dfc$date_begin, format = "%d.%m.%y")
dfc$date_end <- as.Date(dfc$date_end, format = "%d.%m.%y")

dfc[, timespan_days := date_end - date_begin]

mean_zeroes <- dfc[, .(mean_zeroes = mean(timespan_days, na.rm = TRUE))]

