library(tidyverse)
library(sf)
library(leaflet)
library(ggplot2)

recentcoastFR_sf <- read_sf("N_traits_cote_naturels_recents_L_fr_epsg2154_062018_shape")
ancientcoastFR_sf <- read_sf("N_traits_cote_naturels_anciens_L_fr_epsg2154_062018_shape")

evolutioncoastFR_sf <- read_sf("N_evolution_trait_cote_S_fr_epsg2154_062018_shape")

# Fusion ancien et nouveau trait de côte
ggplot() +
  geom_sf(data = recentcoastFR_sf,
          fill = 'red',
          color = 'red',
          size = 20) +
  geom_sf(data = ancientcoastFR_sf,
          fill = NA,
          color = 'black',
          size = 1) +
  theme_void()

# Zone avec éoliennes en mer: 
zonageeol = read_sf("EMR_transmis_OSPAR_oct22")
ggplot() +
  geom_sf(data = recentcoastFR_sf,
          fill = 'red',
          color = 'black',
          size = 20) +
  geom_sf(data=zonageeol,
          fill='lightgreen',
          color='green')+
  theme_void()
#===========================================================================



# Carte des régions de France + éoliennes en mer
library(rmapshaper)

regionfrancaise = read_sf("regions-20180101-shp")
ggplot() +
  geom_sf(data = ms_filter_islands(regionfrancaise, 1400E8))+
  geom_sf(data=zonageeol,
          fill='lightgreen',
          color='green')+
  theme_void()

# Focus sur les Pays de la Loire et le parc éolien de St Naz
library(dplyr)
paysLoire <- filter(regionfrancaise, nom == "Pays de la Loire")
eolguérande <- filter(zonageeol, Site == "Saint-Nazaire")

library(maps)
view(world.cities)

france_cities_PDLL <- world.cities %>% # PDLL pour pays de la loire
  filter(country.etc == "France") %>%
  filter(name %in% c("Nantes", "Saint-Nazaire", "La Baule-Escoublac"))

ggplot()+
  geom_sf(data=paysLoire,
          fill = "darkgreen",
          color = "black")+
  geom_sf(data=eolguérande,
          fill='lightblue',
          color='darkblue')+
  theme_void()



library(sf)

# Convertir les données en un format spatial
france_cities_PDLL_sf <- st_as_sf(france_cities_PDLL, coords = c("long", "lat"), crs = 4326)

library(ggplot2)
library(ggrepel)

ggplot() +
  geom_sf(data = paysLoire,
          fill = "darkgreen",
          color = "black") +
  geom_sf(data = eolguérande,
          aes(fill = 'Parc éolien de St-Nazaire'),
          color = 'darkblue') +
  geom_sf(data = france_cities_PDLL_sf,
          aes(size = pop, color = 'red')) +
  geom_text_repel(data = france_cities_PDLL_sf,
                  aes(label = name, 
                      x = st_coordinates(geometry)[, 1], 
                      y = st_coordinates(geometry)[, 2])) +
  scale_size(range = c(1, 10)) + 
  scale_fill_manual(values = c('Parc éolien de St-Nazaire' = 'lightblue')) +
  theme_void() +
  # Ajoutez un titre
  labs(title = "Loire-Atlantique")








