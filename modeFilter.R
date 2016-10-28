#Mode filter, takes 5*5 neighborhood, removes noisy classified pixels.
# considers a 5*5 neighborhood, pixel value of middle pixel is equal to water if there are atleast 12 water pixels
# classified as not water otherwise

library(rgdal)
library(rgeos)
library(foreign)


infile.name.noExt <- 'ensemblepredict_10bands'
infile.name <- paste(infile.name.noExt,'.csv',sep='')

outfile.csv <- paste(infile.name.noExt,'_relaxedIterative_10bands_All.csv',sep='')
outfile.tif <- paste(infile.name.noExt,'_relaxedIterative_10bands_All.tif',sep='')


#read classified file
labelled.data <- read.csv(infile.name)
colnames(labelled.data) <- c('band4','band3','Aerosol','energy','band2','invDiffM','SWIR1','SWIR2','diffEntr','inertia','Class')

labelled.data$Class <- as.factor(labelled.data$Class)


ExtractNeighbors <- function(i,class.list){
  #Assuming we are doing a 3 by 3 neighborhood i.e., 9 values
  nbrs <- matrix(-1,5,5)
  #print(i) 
  #Mange edge conditions left and right borders
  if(i%%4218 ==0){#right most border 
  nbrs[1,1] <-  class.list[i-8436]
  nbrs[2,1] <-   class.list[i-4219]
  nbrs[3,1] <-  class.list[i-2]
  nbrs[4,1] <- class.list[i+4215]
  nbrs[5,1] <- class.list[i+8432]
  nbrs[1,2] <-  class.list[i-8435]
  nbrs[2,2] <- class.list[i-4218]
  nbrs[3,2] <-  class.list[i-1]
  nbrs[4,2] <- class.list[i+4216]
  nbrs[5,2] <- class.list[i+8433]
  nbrs[1,3] <-  class.list[i-8434]
  nbrs[2,3] <- class.list[i-4217]
  #nbrs[3,3] <-  class.list[i]
  nbrs[4,3] <- class.list[i+4217]
  nbrs[5,3] <- class.list[i+8434]
   
  }else if(i%%4218 ==4217){#one beside right border
  nbrs[1,1] <-  class.list[i-8436]
  nbrs[2,1] <-   class.list[i-4219]
  nbrs[3,1] <-  class.list[i-2]
  nbrs[4,1] <- class.list[i+4215]
  nbrs[5,1] <- class.list[i+8432]
  nbrs[1,2] <-  class.list[i-8435]
  nbrs[2,2] <- class.list[i-4218]
  nbrs[3,2] <-  class.list[i-1]
  nbrs[4,2] <- class.list[i+4216]
  nbrs[5,2] <- class.list[i+8433]
  nbrs[1,3] <-  class.list[i-8434]
  nbrs[2,3] <- class.list[i-4217]
  #nbrs[3,3] <-  class.list[i]
  nbrs[4,3] <- class.list[i+4217]
  nbrs[5,3] <- class.list[i+8434]
  nbrs[1,4] <-  class.list[i-8433]
  nbrs[2,4] <- class.list[i-4216]
  nbrs[3,4] <-  class.list[i+1]
  nbrs[4,4] <- class.list[i+4218]
  nbrs[5,4] <- class.list[i+8435]
  
  }else if(i%%4218==1){ # left most border
  nbrs[1,3] <-  class.list[i-8434]
  nbrs[2,3] <- class.list[i-4217]
  #nbrs[3,3] <-  class.list[i]
  nbrs[4,3] <- class.list[i+4217]
  nbrs[5,3] <- class.list[i+8434]
  nbrs[1,4] <-  class.list[i-8433]
  nbrs[2,4] <- class.list[i-4216]
  nbrs[3,4] <-  class.list[i+1]
  nbrs[4,4] <- class.list[i+4218]
  nbrs[5,4] <- class.list[i+8435]
  nbrs[1,5] <-  class.list[i-8432]
  nbrs[2,5] <- class.list[i-4215]
  nbrs[3,5] <-  class.list[i+2]
  nbrs[4,5] <- class.list[i+4219]
  nbrs[5,5] <- class.list[i+8436]
   
  }else if(i%%4218==2) {# second to left most border
  nbrs[1,2] <-  class.list[i-8435]
  nbrs[2,2] <- class.list[i-4218]
  nbrs[3,2] <-  class.list[i-1]
  nbrs[4,2] <- class.list[i+4216]
  nbrs[5,2] <- class.list[i+8433]
  nbrs[1,3] <-  class.list[i-8434]
  nbrs[2,3] <- class.list[i-4217]
  #nbrs[3,3] <-  class.list[i]
  nbrs[4,3] <- class.list[i+4217]
  nbrs[5,3] <- class.list[i+8434]
  nbrs[1,4] <-  class.list[i-8433]
  nbrs[2,4] <- class.list[i-4216]
  nbrs[3,4] <-  class.list[i+1]
  nbrs[4,4] <- class.list[i+4218]
  nbrs[5,4] <- class.list[i+8435]
  nbrs[1,5] <-  class.list[i-8432]
  nbrs[2,5] <- class.list[i-4215]
  nbrs[3,5] <-  class.list[i+2]
  nbrs[4,5] <- class.list[i+4219]
  nbrs[5,5] <- class.list[i+8436]
    
  } else{
  nbrs[1,1] <-  class.list[i-8436]
  nbrs[2,1] <-   class.list[i-4219]
  nbrs[3,1] <-  class.list[i-2]
  nbrs[4,1] <- class.list[i+4215]
  nbrs[5,1] <- class.list[i+8432]
  nbrs[1,2] <-  class.list[i-8435]
  nbrs[2,2] <- class.list[i-4218]
  nbrs[3,2] <-  class.list[i-1]
  nbrs[4,2] <- class.list[i+4216]
  nbrs[5,2] <- class.list[i+8433]
  nbrs[1,3] <-  class.list[i-8434]
  nbrs[2,3] <- class.list[i-4217]
  #nbrs[3,3] <-  class.list[i]
  nbrs[4,3] <- class.list[i+4217]
  nbrs[5,3] <- class.list[i+8434]
  nbrs[1,4] <-  class.list[i-8433]
  nbrs[2,4] <- class.list[i-4216]
  nbrs[3,4] <-  class.list[i+1]
  nbrs[4,4] <- class.list[i+4218]
  nbrs[5,4] <- class.list[i+8435]
  nbrs[1,5] <-  class.list[i-8432]
  nbrs[2,5] <- class.list[i-4215]
  nbrs[3,5] <-  class.list[i+2]
  nbrs[4,5] <- class.list[i+4219]
  nbrs[5,5] <- class.list[i+8436]
    
  }
  return(nbrs) 

}

