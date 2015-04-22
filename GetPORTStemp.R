# Script for retrieving NOAA PORTS data to construct animated water surface 
# elevation GIF
#
# Developed by John Yagecic, P.E.
# JYagecic@gmail.com



setwd("~/DelawareDashboard")

# Below are components of NOAA PORTS API search string
# see http://co-ops.nos.noaa.gov/api/
PORTS<-read.csv("PORTSstations.csv")

url1<-"http://tidesandcurrents.noaa.gov/api/datagetter?begin_date="
url2<-"&end_date="
url3<-"&station="
url4<-"&product=water_temperature"
url5<-"&interval=h&units=metric&time_zone=lst_ldt&application=DRBC&format=csv"
# Time zone for data is GMT

for (yyy in 1:nrow(PORTS)){ # Loop for locations
 
  EndDate=format(Sys.Date()-1, "%Y%m%d") # Establishing search date range based on 
  NowDate=format(Sys.Date(), "%Y%m%d")    #  code execution date.
  BeginDate=format(Sys.Date()-1, "%Y%m%d")
 
 
  print(BeginDate)
  print(NowDate)
  print(EndDate)
  
 
  fileURL<-paste0(url1, BeginDate, url2, EndDate, url3, PORTS$PORTSID[yyy], url4, url5)
  myfilename=paste0(PORTS$StationName[yyy], "_water_temperature.csv")
  download.file(fileURL, destfile=myfilename)
  
}


