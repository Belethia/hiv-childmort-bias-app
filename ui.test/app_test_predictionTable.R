if (!require(shiny)){
  install.packages("shiny",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(shiny)

if (!require(shinyWidgets)){
  install.packages("shinyWidgets",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(shinyWidgets)




source(file.path(base.path,"modules.R"))



if (!require(yaml)){
  install.packages("yaml",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(yaml)


load(file.path(base.path,"model.RData"))

shinyApp(
  
  fluidPage(
    
    predictionTableUI("myPredictionTable"),
    actionButton("change_things","Change things")
    
    
  ),
  function(input, output, session){
    
    
    vals <- reactiveValues(newdata=newdata)
    
    
    
    values <- callModule(predictionTable, "myPredictionTable", model, vals$newdata)
    
    
    observeEvent(input$change_things,{
      
      vals$newdata <- newdata2
      
    })
    
  }
)