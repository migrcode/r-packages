# Calculate Mean Absolute Deviation using a for loop

x <- c(3,2,3,6,2)
Storage <- x

for (i in 1:length(Storage)) {
  Storage[i] <- abs(Storage[i]- mean(x))
}
Storage
sum(Storage)/length(Storage)
