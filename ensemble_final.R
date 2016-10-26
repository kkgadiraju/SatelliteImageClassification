#Read outputs from other classifiers, convert into water vs everything else, 
# identify a pixel as water if atleast two classifiers have identified it as water
# important to ensure that we don't miss any water pixels

library(rgdal)
library(rgeos)
library(foreign)


#read classified file
classifiednb <- read.csv('nbpredict_10bands.csv')
classifieddt <- read.csv('dtpredict_10bands.csv')
classifiedrf <- read.csv('rfpredict_10bands.csv')
classifiedmlp <- read.csv('mlppredict_10bands.csv')
classifiedknn <- read.csv('knnpredict_10bands.csv')

classifiednb[which(classifiednb$Class!=6),]$Class <-1 #not water
classifiednb[which(classifiednb$Class==6),]$Class <-2 # water

classifieddt[which(classifieddt$Class!=6),]$Class <-1
classifieddt[which(classifieddt$Class==6),]$Class <-2

classifiedrf[which(classifiedrf$Class!=6),]$Class <-1
classifiedrf[which(classifiedrf$Class==6),]$Class <-2

classifiedmlp[which(classifiedmlp$Class!=6),]$Class <-1
classifiedmlp[which(classifiedmlp$Class==6),]$Class <-2

classifiedknn[which(classifiedknn$Class!=6),]$Class <-1
classifiedknn[which(classifiedknn$Class==6),]$Class <-2


classifiednb$Class <- as.factor(classifiednb$Class)
classifieddt$Class <- as.factor(classifieddt$Class)
classifiedrf$Class <- as.factor(classifiedrf$Class)
classifiedmlp$Class <- as.factor(classifiedmlp$Class)
classifiedknn$Class <- as.factor(classifiedknn$Class)

classifiedEnsemble <- data.frame()


classifiedEnsemble<- classifiednb #copy the data over


x <- cbind(classifiednb$Class,classifieddt$Class,classifiedrf$Class,classifiedmlp$Class,classifiedknn$Class)
# identify a pixel as water if atleast two classifiers have identified it as water
# important to ensure that we don't miss any water pixels
getLabel <- function(i,x){
	 sum(x[i,]==2)>=2

}

print('Begninning assigning labels')

counts <- sapply(1:nrow(x),getLabel,x)

classifiedEnsemble$Class <- 1
classifiedEnsemble$Class[counts]<-2

print('Finished assigning labels')

myImg1 <- readGDAL('Clip-May28-Composite.TIF')

col1 = matrix(0, nrow = 2, ncol = 3)
col1[1, ] =  c(255, 255, 255) # black everything else
col1[2, ] =  c(0, 0, 255) # blue water



colorize1 <- function(d)
{
    for(i in 1:3)
    {
        d[, i] <- rep(col1[d[1, 11], i], nrow(d))
    }
    d
}

print('Beginning to add colors')
colnames(classifiedEnsemble) <- c('band4','band3','Aerosol','energy','band2','invDiffM','SWIR1','SWIR2','diffEntr','inertia','Class')

print(colnames(classifiedEnsemble))

classifiedEnsemble$ID <- seq.int(nrow(classifiedEnsemble)) #reorder slides to original order

t1 <- split(classifiedEnsemble, classifiedEnsemble$Class, drop = T)
t1 <- lapply(t1, FUN = colorize1)
x1 <- do.call("rbind", t1)
x1 <- x1[order(x1$ID), ]

x1 <- x1[,-c(12)]
#write.csv(x=x1,file='ensemblepredict_10bands.csv',row.names=F)
x1 <- x1[, -c(4,5,6,7,8,9,10,11)]
colnames(x1) <-c('band4','band3','band2')

myImg1@data[,c('band4','band3','band2')]<-x1

writeGDAL(myImg1, fname = "./Ensembletiff_OVO_10bands.tif")
print('Write completed')




