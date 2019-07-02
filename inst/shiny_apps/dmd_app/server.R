#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dmdScheme)

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {

    #
    output$scheme <- renderText(
      {
        if (require(input$scheme, character.only = TRUE)) {
          succ <- "loaded successful"
        } else {
          succ <- "loading failed"
        }
        paste("Scheme ", input$scheme, succ)
      }
    )

    observeEvent(
      eventExpr = input$open,
      handlerExpr = {
        open_new_spreadsheet( schemeName = input$scheme )
      }
    )

    observeEvent(
      eventExpr = input$validate,
      handlerExpr = {
        report( x = input$spreadsheet$datapath )
      }
    )

    observeEvent(
      eventExpr = input$export,
      handlerExpr = {
        x <- dmdScheme_to_xml( x = input$spreadsheet$datapath )
        output$text <- renderPrint(x)
      }
    )

  }
)