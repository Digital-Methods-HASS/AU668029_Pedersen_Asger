###   GETTING STARTED WITH LEAFLET

# Try to work through down this script, observing what happens in the plotting pane.

# Review favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified

# To install Leaflet package, run this command at your R prompt:
install.packages("leaflet")

# We will also need this widget to make pretty maps:
install.packages("htmlwidget")

# Activate the libraries
library("leaflet")
library("htmlwidgets")

l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)

esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  DANmap <- l_aus %>% addProviderTiles(provider, group = provider)
}
# Task 1: Create a Danish equivalent of AUSmap with esri layers, 
# but call it DANmap

DANmap
leaflet() %>%
  setView(lat = 56.1873276, lng = 10.2143355, zoom = 10) %>%
  addTiles()
den1 <- leaflet() %>%
  setView(lat = 56.1873276, lng = 10.2143355, zoom = 10) %>%
  esri <- grep("^Esri", providers, value = TRUE)
for (provider in esri) {
  den1 <- den1 %>% addProviderTiles(provider, group = provider)
}

DANmap <- den1 %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>%
  htmlwidgets::onRender("
function(el, x) {
var myMap = this;
myMap.on('baselayerchange',
function (e) {
myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
})
}") %>%
  addControl("", position = "topright")

# For some reason I dont understand how to add esri layers, so this is as far as i got. I dont think it works as intended. I think it's because of the current version of Rstudio i am on. 

