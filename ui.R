
library(shiny)

# Define UI for causal impact demo
shinyUI(fluidPage(
    
    #  Application title
    titlePanel("Causal Impact: Detecting Intervention Effects"),
    
    # get user inputs
    sidebarLayout(
        sidebarPanel(
            fluidRow(h5("Causal Impact takes a Bayesian approach to estimating the effect of 
                        an intervention, such as an ad campaign.", br(), br(), 
                        "It only has access to the data itself and when the intervention began.", br(), br(),
                        "CausalImpact 1.0.3, Brodersen et al.,", br(), "Annals of Applied Statistics (in press). 
                        http://google.github.io/CausalImpact/")),
            
            br(),
            
            # a select input
            selectInput('dataset', 
                        fluidRow("Select a data set", br(),
                                 "Tree ring data has no intervention;", br(), 
                                 "Simulated data has intervention"),
                        choices = list("Simulated Data", "Tree Ring Data")),

            br(),    
            
            # text input
            textInput("randseed", fluidRow("Set the random seed", br(), "(for simulation only):"),
                      value = "293"),
            
            br(),
            
            # the number of observations
            sliderInput("obs", "Number of Observations:", 
                        min=100, max=500, value=350, step=50),
            
            br(), 
            
            # set the beginning of the intervention period as pct of total observations
            sliderInput("PIpct", 
                        fluidRow("Start of Intervention Period", br(), 
                                 "(as a percentage of total obs):"),
                        min = .2, max = .9, step=.05, value=.7, format="##%"),
            
            br(),
            
            # improvement during treatment or intervention period
            sliderInput("pct_improvement", 
                        fluidRow("Pct Improvement During Intervention", br(),
                                 "(for simulation only):"),
                        min = -.02, max = .02, value = .010, step=.002, format="##.###%")
        ),
        
        # output panel
        mainPanel(
            
            plotOutput(outputId = "main_plot", height = "200px"),
            
            plotOutput(outputId = "causal_plot", height = "300px"),
            
            textOutput(outputId = "causal_summary")
        )
    )
))