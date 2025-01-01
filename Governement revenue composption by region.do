clear all
cd "C:\Users\massa\Desktop\MiniProjet\Data\Tax DATA"
import excel "taxdtaclean.xlsx", sheet("Sheet1") firstrow clear

merge m:m ISO using coutry_region_iso.dta

drop if _merge == 2

egen id = group(Country)

* Identifier les doublons
duplicates report id Year

* Lister les doublons
*duplicates list id Year

* Gérer les doublons (par exemple, les supprimer)
duplicates drop id Year, force

* Vérifier les doublons supprimés
*duplicates list id Year

* Déclarer les données de panel
xtset id Year

rename AY TaxesonInternationalTradeexpor

******************************************************************
* Générer les variables en pourcentage
gen DirectTaxesIncludingSCIncRe_pct = DirectTaxesIncludingSCIncRe * 100
gen TaxesonIncomeProfitsCapita_pct = TaxesonIncomeProfitsCapita * 100
gen PropertyTaxes_pct = PropertyTaxes * 100
gen IndirectTaxesTotal_pct = IndirectTaxesTotal * 100
gen TaxesonGoodsandServicesVAT_pct = TaxesonGoodsandServicesVAT * 100
gen TxIntertionalTradeTota_pct = TaxesonInternationalTradeTota * 100
gen TaxesonIntationalTradeow_pct = TaxesonInternationalTradeow * 100
gen TxesonInteionalTrdeexpor_pct = TaxesonInternationalTradeexpor * 100

******************************************************************
* Fonction pour créer les graphiques
program define create_graph, rclass
    args varname title filename
    * Agréger les données par région et par année
    preserve
    collapse (mean) `varname', by(region Year)
    
    * Définir les couleurs pour chaque région
    local colors "red blue green purple yellow"
    local regions "Africa Americas Asia Europe Oceania"
    
    * Construire la liste des commandes line
    local plotcmds
    local i = 1
    foreach region of local regions {
        local color : word `i' of `colors'
        local plotcmds `plotcmds' (line `varname' Year if region == "`region'", ///
            lcolor("`color'") lpattern(solid) lwidth(medium))
        local i = `i' + 1
    }
    
    * Exécuter la commande twoway avec les commandes line
    twoway `plotcmds', ///
        legend(order(1 "Africa" 2 "Americas" 3 "Asia" 4 "Europe" 5 "Oceania") ///
               col(5) size(small) position(10) ring(0) region(lcolor(none))) ///
        title(`"`title'"', size(large)) ///
        xtitle("Year", size(medium)) ///
        ytitle("% GDP", size(medium)) ///
        graphregion(color(white)) ///
        plotregion(margin(zero)) ///
        scheme(s2color) ///
        ylabel(, angle(horizontal)) ///
        xlabel(, angle(horizontal))
    
    * Enregistrer le graphique
    graph export "`filename'", replace
    restore
end

******************************************************************
* Créer les graphiques un par un avec les titres et noms de fichiers appropriés

* Graphique 1
local varname = "DirectTaxesIncludingSCIncRe_pct"
local title = "Direct Taxes by Region"
local filename = "DirectTaxesIncludingSCIncRe_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 2
local varname = "TaxesonIncomeProfitsCapita_pct"
local title = "Taxes on Income, Profits, and Capital by Region"
local filename = "TaxesonIncomeProfitsCapita_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 3
local varname = "PropertyTaxes_pct"
local title = "Property Taxes by Region"
local filename = "PropertyTaxes_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 4
local varname = "IndirectTaxesTotal_pct"
local title = "Indirect Taxes by Region"
local filename = "IndirectTaxesTotal_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 5
local varname = "TaxesonGoodsandServicesVAT_pct"
local title = "Taxes on Goods and Services (VAT) by Region"
local filename = "TaxesonGoodsandServicesVAT_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 6
local varname = "TxIntertionalTradeTota_pct"
local title = "Taxes on International Trade (Total) by Region"
local filename = "TxIntertionalTradeTota_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 7
local varname = "TaxesonIntationalTradeow_pct"
local title = "Taxes on International Trade (Imports) by Region"
local filename = "TaxesonIntationalTradeow_pct.png"
create_graph `varname' "`title'" "`filename'"

* Graphique 8
local varname = "TxesonInteionalTrdeexpor_pct"
local title = "Taxes on International Trade (Exports) by Region"
local filename = "TxesonInteionalTrdeexpor_pct.png"
create_graph `varname' "`title'" "`filename'"
