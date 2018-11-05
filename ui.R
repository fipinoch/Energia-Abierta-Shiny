ui <- fluidPage(
    
    titlePanel('Generación Bruta Mensal SEN'),
    
    sidebarLayout(
        sidebarPanel(
            verticalLayout(
                radioButtons(inputId = 'frecuencia',
                             label = 'Frecuencia',
                             choices = c('Horaria', 'Diaria', 'Mensual', 'Anual'),
                             selected = 'Anual'),
#                dateRangeInput(inputId, label, start,end, min, max, format, startview,weekstart, language, separator),
                checkboxGroupInput(inputId = 'subsistema',
                                   label = 'Subsistema',
                                   choices = unique(df_hora$Subsistema),
                                   selected = unique(df_hora$Subsistema)
                                  ),
                checkboxGroupInput(inputId = 'clasificacion',
                                   label = 'Clasificación',
                                   choices = unique(df_hora$Clasificacion),
                                   selected = unique(df_hora$Clasificacion)
                                  ),
                checkboxGroupInput(inputId = 'tecnologia',
                                   label = 'Tecnología',
                                   choices = unique(df_hora$Tecnologia),
                                   selected = unique(df_hora$Tecnologia))
            )
        ),
        mainPanel(
            tabsetPanel(
                tabPanel('Grafico Generación',
                         plotlyOutput('graficoGeneracion')),
                tabPanel('Generación por Subsistema',
                         plotlyOutput('graficoSubsistema')),
                tabPanel('Datos',
                         dataTableOutput('datos'))
            )
        )
    )
)