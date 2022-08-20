library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(plotly)
library(dplyr)


url <- "https://raw.githubusercontent.com/FabianGarciaXY/Proyecto-dashboard-R/main/src/data/BEDU_movies_csv.csv"
data <- read.csv(url)
data <- na.omit(data)
dfCols <- select(data, Release.Year, Distributor, World.Sales..in..., International.Sales..in..., Domestic.Sales..in..., License) # Seleccion de columnas
dfCols <- dfCols[order(dfCols$Release.Year, dfCols$Distributor),]
dfFinal <-  rename(dfCols,     # Renombrando columnas
              Lanzamiento = Release.Year, 
              Estudio = Distributor, 
              Ganancias = World.Sales..in...,
              GananciasInternacionales = International.Sales..in...,
              GananciasLocales = Domestic.Sales..in...,
              Licencia = License
            )


# Header 
 header <- dashboardHeader (title = strong("Proyecto Shiny"))

# Sidebar 
 sidebar <- dashboardSidebar(disable = F,
                              sidebarMenu(
                                menuItem("Caso 1", tabName = "Grafico1"),
                                menuItem("Caso 2", tabName = "Grafico2"),
                                menuItem("Caso 3, presentado por Fede V0", tabName = "Grafico3")
                              )
 ) 

# Body   
body<- dashboardBody(
  mainPanel(
    h3("Proyecto equipo 14"),
    p("Este proyecto se desarrolló como muestra de lo que sea que se esté haciendo en el módulo de Procesamiento de datos con R."),
    p("Para el desarrollo del Dashboard se usaran las librerías"),
    br(),
    code("library(shiny)"),
    br(),
    code("library(shinyWidgets)"),
    br(),
    code("library(shinydashboard)"),
    br(),
    code("library(shinydashboardPlus)"),
    br(),
    code("library(ggplot2)"),
    br(),
    code("library(plotly)"),
    br(),
    br()
  ),
  tabItems(
    # Primer tab: Fabian
    tabItem(tabName = "Grafico1",
            fluidRow(
              #contenedor principal
              box(title = "Caso 1: ¿Cuál es la clasificación que genera más dinero?",
                  h3("Grafico de Barras"),
                  p("Para averiguarlo se graficaron las ganacias que genero cada tipo categoria(PG, PG-13, R)"),
                  width = 12,
                  #Controles
                  box(selectInput(inputId = "TipoGrafica",
                                  label = "Seleccione que se va a Graficar:",
                                  choices = c("Ganancias Mundiales" = "gm",
                                              "Ganancias Internacionales" = "gi",
                                              "Ganancias Nacionales" = "gn"),
                                  selectize = FALSE),
                      width = 4),
                  #Grafica 1 
                  box(plotlyOutput("mi_grafico_1"),
                      width = 8,
                      height = "400px")
              )#Box principal
            )#FluidRow
    ), #TabItem
    
    # Segundo tab
    tabItem(tabName = "Grafico2",
            fluidRow(
              #contenedor principal
              box(title = "Caso 2: ¿Qué estudio genera más dinero, Norte americano o internacional?",
                  h3("Primer Grafico"),
                  p("Para mostrar los resultados de la pregunta dos, los datos se representan de la siguiente manera."),
                  width = 12,
                  #Controles
                  box(sliderInput("Seleccione Fechas", label = h6("Rango de Fechas"), min = 1937, 
                                max = 2022, value = c(2005, 2017))),
                  #Grafica 2 
                  box(plotOutput(outputId = ""))
              )#Box principal
            )#FluidRow
    ), #TabItem
    
    # Tercer tab: Fede
    tabItem(tabName = "Grafico3",
            fluidRow(
              #contenedor principal
              box(title = "Caso 3: ¿Qué estudio genera más películas por año?",
                  h3("Tercer Grafico"),
                  p("Esta última  grafica muestra los datos del tema 3"),
                  width = 12,
                  #Controles
                  box(selectInput(inputId = "TipoGrafica",
                                  label = "Seleccione que se va a Graficar:",
                                  choices = c("Ganancias Mundiales" = "gm",
                                              "Cantidad de Peliculas" = "cp"),
                                  selectize = FALSE),
                      sliderInput("Anio", "Rango de Años",
                                  min(dfFinal$Lanzamiento), max(dfFinal$Lanzamiento),
                                  value = c(2005, 2008),
                                  step = 1),
                      width = 4),
                    #dateRangeInput('dateRange',
                    #                 label = 'Selecciona el rango de fechas',
                    #                 start = "1937-01-01", end = "2022-12-31",
                    #                 min = "1937-01-01", max = "2022-12-31")),
                  #Grafica 3 
                  box(plotlyOutput("mi_grafico"),
                      width = 8,
                      height = "400px")
              )#Box principal
            )#FluidRow
    ) #TabItem
  )#tabItems
)#body



# Footer
footer <- dashboardFooter(left = strong("Equipo 14"), right = strong("2022"))


# Title
title  <- "Proyecto Shiny BEDU"

shinyUI(
  dashboardPage(header, sidebar, body, NULL, footer, title, skin = "midnight") 
)



