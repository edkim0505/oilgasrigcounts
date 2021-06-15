library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(googleVis)
library(scales)
library(tidyverse)
library(gt)
library(DT)
library(formattable)
library(reshape2)
library(ggpmisc)
library(ggpubr)


# setwd("~/RigCounts")
rig_counts <- read.csv(file = "./Rig_counts2.csv")
oilgas_prices <- read.csv(file="./Oil_gas_price.csv")
oilgas_prices <- oilgas_prices %>% mutate(., PublishDate_formatted = as.Date(Date, "%m/%d/%Y"))


##filtering data set for "United States" (excludes 'Canada') and "Land" (excludes 'Offshore' and 'Inland Waters') rigs only, and added Oil and Gas price columns (by joining from separate dataframe)
US_land_rig_counts = rig_counts %>% filter(., Location=='Land' & Country=='UNITED STATES') %>% mutate(., PublishDate_formatted = as.Date(PublishDate, "%m/%d/%Y")) %>% inner_join(., oilgas_prices, by="PublishDate_formatted") %>% select(., -Date)

##added Month_Year and Year_Week columns
US_land_rig_counts = US_land_rig_counts %>% mutate(., Day = 1) %>% mutate(., Month_Year = as.Date(with(., paste(
  Year, Month, Day, sep = "-"
)), "%Y-%m-%d")) %>% mutate(., Year_Week = paste(Year, "Wk", paste(formatC(Week, width=2, flag="0")), sep ="_")
                            )

#Create dataframe grouped by YEAR only, and add oil/gas price info
US_land_rig_counts_by_year_filtered_groupby_year_only = US_land_rig_counts %>% group_by(., Year) %>% summarise(
  .,
  weeks_during_year = max(Week),
  Avg_WTI_oil_price = round(mean(WTI), digits = 2),
  Avg_gas_price = round(mean(NatGas), digits = 2)
)

#Create dataframe grouped by MONTH only, and add oil/gas price info

US_land_rig_counts_by_month_filtered_groupby_month_only = US_land_rig_counts %>% group_by(., Month_Year) %>% summarise(
  .,
  weeks_during_month = n_distinct(Week),
  Avg_WTI_oil_price = round(mean(WTI), digits = 2),
  Avg_gas_price = round(mean(NatGas), digits = 2)
)


#Create dataframe grouped by WEEK only, and add oil/gas price info

US_land_rig_counts_by_week_filtered_groupby_week_only = US_land_rig_counts %>% group_by(., Year_Week) %>% summarise(
  .,
  weeks_during_week = n_distinct(Week),
  Avg_WTI_oil_price = round(mean(WTI), digits = 2),
  Avg_gas_price = round(mean(NatGas), digits = 2)
)

#Create initial US_land_rig_counts_by_year dataframe on which the 'default' screen / selections are based
US_land_rig_counts_by_year_filtered = US_land_rig_counts %>% filter(., DrillFor %in% c("Gas","Oil","Miscellaneous")) %>% group_by(., Year, Basin)
US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston'))) 
US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
  Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
  Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
  Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
  Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
  Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
  Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
  Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
  Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
  Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
  Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
  Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
  Other_Avg = round(Other / weeks_during_year, digits =0),
  Permian_Avg = round(Permian / weeks_during_year, digits =0),
  Utica_Avg = round(Utica / weeks_during_year, digits =0),
  Williston_Avg = round(Williston / weeks_during_year, digits =0),
  Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
)

#Create initial US_land_rig_counts_by_month dataframe
US_land_rig_counts_by_month_filtered = US_land_rig_counts %>% filter(., DrillFor %in% c("Gas","Oil","Miscellaneous")) %>% group_by(., Month_Year, Basin)
US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
  Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
  Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
  Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
  Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
  Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
  Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
  Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
  Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
  Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
  Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
  Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
  Other_Avg = round(Other / weeks_during_month, digits =0),
  Permian_Avg = round(Permian / weeks_during_month, digits =0),
  Utica_Avg = round(Utica / weeks_during_month, digits =0),
  Williston_Avg = round(Williston / weeks_during_month, digits =0),
  Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
)

#Create initial US_land_rig_counts_by_week dataframe
US_land_rig_counts_by_week_filtered = US_land_rig_counts %>%  filter(., DrillFor %in% c("Gas","Oil","Miscellaneous")) %>% group_by(., Year_Week, Basin)
US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
  Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
  Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
  Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
  Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
  Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
  Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
  Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
  Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
  Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
  Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
  Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
  Other_Avg = round(Other / weeks_during_week, digits =0),
  Permian_Avg = round(Permian / weeks_during_week, digits =0),
  Utica_Avg = round(Utica / weeks_during_week, digits =0),
  Williston_Avg = round(Williston / weeks_during_week, digits =0),
  Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
)




##dataframes created for 'Table & pct change' tab
colnames(US_land_rig_counts_by_year)[1]

x = US_land_rig_counts_by_year %>% filter(., Year == 2011 | Year == 2019)


y = as_tibble(t(x), rownames = "row_names")
names(y) <- y %>% slice(1) %>% unlist()
y <- y %>% slice(-1)
y
y = as.data.frame(y)
y
colnames(y)
colnames(y)[1] = "Basin"
y
str(y)
z = y %>% mutate(., pct_change = (y[,3] / y[,2])-1) 
z = z[18:nrow(z),]
# z$pct_change = percent(z$pct_change, digits=0)
str(z)



