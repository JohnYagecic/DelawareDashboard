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

myDO$shift=NA

for (j in 1:nrow(myDO)){
  if(as.numeric(Sys.Date()-as.numeric(myDO$Date[j]))==1){
    myDO$shift[j]=0
  }
  if(as.numeric(Sys.Date()-as.numeric(myDO$Date[j]))>1){
    myDO$shift[j]=12
  }
}

myTitle=paste0("Delaware River Dissolved Oxygen Concentrations \n",
               format(Sys.Date()-6, "%m/%d/%Y"), " to ", format(Sys.Date()-1, "%m/%d/%Y"),
                      " and Standards")

palette(gray(0:20 / 20))

png(file="NWISDOplot.png")
  plot(myDO$RM, myDO$DO, pch=19,
       col=(as.numeric(Sys.Date())-as.numeric(myDO$Date)+myDO$shift),
       cex=(2-((as.numeric(Sys.Date())-as.numeric(myDO$Date)))/5),
       xlab="River Miles", ylab="Dissolved Oxygen, 24-hour mean (mg/L)",
       main=myTitle,
       xlim=c(50,140), ylim=c(0,14))
  segments(48.2, 6, 59.5, 6, lwd=2, col="red")
  segments(59.5, 6, 59.5, 4.5, lwd=2, col="red")
  segments(59.5, 4.5, 70, 4.5, lwd=2, col="red")
  segments(70, 4.5, 70, 3.5, lwd=2, col="red")
  segments(70, 3.5, 108.4, 3.5, lwd=2, col="red")
  segments(108.4, 3.5, 108.4, 5, lwd=2, col="red")
  segments(108.4, 5, 183.66, 5, lwd=2, col="red")
  abline(v=133.4, lty=4)
  abline(v=108.4, lty=4)
  abline(v=95, lty=4)
  abline(v=78.8, lty=4)
  text(120, 4.2, "Water \n Quality \n Standard", cex=0.8)
  text(62, 14, "Zone 5", cex=0.8)
  text(87, 14, "Zone 4", cex=0.8)
  text(102, 14, "Zone 3", cex=0.8)
  text(120, 14, "Zone 2", cex=0.8)
  text(138, 14, "Zone\n1E", cex=0.8)
  legend("bottomleft", legend=c("Oldest", "Newest"), pch=19, col=c("gray85", "black"))
dev.off()





