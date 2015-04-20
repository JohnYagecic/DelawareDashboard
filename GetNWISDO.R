# Translation of the hydrodynamic model automation files into R.
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com

#  This script downloads daily discharge data from the USGS NWIS system and copies .csv files to the
#  working directory.

setwd("~/DelawareDashboard")

require(dataRetrieval) # USGS library for accessing NWIS data

NWIS<-read.table("NWISDOstations.csv", sep=",", colClasses="character", header=TRUE)
NWIS$RM<-as.numeric(NWIS$RM)
siteNumbers<-NWIS$Station
parameterCd="00300"

EndDate=format(Sys.Date()-1, "%Y-%m-%d") # Ending yesterday 
BeginDate=format(Sys.Date()-6, "%Y-%m-%d") # Beginning 6 days ago

myDO<-readNWISdv(siteNumbers, parameterCd, startDate=BeginDate, endDate=EndDate)

for (i in 1:nrow(myDO)){ # I really dislike this work-around.  Need something more flexible in the future
  if(myDO$site_no[i]=="01463500"){
  myDO$DO[i]=myDO[i,7]
  }
  if(myDO$site_no[i]!="01463500"){
  myDO$DO[i]=myDO[i,5]
  }
}

myDO<-myDO[,c(1,2,3,8)]
myDO<-merge(myDO, NWIS, by.x="site_no", by.y="Station", all.x=TRUE)

myTitle=paste0("Delaware River Dissolved Oxygen Concentrations \n",
               format(Sys.Date()-6, "%m/%d/%Y"), " to ", format(Sys.Date()-1, "%m/%d/%Y"),
                      " and Standards")

palette(gray(0:6 / 6))
plot(myDO$RM, myDO$DO, pch=19,
     col=(as.numeric(Sys.Date())-as.numeric(myDO$Date)),
     cex=(2-((as.numeric(Sys.Date())-as.numeric(myDO$Date)))/5),
     xlab="River Miles", ylab="Dissolved Oxygen, 24-hour mean (mg/L)",
     main=myTitle,
     xlim=c(50,140), ylim=c(0,14))
segments(48.2, 6, 59.5, 6, lty=3, lwd=2, col="black")
segments(59.5, 6, 59.5, 4.5, lty=3, lwd=2, col="black")
segments(59.5, 4.5, 70, 4.5, lty=3, lwd=2, col="black")
segments(70, 4.5, 70, 3.5, lty=3, lwd=2, col="black")
segments(70, 3.5, 108.4, 3.5, lty=3, lwd=2, col="black")
segments(108.4, 3.5, 108.4, 5, lty=3, lwd=2, col="black")
segments(108.4, 5, 183.66, 5, lty=3, lwd=2, col="black")
abline(v=133.4, lty=4)
abline(v=108.4, lty=4)
abline(v=95, lty=4)
abline(v=78.8, lty=4)




