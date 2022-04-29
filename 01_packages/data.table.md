# 1. Basics

### What is the data.table package?

* The `data.table` package is an extension of the data.frame package.
* The `data.table` package is an extremely fast and memory efficient package for transforming data in R.
* It has a fast file reader, is very fast when it comes to adding/updating/deleting columns.

### Why is data.table extremely fast?

A major reason is that changes are done in place rather than having to recreate / copy objects.

### Basic usage

**dt[i, j, by]**
* Take data.table **dt**, 
* subset rows using **i** and
* manipulate columns with **j**, 
* grouped according to **by**.


# 2. Basic Operations

## Create a data.table

```r
# Convert a data frame or a list to a data.table
setDT(df)

# Convert to a data table (this will copy the object)
mydata <- as.data.table(mydata)

```
Use `setDT()` when working with very large data sets that are heavy on RAM as each object is modified in place, conserving memory. As in R, data is stored in memory, you will at some point run out of memory if your data is copied several times. The data.table package tries to avoid that while being memory efficient and modifying data in place. Hence, `setDT()` is the more preferable option. See also [this post](https://stackoverflow.com/questions/41917887/when-should-i-use-setdt-instead-of-data-table-to-create-a-data-table) on stackoverflow.


## Subset rows using `i`

```r
# Based on row numbers
dt[1:2,]

# Based on values in one or more columns
dt[a>5,]

# Using multiple conditions
DT[V1 == 1 & V4 == "A"]

# Fast filtering using binary search method
DT["a", on="x"]

# Fast %in% for characters
DT[V4 %chin% c("A", "C")]

# Regular expressions (regex)
DT[V4 %like% "^B"]

# Between
DT[V2 %between% c(3, 5)]

# Set data.table unique
unique(dt)

# Count the number of unique rows based on columns specified in "by",
# leave out the "N" to really extract unique rows
uniqueN(dt, by = c("a", "b")) 

# Sort dt first by x in asc order, then by y in desc order
dt[order(x, -y)]

(Operators: `%in%`, `%like%`, `%between%`, `|`, `%`, `is.na()` ...)
```

## Manipulate colums with `j`

```r
# Extract columns by number
dt[, c(2)]

# Extract columns by name
dt[, .(b,c)]

# Subset columns
dt[, .(col1)]

# Subset columns (output is vector)
dt[, col1]

# Subset column and rename it on-the-fly
mydt <- dt[, .(col_new = col_old)]

# Exclude columns from the data.table (per name)
dt[, !c("col1","col2")]
dt[, col1 := NULL]

# Exclude columns using a vector of names
mycols <- c("x", "y")
dt[, (mycols) := NULL]

# Exclude columns from the data.table (per ID)
DT[!2:4]

# Replace rowvalues based on a condition
dt[x < 2, x := 0L]

# Convert the type of a column
dt[, b := as.integer(b)]

# Rename collumns
setnames(dt, c("a", "b"), c("x","y"))
```

## Compute or do in `j`

```r
# Calculate the sum of column a, returning a vector
dt[, .(x = sum(a))]

# Returning a data.table based on the sum of a,
# using the reference method (no <- required)
dt[, x := sum(a)]

# Adding several columns using the reference method
dt[, ':=' (v1 = sqrt(v1), v2 = v2^2)]

# Only the last expression in the curly brackets is in the output,
# the rest is just generated temporarily
dt[, {tmp1 = mean(mpg); tmp2 = mean(abs(mpg-tmp1)); tmp3 = round(tmp2, 2)}, by = cyl]

(Functions: `mean()`, `median()`, `max()`, ...)
```

## Group according to `by`

```r
# Simple summarizing and grouping
dt[, .(mysum = sum(x)), by = "y"]

# Group rows by values in specific columns
dt[,j, by = .(a)]

# Group and sort rows by values in specific columns
dt[,j, keyby = .(a)]

# Count number of observations in each group
dt[, .N, by = x]

# Count number of observations for each group,
# and add a column for that
dt[, x := .N, by = y][]

```

# 3. Advanced Operations

## Join operations

```r
# Inner join
merge(X, Y, all = FALSE, by.x = "x1", by.y = "y1")

# Left outer join
merge(X, Y, all.x = TRUE)

# Right outer join
merge(X, Y, all.y = TRUE)

# Full outer join
merge(X, Y, all = TRUE)
```

```r
# Merge but exclude specific columns from y
merge(x, y[, !c("id")], by = "group", all.x = TRUE)
```

## fcase / fifelse

```r
# fcase
airquality <- 
  data.table(airquality)[, NextMonth := fcase(Month == 5, 
                                              Month + 1, 
                                              default = NA)]
# fcase
airquality <-
  data.table(airquality)[, Category := fcase(
  Wind > 8 & Temp > 70, "A",
  Wind <= 8 & Temp <= 70, "B",
  Wind > 8 & Temp <= 70, "C",
  Wind <= 8 & Temp > 70, "D"
)]

# fifelse
airquality <- 
  data.table(airquality)[, NextMonth := fifelse(Month == 5,
                                                Month + 1,
                                                Month)]
```
## Reshaping a data table

From wide to long
```r
dt <- melt(data,
          id.vars = c("col1", "col2"),
          measure.vars = c("col3", "col4"),
          variable.name = "mycol1",
          value.name = "mycol2")
```


## Chaining

```r
# Chaining horizontally
dt[ ... ][ ... ]

# Chaining vertically
dt[ ...
   ][ ...
     ][ ...
       ]
```

### Ordering results directly

```
DT[, sum(v), by=x][order(-V1)]
```


## Set operations

```r
x = data.table(c(1,2,2,2,3,4,4))
y = data.table(c(2,3,4,4,4,5))
fintersect(x, y)            # intersect
fintersect(x, y, all=TRUE)  # intersect all
fsetdiff(x, y)              # except
fsetdiff(x, y, all=TRUE)    # except all
funion(x, y)                # union
funion(x, y, all=TRUE)      # union all
fsetequal(x, y)             # setequal
```

## Set by reference

```r
# Set names by name
setnames(dt, "old", "new")
setnames(dt, c("old1","old2"), c("new1", "new2"))

# Set names by position
setnames(dt, 3, "C")
setnames(dt, 3:4, c("new1", "new2"))

# Replace all
setnames(dt, c("a","b","c")) 

# Rearranging the rows of a data.table. By a asc, by b desc
setorder(dt, a, -b)

# Rearranging the columns of a data.table
setcolorder(dt, c("C", "A", "B"))
```

## Shift vectors

```r
dt <- data.table(mtcars)[, .(mpg, cyl)]
dt[, mpg_lag1 := shift(mpg, 1)]
dt[, mpg_forward1 := shift(mpg, 1, type = 'lead')]
head(dt)
```
(from http://brooksandrew.github.io/simpleblog/articles/advanced-data-table/)

## Copy data.table

If you want to create a `copy`, then you have to explicitly mention it using `copy` command.

```r
DT <- data.table(x = 1:5, y= 6:10)
# assign DT2 to DT
DT2 <- DT # assign by reference, no copy taken.
DT2[, z := 11:15]
# DT will also have the z column

DT2 <- copy(DT) # copied content to DT2
DT2[, z := 11:15] # only DT2 is affected
```

(from https://stackoverflow.com/questions/15913417/why-does-data-table-update-namesdt-by-reference-even-if-i-assign-to-another-v)

## Summarize multiple columns efficiently

```r
dt[, lapply(.SD, sum, na.rm=TRUE), by=category ]
#  For specific columns (.SDcols also allows reordering of the columns)
dt[, lapply(.SD, sum, na.rm=TRUE), by=category, .SDcols=c("a", "c", "z") ] 
```

(from https://stackoverflow.com/questions/16513827/summarizing-multiple-columns-with-data-table)

# 5. Import and export data

## Import data

```r
df <- data.table::fread(file.csv, sep = ";", dec = ".", data.table = TRUE, showProgress = TRUE)
```

## Export data

```r
data.table::fwrite(df, mypath, sep = ";", dec = ".", showProgress = TRUE)
```

Some parts were extracted from a [cheat sheet](https://raw.githubusercontent.com/rstudio/cheatsheets/master/datatable.pdf) by Erik Petrovski ([CC BY SA](https://creativecommons.org/licenses/by-sa/4.0/), www.petrovski.dk)

* Great data table cheat sheet: https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf
* Another great data.table intro: https://atrebas.github.io/post/2020-06-17-datatable-introduction/
