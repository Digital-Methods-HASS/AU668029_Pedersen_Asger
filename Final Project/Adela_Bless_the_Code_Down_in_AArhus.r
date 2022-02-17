title: "Final_Project"
author: "Emil Jacobsen and Asger Kammer"
date: "17/02/2022"

#please run the code in this order
#Line 9-12 --> line 16-17 --> line 22-64

# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)
library(htmlwidgets) #optional

#read in google sheet, please follow the instructions below closely
# 1. Run the code below 2. Type the number 0 into console 3. Choose your preffered google acount 4. tick the box that allows R to manage your data and click next 5. the file should now load
places_pacific <- read_sheet("https://docs.google.com/spreadsheets/d/1IAsEHlXaitLqfSqyidO9rbP73RNUCZq1A4O54BI3jO4/edit#gid=0",
                             col_types = "cccnnccccccccnncccccnn")
#if it does not work, pls run the code on line on line 78 instead, it should work just as well, but do keep in mind that the project was originally made with google sheets and bugs may occour


# Create a basic basemap


l_pacific <- leaflet() %>%   # assign the base location to an object
  setView(142.6809142, 25.6106278, zoom = 3)

esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  l_pacific <- l_pacific %>% addProviderTiles(provider, group = provider)
}

#Making it all come together

PACIFICmap <- l_pacific %>%
  addLayersControl(baseGroups = names(esri),
                   overlayGroups = c("before_midway", "after_midway","def_perimeter"),
                   options = layersControlOptions(collapsed = FALSE))%>%
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
  addControl("", position = "topright") %>%
  addTiles() %>%
  addMarkers(lng = places_pacific$Longitude,
             lat = places_pacific$Latitude,
             group = "before_midway",
             popup = paste("<strong>Type: </strong>",places_pacific$Type,"<br><strong>Location : </strong>",places_pacific$Location,"<br><strong>Description : </strong>",places_pacific$Description,
                           "<br><strong>Start_Date : </strong>",places_pacific$Start_Date,"<br><strong>End_Date : </strong>",places_pacific$End_Date,"<br><strong>Source : </strong>",places_pacific$Sources,"<br><strong>Result : </strong>",places_pacific$Results),
             clusterOptions = markerClusterOptions()) %>%
  addMarkers(lng = places_pacific$Longitude_af_m,
             lat = places_pacific$Latitude_af_m,
             group = "after_midway",
             popup = paste("<strong>Type: </strong>",places_pacific$Type_af_m,"<br><strong>Location : </strong>",places_pacific$Location_af_m,"<br><strong>Description : </strong>",places_pacific$Description_af_m,
                           "<br><strong>Start_Date : </strong>",places_pacific$Start_Date_af_m,"<br><strong>End_Date : </strong>",places_pacific$End_Date_af_m,"<br><strong>Source : </strong>",places_pacific$Sources_af_m,"<br><strong>Result : </strong>",places_pacific$Results_af_m),
             clusterOptions = markerClusterOptions()) %>%
  addPolylines(lat = places_pacific$DP_Latitude, lng = places_pacific$Dp_Longitude, color = "red", group = "def_perimeter")

#Run the map
PACIFICmap

saveWidget(PACIFICmap, file="PACIFCmap.html")


#DO NOT RUN UNLESS THE GOOGLE SHEET FILE DOES NOT WORK
places_pacific <- read.csv(file = 'Pacific_War_Coordinates.csv')




