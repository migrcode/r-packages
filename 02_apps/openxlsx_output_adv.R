# FULL UPDATED CODE: 4 sheets, same table spec/formatting, different header text + logo per sheet,
# data starts at row 7.

library(openxlsx)

#----------------------------
# 1) Spec: define columns + styling ONCE
#----------------------------
build_report_spec <- function() {
  cols <- data.frame(
    key    = c("store_id", "product_id", "date",
               "forecast", "sales", "stock",
               "coverage_days", "risk_flag", "comment"),
    header = c("Store", "Product", "Date",
               "Forecast", "Sales", "Stock",
               "Coverage (Days)", "Risk", "Comment"),
    width  = c(10, 14, 12,
               12, 10, 10,
               16, 8, 30),
    fmt    = c("text", "text", "date",
               "num0", "num0", "num0",
               "num1", "text", "text"),
    stringsAsFactors = FALSE
  )
  
  num_formats <- list(
    text = NULL,
    date = "yyyy-mm-dd",
    num0 = "#,##0",
    num1 = "#,##0.0"
  )
  
  column_fills <- list(
    id_cols   = list(keys = c("store_id", "product_id"), fill = "#D9E1F2"),
    risk_cols = list(keys = c("coverage_days", "risk_flag"), fill = "#FCE4D6")
  )
  
  # Conditional formatting rules (multi-column via expression).
  # Use placeholders -> replaced with $<COL><first_data_row>
  cf_rules <- list(
    list(
      name        = "Critical: no stock & low coverage",
      target_keys = c("coverage_days", "risk_flag"),
      type        = "expression",
      formula_tpl = "AND({COV}<3,{STOCK}=0)",
      style       = list(fgFill = "#FFC7CE")  # red-ish
    ),
    list(
      name        = "Warning: forecast>sales & low stock",
      target_keys = c("forecast", "stock"),
      type        = "expression",
      formula_tpl = "AND({FORECAST}>{SALES},{STOCK}<5)",
      style       = list(fgFill = "#FFEB9C")  # yellow-ish
    )
  )
  
  list(
    cols         = cols,
    num_formats  = num_formats,
    column_fills = column_fills,
    cf_rules     = cf_rules
  )
}

#----------------------------
# 2) Helpers
#----------------------------
excel_col_letter <- function(n) {
  letters_vec <- LETTERS
  out <- character(length(n))
  for (i in seq_along(n)) {
    x <- n[i]
    s <- ""
    while (x > 0) {
      r <- (x - 1) %% 26
      s <- paste0(letters_vec[r + 1], s)
      x <- (x - 1) %/% 26
    }
    out[i] <- s
  }
  out
}

standardise_data <- function(df, spec_cols) {
  missing <- setdiff(spec_cols$key, names(df))
  if (length(missing) > 0) {
    for (m in missing) df[[m]] <- NA
  }
  df <- df[spec_cols$key]
  df
}

#----------------------------
# 3) Header: per-sheet title + optional logo
#----------------------------
add_report_header <- function(wb, sheet, title, logo_path = NULL) {
  
  # Make row 1 a bit taller so a small logo is readable but still "cell-like"
  setRowHeights(wb, sheet, rows = 1, heights = 22)
  
  # --- Logo anchored at A1, small (fits roughly in a standard cell) ---
  if (!is.null(logo_path) && file.exists(logo_path)) {
    insertImage(
      wb, sheet,
      file = logo_path,
      startRow = 1, startCol = 1,     # A1
      width = 0.30, height = 0.30,    # inches ~ small icon size
      units = "in"
    )
  }
  
  # --- Title starts in column 2 (B1), spans a few columns on row 1 ---
  # Adjust the merge span as you like; this keeps it compact and clean.
  mergeCells(wb, sheet, cols = 2:10, rows = 1:1)
  
  title_style <- createStyle(
    fontSize = 14,
    textDecoration = "bold",
    halign = "left",
    valign = "center",
    wrapText = FALSE
  )
  
  writeData(wb, sheet, title, startRow = 1, startCol = 2)  # B1
  addStyle(wb, sheet, title_style, rows = 1, cols = 2:10, gridExpand = TRUE, stack = TRUE)
  
  # Optional generated line (still above your table at row 7)
  subtitle_style <- createStyle(fontSize = 10, fontColour = "#666666")
  mergeCells(wb, sheet, cols = 2:10, rows = 2:2)
  writeData(wb, sheet, paste("Generated:", Sys.Date()), startRow = 2, startCol = 2)
  addStyle(wb, sheet, subtitle_style, rows = 2, cols = 2:10, gridExpand = TRUE, stack = TRUE)
  
  # Keep rows 3–6 as spacing so your table can start at row 7
  setRowHeights(wb, sheet, rows = 3:6, heights = c(8, 8, 8, 8))
}


