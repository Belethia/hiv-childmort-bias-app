if(!require(flextable)){
  install.packages("flextable",dependencies = TRUE,repos='http://cran.us.r-project.org')
}


require(flextable)


if(!require(bcaboot)){
  install.packages("bcaboot",dependencies = TRUE,repos='http://cran.us.r-project.org')
}


require(bcaboot)


if(!require(glmnet)){
  install.packages("glmnet",dependencies = TRUE,repos='http://cran.us.r-project.org')
}


require(glmnet)

if (!require(magrittr)){
  install.packages("magrittr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(magrittr)

if (!require(tidyverse)){
  install.packages("tidyverse",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(tidyverse)


##### predictionTable #####

predictionTableUI <- function(id){
  ns = NS(id)
  
  
  tagList(uiOutput(ns("prediction_table")))
  
}


predictionTable <- function(input,output,session,model,x,boot_models,model.formula,newdata){
  
  
  output$prediction_table <- renderUI({
    age_label <- c("[15,20)","[20,25)","[25,30)","[30,35)","[35,40)","[40,45)","[45,49]")
    
    to.predict <- newdata 
    
    to.predict <- model.matrix(model.formula,to.predict %>% mutate(corr=0))[,-1]
    
    z.value <- qnorm((1 + 0.95)/2)
    
    withProgress(message = 'Computing...', value = 0, {
      prediction <- lapply(1:7,function(i){
        # i<- 1
        nx <- to.predict[i,,drop=FALSE]
        t0 <- predict(model,newx = nx,s="lambda.min") %>% as.vector
        tt <- boot_models %>%purrr::map(~predict(.,newx = nx,s="lambda.min") %>% as.vector) %>% unlist()
        lambda <- model$lambda.min
        theta <- as.matrix(coef(model, s = lambda))
        pi_hat <- predict(model, newx = x, s = "lambda.min", type = "response")
        n <- length(pi_hat)
        
        
        
        y_star <- (matrix(runif(n*length(tt)),ncol=length(tt)) <= matrix(rep(pi_hat,length(tt)),ncol=length(tt)))*1
        
        suff_stat <- t(y_star) %*% x
        
        r <- bcapar(t0=t0,tt=tt,bb=suff_stat)
        
        ci <- r$lims %>% as.data.frame() %>% mutate(quantile=as.numeric(rownames(.))) %>% filter(quantile %in% c(0.025,0.975)) %>% select(quantile,bca) %>% mutate(quantile=case_when(quantile==0.025 ~ "ci.lo",TRUE~ "ci.hi"),bca=bca++newdata$fiveq0_surv[i]) %>% spread(quantile,bca)
        
        r <- data.frame(agegroup=newdata$age_label[i], fit=t0+newdata$fiveq0_surv[i],ci)
        
        incProgress(1/7, detail = paste("Age ", age_label[i]))
        
        r
      }) %>% bind_rows()
      
    })
    prediction %<>% 
      mutate(Output=sprintf("%0.2f\n(%0.2f; %0.2f)",fit,ci.lo,ci.hi)) %>% 
      select(agegroup,Output)
    
    prediction %>% flextable() %>% 
      add_footer(agegroup="Values in parenthesis are 95% prediction intervals.") %>%
      merge_at(j=1:ncol(prediction),part="footer") %>%
      set_header_labels(agegroup="Age Group",Output="Corrected U5M") %>%
      width(width=2)%>%
      height(height = 0.75,part = "body")%>%
      height(height = 0.75,part = "header")%>%
      height(height = 0.75,part = "footer")%>%
      bold(part="header")%>%
      align(j=1,part="body",align = "left") %>%
      align(j=2,part="body",align = "center") %>%
      align(part="header",align = "center") %>%
      fontsize(size=18,part = "body") %>%
      fontsize(size=24,part = "header") %>%
      fontsize(size=16,part = "footer") %>%
      htmltools_value()
  })
  
}

destroy_predictionTable_observers <- function(values){
  
  
}