library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(stringr)
library(purrr)


# Read in files for testing phase (remove from final product)
# pollution_df <- read_csv("data/processed_data.csv",
#                col_types = cols_only(index = col_date(),
#                                      STATION_NAME = col_factor(),
#                                      PARAMETER = col_factor(),
#                                      RAW_VALUE = col_double()))
# 
# df_avg <- read_csv("data/processed_baseline_data.csv",
#                   col_types = cols_only(index = col_date(),
#                                      PARAMETER = col_factor(),
#                                      RAW_VALUE = col_double()))


###### Plot 1: Location Linechart

#' Construct a linechart that compares a specified pollutant concentration across selected times and locations
#'
#' @param data Main Dataframe containing pollutant concentrations for each location
#' @param avg_data Dataframe containing pollutant averages
#' @param pm pollutant type
#' @param init_locations list of BC locations
#' @param width plot width
#' @param height plot height
#' @param daterange list containing a year range
#' 
#' @return ggplot linechart based on filters
#' @examples
#' location_linechart(data, avg_data, pm = "PM25", init_locations= list(), width = NULL, height = NULL, daterange=list(2000,2017))
location_linechart <- function(data, avg_data, pm = "PM25", init_locations= list(), width = NULL, height = NULL, daterange=list(2000,2017)){
  temp_data <- data %>% filter(PARAMETER == pm, STATION_NAME %in% init_locations)
  
  #Preserve location and conduct rolling avg operation on the nested data frame (updates RAW_VALUE column)
  nested_df <- nest(temp_data,c(index, PARAMETER, RAW_VALUE))
  nested_df$data <- lapply(nested_df$data, function(df) df %>% mutate(RAW_VALUE = rollmean(RAW_VALUE, 5, na.pad = TRUE)))
  temp_data <- unnest(nested_df, cols = data)
  
  temp_data <- temp_data %>% filter(index > as.Date(as.character(daterange[[1]]), format='%Y') & index <= as.Date(as.character(daterange[[2]]), format = '%Y')) 
  temp_avg <- avg_data %>% filter(PARAMETER == pm)
  
  
  ggplot(temp_data, aes(x = index, y = RAW_VALUE, color = STATION_NAME)) + 
  geom_line(data = temp_avg, aes(x = index, y = RAW_VALUE), color = "grey") +
  geom_point(data = temp_avg, aes(x = index, y = RAW_VALUE), color = "grey") +
  geom_line() +
  geom_point() +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "Year",
       y = "Pollutant Concentration (mu*g/m3)", 
       color = "Locations")
  
}

###### Plot 2: One Location Linechart

#' Construct a linechart that compares pollutant concentrations across selected time, for a given location
#'
#' @param data Main Dataframe containing pollutant concentrations for each location
#' @param avg_data Dataframe containing pollutant averages
#' @param init_locations list of BC locations
#' @param width plot width
#' @param height plot height
#' @param daterange list containing a year range
#' 
#' @return ggplot linechart based on filters
#' @examples
#' linechart(data, avg_data, init_locations= list(), width = NULL, height = NULL, daterange=list(2000,2017))
linechart <- function(data, avg_data, init_locations= list(), width = NULL, height = NULL, daterange= list(2000,2017)){
  
  temp_data <- data %>% filter(STATION_NAME %in% init_locations)
  
  #Preserve location and conduct rolling avg operation on the nested data frame (updates RAW_VALUE column)
  nested_df <- nest(temp_data, c(index, STATION_NAME, RAW_VALUE))
  nested_df$data <- lapply(nested_df$data, function(df) df %>% mutate(RAW_VALUE = rollmean(RAW_VALUE, 5, na.pad = TRUE)))
  temp_data <- unnest(nested_df, cols = data)
  
  temp_data <- temp_data %>% filter(index > as.Date(as.character(daterange[[1]]), format='%Y') & index <= as.Date(as.character(daterange[[2]]), format = '%Y')) 
  #temp_PM10 <- temp_data %>% filter(PARAMETER == "PM10")
  #temp_PM25 <- temp_data %>% filter(PARAMETER == "PM25")
  levels(temp_data$PARAMETER) <- c("PM10", "PM2.5")
  
  ggplot(temp_data, aes(x = index, y = RAW_VALUE, color = PARAMETER)) +
  geom_line(data = avg_data, aes(x = index, y = RAW_VALUE, group = PARAMETER), color = "grey") +
  geom_point(data = avg_data, aes(x = index, y = RAW_VALUE, group = PARAMETER), color = "grey") +
  geom_line() +
  geom_point() +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "Year", y = "Pollutant Concentration (mu*g/m3)")
  
}


