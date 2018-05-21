#Create Train and Test
# SRS without replacement
set.seed(12)
train.rows <- sample(9773, 8000)
speed.train <- speed.last[train.rows,]
speed.test <- speed.last[-train.rows,]

#validate the similarity between train and test
summary(speed.train$speed)
summary(speed.test$speed)


#Grow a Random Forest on train 
#validate predictions of test

library(randomForest)

#fit model
out.speed <- randomForest(x= speed.train[,-18], y= speed.train$speed,
                          xtest=speed.test[,-18], ytest=speed.test$speed,
                          replace = TRUE, #bootstrap samples for trees
                          keep.forest = TRUE,
                          ntree = 100, mtry = 5, nodesize = 25)
# Predict for new obs
predict(out.speed, newdata = new.obs)

#Prediction Performance
out.speed
#Compute RMSE
sqrt(49.01889) #train
sqrt(50.37)    #test

#Model Insight (interpretation)
importance(out.speed)
varImpPlot(out.speed)

#Research Task and Data Features that Match Analysis Strengths:
#Predict Response Variable based on given explanatory variables
#Data is tall and wide, random forests work well with this type of data

#Analysis Weaknesses:
#It is a black box, it gives answers, but we don't really know how

#Challenge Question:
#Using the data provided, a random forest could be used to determine the time of day a person is likely to get a ticket
#based on speed and other explanitory variables.