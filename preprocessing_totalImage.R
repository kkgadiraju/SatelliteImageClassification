#convert geotiff to csv/arff format to be used in Weka classifiers
#Krishna Karthik Gadiraju/kkgadiraju
rm(list=ls())

library(rgdal)
library(rgeos)
library(foreign)


myImg<-readGDAL('Clip-May28-Composite.TIF')
simpleImg <- readGDAL('May28-SimpleFinal.tif')
advancedImg <- readGDAL('May28-AdvancedFinal.tif')
myImgData <- myImg@data
simpleImgData <- simpleImg@data
advancedImgData <- advancedImg@data
colnames(myImgData) <- c("Aerosol","B","G","R","NIR","SWIR1","SWIR2","Cirrus")
colnames(simpleImgData) <- c("energy","entropy","corr","invDiffM","inertia","clusShade","clusProm","hCorr")
colnames(advancedImgData) <- c("mean","variance","dissim","sumAvg","sumVar","sumEntr","diffEntr","diffVar","IC1","IC2")
allData <- cbind(myImgData,simpleImgData,advancedImgData)
x2 <- sample(1:6,nrow(allData),replace=T)
allData$Class <-x2
top10 <- c('R','G','Aerosol','energy','B','invDiffM','SWIR1','SWIR2','diffEntr','inertia','Class')

outputData <- allData[,top10] 

outputData$Class <- as.factor(outputData$Class)

#write.csv(x=outputData,file = 'may28-allImage-top10.csv',row.names = F)
write.arff(outputData,file='may28-allImage-top10.arff',relation='testing')

