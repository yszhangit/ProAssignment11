library(caret)
library(parallel)
library(doParallel)
library(mlbench)

data<-read.csv('pml-training.csv',na.strings = c("#DIV/0!","NA",""))
data<-data[, -(1:7)]
napct<-sapply(data, function(x) sum(is.na(x))/dim(data)[1])
data <- data[,napct < 0.9]
nearZeroVar(data)
ind_train<-createDataPartition(data$classe, p=0.7, list=F)
training<-data[ind_train,]
testing<-data[-ind_train,]

cl <- makeCluster(detectCores() -1)
registerDoParallel(cl)
# 5 fold
fitControl <- trainControl(method="cv", number = 5, allowParallel = T)
# random forest
set.seed(312)
mod_rp<-train(classe ~ ., data=training, method="rpart", trControl = fitControl)
# random forest
set.seed(312)
mod_r<-train(classe ~ ., data=training, method="rf", trControl = fitControl)
# boosting
set.seed(312)
mod_b <- train(classe ~ ., data=training, method="gbm", verbose=F, trControl=fitControl)
# support vector
#mod_sv <- train(classe ~ ., data=training, method="svmRadial", trControl=fitControl)

stopCluster(cl)
registerDoSEQ()

pred_r <- predict(mod, testing)
pred_b <- predict(mod_b, testing)
#pred_sv <- predict(mod_sv, testing)

#comparsion <- resamples(list(RF=mod_r, Boosting=mod_b, SV=mod_sv))
comparsion <- resamples(list(RPart=mod_rp, RF=mod_r, Boosting=mod_b))
dotplot(comparsion)

confusionMatrix(testing$classe, pred)
confusionMatrix(testing$classe, pred_b)
confusionMatrix(testing$classe, pred_sf)

# test against validation
vali<-read.csv('pml-testing.csv', na.strings = c("#DIV/0!","NA",""))
vali<-vali[, -(1:7)]
napct<-sapply(vali, function(x) sum(is.na(x))/dim(vali)[1])
vali <- vali[,napct < 0.9]
nearZeroVar(vali)

pred_vali<-predict(mod, vali)

