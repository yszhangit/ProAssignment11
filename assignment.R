library(caret)
library(parallel)
library(doParallel)
library(mlbench)

data<-read.csv('ProAssignment11/ProAssignment11/pml-training.csv',na.strings = c("#DIV/0!","NA",""))
data<-data[, -(1:7)]
napct<-sapply(data, function(x) sum(is.na(x))/dim(data)[1])
data <- data[,napct < 0.9]
nearZeroVar(data)
# there's none near zero
cor90<-findCorrelation(cor(data[,-53]))
data1<-data[,-cor90]

ind_train<-createDataPartition(data$classe, p=0.75, list=F)
training<-data[ind_train,]
testing<-data[-ind_train,]
# use same random split, but without highly collerated columns
training1<-training[-cor90]
testing1<-testing[-cor90]

cl <- makeCluster(detectCores() -1)
registerDoParallel(cl)
# 5 fold
fitControl <- trainControl(method="cv", number = 5, allowParallel = T)
# 
set.seed(312)
mod_rp<-train(classe ~ ., data=training, method="rpart", trControl = fitControl)
# random forest
set.seed(312)
mod_r<-train(classe ~ ., data=training, method="rf", trControl = fitControl)
mod_r1<-train(classe ~ ., data=training1, method="rf", trControl = fitControl)
# very little improvement mod_r1 over mod_r
# boosting
set.seed(312)
mod_b <- train(classe ~ ., data=training, method="gbm", verbose=F, trControl=fitControl)
mod_b1 <- train(classe ~ ., data=training1, method="gbm", verbose=F, trControl=fitControl)
# support vector
#mod_sv <- train(classe ~ ., data=training, method="svmRadial", trControl=fitControl)

stopCluster(cl)
registerDoSEQ()

pred_rf <- predict(mod_rf, testing)
confusionMatrix(testing$classe, pred_rf)

pred_r <- predict(mod_r, testing)
pred_r1 <- predict(mod_r1, testing1)
pred_b <- predict(mod_b, testing)
pred_b1 <- predict(mod_b1, testing1)
#pred_sv <- predict(mod_sv, testing)

comparsion <- resamples(list(RF=mod_r, RF1=mod_r1, Boosting=mod_b, Boosting1=mod_b1))

#comparsion <- resamples(list(RF=mod_r, Boosting=mod_b, SV=mod_sv))
comparsion <- resamples(list(RPart=mod_rp, RF=mod_r, Boosting=mod_b))
dotplot(comparsion)
# removing correlated predictor didnt make much imporve for random forest, and made boosting worse

confusionMatrix(testing$classe, pred_r)
confusionMatrix(testing$classe, pred_b)
confusionMatrix(testing$classe, pred_r1)
confusionMatrix(testing$classe, pred_b1)
#confusionMatrix(testing$classe, pred_sf)

# test against validation
vali<-read.csv('pml-testing.csv', na.strings = c("#DIV/0!","NA",""))
vali<-vali[, -(1:7)]
napct<-sapply(vali, function(x) sum(is.na(x))/dim(vali)[1])
vali <- vali[,napct < 0.9]
nearZeroVar(vali)
findLinearCombos(data[,-53])
pred_vali<-predict(mod, vali)

