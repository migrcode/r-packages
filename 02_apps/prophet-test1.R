
library(data.table)
library(prophet)

# prevent scientific notation
options(scipen=999)

path_project <- 
  file.path("")

path_data <-
  file.path(path_project, "order_ts_regular.csv")

data <- data.table::fread(path_data)

str(data)

data[, order_date := as.Date(order_date, format = "%d.%m.%y")]


# Missing dates should have zeroes

complete_seq <- 
  data.table(date = seq(from = min(data$order_date), to = max(data$order_date), by = 1))

# Merge

data_enh <- 
  merge(data, complete_seq, 
      by.x = "order_date", by.y = "date", all = TRUE)

# Replace NAs with 0

setnafill(data_enh, "const", cols=c("order_qty"), fill = 0)

setnames(data_enh, old = c("order_date", "order_qty"), 
         new = c("ds", "y"))

m <- prophet(data_enh)

future <- make_future_dataframe(m, periods = 30)

forecast <- predict(m, future)

plot(m, forecast)


