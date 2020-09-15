# PART 0: NECESSITIES -----------------------------------------------------------
library(tidyverse)
library(DT)
library(shiny)
library(readxl)


data <- read_excel("")

data$product_class = factor(data$product_class)
data$product_code <- as.factor(data$product_code)


# PART 1: SERVER -----------------------------------------------------------
server <- function(input, output) {
  
  
  output$mydata <- DT::renderDataTable(
    DT::datatable({
      data
    },
    filter = list(position = 'top', clear = FALSE),
    extensions = list('Scroller' = NULL, 
                      'KeyTable' = NULL,
                      'Buttons' = NULL),
    options = list(
      search = list(regex = TRUE, caseInsensitive = TRUE, search = ''),
      pageLength = 20,
      scrollY = 800,
      scroller = TRUE,
      keys = TRUE,
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )
  )

}



# PART 2: UI -----------------------------------------------------------
ui <- shinyUI(fluidPage(
  h2("my data"),
  DT::dataTableOutput("mydata")
  ))


# PART 3: APP -----------------------------------------------------------
shinyApp(ui = ui, server = server)
