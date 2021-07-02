library(data.table)

# generate some test data
data <- setDT(data.frame(
  "group1" = c(rep(c("a"), 8), rep(c("b"), 8)),
  "group2" = rep(c("2021-04-21", "2021-04-28", "2021-05-05", "2021-05-12"), times = 4),
  "group3" = c(rep(c("g1"), 4), rep(c("g2"), 4), rep(c("g3"), 4), rep(c("g4"), 4)),
  "value" = c(10, 10, 30, 30, 5, 7, 7, 7, 1, 1, 1, 2, 3, 5, 3, 3)
))

# set key
setkeyv(data, c("group1", "group3", "group2"))

# create a lagged variable & group by others
mydt <- data[, .(group2, currval = value, 
                value_lag_1 = shift(value, type = "lag", n = 1)), 
            by = c("group1", "group3")]

# compute change & perc. change
mydt[, ':=' (val_change = currval - value_lag_1,
             val_pchange = (currval - value_lag_1) / value_lag_1 * 100)]
