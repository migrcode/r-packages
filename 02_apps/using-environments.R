# Creating an environment
myenv <- new.env()
myenv$Param1 <- FALSE
myenv$Param2 <- "John"
myenv$Param3 <- 200

# List the parameters in an environment
ls(myenv)

# Extracting values
myenv$Param3
myenv[["Param1"]]
get("Param2", envir = myenv)

# Delete objects from an environment
rm("Param1", envir = myenv)


