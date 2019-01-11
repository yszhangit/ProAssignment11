---
title: "assignment"
author: "yinshu zhang"
date: "January 10, 2019"
output: html_document
---
# Declaimer
This is peer-review-assignment of "Practical Machine Learning" from Coursera.org

# Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways

The goal is to build model to classify correct or incorrect way of exercise, or "how well they do it". Their publish has more information about dataset  http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har 

The data set can be downloaded from https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv for training and testing and https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv as validation.



```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.