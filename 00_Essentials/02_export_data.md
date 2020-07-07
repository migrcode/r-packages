# Write a data frame to a .csv file

My method of choice is fwrite from the `data.table` package.

```
library(data.table)

fwrite(df, mypath, sep = ";", dec = ".", showProgress = TRUE, 
```

# Write a data frame to an .xlsx file

I prefer using the `writexl` package since unlike similar packages, this one is independent from JAVA.

```
library(writexl)

write_xlsx(df, mypath, col_names = TRUE, format_headers = TRUE)
```
