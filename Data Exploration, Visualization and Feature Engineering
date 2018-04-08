# Read train and test files
train <- read.csv("C:/Users/ADitya/Desktop/job/titanic dataset kaggle/train.csv", na.strings = "")
test <- read.csv("C:/Users/ADitya/Desktop/job/titanic dataset kaggle/test.csv", na.strings = "")

# Creating survived in test 
test$Survived <- NA

# Merging as a single df
full <- rbind(train, test)

# summary ( mean,median, NA's)
summary(full)

# Missing value by varibles
sapply(full, function(x) sum(is.na(x)))

# Structure (Class)
str(full)

# Creating survived and Pclass as factor
full$Survived <- as.factor(full$Survived)
full$Pclass <- as.factor(full$Pclass)

# Checking out Missing value of age by pclass    :  class 3 has max age missing values
aggregate(Age ~ Pclass, data=full, function(x) {sum(is.na(x))}, na.action = NULL)

#summmary of Pclass : for comparing missing values to total age values by Pclass
summary(full$Pclass)

# Missing values in Embarked are only 2,  replacing them by mode
full$Embarked[is.na(full$Embarked)]  <- "S"

# Visualization
library(ggplot2)
library(ggthemes)

# Age vs Survived
ggplot(full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram(bins=30) + 
  theme_few() +
  xlab("Age") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Age vs Survived")

# Sex vs Survived
ggplot(full[1:891,], aes(Sex, fill = factor(Survived))) + 
  geom_bar(stat = "count", position = 'dodge')+
  theme_few() +
  xlab("Sex") +
  ylab("Count") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Sex vs Survived")

#Sex vs Survived vs Age 
ggplot(full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram(bins=30) + 
  theme_few() +
  xlab("Age") +
  ylab("Count") +
  facet_grid(.~Sex)+
  scale_fill_discrete(name = "Survived") + 
  theme_few()+
  ggtitle("Age vs Sex vs Survived")

# Pclass vs Survived
ggplot(full[1:891,], aes(Pclass, fill = factor(Survived))) + 
  geom_bar(stat = "count")+
  theme_few() +
  xlab("Pclass") +
  facet_grid(.~Sex)+
  ylab("Count") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Pclass vs Sex vs Survived")



# Extracting the title from name using gsub
full$Title <- gsub("(.*, )|(\\..*)", "", full$Name) 

# Otherwise it can be done as...
# full$Title <- gsub(".*, ", "", full$Name) 
# full$Title <- gsub(". .*", "", full$Title) 

# str of title
str(full$Title)

# table of titles
table(full$Title)

# Titles by Sex
table(full$Sex, full$Title)

# Reassign rare titles
Officer <- c('Capt', 'Col', 'Don', 'Dr', 'Major', 'Rev')
Royalty <- c('Dona', 'Lady', 'the Countess','Sir', 'Jonkheer')

# Reassign mlle, ms, and mme, and rare
full$Title[full$Title == 'Mlle']        <- 'Miss' 
full$Title[full$Title == 'Ms']          <- 'Miss'
full$Title[full$Title == 'Mme']         <- 'Mrs' 
full$Title[full$Title %in% Royalty]  <- 'Royalty'
full$Title[full$Title %in% Officer]  <- 'Officer'

# Selecting the surname 
full$Surname <- gsub(",.*","",full$Name)

# Family size including the person aboard
full$Fsize <- full$SibSp + full$Parch + 1

# family size vs survived
ggplot(full[1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  xlab('Family Size') +
  ylab("Count") +
  theme_few()+
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Family Size vs Survived")

# Assigning family size from numbers to type
full$Fsize[full$Fsize > 4] <-  "Big"
full$Fsize[full$Fsize == 1] <- "Alone"
full$Fsize[full$Fsize < 5 & full$Fsize > 1] <- "Small"

# log transformation of Fair
full$Fare <- log(full$Fare + .01)                         

# one NA value in Fare
full$Fare[is.na(full$Fare)] <- 2 

# Creating Fare Range
full$FareRange <- ifelse(full$Fare > 3.344, "High",
                                ifelse(full$Fare > 2.851, "Med-High",
                                       ifelse(full$Fare > 2.068, "Med", "Low"
                                       )))

#graph title vs survived
ggplot(full[1:891,], aes(Title,fill = factor(Survived))) +
  geom_bar(stat = "count")+
  xlab('Title') +
  ylab("Count") +
  scale_fill_discrete(name = " Survived") + 
  ggtitle("Title vs Survived")+
  theme_few()

# Embarked vs Pclass vs Survived
ggplot(full[1:891,], aes(Pclass, fill = factor(Survived))) + 
  geom_bar(stat = "count")+
  theme_few() +
  xlab("Pclass") +
  ylab("Count") +
  facet_wrap(~Embarked) + 
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Embarked vs Pclass vs Survived")

# Missing value imputation by kNN
library(VIM)
fullclone <- kNN(full)
full$Age <- fullclone$Age

# new variable child and adults
full$Child[full$Age < 15] <- 'Child'
full$Child[full$Age >= 15] <- 'Adult'





# remember this code
#Child vs Sex vs Pclass vs Survived
ggplot(full[1:891,][full[1:891,]$Child == 'Child', ], aes(Sex, fill = factor(Survived))) + 
  geom_bar(stat = "count") + 
  xlab("Sex") +
  ylab("Count") +
  facet_wrap(~Pclass)+
  scale_fill_discrete(name = "Survived") +
  ggtitle("Child vs Sex vs Pclass vs Survived")+
  theme_few()

# Factorization 
str(full)
full$Child  <- factor(full$Child)
full$Title  <- factor(full$Title)
full$Surname  <- factor(full$Surname)
full$Fsize  <- factor(full$Fsize)
full$FareRange <- factor(full$FareRange)

# Split data again
train <- full[1:891, c(-4, -9, -11)]
test <- full[892:1309, c(-4, -9, -11)]

# Deleting survived from test
test$Survived <- NULL
