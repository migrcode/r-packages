## Applying function to all columns in a list of data frames

`purrr::map(mylist, ~as.character(.$mpg))`

`purrr::map(mylist, ~mean(.$mpg))`


### Applications of keep, discard and compact

```r
mylist <- list(a = 1, b = 2, c = 3)
keep(mylist, function(x) x == 1) # version 1
keep(mylist, ~ .x == 1) # version 2
```

```r
mylist <- list(a = 1, b = 2, c = NA_integer_, d = NULL, e = 0, f = integer(0))
compact(mylist)
```

```r
mylist <- list(a = 1, b = 2, c = NA_integer_, d = list(1,2,3), e = list(2,3))
discard(mylist, grepl(1, mylist))
```
# Applications of cross2

```r
# All combinations of .x and .y
list1 <- list(a = "Mike", b = "Jenny")
list2 <- list(c = "Lars", d = "Heide")
list3 <- list(a = "Mike", b = "Jenny", c = "Lars", d = "Heide")
cross2(list1, list2)
```
