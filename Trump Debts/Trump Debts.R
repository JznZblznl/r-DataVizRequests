####################################################################################################################
#
# Map to visualize Unpaid bills from Trump rallies in 2016-2019
# In responce to https://www.reddit.com/r/DataVizRequests/comments/juxwxf/request_county_map_of_moneys_owed_by_the_trump/
# Chart data from the artilce  https://publicintegrity.org/politics/donald-trump-police-cities-bills-maga-rallies/
# Version 1.0, 16 November 2020
#                                                                                          o__\|///
#___________________________________________________________________________________________\°/////___ JznZblznl ___
####################################################################################################################

library(ggplot2)
library(ggrepel)
library(dplyr)
library(maps)

# Read debt from file
debts <- na.omit(read.csv(file = "Trump Debts.csv", stringsAsFactors = FALSE))
# Get data on US cities
data(us.cities)

# Merge det data with city coordinates data
# City coordinates are taken from maps package and complemented with city data from Wiki for  known missed cities,  
# "Burlington VT", 44.475833, -73.211944
# "Lebanon OH",    39.426667, -84.2125
debts_cities <- merge(x = debts, y = rbind(us.cities, read.csv(file = "Known Unknown Places.csv", stringsAsFactors = FALSE)),
                      by.x="Municipality", by.y="name", all.x = TRUE) %>%
                # Generate labels in format Municipality + Unpaid bill size
                mutate(Data.label = paste(Municipality, "\n$", format(Unpaid.bill, digits=0, scientific = FALSE,  big.mark = ","), sep=""))

# Get data for USA states
USA_states <- map_data("state")

# Plot USA Map
ggplot(data = USA_states) + 
  # Plot USA Map, white state bordes, light gray 
  geom_polygon(aes(x = long, y = lat, group = group), color = "white", fill = "light gray") + 
  # Plot bubbles for debt, location by city location, size scale by Unpaid bill size, color by Unpaid bill size
  geom_point(data=debts_cities, aes(x=long, y=lat, size=Unpaid.bill, color=Unpaid.bill), alpha=0.8) +
  scale_colour_gradientn(colours=c("#FF6666", "#660000")) +
  scale_size_continuous(range=c(1,16)) + 
  # Add labels 
  geom_text_repel(data=debts_cities, aes(x=long, y=lat, label=Data.label), nudge_x = 0, nudge_y = 0, size=3) + 
  # Final touches for chart formatting
  coord_fixed(1.3) + 
  theme_void() +
  theme(legend.position = "none")
