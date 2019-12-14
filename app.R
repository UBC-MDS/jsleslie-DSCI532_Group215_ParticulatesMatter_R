
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(readr)
library(plotly)
library(zoo)
library(ggplot2)
library(viridis)


source("https://raw.githubusercontent.com/UBC-MDS/DSCI532_Group215_ParticulatesMatter_R/master/src/utils.R")
source("https://raw.githubusercontent.com/UBC-MDS/DSCI532_Group215_ParticulatesMatter_R/master/src/tabs.R")

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


pm_df = read_csv("https://raw.githubusercontent.com/UBC-MDS/DSCI532_Group215_ParticulatesMatter_R/master/data/processed_data.csv",
               col_types = cols_only(index = col_date(),
                                     STATION_NAME = col_factor(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))

avg_df = read_csv("https://raw.githubusercontent.com/UBC-MDS/DSCI532_Group215_ParticulatesMatter_R/master/data/processed_baseline_data.csv",
                  col_types = cols_only(index = col_date(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))



app$layout(htmlDiv(list(
	      htmlDiv(className="row", style=list(backgroundColor="#000000", border='1px solid', padding="10px"), children= list(
		htmlH3('Pollutants Matter BC – Visualization of Particulate Matter Concentrations',
			style= list(color = "#ffffff", margin_top = 2, margin_bottom = 2)),
		htmlP('This application tracks weighted monthly averages for pollution data collected from different stations across British Columbia. The measured pollutants, PM2.5 and PM10, refer to atmospheric particulate matter (PM) that have a diameter of less than 2.5 and 10 micrometers, respectively.',
			style= list(color = "#ffffff", margin_top = 2, margin_bottom = 2))
	      )),
  dccTabs(id="tabs", value='tab-1', children=list(
    dccTab(label='Joint View', value='tab-1'),
    dccTab(label='Enlarged heatmap', value='tab-2')
    )),
  htmlDiv(id='tabs-content')
  )))

# Callback to change the content of the selected tab
app$callback(output('tabs-content', 'children'),
    params = list(input('tabs', 'value')),
function(tab){
  if(tab == 'tab-1'){
	return(get_first_tab(pm_df, avg_df))
    }
  else if(tab == 'tab-2'){
  return(get_second_tab(pm_df))}
}
)

# Callback to change the first plot
app$callback(
  output=list(id = 'chart-1', property='figure'),
  
  params=list(input(id = 'datarange', property='value'),
	      input(id = 'dropdown1', property='value')),

  function(year_value, location) {
    ggplotly(linechart(pm_df, avg_df, init_locations = location, daterange = year_value)) 
  }
)

# Callback to change the title of the first plot
app$callback(
  output=list(id = 'chart-1-title', property='children'),
  
  params=list(input(id = 'radio1', property='value')),

  function(pm_s) {
	if (pm_s == 'PM25') {
  		pm_s = 'PM2.5'
	}
	paste("Chart 1: ", pm_s, " Concentration for given locations")
  }
)

# Callback to change barplot
app$callback(
  output=list(id = 'chart-2', property='figure'),
  
  params=list(input(id = 'datarange', property='value'),
	      input(id = 'dropdown2', property='value'),
	      input(id = 'radio1', property='value')),

  function(year_value, locations, pm_s) {
    g <- ggplotly( barplot(pm_df, pm = pm_s, init_locations = locations, daterange = year_value)) %>%
    layout(dragmode = FALSE) 
  }
)

# Callback to change the barplot's title
app$callback(
  # update title
  output=list(id = 'chart-2-title', property='children'),
  
  # based on radio button
  params=list(input(id = 'radio1', property='value')),

  function(pm_s) {
	if (pm_s == 'PM25') {
  		pm_s = 'PM2.5'
	}
	paste("Chart 2: Distribution of ", pm_s, " Concentrations for BC cities")
  }
)

# Callback to change the third chart
app$callback(
  # update figure
  output=list(id = 'chart-3', property='figure'),
  
  # based on values of different components
  params=list(input(id = 'datarange', property='value'),
	      input(id = 'dropdown2', property='value'),
	      input(id = 'radio1', property='value')),

  function(year_value, locations, pm_s) {
    ggplotly(location_linechart(pm_df, avg_df, pm=pm_s, init_locations = locations, daterange = year_value))
  }
)

# Callback to change the title of the third chart
app$callback(
  # update figure title
  output=list(id = 'chart-3-title', property='children'),
  
  # based on dropdown menu value
  params=list(input(id = 'dropdown1', property='value')),

  function(location) {
    paste("Chart 3: Pollutant Concentration in ",  location)
  }
)

# Callback to change the first tab's heatmap
app$callback(
  # update figure
  output=list(id = 'chart-4', property='figure'),
  
  # based on value of pm component
  params=list(input(id = 'radio2', property='value')),

  function(pm_s) {
	ggplotly(heatmap(pm_df, pm=pm_s))
  }
)

# Callback to change the first tab's heatmap's title
app$callback(
  # update title
  output=list(id = 'chart-4-title', property='children'),
  
  # based on value of pm component
  params=list(input(id = 'radio2', property='value')),

  function(pm_s) {
	if (pm_s == 'PM25') {
  		pm_s = 'PM2.5'
	}
	paste("Chart 4: ", pm_s, " Concentration Heatmap")
  }
)

# Callback for second tab heatmap
app$callback(
  # update figure
  output=list(id = 'chart-heatmap', property='figure'),
  
  # based on value of pm component
  params=list(input(id = 'heatmap_pm', property='value')),

  function(pm_s) {
	ggplotly(heatmap(pm_df, pm=pm_s, include_years=TRUE))
  }
)
app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050))
