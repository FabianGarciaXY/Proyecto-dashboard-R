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
 header <- dashboardHeader (title = strong("Movies industry"))

# Sidebar 
 sidebar <- dashboardSidebar(disable = F,
                              # tags$li(a(
                              #            img(src = 'https://res.cloudinary.com/people-matters/image/upload/f_auto,q_auto,w_800,h_800,c_lpad/v1517845732/1517845731.jpg',
                              #                title = "Company Home", height = "130px"),
                              #            style = "padding-top:10px; padding-bottom:10px;"),
                              #          class = "dropdown"),
                              sidebarMenu(
                                menuItem("Analisis por genero", tabName = "Grafico1"),
                                menuItem("Analisis por anio", tabName = "Grafico2"),
                                menuItem("Comparativo anios y estudio", tabName = "Grafico3")
                              )
 ) 

# Body   
body<- dashboardBody(
  mainPanel(
    h3("Industria de la peliculas"),
    p("El proposito de este analisis es entender algunas caracteristicas de la industria del entretenimiento (cine)"),
    p("Entre ellas ganancias por anio, por estudio y por genero."),
    p("Para el desarrollo del Dashboard se usamos las librerías"),
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
                  p("Nosotros suponemos que las peliculas con mas accion o contenido para adultos son mas taquilleras"),
                  p("Para averiguarlo se graficaron las ganacias que genero cada tipo categoria(PG, PG-13, R)"),
                  width = 12,
                  #Controles
                  tags$style("#TipoGrafica {background-color:white;}"),
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
                      height = "400px"),
                  p("Por lo que se puede notar que la tendencia es hacia las peliculas PG-13 por lo que la hipotesis se rechaza")
      
              )#Box principal
            )#FluidRow
    ), #TabItem
    
    # Segundo tab
    tabItem(tabName = "Grafico2",
            fluidRow(
              #contenedor principal
              box(title = "Caso 2: ¿Existe una coorelacion entre el anio y los ingresos de las peliculas?",
                  p("Nosotros suponemos que si existe una correlacion"),
                  p("Para demostrar nuestra teoria requerimmos:"),
                  HTML("<ul><li>Analisis de dispersion</li><li>modelo de machine learning</li></ul>"),
                  width = 12,
                  tags$style("#TipoGrafica2 {background-color:white;}"),
                  box(selectInput(inputId = "TipoGrafica2",
                                  label = "Seleccione el tipo de ganancias",
                                  choices = c("Ganancias Mundiales" = "gm",
                                              "Ganancias Internacionales" = "gi",
                                              "Ganancias Nacionales" = "gn"),
                                  selectize = FALSE)),
                  #Grafica 2 
                  box(plotlyOutput("mi_grafico_2")),
                  box(
                    p("Por lo que podemos ver hay un claro patron de dispersion.")
                   
                  )
              )#Box principal
            )#FluidRow
    ), #TabItem
    
    # Tercer tab: Fede
    tabItem(tabName = "Grafico3",
            fluidRow(
              #contenedor principal
              box(title = "Caso 3: ¿Qué estudio genera más películas y ganancias por año? ",
                  p("Creemos que Dreamworks es el estudio que mas ganancias genera en los ultimos diez anios"),
                  p("De la misma manera creemos que Warner Bros es el que mas peliculas produce en los ultimos diez anios"),
            
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
                      height = "400px"),
                  box(
                    p("Por lo que podemos ver las hipotesis se rechazan"),
                    p("Podriamos concluir que la industria del cine genera millones de dolares cada anio. Que la clasifiacion mas exitosa es la pg-13 y que Walt Disney es el estudio que mas genera ganancias.")
                  )
                  
              )#Box principal
            )#FluidRow
    ) #TabItem
  )#tabItems
)#body



# Footer
footer <- dashboardFooter(left = strong("Equipo 14- Moises Alfredo Rubio Camacho, Fabian Hernandez Garcia, Federico Velazquez Ortiz, Cesar Andres Vargas Romero"), right = strong("2022"))


# Title
title  <- "Proyecto Shiny BEDU"

shinyUI(
  dashboardPage(header, sidebar, body, NULL, footer, title, skin = "midnight") 
)



