

library(shiny)
library(ggplot2)
library(plotly)
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(plotly)
library(dplyr)

function(input, output) {
  
  # Loading data
  url = "https://raw.githubusercontent.com/FabianGarciaXY/Proyecto-dashboard-R/main/src/data/BEDU_movies_csv.csv"
  data <- read.csv(url)
  data <- na.omit(data) # Se eliminan datos faltantes
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

  # Conversion de character a numeric en Ganancias, GananciasInternacionales y GananciasLocales
  dfFinal <- mutate(dfFinal, Ganancias=as.numeric(gsub('[$,]', '', Ganancias)))
  dfFinal <- mutate(dfFinal, GananciasInternacional=as.numeric(gsub('[$,]', '', GananciasInternacionales)))
  dfFinal <- mutate(dfFinal, GananciasLocal=as.numeric(gsub('[$,]', '', GananciasLocales)))

  # Grafica 1: Fabian  
  output$mi_grafico_1 <- renderPlotly({

    if (input$TipoGrafica == "gm") {
      yLabel = dfFinal$Ganancias
    } else if (input$TipoGrafica == "gi") {
      yLabel = dfFinal$GananciasInternacional
    } else {
      yLabel = dfFinal$GananciasLocal
    }

    # Grafico de barras
    ggplot(data=dfFinal, aes(x=Licencia, y=yLabel)) +
      geom_bar(stat="identity", width=0.6, fill=rgb(0.1,0.4,0.5,0.7)) +
      theme(legend.position="none") +
      theme_minimal()

  })


  # Grafico 2: Moises
  output$mi_grafico_2 <- renderPlotly({
    #shinypairs(~  dfFinal$Lanzamiento + dfFinal$GananciasLocal + dfFinal$GananciasInternacional + dfFinal$Ganancias,  col = "green", pch = 18, gap = 0.4, cex.labels = 1.5, main = "Graficas de dispersion Ventas/Ano")
    if (input$TipoGrafica2 == "gm") {
      yLabel = dfFinal$Ganancias
      title_screen="Ganancias Mundiales"
    } else if (input$TipoGrafica2 == "gi") {
      yLabel = dfFinal$GananciasInternacional
      title_screen="Ganancias Internacionales"
    } else  {
      yLabel = dfFinal$GananciasLocal
      title_screen="Ganancias Locales"
    }
    
    
    ggplot(data=dfFinal, aes(x=Lanzamiento, y=yLabel)) +
      labs(title = paste("Dispersion Lanzamiento/",title_screen),
           subtitle = "La data esta representada por cientos de miles") + 
        geom_point(size=2, shape=23)
    # ?Qu? tipo de relaciones podemos observar?
    #shinypairs(df$Lanzamiento + dfFinal$GananciasLocal + dfFinal$GananciasInternacional + dfFinal$Ganancias, group = NULL, subset = NULL, labels = NULL)
  })


  # Grafica 3: Fede
  output$mi_grafico <- renderPlotly({
    if (input$TipoGrafica == "gm") {
        lines_data <-  subset(dfFinal, 
                              Lanzamiento >= input$Anio[1] & 
                              Lanzamiento <= input$Anio[2])
      
        ggplot(lines_data, aes(x=Lanzamiento, y=Ganancias, fill=Estudio))+
          labs(title = "Ganancias por Año",
               subtitle = "Ganancias por estudio por año") + 
          geom_col(position = "dodge")
    } else {
      lines_data <-  aggregate(dfFinal$Estudio, by=list(dfFinal$Lanzamiento,dfFinal$Estudio), FUN=length)
      lines_data <-  rename(lines_data, Lanzamiento = Group.1, Estudio = Group.2, Peliculas = x)
      lines_data <-  subset(lines_data, 
                            Lanzamiento >= input$Anio[1] & 
                            Lanzamiento <= input$Anio[2])
      ggplot(lines_data, aes(x=Peliculas, y= Estudio, fill=Estudio))+
        labs(title = "Cantidad de películas por Año") + 
        geom_col(position = "dodge")
    }
  })

  #   output$mi_grafico <- renderPlot({
  #     ggplot(mtcars, aes(x = mpg, y = hp)) +
  #     geom_point()
  #   })
}
