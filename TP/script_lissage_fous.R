# Lissage des données oiseaux

filenames <- c(' 2017 04 23 SDAC05 MEIO BR004  trip 1 .csv',
               ' 2017 04 23 SDAC06 MEIO BR1705  trip 1 .csv',
               ' 2017 04 23 SDAC08 MEIO BR1703  trip 1 .csv'
)
fou_dta <- map_dfr(filenames, function(f_){
  ID <- f_ %>% stringr::str_split( ' ') %>% unlist() %>% stringr::str_subset('BR')
  read_delim(file.path("../data/Fou_sophie/2017", f_ ),
             ";", escape_double = FALSE, trim_ws = TRUE) %>%
    dplyr::select(id, vol, datetime,  alt, lat, lon, dist.nid) %>%
    rename(id_loc = id)  %>%
    mutate(ID = ID)
})

fou_dta_utm <- fou_dta %>% 
  st_as_sf(coords = c("lon", "lat")) %>% 
  mutate(dist_scaled = scale(dist.nid),
         dist_scaled_sq = dist_scaled^2,
         all_scaled = scale(alt)) %>% 
  st_set_crs(4326)  %>% 
  st_transform(crs=32725) %>% 
  mutate(Easting = st_coordinates(.)[,"X"],
         Northing = st_coordinates(.)[,"Y"])



# write.table(fou_dta_utm_smoothed, sep = ";", row.names = FALSE)