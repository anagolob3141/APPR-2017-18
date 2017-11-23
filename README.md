# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Menjalni tečaji med valutami

V projektni nalogi bom analizirala gibanje menjalnih tečajev med valutami. Pri tem si bom kot glavno valuto izbrala euro. Opazovala bom višino menjalnih tečajev za nakup 1 EUR, ter za nakup ene enote druge denarne valute z euri. Analizirani menjalni tečaji bodo izmerjeni v zadnjih 30ih dneh pred zaganjanjem programa.

Podatki bodo pridobljeni iz spodnje spletne strani:
* http://www.xe.com/currencytables/?from=EUR&date=2017-11-01

Zasnova podatkovnega modela:
* Podatki so v obliki HTML.
* Podatki za vsako denarno enoto bodo zbrani v svoji tabeli.
* Tabele bodo oblike: STOLPCI: podatek o tem ali gre za tečaj za menjavo v ali iz dane valute, datum, menjalni tečaj.

CILJ ANALIZE: Primerjava vrednosti menjalnih tečajev med posameznimi valutami. Ugotavljanje koreliranosti med nihanjem tečajev različnih valut, ter koreliranosti med nihanjem menjalnimi tečaji v in iz posamezne valute. (Ekstrapolacija podatkov.)  


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

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
