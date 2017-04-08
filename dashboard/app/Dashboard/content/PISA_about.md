## Introduction

In this app we use **P**rogramme for **I**nternational **S**tudent **A**ssessment (**PISA**) survey results, some macroeconomic variables and some news related to PISA media interpretation to compare between countries through some interactive data visualization. The application was developed using R, shiny and some D3 libraries implemented in R (e.g plotly). The procedure is described below. 

## About PISA
 
The PISA is a triennial international survey which aims to evaluate education systems worldwide by testing the skills and knowledge of 15-year-old students.

In 2015 over **half a million students**, representing 28 million 15-year-olds in 72 countries and economies, took the internationally agreed two-hour test. Students were assessed in science, mathematics, reading, collaborative problem solving and financial literacy.

Similarly to most large-scale surveys, PISA uses a Rotated Questionnaire strategy to obtain data from students and schools. The reason behind this tool is simple: PISA aims to collect information on a wide range of items (the datasets for students and schools contain around 600 and 400 variables respectively), which cannot be obtained from a single respondent: it is easy to imagine what would happen if a student had to fill a questionnaire with 600 questions. In order to balance the interest for multiple variables and the feasibility of such an assessment, PISA has designed different booklets and assigned randomly to respondents, that is, students and principals receive only random parts of the whole questionnaire. The main drawback of this strategy is that no single student, nor school, has information on all items.

For this project I used PISA results from 2012.

## The database and analysis.

I basically used three sources of information: PISA survey results, World Bank Indicators and Google News.

* PISA survey results: The original database published by OECD uses SPSS. In particular I work with the students database. I read this database in R by using the package foreign. Due to the fact that PISA uses rotated questionnaire strategy, I addressed the problem of missing values. In order to overcome this problem, and considering that usually you want to test for all variables, I decided to impute the missing data by using the package mice (Multiple Imputation in Chained Equations). Afterwards, for understanding what are the principal variables which influence math scores, I selected the most important variables by using lasso.

* World Bank: I take some macroeconomic variables of the countries where PISA through the package WDI. This package allows you to retrieve the macroeconomic data by country and year from the World Bank Indicators Database. These variables were an input with math scores for doing a clustering analysis to understand which groups of countries share similar behaviors in order to get an intuitions of how PISA results can be explained by the macroeconomic environment of the different groups of countries.

* Google News: Also to understand how the newspapers in each country report PISA results I propose a sentiment analysis of the news for the years PISA survey was available before the publication of 2015 results (December 2016). This sentiment show how positive or negative were the news published in each countries where some criteria of searching hold, e.g PISA + Country.

# The App

Basically the app has two windows. The first one (About the project) is this procedure explanation. The another is the visualization and interaction for main results. The following are the boxes you can find:

* PISA map: Here you can find a map with the countries which participate in 2012 PISA survey. If you click on one country you will activate the other boxes which will present the principal results by country accordingly to the analysis described above. Map colors correspond to some filter. I use four filters: math, science and reading results, and the Hierarchical clustering.

* Macroeconomic variables: You can find boxes with principal macroeconomic variables for each countries. When you click a country in the map the boxes will show the results for that selection. 

* Variable impact on score: This box shows a graphic with the value of the coefficients for the variable selection when I applied lasso. Blue points are student variables while green represent school variables. If you select the point a tooltip  will show the variable name.

* PISA news: Here you will find two graphs. First will show the sentiment assigned to each news. The colors represent the sentiment (bluer implies more positive). The another graph is a word cloud of all the news for the country. 