###### Plot 3: Distribution Histogram

#' Construct a barchart that compares a specified pollutant concentration across selected times and locations
#'
#' @param data Main Dataframe containing pollutant concentrations for each location
#' @param pm pollutant type
#' @param init_locations list of BC locations
#' @param width plot width
#' @param height plot height
#' @param daterange list containing a year range
#' 
#' @return ggplot linechart based on filters
#' @examples
#' barplot(data, pm = "PM25", init_locations= list(), width = NULL, height = NULL, daterange=list(2000,2017))
barplot <- function(data, pm = "PM25", init_locations = list(), width = NULL, height = NULL, daterange= list(2000,2017)){
    
    temp_data <- data %>% filter(PARAMETER == pm, STATION_NAME %in% init_locations)
    temp_data <- temp_data %>% filter(index > as.Date(as.character(daterange[[1]]), format='%Y') & index <= as.Date(as.character(daterange[[2]]), format = '%Y')) 
    
    ggplot(temp_data, aes(x = RAW_VALUE, fill = STATION_NAME, color = STATION_NAME)) + 
    geom_histogram(position = "identity", alpha = 0.3, binwidth = 0.5)  +
    scale_color_brewer(palette = "Dark2") +
    scale_fill_brewer(palette = "Dark2") +
    labs(x = "Pollutant Concentration (mu*g/m3)", y = "Frequency", fill = "Locations") +
    guides(color=FALSE)
    
    
}

###### Plot 4: Heatmap

#' Construct a heatmap that shows specified pollutant concentrations across years and locations
#'
#' @param data Main Dataframe containing pollutant concentrations for each location
#' @param avg_data Dataframe containing pollutant averages
#' @param pm pollutant type
#' @param width plot width
#' @param height plot height
#' @param daterange list containing a year range
#' 
#' @return ggplot linechart based on filters
#' @examples
#' heatmap(data, pm = "PM25", width = NULL, height = NULL, daterange=list(2000,2017))
heatmap <- function(data, avg_data, pm = "PM25", width = NULL, height = NULL, daterange= list(2000,2017), include_years=FALSE){
    
    temp_data <- data %>% filter(PARAMETER == pm)
    
    x_axis_vals <- str_extract(temp_data$index, ".*-01-01")
    x_axis_vals <- unique(x_axis_vals[!is.na(x_axis_vals)])
    new_x_vals <- lapply(x_axis_vals, function(x) paste("Jan\n ", str_replace(x, "(-01-01)", "")))

    if(include_years){
	print('here')
    	ggplot(temp_data, aes(x = factor(index), y = STATION_NAME, fill = RAW_VALUE)) +
          geom_tile() +
          scale_x_discrete(breaks = c(x_axis_vals), labels = c(new_x_vals)) +
          scale_fill_viridis(option = "magma", direction = -1) +
          labs( x = "Date",y = "Location", fill = "Pollution\nConcentration\n(mu*g/m3)") +
          theme(legend.title = element_text( size = 7), 
		legend.position = "top")
    } else {
    	ggplot(temp_data, aes(x = factor(index), y = STATION_NAME, fill = RAW_VALUE)) +
          geom_tile() +
          scale_x_discrete(breaks = c(x_axis_vals), labels = c(new_x_vals)) +
          scale_fill_viridis(option = "magma", direction = -1) +
          labs( x = "Date",y = "Location", fill = "Pollution\nConcentration\n(mu*g/m3)") +
          theme(legend.title = element_text( size = 7), 
		legend.position = "top",
		axis.text.x=element_blank(),
        	axis.ticks.x=element_blank()) 
    }
}
