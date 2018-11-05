library(dplyr)
library(data.table)

## GET DATA FROM 2014-01 to 2018-09
get_data <- function(ano = 2018, mes = 2){
    auth_key <- 'a2ba0650a770ccb214e6dd12488600db6e82da1a'
    url_csv <- 'http://cne.cloudapi.junar.com/api/v2/datastreams/GENER-BRUTA-HORAR-SEN/data.csv/?'
    if(mes < 10){
        mes_aux <- paste0('0', mes)
    } else {
        mes_aux <- mes
    }
    csv_file <- paste0(url_csv, 'auth_key=', auth_key, '&ano=', ano,'&mes=', mes_aux)

    return(fread(csv_file) %>%
              mutate(Generacion_MWh = as.numeric(sub('x', '',
                                                     sub(',', '\\.',
                                                         sub('\\.', 'x', Generacion_MWh))))))
}

date_range <- seq(as.Date(paste(2014,1,1,sep='-'), format = '%Y-%m-%d'),
                 as.Date(paste(2018,9,1,sep='-'), format = '%Y-%m-%d'),
                 by = 'months')

years <- year(date_range)
months <- month(date_range)

pb <- txtProgressBar(min = 1, max = length(date_range), style = 3)

for(i in seq(1, length(date_range))){
    setTxtProgressBar(pb, i)
    df <- get_data(ano = years[i], mes = months[i])
    file <- paste0('Generacion Horaria/', years[i],'-',months[i],'.csv')
    write.csv(df, file = file)
    Sys.sleep(60)
}

## Agrupar por tipo de central.
df_hora <- data.frame()
files <- list.files('Generacion Horaria/')

it <- 1
pb <- txtProgressBar(min = 1, max = length(files), style = 3)
for(f in files){
    setTxtProgressBar(pb, it)
    file <- paste0('Generacion Horaria/', f)
    df_aux <- fread(file) %>%
        group_by(Date, Year, Month, Day, Hour, Tecnologia, Clasificacion, Subsistema) %>%
        summarise(Generacion_MWh = sum(Generacion_MWh)) %>%
        ungroup()
    df_hora <- bind_rows(df_hora, df_aux)
    it <- it + 1
}
close(pb)

## Arreglar algunos datos.
df_hora$Tecnologia[df_hora$Tecnologia == 'Carb?'] <- 'Carbón'
df_hora$Tecnologia[df_hora$Tecnologia == 'Cogeneraci?'] <- 'Cogeneración'
df_hora$Tecnologia[df_hora$Tecnologia == 'E?ica'] <- 'Eólica'
df_hora$Tecnologia[df_hora$Tecnologia == 'Mini Hidr?lica de Pasada'] <- 'Mini Hidráulica de Pasada'
df_hora$Tecnologia[df_hora$Tecnologia == 'Petr?eo Diesel'] <- 'Petróleo Diesel'

## Exportar a .csv
write.csv(df_hora, file = 'Generacion Horario Tecnologia.csv', row.names = FALSE)