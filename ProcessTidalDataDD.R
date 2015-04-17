# Script for formatting raw tidal data into a structure conducive to animation
# developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/DelawareDashboard")
PORTS<-read.csv("PORTSstations.csv")

myCount<-1

for (jjj in 1:2){ # Loop for Predicted vs. Observed water surface elevations 1=predicted, 2=observed
  
  for (yyy in 1:nrow(PORTS)){ # Loop for locations
  
  
    if (jjj==1){
      Product="predictions"
    }
    if (jjj==2){
      Product="water_level"
    }
    
    myfilename=paste0(PORTS$StationName[yyy], "_", Product, ".csv")
    myDat<-read.csv(myfilename)
    myDat$Date.Time<-strptime(myDat$Date.Time, format("%Y-%m-%d %H:%M"))
    if (jjj==2){ # for observed water levels, get rid of qualifiers
      myDat<-myDat[,1:2]
    }
    myDat$numDat<-as.numeric(myDat$Date.Time)
    names(myDat)<-c("Date.Time", paste0(PORTS$StationName[yyy],Product), "numDat") 
    
    if(myCount==1){
      mergedDat<-myDat
      
    }
    
    if(myCount>1){
      
      myDat<-myDat[,2:3] # only keep the prediction and numDat
      mergedDat<-merge(mergedDat, myDat, by.x="numDat", by.y="numDat", all.x=TRUE)
      
    }
    
  myCount=myCount+1
  
  }
  
}

write.table(mergedDat, file="MergedTidalData.csv", sep=",", row.names=FALSE)
