
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
    
    plot(PORTS$RiverMile, tideDat[yyy,3:11], type="b", pch=19, col="blue", lwd=3, ylim=c(-1,4),
         xlab="River Miles", ylab="Meters (MLLW)", main=myTitle)
    points(PORTS$RiverMile, tideDat[yyy,12:20], type="b", pch=19, col="red", lwd=3)
    abline(v=100.16, lty=4)
    text(108, 3.9, "Ben \n Franklin \n Bridge", cex=0.8)
    abline(v=68.72, lty=4)
    text(60, 3.9, "Delaware \n Memorial \n Bridge", cex=0.8)
    legend("topleft", legend=c("Predicted", "Observed"), col=c("blue", "red"), pch=19)
    abline(h=0, lty=3)
    text(20, -0.2, "Federal Navigation Channel \n Depth based on 0 MLLW", cex=0.8)
    
    segments(-2,1.8288, 10, 1.8288, lwd=1, col="purple4")
    segments(49,2.19456, 70, 2.19456, lwd=1, col="purple4")
    text(55, 2.35, "Minor Flooding", cex=0.8)
    segments(89, 2.49936, 103, 2.49936, lwd=1, col="purple4")
    
    segments(-2,2.1336, 10, 2.1336, lwd=2, col="purple4")
    segments(49,2.49936, 70, 2.49936, lwd=2, col="purple4")
    text(51, 2.65, "Moderate Flooding", cex=0.8)
    segments(89, 2.80416, 103, 2.80416, lwd=2, col="purple4")
    
    segments(-2,2.4384, 10, 2.4384, lwd=3, col="purple4")
    segments(49,2.80416, 70, 2.80416, lwd=3, col="purple4")
    text(55, 2.95, "Major Flooding", cex=0.8)
    segments(89, 3.10896, 103, 3.10896, lwd=3, col="purple4")
    
    abline(h=-0.54864, lty=3, lwd=3)
    text(20, -0.69, "Blowout Tide", cex=0.8)
  
    #Sys.sleep(0.1)
    
    dev.off()
    
    
  
  }

ani.options(convert='C:\\Program Files\\ImageMagick-6.9.1-Q16\\convert.exe')

oopt=ani.options(interval=0.1)
im.convert("Rplot*.png", output="tidalWSE.gif")


