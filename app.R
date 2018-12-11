#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Titanic"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         radioButtons("variable",
                      "Choose variable to display",
                      choices = c("Class", "Sex", "Age")),
        radioButtons("variable2",
                     "Choose second variable to display",
                     choices = c("None", "Class", "Sex", "Age")),
        radioButtons("position",
                     "Choose position adjustment",
                     choices = c("dodge", "stack"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        p("Which people were able to survive when the Titanic sank?"),
        p("This page allows you to explore that question. By clicking the buttons on the left, 
          you can select which variables will be plotted and in which way."),
        plotOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     data("Titanic")

     titanic <- as_tibble(Titanic)
     
     plot <- titanic %>%
       ggplot() + geom_col(aes_string(x = input$variable, y = "n", fill = "Survived"),
                           position = input$position)
     
     if(input$variable2 != "None")
       plot <- plot + facet_wrap(vars(!!as.name(input$variable2)))
     
     plot
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

