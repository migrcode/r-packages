# Data transformation with data.table

The `data.table` package is an extremely fast and memory efficient package for transforming data in R.

The basics of working with data.tables are:

**dt[i, j, by]**
* Take data.table **dt**, 
* subset rows using **i** and
* manipulate columns with **j**, 
* grouped according to **by**.

## Create a data.table

`setDT(df)` converts a data frame or a list to a data.table

## Subset rows using i

`dt[1:2,]` – subset rows based on row numbers

`dt[a>5,]` – subset rows based on values in one or more columns

(Operators: `%in%`, `%like%`, `%between%`, `|`, `%`, `is.na()` ...)
