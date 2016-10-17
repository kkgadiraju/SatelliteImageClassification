################################################
# Get classified samples from Weka, visualize it as geotiff
# 6 colors - (Clouds, Roads, Shadow, Urban, Vegetation, Water) - (white, yellow, black, pink, green, blue)
# Krishna Karthik Gadiraju/kgadira
# Bharathkumar Ramachandra/tnybny
################################################

library(rgdal)
library(rgeos)
library(foreign)


#read original image
myImg<-readGDAL('path_to_original_image')

#read classified file
classified <- read.csv('predicted-csv-file')

#column names of features - top 10 features selected using feature selection + Class Label
colnames(classified) <-  c('band4','band3','Aerosol','energy','band2','invDiffM',
                           'SWIR1','SWIR2','diffEntr','inertia','Class')
print(colnames(classified))
print(summary(classified))

# Convert class variable to factor
classified$Class <-as.factor(classified$Class)
print('all classes summary')
print(summary(classified))

#Assign colors: Source: Visualization work done by BharathKumar Ramachandra/tnybny
col = matrix(0, nrow = 6, ncol = 3)
col[1, ] = c(255, 255, 255) # red clouds
col[2, ] = c(255, 255, 0) # yellow roads
col[3, ] = c(0, 0, 0) # black shadow
col[4, ] = c(255, 105, 180) # hot pink for urban
col[5, ] = c(0, 255,0 ) # green vegetation
col[6, ] =  c(0, 0, 255) # blue water


colorize <- function(d)
{
  for(i in 1:3)
  {
    d[, i] <- rep(col[d[1, 11], i], nrow(d))
  }
  d
}



print('Beginning to add colors')
classified$ID <- seq.int(nrow(classified))


t <- split(classified, classified$Class, drop = T) #split by class
t <- lapply(t, FUN = colorize) #Appl color to each class


print('Colorized completed')
x <- do.call("rbind", t)


x <- x[order(x$ID), ] #Reorder data in original order


x <- x[, -c(4:12)] #Remove unnecessary columns
colnames(x) <-c('band4','band3','band2') #Rename first three bands to ba
myImg@data[,c('band4','band3','band2')]<-x #Copy R,G,B bands
writeGDAL(myImg, fname = "./KNNtiff_10bands.tif") #write GDAL file

print('Write completed')
