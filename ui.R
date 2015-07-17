## @knitr ui.R
# -----------------------------------------------------------------------------
# This module is the ui part of a ShinyApp that predicts the birth weight
# of an infant based on the data collected about the mother. 
#
# The project uses the birthwt dataset from the MASS library, which 
# has 189 observations, capturing infant birth weight along with details of
# key risk factors associated with the mother, to train two regression models,
# Random Forest (rf) and Gradient Boosted Model (gbm), for prediction with 
# new data input by the user from the ui part of the ShinyApp.
# -----------------------------------------------------------------------------

shinyUI(fluidPage(
    h2("Low Birth Weight Prediction Tool"),
    p('This simple prediction tool accepts a set of key data points about an expectant mother
       and fits the data to machine learning models to predict the birth weight 
       of her unborn infant.'),
    p('If the predicted birth weight of her infant is below 2500g, the tool will
       indicate that the risk of LBW is assessed to be Positive.'),
    br(),
    
    sidebarLayout(

      sidebarPanel(
        h4('Mother\'s Data : '),
        sliderInput(inputId = "age",
          label = "Age (in Years)", 
            25, min = 10, max = 80, step = 1),

        numericInput(inputId = "lwt",
          label = "Weight at last Menstrual Period (in kg)", 
            45, min = 20, max = 150, step = 5),

        selectInput(inputId = "race",
          label = "Ethnic Race",
          choices = c("White","Black","Others"),
          selected = "White"),

        radioButtons(inputId = "smoke",
          label = "Smoked during Pregnancy?",
          choices = c("Yes","No"),
          selected = "No",
          inline = TRUE),

        radioButtons(inputId = "ptd",
          label = "Has a History of Premature Labour?",
          choices = c("Yes","No"),
          selected = "No",
          inline = TRUE),
    
        radioButtons(inputId = "ht",
          label = "Has a History of Hypertension?",
          choices = c("Yes","No"),
          selected = "No",
          inline = TRUE),

        radioButtons(inputId = "ui",
          label = "Has a History of Uterine Irritability?",
          choices = c("Yes","No"),
          selected = "No",
          inline = TRUE)

      ),
  
      mainPanel(
          tabsetPanel(type="tabs",
                      tabPanel("Prediction",
                               br(),
                               h4('Prediction Methods'),                               
                               radioButtons(inputId = "predmthd",
                                            label = "Select a Prediction Method",
                                            choices = c("Random Forest","Gradient Boosted Regression"),
                                            selected = "Random Forest"),
                               br(),
                               h4('\nPrediction Results'),
                               verbatimTextOutput("prediction")
                      ),
                      
                      tabPanel("Documentation", 
                               h4('What is Low Birth Weight (LBW)?'),
                               p('Low birth weight (LBW) is defined as a birth weight of 
                                  a liveborn infant of less than 2500g regardless of 
                                  gestational age.  LBW is closely associated with a 
                                  higher risk of infant and childhood mortality, 
                                  inhibited growth and cognitive development, and 
                                  chronic diseases later in life.'),
                               br(),
                               h4('\nHow to use this LBW Prediction Tool?'),
                               p('To use this tool, simply :'),
                               p('  1. Go to the Sidebar Panel, and enter the expectant mother\'s data.'),
                               p('  2. Click on the Prediction Tab, and select one of the two supported prediction methods.'),
                               p('  3. Wait a few seconds and the infant\'s predicted birth weight will be output.'), 
                               p('  4. Based on the predicted value, it will also indicate if it is LBW Risk Positive.'),
                               br(),
                               
                               h4('\nWhy does this LBW Prediction Tool support two prediction methods?'),                             
                               p('Different machine learning methods have different characteristics, causing their
                                  prediction results to vary.'),
                               
                               p('This tool supports two prediction methods to allow the user a chance to review and 
                                 compare the predicted values from both methods, especially in borderline cases.'),
                               
                               p('Random Forest and Gradient Boosted Regression ensemble methods are two of 
                                  the most popular machine learning methods applicable for regression and 
                                  classification problems.')
                               
                      )
          )
      )
    )
))
