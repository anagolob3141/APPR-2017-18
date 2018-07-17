library(shiny)

shinyServer(function(input, output) {
  
  output$gra1 <- renderPlotly({
    
    if (input$primer == "Valute vseh držav"){ 
      izbrane <- tecaji.valut
    } else if (input$primer == "Valute v katerih se največ trguje"){
      izbrane <- subset(tecaji.valut, skupina %in% "najvecje")
    } else {
      izbrane <- subset(tecaji.valut, skupina %in% "v razvoju")
    }
    
    plot_ly() %>%
      add_trace(data=izbrane, x= ~datumi, y= ~value,name= ~ime, color = ~variable,
                type = 'scatter', mode = 'lines') %>%
      layout(title = 'Gibanje nakupnih tečajev', 
             xaxis = list(title = "Datum",tickangle = 45, type = "date", rangeselector = list(
               buttons = list(
                 list(step = "year")
                 , list(step = "all", label = 'All')
               ))),
             yaxis = list (title = "Višina tečaja", range = input$ymax))
    
  })
  
  output$gra2 <- renderPlotly({
    
    if (input$primer == "Valute vseh držav"){ 
      izbrane <- odkloni.po.skupinah
    } else if (input$primer == "Valute v katerih se največ trguje"){
      izbrane <- subset(odkloni.po.skupinah, skupina %in% "najvecje")
    } else {
      izbrane <- subset(odkloni.po.skupinah, skupina %in% "v razvoju")
    }
     
    odkloni <- plot_ly() %>%
      add_trace(data= izbrane, x= ~ime.x, y= ~normiran.odklon, color = ~skupina, legendgroup = ~skupina
                ,type = 'bar') %>%
      layout(xaxis = list(title = "Valute", showticklabels = FALSE),
             yaxis = list(title = "")
      )
    povprecje <- plot_ly() %>%
      add_trace(data=izbrane, x= ~ime.x, y= ~povprecje , color = ~skupina,legendgroup = ~skupina,
                showlegend = F, type = 'bar') %>%
      layout(title = 'Nihanje in povprečna višina tečajev', 
             xaxis = list(title = "Valute", tickangle = 45, showticklabels = FALSE),
             yaxis = list (title = "", range = input$ymax2)
      )
    subplot(nrows = 2, shareX = TRUE, shareY = TRUE,odkloni, povprecje)  %>% 
      layout(annotations = list(list(x = 0.5 , y = 1,text = "Standardni odklon / povprčna višina tečaja", showarrow = F,xref='paper', yref='paper'),
                                list(x = 0.5 , y = 0.5,text = "Povprečna višna tečajev", showarrow = F,xref='paper', yref='paper')))
    
  })
  
  
  output$opis1 <- renderText({"Graf prikazuje gibanje tečajev za nakup 1 USD s preostalimi svetovnimi valutami."})
  output$opis2 <- renderText({"Za mero nihanja valut v obdobju od začetka leta 1998 do začetka leta 2018 
    smo uporabili standatdni odklon od povprečja in ga normirali z povprečno vrednostjo valutnih tečajev. 
    Na zemljevidu so z različnimi barvami označene valute držav v razvoju ter največje svetovne valute."})
  
})
