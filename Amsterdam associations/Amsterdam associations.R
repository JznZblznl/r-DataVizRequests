####################################################################################################################
#
# Packed Bubble Chart to vizualize open question results
# In responce to https://www.reddit.com/r/DataVizRequests/comments/jr7coj/visualize_open_question_results/
# Version 1.0, 13 November 2020
#                                                                                          o__\|///
#___________________________________________________________________________________________\°/////___ JznZblznl ___
####################################################################################################################
library(packcircles)
library(ggplot2)

# Load dataset
AMS <- read.csv("Amsterdam associations.csv", stringsAsFactors = FALSE)
# Generate packaging of bubbles and biung it back to data
packing <- circleProgressiveLayout(AMS$Weight, sizetype='area')
AMS_data <- cbind(AMS, packing)
# See example of packed bubble chart https://www.r-graph-gallery.com/305-basic-circle-packing-with-one-level.html
# Generate bubbles, approximated by polygons. npoints=50 generate smooth polygons, npoints=4 gets diamonds
# id is an unique id of the bubble 
dat.gg <- circleLayoutVertices(packing, npoints=50)

AMS_bubble <- ggplot() +
  # Make the bubbles
  geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = "black", alpha = 0.6) +
  # Add text in the center of each bubble + control its size
  geom_text(data = AMS_data, aes(x, y, size=Weight, label = Association)) +
  # Rest of theme
  labs(title = "Amsterdam associations") + 
  theme_void() + 
  theme(legend.position="none", plot.title = element_text(hjust = 0.5, size=14, face="bold")) + 
  coord_equal()
AMS_bubble