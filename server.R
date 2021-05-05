library(data.table)
library(ggplot2)
library(shiny)
library(shinythemes)
library(DT)

source("R/longitudinalExploration.R")
source("R/scatterExploration.R")
source("R/viewData.R")

shinyServer(
  function(input, output, session){
    labValues = reactive(
      fread("Random_LabValuesInfo_2021.tsv")
    )
    
    ptValues = reactive(
      fread("Random_PatientLevelInfo_2021.tsv")
    )
    callModule(viewData, "data", labValues, ptValues)
    callModule(longitudinalExploration, "long", labValues, ptValues)
    callModule(scatterExploration, "scatter", labValues, ptValues)
  }

)