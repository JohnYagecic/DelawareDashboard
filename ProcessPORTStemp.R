# Script for formatting NOAA PORTS data into a structure for plotting
# developed by John Yagecic, P.E.
#  JYagecic@gmail.com



setwd("~/DelawareDashboard")
PORTS<-read.csv("PORTSstations.csv")
PORTS$StationName<-as.character(PORTS$StationName)

myCount<-1

  
for (yyy in 1:nrow(PORTS)){ # Loop for locations
  
    myfilename=paste0(PORTS$StationName[yyy], "_water_temperature.csv")
    myDat<-read.csv(myfilename)
    myDat$Date.Time<-strptime(myDat$Date.Time, format("%Y-%m-%d %H:%M"))
    myDat$RM<-PORTS$RiverMile[yyy]
    myDat$Station<-PORTS$StationName[yyy]
    
    
    if(myCount==1){
      mergedTemp<-myDat
    }
    
    if(myCount>1){
      mergedTemp<-rbind(mergedTemp, myDat)
      
    }
    
  myCount=myCount+1
  
}
  
mergedTemp


write.table(mergedTemp, file="MergedPORTStempData.csv", sep=",", row.names=FALSE)


