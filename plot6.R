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

bmore_and_la <- yearly_motor_vehicle_by_fips %>% filter( fips %in% c("24510","06037") )
setkey(bmore_and_la,year)
bmore_and_la[,Initial_Total_PM25 := .SD[1,Total_PM25], by= fips]
bmore_and_la[,Total_PM25_Change := Total_PM25 - Initial_Total_PM25]

name_fips <- function(fips) {
  switch(fips,
         "24510" = "Baltimore City",
         "06037" = "Los Angeles County")
}
bmore_and_la <- bmore_and_la %>% mutate( fips_name = name_fips(fips))
qplot( year, Total_PM25_Change, data = bmore_and_la, color = fips_name,
       geom = "line" ) + labs(title = "Motor Vehicle Emissions")

ggsave(file = "plot6.png", scale = 0.5)
