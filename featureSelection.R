################################################
#Feature selection using Learning Vector Quantization
# Source: http://machinelearningmastery.com/feature-selection-with-the-caret-r-package/
# Krishna Karthik Gadiraju/kgadira
################################################


rm(list=ls())


library('mlbench')
library('caret')
library('pROC')

data.training <- read.csv('may28-training-AllBands-final.csv')
data.testing <- read.csv('may28-testing-AllBands-final.csv')
data.training$Class <- as.factor(data.training$Class) #Convert to factor
data.testing$Class <- as.factor(data.testing$Class) #convert to factor
control <- trainControl(method="repeatedcv", number=10, repeats=3) #we can explore more by changing these params

model <- train(Class~., data=data.training, method="lvq", preProcess="scale", trControl=control)
# estimate variable importance
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)
# plot importance
plot(importance)

#Based on this, take top 10 most important variables and Class variable
top10 <- c('R','G','Aerosol','energy','B','invDiffM','SWIR1','SWIR2','diffEntr','inertia','Class')

data.training.final <- data.training[,top10]
data.testing.final <- data.testing[,top10]

#Write down CSV and/or arff files to use for prediction
#write.csv(x=data.training.final,'may28-trainingTop10-AllBands-final.csv',row.names = F)
write.arff(data.training.final,file='may28-trainingTop10-AllBands-final.arff',relation='training')

#write.csv(x=data.testing.final,'may28-testingTop10-AllBands-final.csv',row.names = F)
write.arff(data.testing.final,file='may28-testingTop10-AllBands-final.arff',relation='testing')
