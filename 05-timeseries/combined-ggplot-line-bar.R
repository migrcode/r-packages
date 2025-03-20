library(ggplot2)
library(data.table)


# Set seed for reproducibility
set.seed(123)

# Generate a sequence of dates
dates <- seq.Date(from = as.Date("2023-10-01"), to = as.Date("2023-12-31"), by = "day")
n <- length(dates)

# Create a function for stable time series with a slight increasing trend
generate_series <- function(start_value, trend = 0.0, noise_sd = 0.1) {
  start_value + (1:n) * trend + rnorm(n, mean = 0, sd = noise_sd)
}

# Format function for date labels
format_date <- function(dates) {
  format(dates, "%Y-%m-%d (%a)") # %a gives the abbreviated weekday
}

# Create the dataset
data <- data.table(
  date = rep(dates, times = 4),
  series = rep(c("A", "B", "C", "D", "E", "G"), each = n),
  value = c(
    generate_series(3),
    generate_series(3),
    generate_series(1),
    generate_series(5),
    sample(c(NA, NA, NA, 1, 2, 3), size = n, replace = TRUE),
    sample(c(NA, NA, NA, 1, NA, NA), size = n, replace = TRUE)
  )
)

data <- data.table::dcast(data, date ~ series, value.var = "value")


#------------------

col_red <- '#D0603C'
col_yellow <- '#E3A857'
col_green <- '#7BA982'
col_blue <- '#48769A'
col_violet <- '#8A5E83'
col_peach <- '#E17E5F'
col_black <- '#333333'
col_background <- '#F4EBDC'
col_yellow_light <- '#FFCC86'

ggplot(data) +
  geom_bar(aes(x = date, y = E, fill = "E"), stat = "identity") +
  geom_bar(aes(x = date, y = G, fill = "G"), stat = "identity") +
  geom_line(aes(x = date, y = A, color = "A"), linewidth = 1.1) +
  geom_line(aes(x = date, y = C, color = "C"), linewidth = 1.1) +
  geom_line(aes(x = date, y = D, color = "D"), linewidth = 1.1) +
  labs(title = "Visualization of various time series",
       subtitle = "Combination of line plots and bar plots using ggplot",
       caption = "Data source: John Doe (2025)",
       x = "", y = "Time Series") +
  scale_x_date(
    date_breaks = "2 days",
    labels = format_date
  ) +  
  theme_bw() +
  theme(plot.background = element_rect(fill = col_background),
        panel.background = element_rect(fill = col_background),
        legend.background = element_rect(fill = col_background),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_line(color = col_background)) +
  theme(axis.line = element_line(color = 'black')) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, family = "mono")) +
  scale_color_manual("",values = c("A" = col_black, 
                                   "C" = col_blue,
                                   "D" = col_red)) +
  scale_fill_manual("",values = c("E" = col_yellow_light, 
                                   "G" = col_yellow))
