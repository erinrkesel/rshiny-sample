viewDataUI <- function(id){
  ns <- NS(id)
  
  tagList(
    DT::dataTableOutput(ns("table")),
    downloadButton(ns("all"), label = "Download All Data",
                   icon("download"),
                   style="color: #007ba7; background-color: #080808; 
                   border-color: #2e6da4"),
  )
}

viewData <- function(input, output, session, labValues, ptValues){
  ns <- session$ns
  
  # reactive function to merge data
  getAllData <- reactive({
    labValues = labValues()
    ptValues = ptValues()
    allValues = merge(ptValues, labValues, by = c("STUDYID", "USUBJID"))
    allValues
  })
  
  # Data table showing data
  output$table <- DT::renderDataTable({
    getAllData()
  })
  
  # download - all data
  output$all <- downloadHandler(
    filename = function(){
      paste("alldata.csv")
    },
    content = function(file){
      write.csv(getAllData(), file, row.names = F)
    }
  )
}