library(dplyr)
library(data.table)
library(ggplot2)

if( any(! c("NEI","SCC") %in% ls() ) ){
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
  setDT(NEI)
}

yearly_fips_by_type <- NEI %>% group_by(year,fips,type) %>% summarise( Total_PM25 = sum(Emissions) )
balt_city_by_type <- yearly_fips_by_type[fips == "24510",]

qplot(year, Total_PM25, data = balt_city_by_type, color = type, geom = "line" ) +
    labs(title = "Baltimore City Emissions By Type")

ggsave(file = "plot3.png", scale = 0.5)
