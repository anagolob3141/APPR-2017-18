# 2. faza: Uvoz podatkov

# Vsi podatki so zajeti iz spletnih strani oblike: 
# http://www.xe.com/currencytables/?from=USD&date= (datumi so različni)

library(dplyr)
library(rvest)

# Funkcija ki sprejme vektor s podatki o valutnih tečajih za posamezen dan,
# ter ga ustrezno preoblikuje v tabelo.
UstvariTabelo <- function(podatki, datum){
  dolzina <- length(podatki)
  kratice <- podatki[seq(1, dolzina, 4)]
  valute <- podatki[seq(2, dolzina, 4)]
  tecajNakupni <- podatki[seq(3, dolzina, 4)]
  tecajProdajni <- podatki[seq(4, dolzina, 4)]
  datumi <- rep(datum, dolzina/4)
  tabela <- cbind(datumi, kratice, valute, tecajNakupni, tecajProdajni)
  return(tabela)
} 

# Funkcija, ki iz spletne strani uvozi podatke za vse vhodne datume, ter jih preoblikuje v ustrezno tabelo.
uvoziPodatke <- function(datumi){
  tabela <- data.frame(Characters=character(),
                       Characters=character(),
                       Characters=character(),
                       Ints=integer(),
                       Ints=integer(),
                       stringsAsFactors=FALSE) # Ustvari prazno tabelo
  for (indeks in 1:length(datumi)){
    url <- paste("http://www.xe.com/currencytables/?from=USD&date=", datumi[indeks], sep = "")
    podatki <- html(url)
    podatki <- podatki %>% html_nodes("#historicalRateTbl td") %>% html_text()
    as.vector(podatki)
    novaTabela <- UstvariTabelo(podatki, datumi[indeks])
    tabela <- rbind(tabela, novaTabela)
  }
  return(tabela)
}


datumi <- seq(as.Date("2016-01-01"), as.Date("2016-03-01"), by="days")
tabela1 <- uvoziPodatke(datumi)
head(tabela1)

