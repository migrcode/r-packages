# ---- Packages ----
library(data.table)
library(ggplot2)
library(lubridate)
library(scales)

set.seed(42)

# ---- 1) Simulate data: ~8 weeks at 15-minute resolution ----
start <- floor_date(Sys.time(), "week", week_start = 1) - weeks(8)
end   <- floor_date(Sys.time(), "week", week_start = 1) + days(7) - seconds(1)

dt <- data.table(ts = seq(from = start, to = end, by = "15 mins"))

# Diurnal + weekday pattern + noise/spikes
tod  <- as.numeric(dt$ts - floor_date(dt$ts, "day"), units = "hours")
wday <- lubridate::wday(dt$ts, week_start = 1) # 1=Mon
base_day  <- 105 + 15*sin(2*pi*(tod-4)/24)
wk_mod    <- c(0, 2, 3, 4, 1, -3, -5)[wday]
noise     <- rnorm(nrow(dt), sd = 6)
events    <- rbinom(nrow(dt), 1, 0.01)
event_eff <- events * sample(c(-35,-25,25,35), nrow(dt), TRUE)
dt[, value := pmax(60, base_day + wk_mod + noise + event_eff)]

# ---- 2) Choose the last 3 full weeks ----
dt[, week_start := floor_date(ts, "week", week_start = 1)]
sel_weeks <- sort(unique(dt$week_start), decreasing = TRUE)[1:3]
sel_weeks <- sort(sel_weeks)  # chronological order

# Data to plot
plotdt <- dt[week_start %in% sel_weeks]
plotdt[, facet_lab := paste0("Week of ", format(week_start, "%d %b %Y"))]

# ---- 3) GLOBAL corridor (25–75 across ALL data, no weekday/time dependence) ----
p25_all <- quantile(dt$value, 0.25, na.rm = TRUE)
p75_all <- quantile(dt$value, 0.75, na.rm = TRUE)
plotdt[, `:=`(p25_all = p25_all, p75_all = p75_all)]

# ---- 4) Plot: 3 stacked panels with soft green global corridor ----
soft_green <- "#CDECCD"

ggplot(plotdt, aes(x = ts)) +
  geom_ribbon(aes(ymin = p25_all, ymax = p75_all), fill = soft_green, alpha = 0.9) +
  geom_line(aes(y = value), linewidth = 0.6, color = "#2C6EBE") +
  facet_wrap(~ facet_lab, ncol = 1, scales = "free_x", strip.position = "left") +
  scale_x_datetime(breaks = date_breaks("1 day"),
                   labels = date_format("%a"),
                   expand = expansion(mult = c(0.005, 0.02))) +
  labs(
    title = "Three Weekly Profiles with Global Optimal Corridor (25–75%)",
    x = NULL, y = "Quantity"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_blank(),
    strip.placement  = "outside",
    strip.text       = element_text(face = "bold", hjust = 0),
    plot.title       = element_text(face = "bold", size = 14),
    plot.margin      = margin(10, 14, 10, 14)
  )
