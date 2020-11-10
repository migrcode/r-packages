# Applying function to all columns in a list of data frames
`purrr::map(mylist, ~as.character(.$mpg))`
`purrr::map(mylist, ~mean(.$mpg))`


