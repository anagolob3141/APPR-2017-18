library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Valutni tečaji"),
  tabsetPanel(
      tabPanel("Časovne vrste tečajev", fluid = TRUE,
               sidebarLayout(
                 sidebarPanel(
                   sliderInput(inputId = "ymax",
                               label = "Razpon višin tečajev narisanih na grafu:",
                               min = 0,
                               max = 1800,
                               value = c(0, 1800))
                 ),
                 mainPanel(
                   plotlyOutput(outputId = "gra1"),
                   textOutput("opis1")
                 )
      )),
    
      tabPanel("Varianca in povprečna višina odklonov", fluid = TRUE,
               sidebarLayout(
                 sidebarPanel(
                   selectInput("primer", "Izberite skupino prikazanih valut:", 
                               choices = c("Valute vseh držav", "Valute v katerih se največ trguje", "Valute držav v razvoju")),
                   sliderInput(inputId = "ymax2",
                               label = "Razpon višin tečajev narisanih na grafu:",
                               min = 0,
                               max = 1800,
                               value = c(0, 1800))
                 ),
                 mainPanel(
                   plotlyOutput(outputId = "gra2"), 
                   textOutput("opis2")
                 )
    )
    )
  )
))
