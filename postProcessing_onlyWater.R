################################################
# Get classified samples from Weka, visualize it as geotiff
# Krishna Karthik Gadiraju/kgadira
# Bharathkumar Ramachandra/tnybny
################################################

library(rgdal)
library(rgeos)
library(foreign)

#read original image
myImg1 <- readGDAL('Clip-May28-Composite.TIF')

#read classified file
classified <- read.csv('predicted-csv-file')

#column names of features - top 10 features selected using feature selection + Class Label
colnames(classified) <-  c('band4','band3','Aerosol','energy','band2','invDiffM',
                           'SWIR1','SWIR2','diffEntr','inertia','Class')
print(colnames(classified))
print(summary(classified))

classified[which(classified$Class!=6),]$Class <-1
classified[which(classified$Class==6),]$Class <-2

# Convert class variable to factor
classified$Class <-as.factor(classified$Class)
print('classes summary')
print(summary(classified))

#Assign colors: Source: Visualization work done by BharathKumar Ramachandra/tnybny
col1 = matrix(0, nrow = 2, ncol = 3)
col1[1, ] =  c(255, 255, 255) # white everything else 
col1[2, ] =  c(0, 0, 255) # blue water

#Function that assigns colors
colorize <- function(d)
{
  for(i in 1:3)
  {
    d[, i] <- rep(col1[d[1, 11], i], nrow(d))
  }
  d
}

print('Beginning to add colors')
classified$ID <- seq.int(nrow(classified))

t <- split(classified, classified$Class, drop = T)
t <- lapply(t, FUN = colorize1)

print('Colorized completed')
x <- do.call("rbind", t)

x <- x[order(x$ID), ] #Reorder data in original order


x <- x[, -c(4:12)] #Remove unnecessary columns
colnames(x) <-c('band4','band3','band2') #Rename first three bands to ba
myImg@data[,c('band4','band3','band2')]<-x #Copy R,G,B bands
writeGDAL(myImg, fname = "./KNNtiff_10bands.tif") #write GDAL file

print('Write completed')


