library(tidyverse)
library(rvest)
library(htmltab)

url <- "https://okinawa.stopcovid19.jp/en"

webpage_parse <- read_html(url)

temp <- webpage_parse %>%
  html_nodes("table") %>%
  html_table()
