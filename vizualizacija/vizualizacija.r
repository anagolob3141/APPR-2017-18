# 3. faza: Vizualizacija podatkov
library(reshape2)
library(ggplot2)
library(readr)

# Uvoz podatkov iz CSV tatotek in njihovo združevanje:
tecaji1.tretjina2016 <- read_csv("podatki/tecaji1tretjina.csv")
tecaji2.tretjina2016 <- read_csv("podatki/tecaji2tretjina.csv")
tecaji3.tretjina2016 <- read_csv("podatki/tecaji3tretjina.csv")
tecaji <- rbind(tecaji1.tretjina2016, tecaji2.tretjina2016, tecaji3.tretjina2016)

# Podatke v tabeli grupira po posameznih valutah:
tecaji.po.valutah <- subset(tecaji, kratica=="EUR"& tip == "nakupni")[,c(3,5)]
imena <- c("datumi","EUR")
for(i in 3:nrow(imena.valut)){
  stolpec <- subset(tecaji, kratica==imena.valut[i,1] & tip == "nakupni")
  if(nrow(stolpec) == 366){
    tecaji.po.valutah <- cbind(tecaji.po.valutah, stolpec[,5])
    imena <- c(imena, imena.valut[i,1])
  }

}

colnames(tecaji.po.valutah) <- imena



# Vizualizacija podatkov:

# matplot(tecaji.po.valutah[ ,2:ncol(tecaji.po.valutah)], type = "l", lty = 1,
#         main="Nakupni tečaji po valutah", xlab = "Čas", ylab = "Višina tečajev")



tecaji.po.valutahR = melt(tecaji.po.valutah, id = "datumi")



# Podatki le za 7 valut v katerih se največ trgije:
najpomembnejse1 <- c("EUR", "GBP", "CHF", "CAD", "AUD")
najpomembnejse2 <- c("ZAR", "JPY")
najpomembnejse.valute1 <- subset(tecaji.po.valutahR, variable %in% najpomembnejse1)
najpomembnejse.valute2 <- subset(tecaji.po.valutahR, variable %in% najpomembnejse2)





# Računanje standardnega odklona od povprečja:

odkloni.povprecje <- function(tecaji.po.valutah, imena){
  odkloni <- c(round(mean(tecaji.po.valutah[,1]),4), round(sd(tecaji.po.valutah[,1],4)))
  for(i in 2:ncol(tecaji.po.valutah)){
    povprecje <- round(mean(tecaji.po.valutah[,i]),4)
    odkl <- round(sd(tecaji.po.valutah[,i]),4)
    odkloni <- rbind(odkloni, c(povprecje, odkl))
  }
  
  odkloni <- cbind(imena[1:length(imena)], odkloni)
  odkloni <- as.data.frame(odkloni)
  rownames(odkloni) <- imena[1:length(imena)]
  colnames(odkloni) <- c("valuta", "povprecje", "odklon")
  urejeni.odkloni <- odkloni[order(odkloni$odklon),]
  return(urejeni.odkloni)
}
najpomembnejse.valute <- tecaji.po.valutah[c("EUR", "GBP", "CHF", "CAD", "AUD","ZAR", "JPY")]
urejeni.odkloni <- odkloni.povprecje(najpomembnejse.valute, c("EUR", "GBP", "CHF", "CAD", "AUD","ZAR", "JPY"))

