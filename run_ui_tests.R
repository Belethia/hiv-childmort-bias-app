rm(list = ls())
if (!require(magrittr)){
  install.packages("magrittr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(magrittr)

if (!require(stringr)){
  install.packages("stringr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(stringr)

if (!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(dplyr)

if (!require(tidyr)){
  install.packages("tidyr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(tidyr)


if (!require(rvest)){
  install.packages("rvest",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(rvest)

if (!require(httr)){
  install.packages("httr",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(httr)

if (!require("Rcompression")) { 
  if(!require(devtools)){
    install.packages("devtools",dependencies = TRUE,repos='http://cran.us.r-project.org')
  }
  require(devtools)
  devtools::install_github("omegahat/Rcompression")
}
require(Rcompression)

if (!require(RSelenium)){
  install.packages("RSelenium",repos='http://cran.us.r-project.org')  
}

require(RSelenium)

if(!require(RUnit)){
  install.packages("RUnit")
}

require(RUnit)

if (!require(yaml)){
  install.packages("yaml",dependencies = TRUE,repos='http://cran.us.r-project.org')  
}

require(yaml)

base.path <- file.path(getwd())




# RSelenium::checkForServer(beta = TRUE)
# assume gecko driver is not in our path (assume windows and we downloaded to docs folder)
# if the driver is in your PATH the javaargs call is not needed
selServ <- RSelenium::startServer(javaargs = c("-Dwebdriver.chrome.driver=\"chromedriver\""))
#selServ <- RSelenium::startServer(javaargs = c("-Dwebdriver.gecko.driver=\"geckodriver\""))
## initialize a browsing session

remDr <- remoteDriver(browserName = "chrome")
#remDr <- remoteDriver(browserName = "firefox")


## start the browser 
remDr$open()

testsuite_prediction_table <- defineTestSuite("Prediciton Table", dirs=c("./ui.test"), testFileRegexp = "^test_predictionTable", testFuncRegexp = "^test_")

test.result_prediction_table <- runTestSuite(testsuite_prediction_table)



printTextProtocol(test.result_prediction_table)

remDr$close()
selServ$stop()

rm(list = ls() %>% Filter(function(x) x!="base.path",.))


