scatterExplorationUI <- function(id){
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("selectXCols")),
    uiOutput(ns("selectYCols")),
    uiOutput(ns("selectColorColUI")),
    plotOutput(ns("scatterPlot")),
  )
}

scatterExploration <- function(input, output, session, labValues, ptValues){
  ns <- session$ns
  
  # ui for selecting x axis data
  output$selectXCols <- renderUI({
    labValues = labValues()
    numericCols = names(which(sapply(labValues, is.numeric)))
    selectInput(ns("xCol"), label = "Select x-axis data",
                choices = numericCols)
  })
  
  # ui for selecting y axis data
  output$selectYCols <- renderUI({
    req(input$xCol)
    labValues = labValues()
    numericCols = names(which(sapply(labValues, is.numeric)))
    selectInput(ns("yCol"), label = "Select y-axis data",
                choices = numericCols[numericCols != input$xCol])
  })
  
  # reactive function to merge data
  getAllData <- reactive({
    labValues = labValues()
    ptValues = ptValues()
    allValues = merge(ptValues, labValues, by = c("STUDYID", "USUBJID"))
    allValues
  })
  
  # UI for color by
  output$selectColorColUI <- renderUI({
    allValues = getAllData()
    catCols = colnames(allValues)[grepl('factor|logical|character', 
                                        sapply(allValues, class))]
    selectInput(ns("catCol"), label = "Select categorical variable to color by",
                choices = c(unique(catCols), "Do not color"),
                selected = "Do not color")
  })
  
  # scatterplot
  output$scatterPlot <- renderPlot({
    allValues = getAllData()
    req(input$xCol, input$yCol)
    g = ggplot(data = allValues, aes_string(x = input$xCol, y = input$yCol))
    if(input$catCol == "Do not color"){
      g = g + geom_point()
    } else{
      g = g + geom_point(aes_string(color = input$catCol))
    }
    g
  })
}