#----------------------------
# 4) Writer: applies spec to one existing sheet
#    (IMPORTANT: does NOT call addWorksheet)
#----------------------------
write_sheet <- function(wb, sheet, df, spec,
                        start_row = 7, start_col = 1,
                        with_filters = TRUE, freeze_row = 1) {
  
  cols <- spec$cols
  df_std <- standardise_data(df, cols)
  
  # Use display headers for writing
  colnames(df_std) <- cols$header
  
  writeData(
    wb, sheet,
    x = df_std,
    startRow = start_row,
    startCol = start_col,
    withFilter = with_filters
  )
  
  n_rows <- nrow(df_std)
  n_cols <- ncol(df_std)
  
  # Freeze pane below header row of the table
  if (!is.null(freeze_row) && freeze_row > 0) {
    freezePane(wb, sheet,
               firstActiveRow = start_row + freeze_row,
               firstActiveCol = start_col)
  }
  
  # Column widths
  setColWidths(wb, sheet, cols = start_col:(start_col + n_cols - 1), widths = cols$width)
  
  # Header row style (table header at start_row)
  headerStyle <- createStyle(
    textDecoration = "bold",
    fgFill = "#1F4E79",
    fontColour = "#FFFFFF",
    halign = "center",
    valign = "center",
    wrapText = TRUE
  )
  addStyle(
    wb, sheet, headerStyle,
    rows = start_row,
    cols = start_col:(start_col + n_cols - 1),
    gridExpand = TRUE, stack = TRUE
  )
  setRowHeights(wb, sheet, rows = start_row, heights = 22)
  
  # Body style
  if (n_rows > 0) {
    bodyStyle <- createStyle(
      valign = "center",
      border = "TopBottomLeftRight",
      borderColour = "#D9D9D9"
    )
    addStyle(
      wb, sheet, bodyStyle,
      rows = (start_row + 1):(start_row + n_rows),
      cols = start_col:(start_col + n_cols - 1),
      gridExpand = TRUE, stack = TRUE
    )
  }
  
  # Formats per column
  key_to_pos <- setNames(seq_len(n_cols), spec$cols$key)
  pos_to_excel <- excel_col_letter(start_col + (seq_len(n_cols) - 1))
  
  if (n_rows > 0) {
    for (i in seq_len(n_cols)) {
      fmt_key <- spec$cols$fmt[i]
      fmt <- spec$num_formats[[fmt_key]]
      if (!is.null(fmt)) {
        style <- createStyle(numFmt = fmt)
        addStyle(
          wb, sheet, style,
          rows = (start_row + 1):(start_row + n_rows),
          cols = start_col + (i - 1),
          gridExpand = TRUE, stack = TRUE
        )
      }
    }
  }
  
  # Column background fills
  if (n_rows > 0) {
    for (grp in spec$column_fills) {
      keys <- grp$keys
      fill <- grp$fill
      cols_idx <- key_to_pos[keys]
      cols_idx <- cols_idx[!is.na(cols_idx)]
      if (length(cols_idx)) {
        fillStyle <- createStyle(fgFill = fill)
        addStyle(
          wb, sheet, fillStyle,
          rows = (start_row + 1):(start_row + n_rows),
          cols = start_col + (cols_idx - 1),
          gridExpand = TRUE, stack = TRUE
        )
      }
    }
  }
  
  # Conditional formatting rules (multi-column expression)
  if (n_rows > 0) {
    # Map spec keys -> excel letters for this sheet
    key_to_letter <- setNames(pos_to_excel, spec$cols$key)
    
    # First data row number (not header)
    first_data_row <- start_row + 1
    
    placeholder_map <- list(
      "{COV}"      = paste0("$", key_to_letter[["coverage_days"]], first_data_row),
      "{STOCK}"    = paste0("$", key_to_letter[["stock"]],        first_data_row),
      "{FORECAST}" = paste0("$", key_to_letter[["forecast"]],     first_data_row),
      "{SALES}"    = paste0("$", key_to_letter[["sales"]],        first_data_row)
    )
    
    for (rule in spec$cf_rules) {
      target_keys <- rule$target_keys
      target_pos <- key_to_pos[target_keys]
      target_pos <- target_pos[!is.na(target_pos)]
      if (!length(target_pos)) next
      
      formula <- rule$formula_tpl
      for (ph in names(placeholder_map)) {
        formula <- gsub(ph, placeholder_map[[ph]], formula, fixed = TRUE)
      }
      
      cfStyle <- do.call(createStyle, rule$style)
      
      conditionalFormatting(
        wb, sheet,
        cols  = start_col + (target_pos - 1),
        rows  = (start_row + 1):(start_row + n_rows),
        rule  = formula,
        type  = rule$type,
        style = cfStyle
      )
    }
  }
  
  invisible(NULL)
}

