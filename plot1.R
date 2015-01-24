library(dplyr)
library(data.table)

if( any(! c("NEI","SCC") %in% ls()) ) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
  setDT(NEI)
}

make_plot1 <- function() {  
  yearly_data <- NEI %>% group_by(year) %>% summarise( Total_PM25 = sum(Emissions) )
  with(yearly_data, plot(year, Total_PM25,
                         main = "Total US Annual PM 2.5 Emissions"))
  with(yearly_data, lines(year, Total_PM25))
}

make_plot1()

save_plot1 <- function(){
  png(file = "plot1.png")
  make_plot1()
  dev.off()
}
save_plot1()