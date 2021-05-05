source("R/longitudinalExploration.R")
source("R/scatterExploration.R")
source("R/viewData.R")
library(shiny)
library(shinythemes)
library(DT)

shinyUI(
  fluidPage(
    theme = shinytheme("cerulean"),
    h1("Patient Lab Data"),
    tabsetPanel(
      tabPanel("View Data", fluid = T,
               tagList(
                 h3("View All Data"),
                 viewDataUI("data")
               )),
      tabPanel("Longitudinal Exploration", fluid = T,
               tagList(
                 h3("Longitudinal Exploration"),
                 longitudinalExplorationUI("long")
               )
      ),
      tabPanel("Scatterplot Exploration", fluid = T,
               tagList(
                 h3("Scatterplot Exploration"),
                 scatterExplorationUI("scatter")
               ))
    )
  )
)