# Devizni tečaji
## Projekt pri predmetu Analiza podatkov s programom R

V projektni nalogi bom analizirala gibanje menjalnih tečajev med valutami. Najprej bo predstavljeno, nekaj osnovnih podatkov o valutnih tečajih in državah v katerih se uporabljajo. V drugem delu pa bomo s pomočjo stohastičnih modelo Brownovo gibanje in modela Ornstein–Uhlenbeck narejena napoved gibanja tečajev za naprej.

Podatki bodo pridobljeni iz spodnjih spletnih strani:
* http://www.xe.com/currencytables/?from=EUR&date=2017-11-01
* https://en.wikipedia.org/wiki/List_of_circulating_currencies
* https://en.wikipedia.org/wiki/Developing_country

Zasnova podatkovnega modela:
* Podatki so v obliki HTML.
* Večji del podatkov bo po zajetju shranjeni v CSV datoteko z imenom tecajiPoMesecih
* Tabele bodo oblike:

tabela 1: kratica valute, datum, višina tečaja, skupina <br />
tabela 2: kratica valute, ime valute <br />
tabela 3: kratica valute, drzava, skupina <br />
tabela 4: kratica valute, povprecje, normiran.odklon, skupina                    

CILJ ANALIZE: Primerjava vrednosti menjalnih tečajev med posameznimi valutami. Opazovanje koreliranosti med stabilnostjo valut, ki jih uporabljajo v državah različnih skupin (npr. države v rozvoju, gospodarske velesile...). Ter narediti napoved gibanja tečaja EUR/USD s primernim modelom.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
