# The apply() - family of functions

This family consists of the following functions:
* The `apply()` functions for matrices
* The `lapply()` function for data frames, lists or vectors
* The `sapply()` function which is similar to lapply but simplifies the output


## Examples

We use `lapply()` if we want to apply a function to every element of a list and obtain a list as a result. 

```
lapply(df[, c('a')], function(x) sum(x))
```
The line above uses dataframe `df` and takes the sum of the rows of column `a`. The output is a list.

```
sapply(df[, c('a')], function(x) sum(x))
```
When using sapply, the output from above would be a vector and not a list.
