# --- Packages ----------------------------------------------------------------
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(lubridate)
})

# --- 1) Generate synthetic monthly unemployment data -------------------------
set.seed(42)

yrs <- 1948:2015  # match the example span
df <- expand.grid(year = yrs, month = 1:12) %>%
  mutate(
    date = as.Date(sprintf("%d-%02d-01", year, month)),
    t    = as.numeric((year - min(yrs)) * 12 + month),
    
    # Smooth long-cycle waves + business-cycle waves + mild seasonality
    long_wave  = 1.8 * sin(2*pi*t/360),
    biz_cycle  = 1.2 * sin(2*pi*t/120 + 0.8),
    seasonal   = 0.35 * cos(2*pi*(month-1)/12),
    
    # Random noise (smoothed a bit)
    noise_raw  = rnorm(n(), 0, 0.5),
    noise      = stats::filter(noise_raw, rep(1/3,3), sides = 2),
    
    base       = 5,  # center around 5%
    rate       = base + long_wave + biz_cycle + seasonal + noise,
    rate       = as.numeric(rate),
    
    # Clamp for palette like WSJ legend
    rate_clamped = pmin(pmax(rate, 2), 11),
    
    # For faceted y-axis like the WSJ chart (Jan at the top)
    mon_lab = factor(month.abb[month], levels = rev(month.abb))
  )

# --- 2) Recession months (hard-coded NBER-style ranges) ----------------------
rec_ranges <- list(
  c("1948-11-01","1949-10-01"), c("1953-07-01","1954-05-01"),
  c("1957-08-01","1958-04-01"), c("1960-04-01","1961-02-01"),
  c("1969-12-01","1970-11-01"), c("1973-11-01","1975-03-01"),
  c("1980-01-01","1980-07-01"), c("1981-07-01","1982-11-01"),
  c("1990-07-01","1991-03-01"), c("2001-03-01","2001-11-01"),
  c("2007-12-01","2009-06-01")
)

rec_df <- do.call(rbind, lapply(rec_ranges, function(r) {
  data.frame(date = seq(as.Date(r[1]), as.Date(r[2]), by = "month"))
})) %>%
  mutate(year = year(date), month = month(date),
         mon_lab = factor(month.abb[month], levels = rev(month.abb)),
         rec = 1L) %>%
  filter(year %in% yrs)

# --- 3) Colors & theme -------------------------------------------------------
pal <- c("#6FB6A9","#84C1B6","#A3CDC4","#C4D9D4","#E2E7E4",
         "#E7D9D9","#DFAEAE","#D27E7E","#C35353","#AC2F2F","#8F1A1A")

wsj_theme <- theme_minimal(base_size = 11) +
  theme(
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text.y = element_text(size = 9),
    axis.text.x = element_text(size = 7, angle = 60, hjust = 1, vjust = 1),
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 10),
    plot.caption = element_text(size = 8, colour = "grey40"),
    legend.position = "top",
    legend.justification = c(0, 0.5),
    legend.direction = "horizontal"
  )

# --- 4) Plot ------------------------------------------------------------------
g <- ggplot(df, aes(x = year, y = mon_lab, fill = rate_clamped)) +
  geom_tile(width = 0.98, height = 0.98) +
  # soft recession overlay
  geom_tile(data = rec_df, aes(x = year, y = mon_lab),
            inherit.aes = FALSE, width = 0.98, height = 0.98, alpha = 0.08) +
  scale_x_continuous(breaks = seq(min(yrs) + 2, max(yrs), by = 5), expand = c(0,0)) +
  scale_fill_stepsn(
    colours = pal, breaks = 2:11, limits = c(2,11),
    labels = 2:11, name = "Jobless rate (%)"
  ) +
  labs(
    title = "Unemployment: A Historical View",
    subtitle = "Synthetic monthly data (Jan at top)",
    caption = "Self-generated series; recessions approximate ranges."
  ) +
  wsj_theme

print(g)

# --- (Optional) Tiny white markers: min month per year -----------------------
# mins <- df %>% group_by(year) %>% slice_min(rate, n = 1, with_ties = FALSE)
# g + geom_point(data = mins, aes(x = year, y = mon_lab),
#                shape = 22, fill = "white", size = 1.2, colour = "white")
