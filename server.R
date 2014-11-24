

# Install packages (if necessary)
list.of.packages <- c("devtools", "datasets", "shiny")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(devtools)
library(datasets)
library(shiny)


list.of.packages <- c("CausalImpact")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) devtools::install_github("google/CausalImpact")

library(CausalImpact)
# devtools::install_github("google/CausalImpact")



shinyServer(function(input, output) {

    output$main_plot <- renderPlot({
        
        # matplot plots columns of a matrix
        par(mar=c(2,4,2,2.2))
        
        if(input$dataset == "Simulated Data") {
            matplot(simulate_data(input$obs, input$PIpct, input$pct_improvement, input$randseed), 
                    type = "l", ylab="", main="Simulated Time Series")   
            legend("bottomright", inset=c(.03,.4), legend=c("x", "y"), pch='-', 
                   col=c("red", "black"), text.col=c("red", "black"), horiz=TRUE)
        }
        else {
            matplot(treering[0:input$obs], type = "l", ylab="", main="Tree Ring Time Series")   
        }
    })
    

    output$causal_plot <- renderPlot ({
        
        if(input$dataset == "Simulated Data") {
            plot(
            causal_analysis(simulate_data(input$obs, input$PIpct, input$pct_improvement, input$randseed), 
                            (round(input$PIpct * input$obs)),
                            input$obs)
            )
        }
        else {
            plot(
                causal_analysis(treering[0:input$obs], 
                                (round(input$PIpct * input$obs)),
                                input$obs)
            )            
        }
    })
        
    output$causal_summary <- renderText ({ 
        
        if(input$dataset == "Simulated Data") {
            (causal_analysis(simulate_data(input$obs, input$PIpct, input$pct_improvement, input$randseed), 
                             (round(input$PIpct * input$obs)), input$obs)
            )$report
        }
        else {
            (causal_analysis(treering[0:input$obs], round(input$PIpct * input$obs), input$obs)
            )$report            
        }
    })

})


# supporting functions
# --------------------

# simulate_data creates a simulated time series
simulate_data <- function(nobs=100, trtmtStart=.7, improvement=.1, seedVal=293) {
    
    set.seed(seedVal)
    
    x1 <- 100 + arima.sim(model = list(ma = 0.999), n = nobs)
    y  <- 1.2 * x1 + rnorm(nobs)

    trtmt.start <- round(trtmtStart * nobs)

    y[trtmt.start:nobs] <-  y[trtmt.start:nobs] * (1 + improvement)

    data <- cbind(y, x1)
    
    return(data)
}



# Returns a CausalImpact object
causal_analysis <- function(data, preperiodend, maxobs) {
     
    preperiod  <- c(1, preperiodend)
    postperiod <- c(preperiodend+1, maxobs)
    
    CausalImpact(data, preperiod, postperiod)
}