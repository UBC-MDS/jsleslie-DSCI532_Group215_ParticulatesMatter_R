library(tidyverse)
library(plotly)
library(tibbletime)

## TO DO:
# - add comments/docstrings
# - use better color scheme
# - move the read_csv calls to app.R


pollution_df <- read_csv("data/processed_data.csv",
               col_types = cols_only(index = col_date(),
                                     STATION_NAME = col_factor(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))

df_avg <- read_csv("data/processed_baseline_data.csv",
                  col_types = cols_only(index = col_date(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))

# temp_data$RAW_VALUE <- stats::filter(temp_data$RAW_VALUE, rep(1/5,5), method = "convolution", sides = 2)

###### Plot 1: Location Linechart

location_linechart <- function(data, avg_data, pm = "PM25", init_locations= list(), width = NULL, height = NULL, daterange=list(2000,2017)){
  
  temp_data <- data %>% filter(PARAMETER == pm, STATION_NAME %in% init_locations)
  temp_avg <- avg_data %>% filter(PARAMETER == pm)
  temp_data$RAW_VALUE <- stats::filter(temp_data$RAW_VALUE, rep(1/5,5), method = "convolution", sides = 2)
  
  ggplot(temp_data, aes(x = index, y = RAW_VALUE, color = STATION_NAME)) + 
  geom_line(data = temp_avg, aes(x = index, y = RAW_VALUE), color = "grey") +
  geom_point(data = temp_avg, aes(x = index, y = RAW_VALUE), color = "grey") +
  geom_line() +
  geom_point() +
  labs(x = "Year",
       y = "Pollutant Concentration (µg/m3)", 
       title = "Abbotsford PM10 values VS Provincial Average",
       color = "Locations")
  
}

###### Plot 2: One Location Linechart

linechart <- function(data, avg_data, init_locations= list(), width = NULL, height = NULL, daterange= list(2000,2017)){
  
  temp_data <- data %>% filter(STATION_NAME %in% init_locations)
  #nested_df <- nest(temp_data,-PARAMETER) %>% mutate(data = map(data, function(x) rollmean(x$RAW_VALUE, 5, na.pad = TRUE)))
  # temp_PM10 <- temp_data %>% 
  #   filter(PARAMETER == "PM10") %>% 
  #   mutate(RAW_VALUE = stats::filter(RAW_VALUE, rep(1/5,5), method = "convolution", sides = 2))
  # temp_PM25 <- temp_data %>% 
  #   filter(PARAMETER == "PM25") %>%
  #   mutate(RAW_VALUE = stats::filter(RAW_VALUE, rep(1/5,5), method = "convolution", sides = 2))
    

  
  ggplot(temp_data, aes(x = index, y = RAW_VALUE, color = PARAMETER)) +
  geom_line(data = avg_data, aes(x = index, y = RAW_VALUE, group = PARAMETER), color = "grey") +
  geom_point(data = avg_data, aes(x = index, y = RAW_VALUE, group = PARAMETER), color = "grey") +
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Pollutant Concentration (µg/m3)", title = "Abbotsford PM10 values VS Provincial Average")
  
}


###### Plot 3: Distribution Histogram
barplot <- function(data, pm = "PM25", init_locations = list(), width = NULL, height = NULL, daterange= list(2000,2017)){
    
    temp_data <- data %>% filter(PARAMETER == pm, STATION_NAME %in% init_locations)
    
    ggplot(temp_data, aes(x = RAW_VALUE, fill = STATION_NAME, color = STATION_NAME)) + 
    geom_histogram(position = "identity", alpha = 0.3, binwidth = 0.5)  +
    labs(x = "Pollutant Concentration (µg/m3)", y = "Frequency", fill = "Locations") +
    guides(color=FALSE)
    
    
}

###### Plot 4: Heatmap

heatmap <- function(data, avg_data, pm = "PM25", width = NULL, height = NULL, daterange= list(2000,2017)){
    
    temp_data <- data %>% filter(PARAMETER == pm)
    
    x_axis_vals <- str_extract(temp_data$index, ".*-01-01")
    x_axis_vals <- unique(x_axis_vals[!is.na(x_axis_vals)])
    new_x_vals <- lapply(x_axis_vals, function(x) paste("Jan\n ", str_replace(x, "(-01-01)", "")))
    
    ggplot(temp_data, aes(x = factor(index), y = STATION_NAME, fill = RAW_VALUE)) +
           geom_tile() +
             scale_x_discrete(breaks = c(x_axis_vals), labels = c(new_x_vals)) +
            labs( x = "Date",y = "Location", fill = "Pollution Concentration (µg/m3)")
}