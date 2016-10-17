################################################
##Read extracted CSV, verify properties
# split into training and test
# Krishna Karthik Gadiraju/kgadira
################################################




rm(list=ls(all=T))
library(rgdal)
library(rgeos)
library(foreign)

data.all <- read.csv('may28TrainingAllBandsFinal.csv') #contains all sampled points generated using
#point sampling tool in QGIS

x2 <- sample(1:nrow(data.all),nrow(data.all),replace=F)
data.all <- data.all[x2,]

#messed up the original id attribute in QGIS, redo it
id <- seq.int(nrow(data.all))
data.all$id <- id


#Split data into training and testing - Assume 60,40 ratio
colnames(data.all)[4] <- 'Class'
data.all$Class <- as.factor(data.all$Class)

data.all.split <- split(data.all,data.all$Class,drop=T)
data.training<- data.frame()
data.testing <- data.frame()
#colnames(data.training) <- colnames(data.all)

for( i in 1:6){
  current <- data.frame(data.all.split[i])
  colnames(current) <- colnames(data.all)
  noSamples <- nrow(current)
  noTraining <- ceiling(0.6*noSamples)
  x2 <- sample(1:nrow(current),noTraining,replace=F)
  data.training <- rbind(data.training,current[x2,])
  data.testing <- rbind(data.testing, current[-x2,])
}

#remove X,Y, id attribute - we don't use them
data.training <- data.training[,-c(1:3)]
data.testing <- data.testing[,-c(1:3)]

#Write down CSV and/or arff files
write.csv(x=data.training,'may28-training-AllBands-final.csv',row.names = F)
write.arff(data.training,file='may28-training-AllBands-final.arff',relation='training')

write.csv(x=data.testing,'may28-testing-AllBands-final.csv',row.names = F)
write.arff(data.testing,file='may28-testing-AllBands-final.arff',relation='testing')