LabelRelaxation <- function(i,class.list){
  #first extract neighbors
  nbrs <- ExtractNeighbors(i,class.list)
  count <- sum(nbrs==2)
  if(count>=13){ #more than half, change to water
  	return(2)
} else if(count == 12){ # exactly half, remains same
	return(class.list[i])
  }else
	return(1) 
}

ModeFilter <- function(){

print('Beginning assigning labels')
label <- rep(1,nrow(labelled.data))
min <- 8437
max <- nrow(labelled.data)-2*4218
label[min:max] <- sapply(min:max,LabelRelaxation,labelled.data$Class)
labelOld = labelled.data$Class
labelled.data$Class <<- as.factor(label)
countDifference <- sum(labelOld!=label)
cat('Difference in labels = ',countDifference,'\n')

}

currentTime <- proc.time()
ModeFilter()
print('Finished assigning labels')
cat('Execution time = ',proc.time()-currentTime,'\n')
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

labelled.data$ID <- seq.int(nrow(labelled.data))
t1 <- split(labelled.data, labelled.data$Class, drop = T)
t1 <- lapply(t1, FUN = colorize1)
print('Colorized completed')

x1 <- do.call("rbind", t1)
x1 <- x1[order(x1$ID), ]
x1 <- x1[,-12]
write.csv(x=x1,file=outfile.csv,row.names=F)
x1 <- x1[, -c(4,5,6,7,8,9,10,11)]
colnames(x1) <- c('band4','band3','band2')
myImg1@data[,c('band4','band3','band2')]<-x1
writeGDAL(myImg1, fname = outfile.tif)

print('Write completed')




