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

## Manipulate colums with j

`dt[, c(2)]` – extract columns by number or drop columns with "-"

`dt[, .(b,c)]` – extract columns by name

## Summarize

`dt[, .(x = sum(a))]` – create a data.table with new columns based on summarized values of rows. 

(Functions: `mean()`, `median()`, `max()`, ...)

## Convert

`dt[, b := as.integer(b)]` – convert the type of a column

## Group according to by

`dt[,j, by = .(a)]` – group rows by values in specific columns

`dt[,j, keyby = .(a)]` – group and sort rows by values in specific columns

## 


Some parts were extracted from a [cheat sheet](https://raw.githubusercontent.com/rstudio/cheatsheets/master/datatable.pdf) by Erik Petrovski ([CC BY SA](https://creativecommons.org/licenses/by-sa/4.0/), www.petrovski.dk)
