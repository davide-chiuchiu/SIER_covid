library(readxl)
library(tidyverse)
library(rstudioapi)
library(lubridate)

# utility
`%notin%` <- Negate(`%in%`)

# Set working directory to where this script is locates
setwd(dirname(getActiveDocumentContext()$path))

# file to load
folder <- "airport_data"
file_to_load_naha_airport <- "snippet_airport_data_12-Apr-2020.xlsx"
file_to_load_flightradar <- "flightradar_snippet_12-Apr-2020.xlsx"
file_to_load_naha_airport <- file.path(folder, file_to_load_naha_airport)
file_to_load_flightradar <- file.path(folder, file_to_load_flightradar)

# Airports within Okinawa prefecture
destinations_in_okinawa <- c("AMAMIOSHIMA", "ISHIGAKI", "KITADAITO", "KUMEJIMA", "MINAMIDAITO", "MIYAKO", "OKINOERABU", "YONAGUNI", "YORON")

# import data
airport_data_naha_airport <- read_excel(file_to_load_naha_airport) %>%
  filter(!is.na(Destination)) %>%
  filter(Destination %notin% destinations_in_okinawa)
airport_data_flightradar <- read_excel(file_to_load_flightradar, range = cell_rows(c(2, NA))) %>%
  mutate(DateTime = ymd(DateTime))

# get destinations
Oka_destinations <- data.frame(destinations = unique(airport_data_naha_airport$Destination)) %>%
  arrange(destinations)



# estimate fraction of cancelled flights
total_flights <- airport_data_naha_airport %>%
  summarize( total = n())
cancelled_flights <- airport_data_naha_airport %>%
  filter(Remarks == "CANCELLED") %>%
  summarize(cancelled = n())
total_summary <- total_flights %>%
  bind_cols(cancelled_flights) %>%
  mutate(flying =  total - cancelled, fraction_cancelled = cancelled / total) %>%
  mutate(DateTime = ymd("2020-05-12"))

airport_data_flightradar <- airport_data_flightradar %>%
  mutate(fraction_cancelled = 1 - `Tracked flights` / `Scheduled flights`)

# comparison with data from flightradar
airport_data_flightradar %>%
  ggplot(aes(x = DateTime, y = fraction_cancelled)) +
  geom_line() + 
  geom_point(aes(x = total_summary$DateTime, y = total_summary$fraction_cancelled))

