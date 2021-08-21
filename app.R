library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")

ui <- fluidPage(
  titlePanel("censo de EE.UU. en el 2010"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Cree mapas demograficos con informacion del
               censo de EE. UU. De 2010"),
      
      selectInput("var", 
                  label = "elija una variable para mostrar el 
                  porcentaje de residentes por raza",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)