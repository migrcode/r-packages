 # Loading data from .csv files
 
If data are available as comma separated text files (.csv), the `data.table` package is typically the fastest option:

```
library(data.table)

df <- fread(file.csv, sep = ";", dec = ".", data.table = TRUE, showProgress = TRUE)
```

For further options, see https://www.rdocumentation.org/packages/data.table/versions/1.12.8/topics/fread.

# Loading data from .xlsx files

If data are available as .xlsx files, I prefer using the `readxl` package since it does not depend on JAVA.

```
library(readxl)

df <- read_excel(file.xlsx, sheet = 1)
```
For further options, see https://www.rdocumentation.org/packages/readxl/versions/1.3.1.
