# Creating a logfile for a script

This is a simple example of a logfile.

### script.R
```R
#!/usr/bin/env Rscript
# Create/Read Logfile
log <- file("logfile.log", open = "a")
cat(paste0("[",format(Sys.time(), usetz = TRUE),"]", " ", "START"), file = log, sep="\n")
cat(paste0("[",format(Sys.time(), usetz = TRUE),"]", " ", "USER: ", Sys.getenv("USERNAME")), file = log, sep="\n")

# Run some example code
library(data.table)
data <- as.data.table(mtcars)
fwrite(data,file.path(".../test.csv"))

cat(paste0("[",format(Sys.time(), usetz = TRUE),"]", " ", "END"), file = log, sep="\n")
close(log)
```

### run.bat
```
"C:\Program Files\R\R-4.0.2\bin\R.exe" CMD BATCH --no-save --no-timing --no-restore --slave C:\...\script.R NUL
```
