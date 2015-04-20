
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

setwd("C:/Users/JohnYagecic/Documents/DelawareDashboard")
require(animation)

PORTS<-read.csv("PORTSstations.csv")
tideDat<-read.csv("MergedTidalData.csv")

  for (yyy in 1:nrow(tideDat)){
    myDate<-format(strptime(tideDat[yyy,2], "%Y-%m-%d %H:%M"),"%m/%d/%Y %H:%M")
    myTitle=paste("Delaware Estuary Water Surface Elevation, ", myDate)
    myTitle=paste(myTitle, "\nData retrieved ", format(Sys.Date(), "%m/%d/%Y"))
    
    png(file=paste0("Rplot",substrRight(paste0("0000", yyy),3),".png"))
    
    plot(PORTS$RiverMile, tideDat[yyy,3:11], type="b", pch=19, col="blue", lwd=3, ylim=c(-1,3),
         xlab="River Miles", ylab="Meters (MLLW)", main=myTitle)
    points(PORTS$RiverMile, tideDat[yyy,12:20], type="b", pch=19, col="red", lwd=3)
    abline(v=100.16, lty=4)
    text(108, 2.9, "Ben \n Franklin \n Bridge", cex=0.8)
    abline(v=68.72, lty=4)
    text(60, 2.9, "Delaware \n Memorial \n Bridge", cex=0.8)
    legend("topleft", legend=c("Predicted", "Observed"), col=c("blue", "red"), pch=19)
  
    #Sys.sleep(0.1)
    
    dev.off()
    
    
  
  }

ani.options(convert='C:\\Program Files\\ImageMagick-6.9.1-Q16\\convert.exe')

oopt=ani.options(interval=0.1)
im.convert("Rplot*.png", output="tidalWSE.gif")


