#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
source("modules.R")

load("best_fitting_model.RData")
load("boot_models.RData")

boot_models <- boot_models[1:350]

# Define UI for application that draws a histogram
ui <- fluidPage(
  

  mainPanel(
    
    column(width=12,
           tags$h1("Population Characteristics"),
           wellPanel(
             fluidRow(
               column(width=3,
                      tags$h3("HIV prevalence"),
                      numericInput("hiv1990",
                                   "20 Year prior to survey:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),
                      numericInput("hiv2000",
                                   "10 Year prior to survey:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),
                      numericInput("hiv2010",
                                   "Year of survey:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),
                      actionButton("compute","Submit",style="color: #fff; background-color: #982C25; border-color: #000000")
                      
               ),
               column(width=3,
                      tags$h3("ART prevalence*"),
                      numericInput("art_prev2005",
                                   "2005:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),
                      numericInput("art_prev2007",
                                   "2007:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),
                      numericInput("art_prev2009",
                                   "2009:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      )
                      
               ),
               
               column(3,
                      tags$h3("Total Fertility Rate"),
                      numericInput("tfr2000",
                                   "10 Year prior to survey:",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      ),numericInput("tfr2010",
                                     "Year of survey",
                                     min = 0,
                                     max = 1,
                                     value = 0.5,
                                     step=0.05,
                                     width='110px'
                      )
                      
               ),
               column(width=3,
                      tags$h3("Under-5 mortality**"),
                      numericInput("fiveq0_surv",
                                   "",
                                   min = 0,
                                   max = 1,
                                   value = 0.5,
                                   step=0.05,
                                   width='110px'
                      )
                      
               )
               
             )
           ),
           tags$p("*ART prevalence: Percent of women aged 15-49 years who are on anti-retorviral therapy"),
           tags$p("** Crude estimate of under-5 mortality for all age groups")
           
    ),
    column(width=4,
           tags$h1("Prediction"),
           wellPanel(style = "background: white",
             fluidRow(
               predictionTableUI("myPredictionTable")
             )
           )
           
    )
  ) 
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$compute,{
    
    age_label <- c("[15,20)","[20,25)","[25,30)","[30,35)","[35,40)","[40,45)","[45,49]")
    
    
    newdata <- data.frame(agegroup=factor(1:7),fiveq0_surv=input$fiveq0_surv,hiv1990=input$hiv1990,hiv2000=input$hiv2000,hiv2010=input$hiv2010,art_prev2005=input$art_prev2005,art_prev2007=input$art_prev2007,art_prev2009=input$art_prev2009,tfr2000=input$tfr2000,tfr2010=input$tfr2010,age_label=age_label)
    
    callModule(predictionTable, "myPredictionTable", best.fitting.model,x,boot_models,full.model.formula, newdata)  
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

