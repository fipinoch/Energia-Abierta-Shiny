# Energía Abierta Shiny
Shiny Visualization of Chilean Energy Production SEN (SIC and SING) and uploaded to the shinyapps.io (https://fipinoch.shinyapps.io/energia_abierta/). 

Data obtained from http://energiaabierta.cl/ using its Open Data API. The monthly data for generation can be obtained directly using the get_generacion_bruta.R script in R and a proper authentification key for the API.

Manipulation of the data easily made with the dplyr library, visualizations using ggplot2 library and interactivity with the plotly library.
