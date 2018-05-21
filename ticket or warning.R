# Tree-based Classification

#Analysis Ticket or Warning? 

#Montgomery County Traffic Stops Data

source('https://grimshawville.byu.edu/TrafficStops2017a.R')

#EDA
#Table of Categorical Response Variable
table(ticket.last$Ticket)
prop.table(table(ticket.last$Ticket))

#Create a dataset with half goods (warnings) and half bads (tickets)
all.bad <- subset(ticket.last, Ticket=="TRUE")
n.bad <- dim(all.bad)[1]
#SRS without replacement from the goods
all.good <- subset(ticket.last, Ticket=="FALSE")
n.good <- dim(all.good)[1]
set.seed(12)
rows.good <- sample(n.good,n.bad)
sample.good <- all.good[rows.good,]

ticket.model <- rbind(all.bad, sample.good)

#Create Train and Test
train.rows <- sample(159134,125000)
ticket.train <- ticket.model[train.rows,]
ticket.test <- ticket.model[-train.rows,]

#Validate similarities between train and test
summary(ticket.train$Ticket)
summary(ticket.test$Ticket)

#Grow a Random Forest
library(randomForest)

#fit model
out.ticket <- randomForest(x=ticket.train[,-17], y=ticket.train$Ticket,
                           xtest=ticket.test[,-17], ytest=ticket.test$Ticket,
                           replace = TRUE,
                           keep.forest = TRUE,
                           ntree = 100, mtry = 4, nodesize = 25)

#Predict new obs
ticket.new.obs <- ticket.model[145685,]
predict(out.ticket, ticket.new.obs)

#Prediction Performance
out.ticket
#31.75% - TRAIN
#31.3%  - TEST

#Model Insight (interpredation)
importance(out.ticket)
varImpPlot(out.ticket)
#Color Hour and Auto Year most "important"

#Research Task: Predict whether or not a ticket would be issued given certain eplanatory variables
#Data Features: tall and wide, random forests work well with this type of data

#Analysis Weakness: It is a black box, it gives answers, but we don't really know how
#Not perfectly reproducaable because of random samples as well as a chance of Overfit Bias

#Challenge Question: Predict driver's gender based on explanatory variables found in Montgomery County traffic Data


