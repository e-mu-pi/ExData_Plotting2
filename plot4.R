library(dplyr)
library(data.table)
library(ggplot2)
library(lattice)

if( any(! c("NEI","SCC") %in% ls()) ) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
  setDT(NEI)
}

coal_sources <- SCC %>% filter( grepl("Coal", SCC.Level.Three, ignore.case = TRUE) )
combustion_totals <- coal_sources %>% filter( grepl("Total", SCC.Level.Four, ignore.case = TRUE))

combustion_emissions <- NEI %>% filter( SCC %in% combustion_totals$SCC ) %>% 
  group_by(year) %>%
  summarise( Total_PM25 = sum(Emissions) )

qplot(year, Total_PM25, data = combustion_emissions, geom = "line") +
  labs(title = "US Combustion Emissions")
ggsave(file = "plot4.png", scale = 0.5)
