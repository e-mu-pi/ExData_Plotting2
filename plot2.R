library(dplyr)
library(data.table)

if( any(! c("NEI","SCC") %in% ls() ) ) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
  setDT(NEI)
}

yearly_fips_data <- NEI %>% group_by(year,fips) %>% summarise( Total_PM25 = sum(Emissions) )
balt_city_yearly <- yearly_fips_data[fips == "24510",]

make_plot2 <- function(){
  with(balt_city_yearly, plot(year, Total_PM25,
                            main = "Baltimore City, Maryland Total PM_2.5"))
  with(balt_city_yearly, lines(year, Total_PM25))
}

make_plot2()

save_plot2 <- function(){
  png('plot2.png')
  make_plot2()
  dev.off()
}

save_plot2()