#----------------------------
# 5) Workbook writer: 4 sheets, different headers/logos, same table format
#----------------------------
write_report_xlsx <- function(path, sheets, start_row = 7) {
  # sheets: list of list(name, data, header=list(title, logo))
  spec <- build_report_spec()
  wb <- createWorkbook()
  
  for (s in sheets) {
    addWorksheet(wb, s$name)
    
    add_report_header(
      wb, s$name,
      title = s$header$title,
      logo_path = s$header$logo
    )
    
    write_sheet(
      wb, s$name,
      df = s$data,
      spec = spec,
      start_row = start_row
    )
  }
  
  saveWorkbook(wb, path, overwrite = TRUE)
  invisible(path)
}

#----------------------------
# 6) SIMPLE TEST DATA + RUN
#----------------------------
set.seed(1)
make_df <- function(n) {
  data.frame(
    store_id      = paste0("S", sample(1:5, n, TRUE)),
    product_id    = paste0("P", sample(1:10, n, TRUE)),
    date          = as.Date("2026-01-01") + sample(0:10, n, TRUE),
    forecast      = sample(0:20, n, TRUE),
    sales         = sample(0:20, n, TRUE),
    stock         = sample(0:10, n, TRUE),
    coverage_days = round(runif(n, 0, 10), 1),
    risk_flag     = ifelse(runif(n) < 0.3, "RISK", "OK"),
    comment       = sample(c("promo", "normal", "overstock"), n, TRUE),
    stringsAsFactors = FALSE
  )
}

df_a <- make_df(25)
df_b <- make_df(25)
df_c <- make_df(25)
df_d <- make_df(25)

downloads <- file.path(Sys.getenv("HOME"), "Downloads")
out_file  <- file.path(downloads, "test_report.xlsx")

sheets <- list(
  list(
    name = "North",
    data = df_a,
    header = list(
      title = "North Region – Coverage & Risk",
      logo  = file.path(downloads, "logo_north.png")  # replace or set NULL
    )
  ),
  list(
    name = "South",
    data = df_b,
    header = list(
      title = "South Region – Coverage & Risk",
      logo  = file.path(downloads, "logo_south.png")
    )
  ),
  list(
    name = "East",
    data = df_c,
    header = list(
      title = "East Region – Coverage & Risk",
      logo  = file.path(downloads, "logo_east.png")
    )
  ),
  list(
    name = "West",
    data = df_d,
    header = list(
      title = "West Region – Coverage & Risk",
      logo  = file.path(downloads, "logo_west.png")
    )
  )
)

# If you don't have logos yet, set them to NULL quickly:
# for (i in seq_along(sheets)) sheets[[i]]$header$logo <- NULL

write_report_xlsx(out_file, sheets, start_row = 7)

message("Wrote: ", out_file)
