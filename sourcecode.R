# source.R

library(shiny)
library(ggplot2)
library(markdown)

# Get dataset
dataset <- stackloss

# Set cn - Column names array
cn <- names(dataset)

# Set  Column Description
cnDesc <- list(Air.Flow =  "Flow of cooling air",
              Water.Temp = "Cooling Water Inlet Temperature",
              Acid.Conc.= "Concentration of acid [per 1000, minus 500]",
              stack.loss  = "Stack loss")