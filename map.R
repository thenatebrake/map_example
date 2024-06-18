require(tidyverse) 
require(urbnmapr)
require(sf)
## To install urbnampr
#require("devtools")
#devtools::install_github("UrbanInstitute/urbnmapr")
packages <- installed.packages()


## Get map data from urbanmapr package
#METHOD 1 (Recommended, but may not be applicable)
counties <- get_urbn_map("counties", sf = TRUE) 
states <- get_urbn_map("states", sf = TRUE)

## Ignore warnings, they come from converting an older version of a special features object to a recent one, 
## they have no real impact

#METHOD 2
counties2 <- urbnmapr::counties
states2 <- urbnmapr::states

## Example Data 
data_county <- urbnmapr::countydata
data_states <- urbnmapr::statedata

##### METHOD 1 #####

## Apply filtering criterion 
wv_counties <- counties %>% filter(state_name == "West Virginia")
# Join with example data 
wv_df <- wv_counties %>% left_join(data_county, by = c("county_fips"))
## Plot Data
wv_df %>% ggplot + geom_sf(aes(fill = horate))

## Again with states df
states %>% 
  left_join(data_states, by = ("state_name")) %>%
  ggplot() + 
  geom_sf(aes(fill = medhhincome)) 

### TRY THIS
county_wrong_join <- data_county %>% right_join(wv_counties, by = "county_fips")
county_wrong_join %>% ggplot + 
  geom_sf(aes(fill = horate))
## SF objects can behave differently when they are joined the wrong way. As a general rule of thumb, 
# keep SF objects to the left side of a join. 

##### METHOD 2 #####

county_df <- counties2 %>% left_join(data_county, by = "county_fips")
ggplot_counties <- county_df %>% ggplot(aes(long, lat, group = group))  +
  geom_polygon(aes(fill = horate)) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

## If you need to label -- this works on both methods
ggplot_counties + 
  geom_text(data = urbnmapr::get_urbn_labels(), aes(long, lat, label = state_abbv), size = 3,inherit.aes = FALSE)



## LET ME KNOW IF YOU HAVE ANY QUESTIONS 
