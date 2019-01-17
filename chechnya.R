library(tidyverse)
library(dplyr)


chechnya_all_data <- read.csv('chechnya.csv', stringsAsFactors = FALSE)

#order data by year to make it easier to read, just to check what is going on
chechnya_ordered <- chechnya_all_data[order(chechnya_all_data$year),]

#get average deaths per year 
chechnya_all_data= group_by(chechnya_all_data, year) %>% 
  mutate(average = mean(best)) 



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

# some stats just in case
# gives total deaths for each conflict_name per year
chechnya_grouped_new = group_by(chechnya_grouped, year, conflict_name) %>% 
 summarise(total_death = sum(best))

# DONT FORGET THE colorblind friendly pallete
#plotting total deahts vs years for conflict_name
ggplot(chechnya_grouped_new, aes(x = year, y = total_death)) + 
 geom_bar(stat = "identity", aes(fill = conflict_name)) + 
 scale_x_continuous(breaks=seq(1994,2015,2))

