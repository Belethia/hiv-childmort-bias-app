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

age_label <- c("[15,20)","[20,25)","[25,30)","[30,35)","[35,40)","[40,45)","[45,49]")

newdata <- model$model%>% rename(agegroup=`as.factor(agegroup)`,corr2=`abs(corr2)`) %>% group_by(agegroup) %>% summarise_all(funs(mean)) %>% ungroup %>% mutate(age_label=age_label[agegroup])

newdata2 <- model$model%>% rename(agegroup=`as.factor(agegroup)`,corr2=`abs(corr2)`) %>% group_by(agegroup) %>% summarise_all(funs(median)) %>% ungroup %>% mutate(age_label=age_label[agegroup])

shinyApp(
  
  fluidPage(
    
    predictionTableUI("myPredictionTable"),
    actionButton("change_things","Change things")
    
    
  ),
  function(input, output, session){
    
    
    vals <- reactiveValues(newdata=newdata)
    
    
    
    values <- callModule(predictionTable, "myPredictionTable", model, reactive(vals$newdata))
    
    
    observeEvent(input$change_things,{
      
      vals$newdata <- newdata2
      
    })
    
  }
)