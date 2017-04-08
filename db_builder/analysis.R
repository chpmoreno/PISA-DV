##############################
### SETTING UP ENVIRONMENT ###
##############################

rm(list=ls())

library(dplyr)
library(RMySQL)
library(glmnet)
setwd("yourpath")

####################
### LOADING DATA ###
####################
# RData files
#   varnames.RData: vector of selected variable names by level, we will use it to 
#   create a dataframe where to store the results
#   ID_students_100000.RData: dataframe with identifying variables for our 100,000 students
#   list_schools.RData: list with 5 imputed schools dataframes
#   list_students.RData: list with 5 imputed students dataframes
#   important_var.RData: name and deviance of selected variables (see script: var_selection.R)

load(file="varnames.RData")
escuelitas<-read.sc(0)[,1] #Load schools dataset: IDschools variable
load("imputation/Rdata/students/16_dic_imp_100000/ID_students_100000.RData")
load("list_schools.RData")
load("list_students.RData")
load("important_var.RData")
important_var <- sel_impo_var[,1] #Take only the varnames of the selected variables (get rid of deviance)

###############################
### THE LOOP OF REGRESSIONS ###
###############################

### International dataframe (non-nested students)

#Generate a data frame with 25 rows (number of regressions: 5 imputations x 5 plausible values) and
#number of columns=number of coefficients you get from a regression
supertable <- as.data.frame(matrix(0, nrow=25, ncol=length(varnames))) 
colnames(supertable) <- varnames
l=1 #needed in the loop to assign the results to supertable rows
lambda <- 3.17 #Best lambda previously found

for(i in 1:5){ #This loop combines students and schools dataframes, along with other modifications
  aux <- students[[i]]
  students_prov <- as.data.frame(aux)[, -which(colMeans(is.na(aux)) > 0)] #Remove 4 variables not imputed
  students_prov2 <- cbind(IDschool=IDst_data$IDschool, students_prov)
  aux <- schools[[i]]
  schools_prov <- cbind(IDschool = escuelitas, aux)
  st_sc <- students_prov2 %>% left_join(schools_prov, by="IDschool")
  for(j in 1:5){ #This loop runs the regressions
    print(l)
    data <- na.omit(cbind(PVMATH=IDst_data[,j+2], st_sc))
    y <- data[,"PVMATH"]
    x <- cbind(PVMATH=data[,"PVMATH"], data[,important_var])
    x <- model.matrix(PVMATH~.,data=x)[,-1]
    fm <- glmnet(y=y, x=x, alpha=0, lambda=lambda)
    coefficients <- unname(coef(fm)[,1]) #Object for the coefficients
    supertable[l,] <- coefficients #Store the coefficients
    l = l+1 #The "l" ensures that the storing does not happen to the same 5 rows all the time
  }
}

save(file="supertable.RData") ###VERY IMPORTANT!!!
parameters <- supertable %>% summarise_each(funs(mean)) #We combine the coefficients by taking its mean
write.csv(parameters, file="parameters.csv", row.names = FALSE) #Finally :)

### National dataframes
# Again, we create a dataframe, this time, with 25 rows times the number of unique countries and one
# extra column to store the IDcountry
supertable_cnt <- as.data.frame(matrix(0, nrow=25*length(unique(data$IDcountry)), ncol=length(varnames)+1))
colnames(supertable_cnt) <- c("IDcountry", varnames)
l=1 #To check progress
z=1 #
for(i in 1:5){
  aux <- students[[i]]
  students_prov <- as.data.frame(aux)[, -which(colMeans(is.na(aux)) > 0)] #Remove 4 variables not imputed
  students_prov2 <- cbind(IDschool=IDst_data$IDschool, students_prov)
  aux <- schools[[i]]
  schools_prov <- cbind(IDschool = escuelitas, aux)
  st_sc <- students_prov2 %>% left_join(schools_prov, by="IDschool")
  for(j in 1:5){
    print(l)
    data <- na.omit(cbind(PVMATH=IDst_data[,j+2], st_sc))
    pb <- txtProgressBar(min = 0, max = length(unique(data$IDcountry)), style = 3)
    for(m in 1:length(unique(data$IDcountry))){
      subdata <- subset(data, IDcountry==m)
      y <- subdata[,"PVMATH"]
      x <- cbind(PVMATH=subdata[,"PVMATH"], subdata[,important_var])
      x <- model.matrix(PVMATH~.,data=x)[,-1]
      fm <- glmnet(y=y, x=x, alpha=0, lambda=lambda)
      coefficients <- unname(coef(fm)[,1])
      supertable_cnt[z,] <- c(m, coefficients)
      setTxtProgressBar(pb, m)
      z=z+1
      }
    l = l+1
    }
}

#We need to restablish factor levels, lost at some point of the analysis
students<-read.st(0) #Load original dataframe
students$IDcountry <- as.factor(students$IDcountry) #Factorize the variable
levels(supertable_cnt$IDcountry) <- levels(students$IDcountry) #Restablish factor levels

save(supertable_cnt, file="supertable_cnt.RData") ###VERY IMPORTANT!!!
parameters_cnt <- supertable_cnt %>% group_by(IDcountry) %>%  summarise_each(funs(mean)) # Group results
write.csv(parameters_cnt, file="parameters_cnt.csv", row.names = FALSE) # Finally :)

# THE END