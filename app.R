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
           tags$h1(tags$a(href="https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-019-7780-3","Correct bias in indirect estimates of under-5 mortality due to HIV/AIDS")),
           tags$p("This webpage allows the user to apply the method described in Quattrochi et al. 2019 Measuring and correcting bias in indirect estimates of under-5 mortality in populations
affected by HIV/AIDS: a simulation study. BMC Public Health. It requires the crude indirect estimates of under-5 mortality and the population characteristics listed below. The time reference for each of the corrected estimates is the same as for the crude estimates. The full code is available here: ", 
                  tags$a(href="https://github.com/jquattro/hiv-childmort-bias","https://github.com/jquattro/hiv-childmort-bias")),
           wellPanel(
             fluidRow(
               fluidRow(column(12,tags$h3("HIV prevalence"),tags$p("Please enter the prevalence as a proportion. For example, 10% prevalence should be entered as 0.1."))),
               fluidRow(
                 column(3,
                        numericInput("hiv1990",
                                     "20 years prior to survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 ),
                 column(3,
                        numericInput("hiv2000",
                                     "10 years prior to survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 ),
                 column(3,
                        numericInput("hiv2010",
                                     "Year of survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 )
               )
             ),
             fluidRow(
               fluidRow(column(width=12,tags$h3("ART prevalence*"),tags$p("Please enter the prevalence as a proportion. For example, 10% prevalence should be entered as 0.1."))),
               fluidRow(
                 column(width=3,
                        numericInput("art_prev2005",
                                     "5 years before the survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 ),
                 column(width=3,
                        numericInput("art_prev2007",
                                     "3 years before the survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 ),
                 column(width=3,
                        numericInput("art_prev2009",
                                     "1 year before the survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 )
               )
             ),
             fluidRow(
               fluidRow(
                 column(12,
                        tags$h3("Total Fertility Rate")
                 )
               ),
               fluidRow(
                 column(3,
                        numericInput("tfr2000",
                                     "10 years prior to survey:",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                 ),
                 column(3,
                        numericInput("tfr2010",
                                     "Year of survey",
                                     min = 0,
                                     max = 1,
                                     value = NA,
                                     step=0.05,
                                     width='175px'
                        )
                        
                 )
               )
             ),
             
             fluidRow(
               fluidRow(column(12,tags$h3("Under-5 mortality**"),tags$p("Please enter the mortality rate as a proportion. For example, 100 deaths per 1,000 live births should be entered as 0.1."))),
               column(12,
                      
                      fluidRow(
                        fluidRow( 
                          column(3,
                                 numericInput("fiveq0_surv_1",
                                              "15-19 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          ),
                          column(3,
                                 numericInput("fiveq0_surv_2",
                                              "20-24 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          ),
                          column(3,
                                 numericInput("fiveq0_surv_3",
                                              "25-29 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          ),
                          column(3,
                                 numericInput("fiveq0_surv_4",
                                              "30-34 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          )
                          
                        ),
                        fluidRow( 
                          column(3,
                                 numericInput("fiveq0_surv_5",
                                              "35-39 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          ),
                          column(3,
                                 numericInput("fiveq0_surv_6",
                                              "40-45 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          ),
                          column(3,
                                 numericInput("fiveq0_surv_7",
                                              "45-49 year old women",
                                              min = 0,
                                              max = 1,
                                              value = NA,
                                              step=0.05,
                                              width='175px'
                                 )
                          )
                        )
                      )
               )
             ),
             tags$p("*ART prevalence: Percent of women aged 15-49 years who are on anti-retorviral therapy"),
             tags$p("** Crude estimate of under-5 mortality for all age groups.")
           ),
           actionButton("compute","Submit",style="color: #fff; background-color: #982C25; border-color: #000000"),
           tags$p("Please allow 1-2 minutes for predictions to appear while bootstrapped estimates of uncertainty are calculated.")
           
    ),
    column(width=12,
           fluidRow(column(12,tags$h1("Corrected estimates of U5M"))),
           fluidRow(
             column(8,
                    wellPanel(style = "background: white",
                              fluidRow(
                                predictionTableUI("myPredictionTable")
                              )
                    )
             )
           )
           
    ),
      tags$p(style="font-size: 10px;font-style: italic;",
        "This page was created by ",tags$a(href="https://www.linkedin.com/in/jlherreracortijo","Juan Luis Herrera Cortijo")," and John Quattrochi.")
    
  ) 
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$compute,{
    
    checks <- c(fiveq0_surv_1="Under-5 mortality for 15-19 year old women is missing.",
                fiveq0_surv_2="Under-5 mortality for 20-24 year old women is missing.",
                fiveq0_surv_3="Under-5 mortality for 25-29 year old women is missing.",
                fiveq0_surv_4="Under-5 mortality for 30-34 year old women is missing.",
                fiveq0_surv_5="Under-5 mortality for 35-39 year old women is missing.",
                fiveq0_surv_6="Under-5 mortality for 40-44 year old women is missing.",
                fiveq0_surv_7="Under-5 mortality for 45-49 year old women is missing.",
                hiv1990="HIV prevalence 20 years prior to survey is missing.",
                hiv2000="HIV prevalence 10 years prior to survey is missing.",
                hiv2010="HIV prevalence on the year of the survey is missing."
                
    )
    
    all_inputs_filled <- names(checks) %>% map(~{
      
      valid<- !is.na(input[[.x]])
      
      if(!valid) showNotification(checks[.x])
      
      valid
      
    }) %>% unlist() %>% all
    
    if(all_inputs_filled){
      age_label <- c("[15,20)","[20,25)","[25,30)","[30,35)","[35,40)","[40,45)","[45,49]")
      
      fiveq0_surv <- as.numeric(c(input$fiveq0_surv_1,input$fiveq0_surv_2,input$fiveq0_surv_3,input$fiveq0_surv_4,input$fiveq0_surv_5,input$fiveq0_surv_6,input$fiveq0_surv_7))
      
      newdata <- data.frame(agegroup=factor(1:7),fiveq0_surv=fiveq0_surv,hiv1990=input$hiv1990,hiv2000=input$hiv2000,hiv2010=input$hiv2010,art_prev2005=input$art_prev2005,art_prev2007=input$art_prev2007,art_prev2009=input$art_prev2009,tfr2000=input$tfr2000,tfr2010=input$tfr2010,age_label=age_label)
      
      callModule(predictionTable, "myPredictionTable", best.fitting.model,x,boot_models,full.model.formula, newdata)  
    }
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

