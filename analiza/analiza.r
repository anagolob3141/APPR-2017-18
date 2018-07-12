# 4. faza: Analiza podatkov
source("lib/libraries.r", encoding = "UTF-8")
source("uvoz/uvoz.r", encoding = "UTF-8")
source("vizualizacija/vizualizacija.r", encoding = "UTF-8")
library(animation)

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
tecajiSPovprecjem <- subset(tecajiSPovprecjem, tecajiSPovprecjem$tip == "nakupni")
datumiPoMesecih <- seq(as.Date("1998-01-01"), as.Date("2018-01-01"), by="quarter")
tecajiSPovprecjem <- subset(tecajiSPovprecjem, tecajiSPovprecjem$datum %in% datumiPoMesecih)

for (i in 1:nrow(tecajiSPovprecjem)){
  if (tecajiSPovprecjem[i, 6] < 1.7){
    tecajiSPovprecjem[i, 4] <- "majhen"
  } else if (tecajiSPovprecjem[i, 6] < 4){
    tecajiSPovprecjem[i, 4] <- "sreden"
  } else {
    tecajiSPovprecjem[i, 4] <- "velik"
  }
}

#View(tecajiSPovprecjem)
tecajiSPovprecjem <- tecajiSPovprecjem[order(tecajiSPovprecjem$datum,decreasing = FALSE),]

# Graf amočikacije gibanja tečajev v času: NI VKLJUČEN V POROČILO
gibanjaTecajev <- ggplot(tecajiSPovprecjem, aes(x= kratica, y= tecaj, frame = datum, color=kratica, label=kratica)) +
  ggtitle("Gibanje valutnih tečajev") +
  xlab("Povprečna višina tečaja") + 
  ylab("Visina tecaja glede na čas") +
  theme(legend.position="none") +
  geom_path(aes(group = tip)) +
  facet_wrap(~tip)

#gganimate(gibanjaTecajev, interval=0.3, "output.html")

# Podatki za tecaj EUR/USD:

EUR_USD <- subset(tecaji.valut, variable %in% "EUR")
EUR_USD <- EUR_USD[, c(2,3)]

firstDiff <- function(data){
  data$df <- data[,2]
  for (i in (1:(length(data[ ,2]) - 1))){
    data[i, 3] <- data[i + 1, 2] - data[i, 2]
  }
  return (data)
}

EUR_USD <- firstDiff(EUR_USD)

#Ocenjevanje parametrov za model Ornstein-Uhlnbeck po Ergodic Estimation:
n <- dim(EUR_USD)[1]

theta <- mean(EUR_USD$value)
sigma <- sd(EUR_USD$df)

stevec <- 0
imenovalec <- 0

for (i in 2:n) {
  stevec <- stevec + (EUR_USD$value[i] - EUR_USD$value[i-1])^2
  imenovalec <- imenovalec + (EUR_USD$value[i] - theta)^2 
}

alpha <- stevec / (2*imenovalec) * 12


# IZRISOVANJE SIMULACIJE:
library(ESGtoolkit)
x <- simdiff(n = 15, horizon = 3, frequency = "monthly", model = "OU", 
             x0 = EUR_USD[1,2], theta1 = alpha*theta, 
             theta2 = alpha, theta3 = sigma)

x <- data.frame(x)
x$date <- EUR_USD$datumi[1:nrow(x)]
x$podatki <- EUR_USD[1:nrow(x),2]

meltdf <- melt(x,id="date")

# Naredimo 200 simulacij, na katerih bomo pogledali 90% interval zaupanja
y <- simdiff(n = 200, horizon = 3, frequency = "monthly", model = "OU", 
             x0 = EUR_USD[nrow(EUR_USD),2], theta1 = alpha*theta, 
             theta2 = alpha, theta3 = sigma)
