# 3. faza: Vizualizacija podatkov


##################################################################################
# ŠTETJE PODATKOV:
# Valute, ki se uporabljajo v več kot eni državi
pogostost <- as.data.frame(count(valute.po.drzavah, vars = valuta))

pogostost <- merge(x=pogostost, y=imena.valut, by.x="vars", by.y="variable")
pogostost <- pogostost[order(pogostost$n,decreasing = TRUE),]
pogostost <- pogostost[, c(1,3,2)]
colnames(pogostost) <- c("kratica valute","ime valute", "št.držav")
row.names(pogostost) <- NULL
pogoste.valute <- pogostost[pogostost$št.držav > 1,]


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
View(valute.drzav.s.skupinami)
valute.centri <- left_join(centri,valute.drzav.s.skupinami, by="drzava")
valute.po.svetu <- left_join(world,valute.drzav.s.skupinami, by="drzava")

valute.po.svetu$valuta[valute.po.svetu$drzava == "United States of America"] <- "USD"
valute.po.svetu$skupina[valute.po.svetu$drzava == "United States of America"] <- "v razvoju"
valute.centri$valuta[valute.centri$drzava == "United States of America"] <- "USD"
valute.centri$skupina[valute.centri$drzava == "United States of America"] <- "v razvoju"

# GRAF SE NAHAJA V SHINY APLIKACIJI
# valute.svet <- ggplot() + geom_polygon(data = valute.po.svetu,
#                                        aes(x=long, y = lat, group = group,fill=valuta)) + coord_fixed(1.3) +
#   theme(legend.position="bottom",legend.text = element_text(size=3), legend.key.size =  unit(0.09, "in")) +
#   geom_text(data= valute.centri,
#             aes(x = x, y = y, label = valuta),
#             alpha = 1,
#             color = "black",
#             size = 1.5)
# 
# valute.svet
#####################################################################
# Zemljevid, ki prikazuje države z večjim številom državnih valut (nadajevanje od zgoraj):
vec.valut.centri <- left_join(centri,vec.valut, by="drzava")
vec.valut.drzave <- left_join(world,vec.valut, by="drzava")


vec.valut.svet <- ggplot() + geom_polygon(data = vec.valut.drzave,
                                          aes(x=long, y = lat, group = group,fill=št.valut)) + coord_fixed(1.3) +
  geom_text(data= vec.valut.centri[vec.valut.centri$št.valut > 1,],
            aes(x = x, y = y, label = drzava),
            alpha = 1,
            color = "red",
            size = 2.5)

vec.valut.svet

