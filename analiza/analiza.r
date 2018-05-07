# 4. faza: Analiza podatkov

# Računanje standardnega odklona od povprečja:
urejeni.odkloni <- tecaji %>%
  filter(tip == "nakupni") %>%
  group_by(kratica) %>% summarise(povprecje = mean(tecaj), odklon = sd(tecaj)/mean(tecaj)) %>%
  arrange(odklon)
colnames(urejeni.odkloni) <- c("valuta", "povprecje", "normiran.odklon")


odkloni.po.skupinah <- merge(x=urejeni.odkloni, y=valute.po.skupinah, by="valuta")
odkloni.po.skupinah$skupina[is.na(odkloni.po.skupinah$skupin)] <- "druge"
odkloni.po.skupinah <- merge(x=odkloni.po.skupinah, y=imena.valut, by.x="valuta", by.y="variable" )
odkloni.po.skupinah$valuta <- factor(odkloni.po.skupinah$valuta,
                                     levels = unique(odkloni.po.skupinah$valuta)[order(odkloni.po.skupinah$normiran.odklon, decreasing = TRUE)])


odkloni.po.skupinah <- merge(x=odkloni.po.skupinah, y=imena.valut, by.x="valuta", by.y="variable")
odkloni.po.skupinah <- odkloni.po.skupinah[,c(1,2,3,5,4)]


# GRAF SE NAHAJA V SHINY APLIKACIJI
# odkloni <- plot_ly() %>%
#   add_trace(data=odkloni.po.skupinah, x= ~valuta, y= ~normiran.odklon ,name= ~ime.x, color = ~skupina,
#             type = "bar") %>%
#   layout(title = "Nihanje valut", 
#          xaxis = list(title = "Valute"),
#          yaxis = list (title = "Standardni odklon / povprčna višina tečaja)"),
#          showlegend = FALSE
#   )
# povprecje <- plot_ly() %>%
#   add_trace(data=odkloni.po.skupinah, x= ~valuta, y= ~povprecje ,name= ~ime.x, color = ~skupina,
#             type = "bar") %>%
#   layout(title = "Nihanje valut", 
#          xaxis = list(title = "Valute"),
#          yaxis = list (title = "Povprečna višna tečajev"),
#          showlegend = FALSE
#   )
# 
# povprecje



