
      ###
#Data Modelling
### Implications of feature engineering
#Name not imp, made child variable instead of age(not imp) ( child and women and royals imp),
#farerange not used because fare is good after log transformation, ticket and cabin not usful, Fsize used instead of sibsp and parch
# Title used because its correlated with name and family size(royal and staff Differentiator)
# Surname has too many variables


####### Decision trees
library(rpart)

# Tree model: 
my_tree <- rpart(Survived ~ Pclass + Sex + Fare + Embarked + Title + 
                   Fsize + Child, data = train, method = "class", control=rpart.control(cp=0.0001))

# Summary
summary(my_tree)
attributes(my_tree)

## Validation data set not created so no counfusionmatrix
# Prediction on test data
predTree <- predict(my_tree, newdata = test, type = "class")

# summary
summary(predTree)

# Structure of prediction
str(predTree)

# Binding test and prediction
Prediction <-cbind(test, predTree)

# Taking only variables needed for submission
finalDT <- Prediction[ , c(1,14)]

# Renaming column name
colnames(finalDT)[2] <- "Survived"

# Writing csv
write.csv(finalDT, file = "titanic decision tree.csv", row.names=FALSE)







##### Random forest

# random forest
library('randomForest')

set.seed(123)

# Random Forest model
rf_model <- randomForest(Survived ~ Pclass + Sex + Fare + Embarked + Title + 
                           Fsize + Child, mtry= 2, data = train)

# Summary
summary(rf_model)

# Out of bag error check( no need of validation set in random forest)
print(rf_model)

# Tuning randomForest, checking best mtry
bestmtry <- tuneRF(train[ ,c(3,4,8,9,10,12,14)], train$Survived, stepFactor = 1.2, improve = 0.01,trace = T, plot = T)

# Prediction on test data
predRF <- predict(rf_model, newdata = test)

# Combining test and prediction
prediction2 <- cbind(test,predRF)

# Choosing needed columns
finalRF <- prediction2[ , c(1,14)]

# Renaming one column
colnames(finalRF)[2] <- "Survived"

# checking for NA values
sum(is.na(finalRF))

# Writing CSV
write.csv(finalRF, file = "titanic random forest.csv", row.names=FALSE)






#### Xgboost
library(xgboost)
library(Matrix)   # for sparse model matrix

# creating data set with needed variables
full.spare <- full[ , c(2,3,5,10,12,13,15,17)]

# Structure check
str(full.spare)

# Creating new train and test from selected variable full.spare 
train.spare <- full.spare[1:891 ,]
str(train.spare)
test.spare <- full.spare[892:1309, ]

# Encodeing numeric variable for logistic in Survived only
train.spare$Survived <- as.numeric(train.spare$Survived)

# recoding survived, because after numeric transfer values changed to 1,2, but we need values in range [0,1]
train.spare$Survived <- recode(train.spare$Survived, "1=0; 2=1")

# Creating model matrix ( i.e. numeric transformation of all exept survived)
train.spare1 <- sparse.model.matrix(Survived~ ., data = train.spare)
str(train.spare)

# model matrix for test. survived has NA values , so giving them value 1 for continuing
test.spare$Survived <- 1
test.spare1 <- sparse.model.matrix(Survived~ ., data = test.spare)

str(train.spare)


## Xgboost model   # data is matrix, label is survived before matrix
xg.model1 <- xgboost(data= train.spare1,     #train sparse matrix 
                    label= train.spare$Survived,          #output vector to be predicted 
                    eval.metric= 'logloss',        #model minimizes Root Mean Squared Error
                    objective= "binary:logistic",     #regression
                    #tuning parameters
                    max.depth= 8,            #Vary btwn 3-15
                    eta= 0.1,                #Vary btwn 0.1-0.3
                    nthread = 5,             #Increase this to improve speed
                    subsample= 1,            #Vary btwn 0.8-1
                    colsample_bytree= 0.5,   #Vary btwn 0.3-0.8
                    lambda= 0.5,             #Vary between 0-3
                    alpha= 0.5,              #Vary between 0-3
                    min_child_weight= 3,     #Vary btwn 1-10
                    nround= 30               #Vary btwn 100-3000 based on max.depth, eta, subsample and               colsample
)


# Imporance of xgboost, Checking gains feature 8 that is are is more contributing
imp <- xgb.importance(feature_names = NULL, model = xg.model1)


# Prediction on test data model matrix
xg_prediction <- predict(xg.model1, newdata= test.spare1)

# Giving it binary values, choosing 0.55 as differentiator   # it might improve model changing this value ,but not now
xg_prediction <- ifelse(xg_prediction >= 0.55,1,0)

# combining test to prediction
predictxg <- cbind(test, xg_prediction)

# selecting needed variables
finalxg <- predictxg[ , c(1,14)]

# renaming columns
colnames(finalxg)[2] <- "Survived"
str(finalxg)

# converting Survived as factor
finalxg$Survived <- factor(finalxg$Survived)

# writing csv
write.csv(finalxg, file = "titanic xg boost.csv", row.names=FALSE)
