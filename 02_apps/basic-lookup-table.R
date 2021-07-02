# The idea here is to use a lookup table to update a data table. 
# In the lookup table, a value_new may be defined on group or id level. 
# If a value_new is defined on the more granular id level, it should 
# always be used instead of a possibly defined value_new on group level.
# In case a value_new on id level is not defined, the value_new on group 
# level should be used.

library(data.table)

lookup <-
  data.table(group = c("1001", NA_character_, NA_character_, NA_character_),
             id = c(NA_integer_, 101, 102, 103),
             value_new = c(3, 4, 1, 2))

data <-
  data.table(group = c("1001", "1001", "1002", "1003"),
             id = c(100, 101, 102, 103),
             value = c(2, 1, 9, 8))

# Merge (Step 1)
final_analysis <- merge(data, lookup[, !c("id")], by = "group", all.x = TRUE)
setnames(final_analysis, old = c("value_new"), new = c("value_new_h_group"))

# Merge (Step 2)
final_analysis <- merge(final_analysis, lookup[, !c("group")], by = "id", all.x = TRUE)
setnames(final_analysis, old = c("value_new"), new = c("value_new_h_id"))

# If no value on id level is defined, use value on group level
# If a value on id level is defined, always use the value on id level
final_analysis[, value_new := fcase(
    is.na(value_new_h_id) & !is.na(value_new_h_group), value_new_h_group,
    is.na(value_new_h_group) & !is.na(value_new_h_id), value_new_h_id,
    !is.na(value_new_h_group) & !is.na(value_new_h_id), value_new_h_id  
)]

final <- final_analysis[, .(group, id, value, value_new)]
