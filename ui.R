
library(shiny)

# Define UI for causal impact demo
shinyUI(fluidPage(
    
    #  Application title
    titlePanel("Causal Impact: Detecting Intervention Effects"),
    
    # get user inputs
    sidebarLayout(
        sidebarPanel(
            fluidRow(h5("Causal Impact takes a Bayesian approach to estimating the effect of 
                        an intervention, such as an ad campaign, or in the case of tree ring data,
                        perhaps a change in climate."
                        )),
            
            br(), 
            
            # a select input
            selectInput('dataset', 
                        fluidRow("Select a data set:"),
                        choices = list("Simulated Data", "Tree Ring Data")),
            
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
                                 "(for simulation data only):"),
                        min = -.02, max = .02, value = .010, step=.002, format="##.###%"), 

            br(),
            
            # text input
            textInput("randseed", fluidRow("Set the random seed", br(), 
                                           "(for simulation data only):"),
                      value = "293"),
            
            br(),
            
            fluidRow(h6("CausalImpact 1.0.3, Brodersen et al.,", br(), "Annals of Applied Statistics (in press). 
                        http://google.github.io/CausalImpact/"))
        ),
        
        # output panel
        mainPanel(
            
            # plotOutput(outputId = "main_plot", height = "200px"),
            
            plotOutput(outputId = "causal_plot", height = "450px"),
            
            textOutput(outputId = "causal_summary")
        )
    )
))