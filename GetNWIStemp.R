# Retrieve and process temperature data for plotting
# developed by John Yagecic, P.E.
#  JYagecic@gmail.com

#  This script downloads temperature data from the USGS NWIS system and copies .csv files to the
#  working directory.


setwd("~/DelawareDashboard")

require(dataRetrieval) # USGS library for accessing NWIS data

NWIS<-read.table("NWISDOstations.csv", sep=",", colClasses="character", header=TRUE)
NWIS$RM<-as.numeric(NWIS$RM)
siteNumbers<-NWIS$Station


EndDate=format(Sys.Date()-1, "%Y-%m-%d") # Ending yesterday 
BeginDate=format(Sys.Date()-1, "%Y-%m-%d") # Beginning 6 days ago

myTemp<-readNWISdata(sites=siteNumbers, parameterCd="00010", service="iv", startDate=BeginDate, endDate=EndDate)

for (i in 1:nrow(myTemp)){ # I really dislike this work-around.  Need something more flexible in the future
  if(myTemp$site_no[i]=="01463500"){
    myTemp$Temp[i]=myTemp[i,8]
  }
  if(myTemp$site_no[i]!="01463500"){
    myTemp$Temp[i]=myTemp[i,6]
  }
}

myTemp<-myTemp[,c(1,2,3,9)]

for (j in 1:nrow(myTemp)){
  for (k in 1:nrow(NWIS)){
    if (myTemp$site_no[j]==NWIS$Station[k]){
      myTemp$RM[j]=NWIS$RM[k]
    }
  }
}

myTemp

write.table(myTemp, file="NWIStemp.csv", sep=",", row.names=FALSE)




