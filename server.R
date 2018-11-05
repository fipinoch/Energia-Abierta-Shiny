server <- function(input, output, session){
    
    df <- reactive({
        x <- input$frecuencia
        
        df <- df_hora %>%
            filter(Subsistema %in% input$subsistema,
                   Clasificacion %in% input$clasificacion,
                   Tecnologia %in% input$tecnologia)
        
        if(x == 'Horaria'){
            df <- df %>%
                mutate(Fecha = as.POSIXct(paste0(paste(Year, Month, Day, sep = '-'),
                                                 ' ',
                                                 paste0(Hour - 1, ':59:59')),
                                          format = '%Y-%m-%d %H:%M:%S')) %>%
                filter(!is.na(Fecha))
        } else if (x == 'Diaria'){
            df <- df %>%
                mutate(Fecha = as.Date(paste(Year, Month, Day, sep = '-'),
                                       format = '%Y-%m-%d')) %>%
                group_by(Fecha, Subsistema, Clasificacion, Tecnologia) %>%
                summarise(Generacion_MWh = sum(Generacion_MWh))
        } else if (x == 'Mensual'){
            df <- df %>%
                mutate(Fecha = as.Date(paste(Year, Month, '01', sep = '-'),
                                       format = '%Y-%m-%d')) %>%
                group_by(Fecha, Subsistema, Clasificacion, Tecnologia) %>%
                summarise(Generacion_MWh = sum(Generacion_MWh))
        } else {
            df <- df %>%
                mutate(Fecha = Year) %>%
                group_by(Fecha, Subsistema, Clasificacion, Tecnologia) %>%
                summarise(Generacion_MWh = sum(Generacion_MWh))
        }
    })
    
    ## Grafico Generación por Teconología.
    output$graficoGeneracion <- renderPlotly({
        ggplotly(
            df() %>%
                group_by(Fecha, Tecnologia) %>%
                summarise(Generacion_MWh = sum(Generacion_MWh)) %>%
                ungroup() %>%
                mutate(Tecnologia = forcats::fct_relevel(Tecnologia, new_tec_level)) %>%
                ggplot(aes(x = Fecha, y = Generacion_MWh, fill = Tecnologia)) +
                geom_bar(stat = 'identity', position = 'stack') +
                scale_fill_manual(values = tec_color)
        )
    })
    
    output$graficoSubsistema <- renderPlotly({
        ggplotly(
            df() %>%
                group_by(Fecha, Subsistema) %>%
                summarise(Generacion_MWh = sum(Generacion_MWh)) %>%
                ggplot(aes(x = Fecha, y = Generacion_MWh, fill = as.factor(Subsistema))) +
                geom_bar(stat = 'identity', position = 'stack')
        )
    })
    
    output$datos <- renderDataTable({df()})
    
    output$downloadData <- downloadHandler(
        filename = function(){
            paste('Generacion Bruta ', input$frecuencia, '.csv', sep = '')
        },
        content = function(file){
            write.csv(df(), file, row.names = FALSE, fileEncoding = 'latin1')
        }
    )
}