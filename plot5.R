library(dplyr)
library(data.table)
library(ggplot2)

if( any(! c("NEI","SCC") %in% ls()) ) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
  setDT(NEI)
}

motor_vehicle_scc <- SCC %>% filter(Data.Category == "Onroad")
yearly_motor_vehicle_by_fips <- NEI %>% filter( SCC %in% motor_vehicle_scc$SCC) %>% group_by(fips, year) %>% summarise( Total_PM25 = sum(Emissions) )

qplot( year, Total_PM25, data = filter(yearly_motor_vehicle_by_fips, fips == "24510"),
       geom = "line" ) + labs(title = "Baltimore City, Motor Vehicle Emissions")

ggsave(file = "plot5.png", scale = 0.5)
