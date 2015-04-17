

setwd("C:/Users/JohnYagecic/Documents/DelawareDashboard")
require(animation)

PORTS<-read.csv("PORTSstations.csv")
tideDat<-read.csv("MergedTidalData.csv")

#saveGIF({
  for (yyy in 1:nrow(tideDat)){
    myDate<-format(strptime(tideDat[yyy,2], "%Y-%m-%d %H:%M"),"%m/%d/%Y %H:%M")
    myTitle=paste("Delaware Estuary Water Surface Elevation, ", myDate)
    
    plot(PORTS$RiverMile, tideDat[yyy,3:11], type="b", pch=19, col="blue", lwd=3, ylim=c(-1,3),
         xlab="River Miles", ylab="Meters (MLLW)", main=myTitle)
    points(PORTS$RiverMile, tideDat[yyy,12:20], type="b", pch=19, col="red", lwd=3)
    abline(v=100.16, lty=4)
    text(108, 2.9, "Ben \n Franklin \n Bridge", cex=0.8)
    abline(v=68.72, lty=4)
    text(60, 2.9, "Delaware \n Memorial \n Bridge", cex=0.8)
    legend("topleft", legend=c("Predicted", "Observed"), col=c("blue", "red"), pch=19)
  
    Sys.sleep(0.1)
  
  }

#}, nmax=nrow(tideDat), interval=0.1,
#  movie.name="TidalWSE.gif",
#  convert="convert",
#  ani.width=300, ani.height=300)

