# Kaggle-Titanic-Survival
#    Score among Top 3% of kaggle. Rank - 321/10680     (8 april 1018)     #####
# Algorithms used :  Decision Trees, Random Forest and XGBoost

Titanic data survival yes or no prediction. 
I created a          decision tree model          random forest model          xgboost model    individually

Decision tree model
accuracy score : 0.78947

Random Forest model
accuracy score : 0.82296

XGBoost model
accuracy score : 0.82296



Random Forest and XGboost had same score 

Explanation of each code (and why which step taken)  is written in the code file.



#####
Data Dictionary
Variable	Definition	Key

survival	Survival	0 = No, 1 = Yes
pclass	Ticket class	1 = 1st, 2 = 2nd, 3 = 3rd
sex	Sex	
Age	Age in years	
sibsp	# of siblings / spouses aboard the Titanic	
parch	# of parents / children aboard the Titanic	
ticket	Ticket number	
fare	Passenger fare	
cabin	Cabin number	
embarked	Port of Embarkation	C = Cherbourg, Q = Queenstown, S = Southampton

#
Variable Notes
pclass: A proxy for socio-economic status (SES)
1st = Upper
2nd = Middle
3rd = Lower

age: Age is fractional if less than 1. If the age is estimated, is it in the form of xx.5

sibsp: The dataset defines family relations in this way...
Sibling = brother, sister, stepbrother, stepsister
Spouse = husband, wife (mistresses and fiancés were ignored)

parch: The dataset defines family relations in this way...
Parent = mother, father
Child = daughter, son, stepdaughter, stepson
Some children travelled only with a nanny, therefore parch=0 for them.
