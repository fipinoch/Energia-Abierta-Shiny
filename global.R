library(dplyr)
library(shiny)
library(ggplot2)
library(plotly)
library(lubridate)
library(data.table)

df_hora <- fread('Generacion Horario Tecnologia.csv')
df_hora$Tecnologia <- as.factor(df_hora$Tecnologia)
df_hora$Clasificacion <- as.factor(df_hora$Clasificacion)
df_hora$Subsistema <- as.factor(df_hora$Subsistema)

tec_color <- c('Biomasa' = '#006600',
               'Carbón' = '#000000',
               'Cogeneración' = '#777777',
               'Eólica' = '#009900',
               'Gas Natural' = '#CCCCCC',
               'Geotermica' = '#CC0000',
               'Hidráulica de Embalse' = '#0033CC',
               'Hidráulica de Pasada' = '#3366FF',
               'Mini Hidráulica de Pasada' = '#6699FF',
               'Petróleo Diesel' = '#444444',
               'Solar Fotovoltaica' = '#FFCC00')

new_tec_level <- c('Solar Fotovoltaica',
               'Eólica',
               'Biomasa',
               'Geotermica',
               'Hidráulica de Embalse',
               'Hidráulica de Pasada',
               'Mini Hidráulica de Pasada',
               'Gas Natural',
               'Cogeneración',
               'Petróleo Diesel',
               'Carbón')