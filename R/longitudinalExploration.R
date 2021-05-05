longitudinalExplorationUI <- function(id){
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("selectTestUI")),
    radioButtons(ns("plotType"), label = "Select type of plot", 
                 choices = list("Boxplot by groups" = "boxplot",
                                "Single patient progress" = "point")),
    uiOutput(ns("selectColorColUI")),
    uiOutput(ns("selectSubjectUI")),
    plotOutput(ns("timePlot"))
  )
}

longitudinalExploration <- function(input, output, session, labValues, ptValues){
  ns <- session$ns
  
  # UI for selecting test
  output$selectTestUI <- renderUI({
    labValues = labValues()
    selectInput(ns("test"), label = "Select Test", multiple = F,
                choices = unique(labValues$LBTEST))
  })
  
  # reactive function to merge data
  getAllData <- reactive({
    labValues = labValues()
    ptValues = ptValues()
    allValues = merge(ptValues, labValues, by = c("STUDYID", "USUBJID"))
    allValues
  })
  
  # UI for boxplot - color by
  output$selectColorColUI <- renderUI({
    allValues = getAllData()
    catCols = colnames(allValues)[grepl('factor|logical|character', 
                                        sapply(allValues, class))]
    
    conditionalPanel(paste0("input['", ns("plotType"), "'] == 'boxplot'"),
                     selectInput(ns("catCol"), 
                                 label = "Select categorical variable to color by",
                                 choices = c(unique(catCols), "Do not color"),
                                 selected = "Do not color"))
  })
  
  # UI for selecting subject
  output$selectSubjectUI <- renderUI({
    labValues = labValues()
    conditionalPanel(paste0("input['", ns("plotType"), "'] == 'point'"),
                     selectInput(ns("subjectID"), 
                                 label = "Select subject to explore",
                                 choices = unique(labValues$USUBJID)),
                     verbatimTextOutput(ns("patientInfo")))
  })
  
  # text to print selected subject information
  output$patientInfo <- renderText({
    ptValues = ptValues()
    ptRow = data.frame(ptValues[USUBJID == input$subjectID])
    info = paste("Subject", input$subjectID, "information:\n")
    for(i in 1:ncol(ptRow)){
      info = paste0(info, colnames(ptRow)[i], ": ", ptRow[1,i], "\n")
    }
    info
  })
  
  # outplot
  output$timePlot <- renderPlot({
    allValues = getAllData()
    req(input$test)
    to.plot = allValues[LBTEST == input$test]
    if(input$plotType == "point"){
      to.plot = to.plot[USUBJID == input$subjectID]
    }
    
    g = ggplot(data = to.plot, aes(x = AVISIT, y = AVAL)) +
      xlab("Visit") +
      ylab(paste0("Test Value (", unique(to.plot$AVALU), ")"))
    
    if(input$plotType == "boxplot"){
      if(input$catCol != "Do not color"){
        g = g + geom_boxplot(aes_string(color = input$catCol))
      } else{
        g = g + geom_boxplot()
      }
        
    } else{
      g = g + geom_point()
    }
    
    g
    
  })
}