# Script for plotting the temperature data retrieved from other scripts with comparison to
# temperature criteria.  Developed by John Yagecic, P.E.
#   JYagecic@gmail.com

myTitle=paste0("Delaware River Temperatures and Standards, ", format(Sys.Date()-1, "%m/%d/%Y"))

NWIStemp<-read.csv("NWIStemp.csv")
PORTStemp<-read.csv("MergedPORTStempData.csv")
myCrit<-read.csv("TemperatureCriteria.csv")
DOY<-as.numeric(strftime(Sys.Date()-1, format="%j")) #numeric day of year for yesterday



png(file="TemperaturePlot.png")
plot(PORTStemp$RM, PORTStemp$Water.Temperature, col="blue",
     xlab="River Miles", ylab="Water Temperature (degrees C)",
     main=myTitle,
     xlim=c(0,140), ylim=c(0,35))
points(NWIStemp$RM, NWIStemp$Temp, col="red")
abline(v=133.4, lty=4)
abline(v=108.4, lty=4)
abline(v=95, lty=4)
abline(v=78.8, lty=4)
abline(v=48.2, lty=4)
abline(v=78.8, lty=4)
abline(v=0, lty=4)

# Zone 2
segments(108.4, myCrit$Z2C[DOY], 133.4, myCrit$Z2C[DOY], lwd=2, col="orange")
# Zone 3
segments(95, myCrit$Z3C[DOY], 108.4, myCrit$Z3C[DOY], lwd=2, col="orange")
# Zone 4
segments(78.8, myCrit$Z4C[DOY], 95, myCrit$Z4C[DOY], lwd=2, col="orange")
# Zone 5 - abs max only
segments(48.2, 30, 78.8, 30, lwd=2, col="green")
# zone 6 - abs max only
segments(0, 29.4, 48.2, 29.4, lwd=2, col="green")

#text(120, 4.2, "Water \n Quality \n Standard", cex=0.8)
text(22, 0, "Zone 6", cex=0.8)
text(62, 0, "Zone 5", cex=0.8)
text(87, 0, "Zone 4", cex=0.8)
text(102, 0, "Zone\n3", cex=0.8)
text(120, 0, "Zone 2", cex=0.8)
text(140, 0, "Zone\n1E", cex=0.8)

legend("topleft", legend=c("NOAA PORTS Data", "USGS NWIS Data"), pch=c(1,1), col=c("blue", "red"))
legend("topright", legend=c("Max Criteria", "Day of Year Criteria"), lty=1, lwd=2,
       col=c("green", "orange"))

dev.off()



