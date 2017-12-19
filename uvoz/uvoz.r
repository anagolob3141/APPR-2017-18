# 2. faza: Uvoz podatkov

# Vsi podatki so zajeti iz spletnih strani oblike: 
# http://www.xe.com/currencytables/?from=USD&date= (datumi so različni)

library(dplyr)
library(rvest)
library(reshape2)

# Funkcija, ki uvozi podatke o valutnih tečajki za vhodne datume in jih zapiše v tabelo.
uvoziPodatke <- function(datumi){
  lapply(datumi, function(datum) {
    paste0("http://www.xe.com/currencytables/?from=USD&date=", datum) %>% html_session() %>%
      read_html() %>% html_nodes(xpath="//table[@id='historicalRateTbl']") %>% .[[1]] %>%
      html_table() %>% mutate(datum = datum)
  }) %>% bind_rows()
}

#   Funkcija za urejanje tabele, njeno preoblikovanje v tidy data in shrabžnjevanje v CSV-datoteko.
uredi.tabelo <- function(tabela, ime.datoteke){
  names(tabela) <- c("kratica", "ime", "nakupni", "prodajni", "datum")
  tecaji <- melt(tabela[, -2], measure.vars = c("nakupni", "prodajni"),
                       variable.name = "tip", value.name = "tecaj")
  write.csv(tecaji, file = ime.datoteke)
}

tabela.za.kratice <- uvoziPodatke("2016-01-01")
names(tabela) <- c("kratica", "ime", "nakupni", "prodajni", "datum")
imena.valut <- tabela[, 1:2] %>% unique()

# Ker je uvoženih podatkov veliko jih bomo shranili v 3 csv datotek.
# V vsaki se nahajajo podatki o valutah za eno tretjino leta 2016.
if (!file.exists("tecaji1tretjina.csv")){
  datumi1.tretjina2016 <- seq(as.Date("2016-01-01"), as.Date("2016-04-30"), by="days")
  tabela1.tretjina2016 <- uvoziPodatke(datumi1.tretjina2016)
  uredi.tabelo(tabela1.tretjina2016, "tecaji1tretjina.csv")
}

if (!file.exists("tecaji2tretjina.csv")){
  datumi2.tretjina2016 <- seq(as.Date("2016-05-01"), as.Date("2016-08-31"), by="days")
  tabela2.tretjina2016 <- uvoziPodatke(datumi2.tretjina2016)
  uredi.tabelo(tabela2.tretjina2016, "tecaji2tretjina.csv")
}

if (!file.exists("tecaji3tretjina.csv")){
  datumi3.tretjina2016 <- seq(as.Date("2016-09-01"), as.Date("2016-12-31"), by="days")
  tabela3.tretjina2016 <- uvoziPodatke(datumi3.tretjina2016)
  uredi.tabelo(tabela3.tretjina2016, "tecaji3tretjina.csv")
}
