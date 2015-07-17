# -----------------------------------------------------------------------------
# This module is the server part of a ShinyApp that predicts the birth weight
# of an infant based on the data collected about the mother. 
#
# The project uses the birthwt dataset from the MASS library, which 
# has 189 observations, capturing infant birth weight along with details of
# key risk factors associated with the mother, to train two regression models,
# Random Forest (rf) and Gradient Boosted Model (gbm), for prediction with 
# new data input by the user from the ui part of the ShinyApp.
# -----------------------------------------------------------------------------
library(MASS)
library(randomForest)
library(gbm)
library(caret)

# 
# This section is where the dataset is loaded and the two regression models 
# are trained with the dataset.
#
cat("Extracting the Birth Weight Sample Data Set\n")
training <- with(birthwt, {
    race <- factor(race, labels = c("White", "Black", "Others"))
    ftv <- factor(ftv)
    levels(ftv)[-(1:2)] <- "2+"
    data.frame(bwt, age, lwt, race, smoke = (smoke > 0),
               ptd = (ptl > 0), ht = (ht > 0), ui = (ui > 0))
})

set.seed(62433)
trc=trainControl(method="cv", number=3)

cat("RandomForest Model: Training in progress...  Please wait...\n")
rf_fit <- train(bwt ~ ., data=training, method="rf", trControl=trc, verbose=FALSE)

cat("Gradient Boosted Model: Training in progress...  Please wait...\n")
gbm_fit <- train(bwt ~ ., data=training, method="gbm", trControl=trc, verbose=FALSE)

cat("Model Training completed.\n")

# This section is the ShinyApp server
#

shinyServer(function(input, output) {
        
        output$prediction <- renderText({ 
            testing <- data.frame(age=input$age, 
                              lwt=(input$lwt * 2.2046),   # Convert kg to lb
                              race=input$race, 
                              smoke=as.logical(input$smoke == "Yes"), 
                              ptd=as.logical(input$ptd == "Yes"), 
                              ht=as.logical(input$ht == "Yes"), 
                              ui=as.logical(input$ui == "Yes"))

            # Call the predict() function based on the user-selected method
            if (input$predmthd == "Random Forest")
                pred <- predict(rf_fit, new=testing)
            else 
                if (input$predmthd == "Gradient Boosted Regression")
                    pred <- predict(gbm_fit, new=testing)
                else
                    return("Error : Unsupported Prediction Method Selected")
        
            # Check if the predicted value is less than the LBW Threshold of 2500.
            # If true, append the comment the predicted value is LBW Risk Positive.
            pred_bwt <- round(pred[1], 0)
            if (pred_bwt < 2500)
                return(paste0("Predicted Birth Weight : ", 
                              as.character(pred_bwt),
                              "g (!!! LBW Risk Positive !!!)"))
            else 
                return(paste0("Predicted Birth Weight : ", 
                              as.character(pred_bwt),
                              "g"))

        })
})
