library(shiny)
library(ggplot2)
library(plotly)
function(input, output) {
  
data <- read.csv("https://raw.githubusercontent.com/FabianGarciaXY/Proyecto-dashboard-R/main/data/BEDU_movies_csv.csv")
data <- na.omit(data)
dfCols <- select(data, Release.Year,Distributor, World.Sales..in...)
dfCols <- dfCols[order(dfCols$Release.Year, dfCols$Distributor), ]
dfFinal <-  rename(dfCols, Lanzamiento = Release.Year, Estudio = Distributor, Ganancias = World.Sales..in...)

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
#      ggplot(mtcars, aes(x = mpg, y = hp)) +
#        geom_point()
#    })
  }
