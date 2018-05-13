# 3. faza: Vizualizacija podatkov


##################################################################################
# ŠTETJE PODATKOV:
# Valute, ki se uporabljajo v več kot eni državi
pogostost <- as.data.frame(count(valute.po.drzavah, vars = valuta))

pogostost <- merge(x=pogostost, y=imena.valut, by.x="vars", by.y="variable")
pogostost <- pogostost[order(pogostost$n,decreasing = TRUE),]
pogostost <- pogostost[, c(1,3,2)]
row.names(pogostost) <- NULL

pogoste.valute <- pogostost[pogostost$n > 1,]

pogoste.valute$vars <- factor(pogoste.valute$vars,
                                     levels = unique(pogoste.valute$vars)[order(pogoste.valute$n, decreasing = TRUE)])

graf1 <- plot_ly() %>%
  add_trace(data=pogoste.valute, x= ~vars, y=~n, type = 'bar') %>%
  layout(title = 'Valute, ki se uporabljajo v več kot 1 državi', 
       xaxis = list(title = "Valute", tickangle = 45),
       yaxis = list (title = "Šrevilo držav v katerih se uporabljajo")
  )
graf1 


# Države,z večjim številom državnih valut (prikazane na zemljevidu spodaj):
vec.valut <- as.data.frame(count(valute.po.drzavah, vars = drzava))
vec.valut <- vec.valut[order(vec.valut$n,decreasing = TRUE),]
colnames(vec.valut) <- c("drzava", "št.valut")
row.names(vec.valut) <- NULL
drzave.z.vec.valutami <- vec.valut[vec.valut$št.valut > 1,]
##########################################################################################################
# Prikaz podatkov na zemljevidu:

#Uvoz zemljevida sveta
library(rgeos)
library(rworldmap)
wmap <- getMap(resolution="high")
centri <- as.data.frame(gCentroid(wmap, byid=TRUE))
centri <- cbind(drzava = rownames(centri), centri)

world <- map_data("world")
world<-world[c(1:5)]
colnames(world) <-c("long","lat","group","order","drzava")
world$Country <- toupper(world$drzava)

###########################################################
# Zemljevid, ki prikazuje razporejenost valut po državah:
valute.drzav.s.skupinami <- subset(valute.drzav.s.skupinami, !duplicated(valute.drzav.s.skupinami[,1]))
valute.centri <- left_join(centri,valute.drzav.s.skupinami, by="drzava")
valute.po.svetu <- left_join(world,valute.drzav.s.skupinami, by="drzava")

valute.po.svetu$valuta[valute.po.svetu$drzava == "United States of America"] <- "USD"
valute.po.svetu$skupina[valute.po.svetu$drzava == "United States of America"] <- "najvecje"
valute.centri$valuta[valute.centri$drzava == "United States of America"] <- "USD"
valute.centri$skupina[valute.centri$drzava == "United States of America"] <- "najvecje"
valute.centri$valuta[valute.centri$drzava == "Greenland"] <- "DKK"
valute.po.svetu$valuta[valute.po.svetu$drzava == "Greenland"] <- "DKK"

izloci <- c("Antigua and Barbuda", "Anguilla","Aruba", "Dominica", "Haiti", "Jamaica",
            "Liechtenstein", "Sint Maarten", "Turks and Caicos Islands", "Grenada",
            "Cayman Islands", "Northern Cyprus", "Saint Kitts and Nevis", "Saint Lucia", "Saint Martin",
            "Montserrat","Puerto Rico", "Trinidad and Tobago", "British Virgin Islands", 
            "United States Virgin Islands", "Saint Barthelemy", "Curacao", "Saint Vincent and the Grenadines",
            "Barbados", "El Salvador","Belize","Honduras", "Bosnia and Herzegovina", "Guernsey", "Hungary",
            "Moldova","Romania","French Polynesia","Wallis and Futuna","Samoa", "Tonga", "Niue", "American Samoa",
            "Cook Islands", "Pitcairn Islands", "Sierra Leone", "Benin","Togo","Equatorial Guinea", 
            "Republic of the Congo","Rwanda","Lesotho","Israel", "Lebanon","Qatar","Marshall Islands","Thailand",
            "Laos","Armenia","Vanuatu") 

izpisi.centri <- subset(valute.centri,!(valuta %in% "EUR"))
izpisi.centri <- subset(izpisi.centri,!(drzava %in% izloci))
izpisi.centri <- rbind(izpisi.centri, subset(valute.centri,drzava %in% c("Netherlands","Spain")))

valute.svet <- ggplot() + geom_polygon(data = valute.po.svetu,
                                       aes(x=long, y = lat, group = group,fill=valuta)) + coord_fixed(1.3) +
  theme(legend.position="none") +
  ggtitle("Nacionalne valute držav") +
  geom_text(data= izpisi.centri,
            aes(x = x, y = y, label = valuta),
            alpha = 1,
            color = "black",
            size = 1.5)
valute.svet

#####################################################################


