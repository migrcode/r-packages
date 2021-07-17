path_data <- ""


# Defining a function
getFiles <- function(myFiles) {
  
  for(currFile in myFiles) {
    if(currFile == "data1") {
      load(file.path(path_data, "data1.RData"), envir = .GlobalEnv)
    }
    
    else if(currFile == "data2") {
      load(file.path(path_data, "data2.RData"), envir = .GlobalEnv)
    }
    
    else if(currFile == "data3") {
      load(file.path(path_data, "data3.RData"), envir = .GlobalEnv)
    }
  }
}

# Applying the function
getFiles(c("data1", "data2", "data3"))
