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

# Amplikacija, ki prikazuje gibanje valutnih tečajev skozi čas
tecajiSPovprecjem <- merge(x=tecaji, y=odkloni.po.skupinah[,c(1,2)], by.x="kratica", by.y="valuta")

# GRAF SE NAHAJA V DATOTEKI   projekt.rmd
# gibanjaTecajev <- ggplot(tecajiSPovprecjem, aes(x= povprecje, y= tecaj, frame = datum, color=kratica)) +
#   ggtitle("Gibanje valutnih tečajev") +
#   xlab("Povprečna višina tečaja") +
#   ylab("Visina tecaja glede na čas") +
#   theme(legend.position="none") +
#   geom_point() +
#   geom_text(data=tecajiSPovprecjem,
#             aes(x= povprecje, y= tecaj, label=kratica),
#             size = 1)
# gibanjaTecajev

#gg_animate(gibanjaTecajev)




