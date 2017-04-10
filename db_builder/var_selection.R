##############################
### SETTING UP ENVIRONMENT ###
##############################
rm(list=ls())

library(RMySQL)
library(glmnet)
setwd("yourpath")

####################
### LOADING DATA ###
####################

# RData files
#   ID_students_100000.RData: dataframe with identifying variables for our 100,000 students
#   list_schools.RData: list with 5 imputed schools dataframes
#   list_students.RData: list with 5 imputed students dataframes
escuelitas<-read.sc(0)[,1] #Load schools dataset: IDschools variable
load("ID_students_100000.RData")
load("list_schools.RData")
load("list_students.RData")

st1 <- students[[1]] #We will work with one dataframe for students
st1 <- as.data.frame(st1)[, -which(colMeans(is.na(aux)) > 0)]  #Remove 4 variables not imputed
st1 <- cbind(IDschool=IDst_data$IDschool, students_prov)
sc1 <- schools[[1]] # WE will work with one dataframe for schools
sc1 <- cbind(IDschool = escuelitas, sc1)
st_sc <- students_prov2 %>% left_join(schools_prov, by="IDschool") #left join of the two dataframes
# Omit NA cases in one variable from the schools dataset and add the Plausible Value 1
data_sel <- na.omit(cbind(PVMATH=IDst_data[,3], st_sc)) 
rm(st1, sc1, st_sc) #Let's get some RAM

##########################
### VARIABLE SELECTION ###
##########################

# Selection by deviance

variables<-colnames(data_sel) #We get a vector of column names
variables<-variables[c(-23,-2,-1, -383, -25)] #Remove some variables that we do not want
#Now, we create a dataframe to store the values (variables and their deviances)
important_var<-data.frame(var=character(),deviance=double(),stringsAsFactors = FALSE) 
important_var[1,]<-c("2",0)
colnames(important_var)<-c("var","deviance")

#We iterate through the whole dataframe to do univariate regressions
n=1
for(i in variables){
  model<-lm(formula(paste0("PVMATH~", i)),data=data_sel)
  dev<-deviance(model) #We store the deviance
  var<-c(i,dev)
  important_var[n,]<-var
  n<-n+1
  print(i) #Print the name of the explanatory variable on each iteration to check the progress
  }

#Now we order the variables by deviance and take the 50 with lowest deviance
important_var<-transform(important_var,deviance=as.numeric(deviance))
important_var<-important_var[order(important_var$deviance,decreasing=FALSE),]
sel_impo_var<-important_var[1:50,]

#If one thing I've learnt in this project is that big data is like a difficult videogame, you should save
#after every step you take
save(sel_impo_var, file= "important_var.RData")


#Lasso selection - DIDNT WORK, but it helped us get a vector of variable names that we will use later
y <- data_sel[,1]
x <- cbind(data_sel["PVMATH"],data_sel[sel_impo_var$var])
x <- model.matrix(PVMATH~.,data=x)[,-1]

modelLasso <- glmnet(x,y,alpha=0) #We use ridge to get the variable names, do not care about the results
coefficients <- coef(modelLasso)[,1]
varnames <-names(coefficients)
save(varnames, file="varnames.RData")



