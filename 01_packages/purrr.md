## Applying function to all columns in a list of data frames

`purrr::map(mylist, ~as.character(.$mpg))`

`purrr::map(mylist, ~mean(.$mpg))`


### Applications of keep, discard and compact

```{r }
mylist <- list(a = 1, b = 2, c = 3)
keep(mylist, function(x) x == 1) # version 1
keep(mylist, ~ .x == 1) # version 2
```

