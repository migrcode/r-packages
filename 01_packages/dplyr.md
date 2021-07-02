# Data transformation with dplyr

* [Lesser known dplyr tricks](https://www.brodrigues.co/blog/2017-02-17-lesser_known_tricks/) – Removing unneeded columns using `select`, apply a function to certain columns only, 

## select
```r
select(flights, Year:DayofMonth, contains("Taxi"), contains("Delay"))
```

## sample
```r
#give me some random rows and replace
flights %>% sample_n(10,replace=TRUE)
```

## str/glimpse
```r
#instead of traditional str(flights)
glimpse(flights)
```
