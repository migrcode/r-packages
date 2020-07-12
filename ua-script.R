# script
# 12.3. - 14.3.


#libs
library(tidyverse)
#library(forecast)
library(lubridate)

#read data
sample <- read_csv2("sample-time-series.csv")

sample$date <-as.Date(sample$date,"%d.%m.%Y")
sample$qty <- as.integer(sample$qty)

# Aggregate on a weekly base
sample_weekly <-
  sample %>% 
  group_by(WeekStartDate = cut(date, "week")) %>% 
  summarise(AggQty = sum(qty)) %>% 
  mutate(CW = lubridate::isoweek(as.Date(WeekStartDate, format = '%Y-%m-%d')))

# Make it a time series
sample_weekly.ts <-
  ts(sample_weekly$AggQty, 
   freq=365.25/7, 
   start=decimal_date(ymd("2019-12-30")))

plot(sample_weekly.ts)

monthplot(sample_weekly.ts)
seasonplot(sample_weekly.ts)




# Aggregate on a monthly base
sample_monthly <-
  sample %>% 
  group_by(WeekStartDate = cut(date, "month")) %>% 
  summarise(AggQty = sum(qty)) %>% 
  mutate(MO = lubridate::month(as.Date(WeekStartDate, format = '%Y-%m-%d')))

# Make it a time series
sample_monthly.ts <-
  ts(sample_monthly$AggQty, 
     freq=12, 
     start=decimal_date(ymd("2019-12-30")))

plot(sample_monthly.ts)

monthplot(sample_monthly.ts)
seasonplot(sample_monthly.ts)
