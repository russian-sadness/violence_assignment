library(tidyverse)
library(dplyr)

# open the csv with Chechnya data

chechnya_all_data <- read.csv('chechnya.csv', stringsAsFactors = FALSE)

#order data by year to make it easier to read, just to check what is going on
chechnya_ordered <- chechnya_all_data[order(chechnya_all_data$year),]

#get average deaths per year 
chechnya_all_data= group_by(chechnya_all_data, year) %>% 
  mutate(average = mean(best)) 


##realize it was a bad idea, because averaging deaths is something unusual 

# side_a vs side_b -> chechnya_group
# In order to make some sence out of the conflicts in Chechnya I've decided to combine sides "a"with the corresponding sides "b"., this gave 8 distinct types of conflicts + Another
chechnya_grouped <- chechnya_all_data %>%
  mutate(
    conflict_sides = paste(side_a, side_b, sep=' vs '),
    conflict_name = case_when(
      conflict_sides == "Government of Russia (Soviet Union) vs Chechen Republic of Ichkeria" ~ "Russia vs Ichkeria",
      conflict_sides == "Government of Russia (Soviet Union) vs Civilians" ~ "Russia vs Civilians",
      conflict_sides == "Government of Russia (Soviet Union) vs Forces of the Caucasus Emirate" ~ "Russia vs The Caucasus Emirate",
      conflict_sides == "Government of Russia (Soviet Union) vs IS" ~ "Russia vs IS",
      conflict_sides == "Chechen Republic of Ichkeria vs Civilians" ~ "Ichkeria vs Civilians",
      conflict_sides == "Forces of the Caucasus Emirate vs Civilians" ~ "The Caucasus Emirate vs Civilians",
      conflict_sides == "Chechen Republic of Ichkeria vs Provisional Council of the Chechen Republic" ~ "Ichkeria vs Provisional Council of the Chechen Republic",
      conflict_sides == "Chechen Republic of Ichkeria vs Forces of Ruslan Labazanov" ~ "Ichkeria vs Labazanov",
      
      TRUE ~ "Another"
    )
  )

# data analysis
# gives total deaths for each conflict_name per year
chechnya_grouped_new = group_by(chechnya_grouped, year, conflict_name) %>% 
  summarise(total_death = sum(best))



#chechnya_for_plot = filter(chechnya_grouped_new, total_death > 3) --> filtering only those that have non-zero values will mean that the data vas missed which is not the case

#adding colorblind palette
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#CC79A7", "#0072B2", "#D55E00", "#F0E442", "#999999")


#plotting total deahts vs years for conflict_name
plot1 <- ggplot(chechnya_grouped_new, aes(x = year, y = total_death)) + 
  geom_bar(stat = "identity", aes(fill = conflict_name)) + 
  scale_x_continuous(breaks=seq(1994,2015,2))+
  scale_y_continuous(breaks=seq(0, 5000, 250))
plot_1 + scale_fill_manual(values=cbPalette, name="Conflict Sides")+
  ggtitle("Deaths per Year") +
  xlab("Years") + 
  ylab("Total Deaths") 

#plotting deaths on the ggmap
#used “Maps Static API” from the google cloud platform 
# latest install
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup", force=TRUE)
library("ggmap")
ggmap::register_google(key = "My key can be found in the assignment report file")

#create a map
# used coordinates of Grozny city as a center., used all deaths instead of total_per_something just to show the number of people died on this territory is huge
map_chechnya <- ggmap(get_googlemap(center = c(lon = 45.6815, lat = 43.3169),
                                    zoom = 8, scale = 2,
                                    maptype ='roadmap',
                                    color = 'color')) 

map_chechnya + geom_point(data = chechnya_grouped, aes(x = longitude, y = latitude,  colour = conflict_name, size = best))+ 
  theme(legend.position="bottom") +
  ggtitle("Violence in Chechnya from 1989 till 2015") +
  xlab("Longitude") + 
  ylab("Latitude") 

#Warning message: Removed 1 rows containing missing values (geom_point) --> I did not manage to adjust zooming to keep all values, because the zoom should be equal to the round number





