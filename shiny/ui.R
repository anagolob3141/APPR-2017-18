library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Valutni tečaji"),
  
  sidebarLayout(
    sidebarPanel(
      
      sliderInput(inputId = "ymax",
                  label = "Razpon višin tečajev narisanih na grafu:",
                  min = 0,
                  max = 1800,
                  value = c(0, 1800)),
      
      selectInput("primer", "Izberite skupino prikazanih valut:", 
                  choices = c("Valute vseh držav", "Valute v katerih se največ trguje", "Valute držav v razvoju"))
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Gibanje valutnih tečajev",plotlyOutput(outputId = "gra1"), textOutput("opis1")),
                  tabPanel("Nihanje in povprečje",plotlyOutput(outputId = "gra2"), textOutput("opis2"))
      )
    )
  )
))
