# 2. faza: Uvoz in čiščenje podatkov

# Vsi podatki so zajeti iz spletnih strani oblike: 
# http://www.xe.com/currencytables/?from=USD&date= (datumi so različni)
# ter iz Wikipedije
# https://en.wikipedia.org/wiki/List_of_circulating_currencies

# 1. Funkcija, ki uvozi podatke o valutnih tečajki za vhodne datume in jih zapiše v tabelo.
uvoziPodatke <- function(datumi){
  lapply(datumi, function(datum) {
    paste0("http://www.xe.com/currencytables/?from=USD&date=", datum) %>% html_session() %>%
      read_html() %>% html_nodes(xpath="//table[@id='historicalRateTbl']") %>% .[[1]] %>%
      html_table() %>% mutate(datum = datum)
  }) %>% bind_rows()
}

#   Funkcija za urejanje tabele, njeno preoblikovanje v tidy data in shranjevanje v CSV-datoteko.
uredi.tabelo <- function(tabela, ime.datoteke){
  names(tabela) <- c("kratica", "ime", "nakupni", "prodajni", "datum")
  tecaji <- melt(tabela[, -2], measure.vars = c("nakupni", "prodajni"),
                       variable.name = "tip", value.name = "tecaj")
  write.csv(tecaji, file = ime.datoteke)
}

tabela.za.kratice <- uvoziPodatke("2016-01-01")
names(tabela.za.kratice) <- c("kratica", "ime", "nakupni", "prodajni", "datum")
imena.valut <- tabela.za.kratice[, 1:2] %>% unique()

# Če datoteka s podatki še ne obstaja, jo ustvarimo:
if (!file.exists("podatki/tecajiPoMesecih.csv")){
  datumiPoMesecih <- seq(as.Date("1998-01-01"), as.Date("2018-01-01"), by="months")
  tabela1.tecajiPoMesecih <- uvoziPodatke(datumiPoMesecih)
  uredi.tabelo(tabela1.tecajiPoMesecih, "podatki/tecajiPoMesecih.csv")
}

#######################################################################################################

# 2. Uvoz podatkov o tem katere valute uporabljajo v posameznih državah:
url <- "https://en.wikipedia.org/wiki/List_of_circulating_currencies"
stran <- html_session(url) %>% read_html()
tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table(fill = TRUE)
valute.po.drzavah <- tabela[,c(1,4)]
names(valute.po.drzavah) <- c("drzava", "valuta")

# Urejanje tabele:
valute.po.drzavah <- subset(valute.po.drzavah, valuta != "(none)")

valute.po.drzavah$valuta <- gsub("\\[G|\\]","",valute.po.drzavah$valuta)
valute.po.drzavah$drzava <- gsub("\\[.|\\]","",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Bahamas, The","The Bahamas",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Congo, Democratic Republic of the","Democratic Republic of the Congo",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Congo, Republic of the","Republic of the Congo",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Korea, North","North Korea",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Korea, South","South Korea",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Macedonia, Republic of","Republic of Macedonia",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("Korea, North","North Korea",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("United States","USA",valute.po.drzavah$drzava)
valute.po.drzavah$drzava <- gsub("United Kingdom","UK",valute.po.drzavah$drzava)

#######################################################################################################
#2. Uvoz seznama drzav v razvoju po International Monetary "Fund's World Economic Outlook Report, April 2015"
#Podatki so uvoženi iz spletne strani: https://en.wikipedia.org/wiki/Developing_country

url2 <- html("https://en.wikipedia.org/wiki/Developing_country")
v.razvoju <- url2 %>% html_nodes(".column-count-4 a") %>% html_text()

drzave.v.razvoju <- subset(valute.po.drzavah, drzava %in% v.razvoju)


# seznam 7ih valut v katerih se največ trgije:
najvecje <- c("EUR", "GBP", "CHF", "CAD", "AUD", "ZAR", "JPY","USD")

# Razvrščanje valut po skupinah (navečje, iz držav v razvoju in druge):
valute.po.skupinah <- subset(valute.po.drzavah, valuta %in% najvecje)
skupina <- rep("najvecje", nrow(valute.po.skupinah))
valute.po.skupinah <- cbind(valute.po.skupinah, skupina)

drzave.v.razvoju <- subset(valute.po.drzavah, drzava %in% v.razvoju & !(valuta %in% najvecje))
skupina <- rep("v razvoju", nrow(drzave.v.razvoju))
drzave.v.razvoju <- cbind(drzave.v.razvoju, skupina)


druge <- subset(valute.po.drzavah, !(valuta %in% valute.po.skupinah$valuta))
skupina <- rep("druge", nrow(druge))
druge <- cbind(druge, skupina)

valute.drzav.s.skupinami <- rbind(valute.po.skupinah, drzave.v.razvoju, druge)
valute.po.skupinah <- valute.drzav.s.skupinami[,c(2,3)] 
valute.po.skupinah <- valute.po.skupinah[!duplicated(valute.po.skupinah$valuta),]


# Preoblikovanje podatkov iz različnih virov, ki smo jih prido:
tecaji <- read_csv("podatki/tecajiPoMesecih.csv")
tecaji.po.valutah <- subset(tecaji, kratica=="EUR"& tip == "nakupni")[,c(3,5)]
imena <- c("datumi","EUR")
for(i in 3:nrow(imena.valut)){
  stolpec <- subset(tecaji, kratica==imena.valut[i,1] & tip == "nakupni")
  if(nrow(stolpec) == 241){
    tecaji.po.valutah <- cbind(tecaji.po.valutah, stolpec[,5])
    imena <- c(imena, imena.valut[i,1])
  }
  
}

colnames(tecaji.po.valutah) <- imena
tecaji.po.valutahR = melt(tecaji.po.valutah, id = "datumi")

colnames(imena.valut) <- c("variable", "ime")
tecaji.valut <- merge(tecaji.po.valutahR, imena.valut, by="variable")
tecaji.valut <- merge(x=tecaji.valut,y=valute.po.skupinah, by.x="variable", by.y="valuta")
tecaji.valut <- tecaji.valut[with(tecaji.valut, order(variable, datumi)),]

