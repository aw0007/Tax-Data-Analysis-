library(shiny)
library(tidyverse)
library(readxl)
library(haven)
library(bslib)
library(DT)
library(plotly)

# -------------------- Importation des données --------------------
tax_data <- read_excel("data/taxdtaclean.xlsx")
region_data <- read_dta("data/coutry_region_iso.dta")

full_data <- tax_data %>%
  left_join(region_data, by = "ISO") %>%
  drop_na(region) %>%
  distinct(Country, Year, .keep_all = TRUE)

full_data <- full_data %>%
  mutate(
    DirectTaxesIncludingSCIncRe_pct = `Direct Taxes Including SC Inc Resource` * 100,
    TaxesonIncomeProfitsCapita_pct = `Taxes on Income Profits & Capital Gains Total` * 100,
    PropertyTaxes_pct = `Property Taxes` * 100,
    IndirectTaxesTotal_pct = `Indirect Taxes Total` * 100,
    TaxesonGoodsandServicesVAT_pct = `Taxes on Goods and Services  VAT` * 100,
    TxIntertionalTradeTota_pct = `Taxes on International TradeTotal` * 100,
    TaxesonIntationalTradeow_pct = `Taxes on International Trade o/w Import` * 100,
    TaxesonInternationalTradeexpor_pct = `Taxes on International Trade o/w Export` * 100
  )

data_long <- full_data %>%
  pivot_longer(
    cols = ends_with("_pct"),
    names_to = "TaxType",
    values_to = "Value"
  ) %>%
  mutate(TaxType = recode(TaxType,
                          "DirectTaxesIncludingSCIncRe_pct" = "Direct Taxes",
                          "TaxesonIncomeProfitsCapita_pct" = "Income, Profits, Capital Gains",
                          "PropertyTaxes_pct" = "Property Taxes",
                          "IndirectTaxesTotal_pct" = "Indirect Taxes",
                          "TaxesonGoodsandServicesVAT_pct" = "VAT",
                          "TxIntertionalTradeTota_pct" = "Trade Total",
                          "TaxesonIntationalTradeow_pct" = "Imports",
                          "TaxesonInternationalTradeexpor_pct" = "Exports"
  ))

# -------------------- Interface utilisateur --------------------

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "flatly", base_font = font_google("Roboto")),
  uiOutput("responsiveUI")
)

# -------------------- Serveur --------------------

server <- function(input, output, session) {
  
  # Génération dynamique de l'interface selon la taille de l'écran
  output$responsiveUI <- renderUI({
    width <- session$clientData$output_revenuePlot_width
    
    if (is.null(width) || width > 800) {
      # Design PC/Tablette
      navbarPage(
        title = "Observatoire Fiscal International",
        tabPanel("Visualisation",
                 sidebarLayout(
                   sidebarPanel(
                     radioButtons("mode", "Mode d'affichage :", 
                                  choices = c("Région", "Pays"), selected = "Région"),
                     uiOutput("selector"),
                     checkboxGroupInput("taxes", "Types de taxes :", 
                                        choices = unique(data_long$TaxType),
                                        selected = unique(data_long$TaxType))
                   ),
                   mainPanel(
                     plotlyOutput("revenuePlot", height = "600px")
                   )
                 )
        ),
        tabPanel("Données", DT::dataTableOutput("table")),
        tabPanel("À propos",
                 h4("Projet développé par Abdoul Wahid"),
                 p("Analyse des recettes fiscales internationales à partir des bases UNU-WIDER."),
                 p("Application Shiny interactive en R.")
        )
      )
    } else {
      # Design Mobile
      fluidPage(
        titlePanel("Fiscal International"),
        radioButtons("mode", "Mode :", choices = c("Région", "Pays"), selected = "Région"),
        uiOutput("selector"),
        checkboxGroupInput("taxes", "Taxes :", 
                           choices = unique(data_long$TaxType),
                           selected = unique(data_long$TaxType)),
        plotlyOutput("revenuePlot", height = "400px"),
        DT::dataTableOutput("table")
      )
    }
  })
  
  # Sélecteurs dynamiques
  output$selector <- renderUI({
    if (input$mode == "Région") {
      selectInput("region", "Sélectionner la région :", 
                  choices = unique(data_long$region),
                  selected = unique(data_long$region)[1])
    } else {
      selectInput("country", "Sélectionner le pays :", 
                  choices = unique(data_long$Country),
                  selected = unique(data_long$Country)[1])
    }
  })
  
  # Filtrage des données
  filteredData <- reactive({
    if (input$mode == "Région") {
      data_long %>%
        filter(TaxType %in% input$taxes) %>%
        group_by(region, Year, TaxType) %>%
        summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop") %>%
        filter(region == input$region)
    } else {
      data_long %>%
        filter(Country == input$country, TaxType %in% input$taxes)
    }
  })
  
  output$revenuePlot <- renderPlotly({
    colors_fixed <- c(
      "Direct Taxes" = "#1f77b4",
      "Income, Profits, Capital Gains" = "#ff7f0e",
      "Property Taxes" = "#2ca02c",
      "Indirect Taxes" = "#d62728",
      "VAT" = "#9467bd",
      "Trade Total" = "#8c564b",
      "Imports" = "#e377c2",
      "Exports" = "#7f7f7f"
    )
    
    p <- ggplot(filteredData(), aes(x = Year, y = Value, color = TaxType)) +
      geom_line(size = 1.2) +
      scale_color_manual(values = colors_fixed) +
      labs(x = "Année", y = "% du PIB", color = "Type de taxe") +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    ggplotly(p)
  })
  
  output$table <- DT::renderDataTable({
    filteredData()
  })
}

# -------------------- Lancement --------------------
shinyApp(ui, server)
