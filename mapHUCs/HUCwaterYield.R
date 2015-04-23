# A script for retrieving discharge data from all basin gages to compute the mean discharge per 
# drainage area by HUC8, and plot a chloropleth.  Developed by John Yagecic, P.E.
#   JYagecic@gmail.com

setwd("~/DelawareDashboard/mapHUCs")
require(rgeos)
require(maptools)
require(dataRetrieval) # USGS library for accessing NWIS data


HUC.map<-readShapeSpatial("huc8.shp")
plot(HUC.map, border="darkgray")

gages<-read.csv("gageHUCshort.csv")
gages$USGS_CODE<-as.character(gages$USGS_CODE)
gages$HUC_10<-as.factor(gages$HUC_10)
gages$HUC_8<-as.factor(gages$HUC_8)

gages$USGS_CODE<-paste0("0", gages$USGS_CODE)

gages

siteNo<-gages$USGS_CODE

EndDate=format(Sys.Date()-1, "%Y-%m-%d") # Establishing search date range based on  
BeginDate=format(Sys.Date()-1, "%Y-%m-%d") 

Param<-"00060"  # Parameter code for discharge CFS
Discharge<-readNWISdv(siteNo, Param, BeginDate, EndDate)

Discharge

for (i in 1:nrow(Discharge)){
  Discharge$Q[i]<-max(Discharge[i,c(5,7,9)], na.rm=TRUE)
}

Discharge<-Discharge[,c(1,2,3,10)] # keep only the relevant columns

Discharge

gages<-merge(gages, Discharge, by.x="USGS_CODE", by.y="site_no", all.x=TRUE)

gages$yield <- gages$Q / gages$DA_SQ_MI #compute Q per sq mi

gages<-na.omit(gages)

gages

HUC8yield<-aggregate(gages[,9], list(gages$HUC_8), mean) # Computes the mean surface water yield (CFS/mi2)
                                                         # per HUC8 based on yesterday's gage daily data


names(HUC8yield)<-c("HUC8", "yield")

HUC8yield$HUC8<-as.factor(paste0("0", as.character(HUC8yield$HUC8)))

HUC8yield

HUC.map<-merge(HUC.map, HUC8yield, by.x="HUC_8", by.y="HUC8", all.x=TRUE)

names(HUC.map)
mytitle=paste0("Delaware Basin daily water Yield\n(CFS/square mile) on ", format(Sys.Date()-1, "%m/%d/%Y"))
mypal <- colorRampPalette( c( "#f6e8c3", "blue", "darkblue" ) )(20)

plot(HUC.map, border="black", col=mypal[round(HUC.map$yield)], main=mytitle)




