# A script for retrieving discharge data from all basin gages to compute the mean discharge per 
# drainage area by HUC8, and plot a chloropleth.  Developed by John Yagecic, P.E.
#   JYagecic@gmail.com

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

setwd("~/DelawareDashboard/mapHUCs/Animated")
require(animation)

require(rgeos)
require(maptools)
require(dataRetrieval) # USGS library for accessing NWIS data


HUC.map<-readShapeSpatial("huc8.shp")
plot(HUC.map, border="darkgray")

png(file="YieldMapAni099.png")
  plot(HUC.map, border="black", main="Delaware Basin daily water Yield\n(CFS/square mile) Resetting ")
dev.off()

gages<-read.csv("gageHUCshort.csv")
gages$USGS_CODE<-as.character(gages$USGS_CODE)
gages$HUC_10<-as.factor(gages$HUC_10)
gages$HUC_8<-as.factor(gages$HUC_8)

gages$USGS_CODE<-paste0("0", gages$USGS_CODE)

gages

siteNo<-gages$USGS_CODE


for (j in 20:1){
  HUC.map<-readShapeSpatial("huc8.shp")
  
  gages<-read.csv("gageHUCshort.csv")
  gages$USGS_CODE<-as.character(gages$USGS_CODE)
  gages$HUC_10<-as.factor(gages$HUC_10)
  gages$HUC_8<-as.factor(gages$HUC_8)
  
  gages$USGS_CODE<-paste0("0", gages$USGS_CODE)
  
  EndDate=format(Sys.Date()-j, "%Y-%m-%d") # Establishing search date range based on  
  BeginDate=format(Sys.Date()-j, "%Y-%m-%d") 
  
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
  
  for (p in 1:nrow(gages)){
    if (!is.na(gages$yield[p]) & (gages$yield[p] < 0)) {
      gages$yield[p]<-NA
    }
  }
  
  if(j==7){
    write.table(gages, file="GageOutCheck.csv", sep=",", row.names=FALSE)
  }
  
  gages<-na.omit(gages)
  
  gages
  
  HUC8yield<-aggregate(gages[,9], list(gages$HUC_8), mean) # Computes the mean surface water yield (CFS/mi2)
                                                           # per HUC8 based on yesterday's gage daily data
  
  
  names(HUC8yield)<-c("HUC8", "yield")
  
  HUC8yield$HUC8<-as.factor(paste0("0", as.character(HUC8yield$HUC8)))
  
  HUC8yield
  
  HUC.map<-merge(HUC.map, HUC8yield, by.x="HUC_8", by.y="HUC8", all.x=TRUE)
  
  names(HUC.map)
  mytitle=paste0("Delaware Basin daily water Yield\n(CFS/square mile) on ", format(Sys.Date()-j, "%m/%d/%Y"))
  mypal <- colorRampPalette( c( "#f6e8c3", "blue", "darkblue" ) )(20)
  
  myFile<-paste0("YieldMapAni", substrRight(paste0("0000", as.character(30-j)),3),".png")
  png(file=myFile)
    plot(HUC.map, border="black", col=mypal[round(HUC.map$yield)], main=mytitle)
    legend("bottomleft", # position
         legend = c("1","3","5","10","20"), 
         title = "Yield\n(CFS/ square mile)",
         fill = mypal[c(1,3,5,10,20)],
         bty = "n") # border
  dev.off()
  
  if (j==1){
    png(file="YieldMapAni095.png")
      plot(HUC.map, border="black", col=mypal[round(HUC.map$yield)], main=mytitle)
    legend("bottomleft", # position
           legend = c("1","3","5","10","20"), 
           title = "Yield\n(CFS/ square mile)",
           fill = mypal[c(1,3,5,10,20)],
           bty = "n") # border
    dev.off()
    png(file="YieldMapAni096.png")
      plot(HUC.map, border="black", col=mypal[round(HUC.map$yield)], main=mytitle)
    legend("bottomleft", # position
           legend = c("1","3","5","10","20"), 
           title = "Yield\n(CFS/ square mile)",
           fill = mypal[c(1,3,5,10,20)],
           bty = "n") # border
    dev.off()
    
  }
  #Sys.sleep(0.5)
  

}


ani.options(convert='C:\\Program Files\\ImageMagick-6.9.1-Q16\\convert.exe')

oopt=ani.options(interval=1.8)
im.convert("YieldMapAni*.png", output="AnimatedYield.gif")

