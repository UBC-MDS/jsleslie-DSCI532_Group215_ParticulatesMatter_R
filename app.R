
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
source("src/utils.R")

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


pm_df = read_csv("data/processed_data.csv",
               col_types = cols_only(index = col_date(),
                                     STATION_NAME = col_factor(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))

avg_df = read_csv("data/processed_baseline_data.csv",
                  col_types = cols_only(index = col_date(),
                                     PARAMETER = col_factor(),
                                     RAW_VALUE = col_double()))


chart_1 <- dccGraph(
  id = "chart-1",
  figure = ggplotly(linechart(pm_df, avg_df, init_locations = list("Vancouver")))
  ) 

chart_2 <- dccGraph(
  id = "chart-2",
  figure = ggplotly(location_linechart(pm_df, avg_df, init_locations = list("Vancouver", "Kelowna")))
)

chart_3 <- dccGraph(
  id = "chart-3",
  figure = ggplotly(barplot(pm_df, init_locations = list("Vancouver", "Kelowna")))
)

chart_4 <- dccGraph(
  id = "chart-4",
  figure = ggplotly(heatmap(pm_df)))

app$layout(
  htmlDiv(
    list(
      htmlDiv(className="row", style=list(backgroundColor="#000000", border='1px solid', padding_left="5"), children= list(
        htmlH3('Pollutants Matter BC – Visualization of Particulate Matter Concentrations',
                style= list(color = "#ffffff", margin_top = 2, margin_bottom = 2)),
        htmlP('This application tracks weighted monthly averages for pollution data collected from different stations across British Columbia. The measured pollutants, PM2.5 and PM10, refer to atmospheric particulate matter (PM) that have a diameter of less than 2.5 and 10 micrometers, respectively.',
                style= list(color = "#ffffff", margin_top = 2, margin_bottom = 2))
      )),

      htmlDiv(className="row", children = list(

        ## SIDE BAR - COLUMN 1
        htmlDiv(className = "two columns", children =list(

          htmlDiv(className = "row", 
            style=list(backgroundColor ="#8BBEE8FF",padding_left="10", padding_right="10", padding_top="2", padding_bottom="195",border= '1px solid'), 
            children = list(
                      htmlP("Chart 1 & 2 controls:\n\n\n"),
                      htmlP("Pollutant:"),

                      ### INSERT RADIO BUTTONS HERE

                      htmlP("Location:")

                      ### INSERT DROPDOWN LIST HERE
                    ))      
        )
      ),
        ## CHART 1 
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 1: <Polutant> Concentration for given locations", 
              style=list(backgroundColor ="#8BBEE8FF", border='1px solid', text_align='center', padding_left= "5")),
            chart_1))
        )
      ),

        ## CHART 2
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
            htmlDiv(className = "row", children=list(
              htmlH6("Chart 2: Distribution of <Pollutant> Concentrations for BC cities",
                style=list(backgroundColor ="#8BBEE8FF", border='1px solid', text_align='center', padding_left= "5")),
              chart_2))
          )
      ))
      ),

      htmlDiv(className="row", children = list(

        ## SIDE BAR - COLUMN 1
        htmlDiv(className = "two columns", children =list(
          
          ### BOX 2
          htmlDiv(className = "row", 
            style=list(backgroundColor ="#A8D5BAFF",padding_left="10", padding_right="10", padding_top="2", padding_bottom="195",border= '1px solid'), 
            children = list(
                      htmlP("Chart 3 controls:\n\n\n"),
                      htmlP("Location:")

                      ### INSERT DROPDOWN LIST HERE
                    )),

          ### BOX 3
          htmlDiv(className = "row", 
          style=list(backgroundColor ="#E3D1FB",padding_left="10", padding_right="10", padding_top="2", padding_bottom="195",border= '1px solid'), 
          children = list(
                    htmlP("Chart 4 controls:\n\n\n"),
                    htmlP("Pollutant:")

                    ### INSERT RADIO BUTTONS LIST HERE
                  ))      
        )
      ),
      ## CHART 3 
      htmlDiv(className = "five columns", children =list(
        htmlDiv(className = "row", children=list(
          htmlH6("Chart 3: Pollutant Concentration in <Location>",
            style=list(backgroundColor ="#A8D5BAFF", border='1px solid', text_align='center', padding_left= "5")),
          chart_3))
      )
    ),

      ## CHART 4
      htmlDiv(className = "five columns", children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 4: <Pollutant> Concentration Heatmap",
              style=list(backgroundColor ="#E3D1FB", border='1px solid', text_align='center', padding_left= "5")),
            chart_4))
        )
    ))
    ),



      htmlDiv(className = "row", children = list(
          #htmlP("Date control slider"),
           #BOX5 DATE CONTROLLER
          htmlDiv(className="row",  style=list(backgroundColor="#d2d7df", padding_bottom ="30", padding_left="10",  border ='1px solid'), children=list(
              htmlP("Date control slider", style=list(padding_top="0"))
              
              ### DATE SLIDER COMPONENT GOES HERE


              ),
          htmlA("BC Ministry of Environment and Climate Change Strategy", href = "https://catalogue.data.gov.bc.ca/dataset/77eeadf4-0c19-48bf-a47a-fa9eef01f409", target = "_blank"),
          htmlP("Data is limited to the stations where measurements were taken and therefore does not account for the entirety of BC")
      ))
      )
  
    )
    
  ))


# #### End of Component Making
# app$layout(
#   htmlDiv(
#     list(
#       htmlH1('Gapminder Dash Demo'),
#       htmlH2('Looking at country data interactively'),
#       #selection components
#       htmlLabel('Select a year range:'),
#       yearSlider,
#       htmlIframe(height=15, width=10, style=list(borderWidth = 0)), #space
#       htmlLabel('Select continents:'),
#       continentDropdown,
#       htmlLabel('Select y-axis metric:'),
#       yaxisDropdown,
#       #graph and table
#       graph, 
#       htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
#       htmlLabel('Try sorting by table columns!'),
#       table,
#       htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
#       dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")
#     )
#   )
# )
# Selection components

#We can get the years from the dataset to make ticks on the slider
# yearMarks <- lapply(unique(gapminder$year), as.character)
# names(yearMarks) <- unique(gapminder$year)
# yearSlider <- dccRangeSlider(
#   id="year",
#   marks = yearMarks,
#   min = 1952,
#   max = 2007,
#   step=5,
#   value = list(1952, 2007)
#)

# continentDropdown <- dccDropdown(
#   id = "continent",
#   options = lapply( # a shortcut for defining your options
#     levels(gapminder$continent), function(x){
#       list(label=x, value=x)
#     }),
#   value = levels(gapminder$continent), #Selects all by default
#   multi = TRUE
# )

# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
# yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
#                    value = c("gdpPercap", "lifeExp", "pop"))
# yaxisDropdown <- dccDropdown(
#   id = "y-axis",
#   options = lapply(
#     1:nrow(yaxisKey), function(i){
#       list(label=yaxisKey$label[i], value=yaxisKey$value[i])
#     }),
#   value = "gdpPercap"
# )

# Use a function make_graph() to create the graph

# # Uses default parameters such as all_continents for initial graph
# all_continents <- unique(gapminder$continent)
# make_graph <- function(years=c(1952, 2007), 
#                        continents=all_continents,
#                        yaxis="gdpPercap"){

#   # gets the label matching the column value
#   y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
#   #filter our data based on the year/continent selections
#   data <- gapminder %>%
#     filter(year >= years[1] & year <= years[2]) %>%
#     filter(continent %in% continents)
 
#   # make the plot!
#   # on converting yaxis string to col reference (quosure) by `!!sym()`
#   # see: https://github.com/r-lib/rlang/issues/116
#   p <- ggplot(data, aes(x=year, y=!!sym(yaxis), colour=continent)) +
#     geom_point(alpha=0.6) +
#     scale_color_manual(name="Continent", values=continent_colors) +
#     scale_x_continuous(breaks = unique(data$year))+
#     xlab("Year") +
#     ylab(y_label) +
#     ggtitle(paste0("Change in ", y_label, " Over Time")) +
#     theme_bw()
  
#   ggplotly(p)
# }

# # Now we define the graph as a dash component using generated figure
# graph <- dccGraph(
#   id = 'gap-graph',
#   figure=make_graph() # gets initial data using argument defaults
# )

# # Use another function to get filtered data for our table
# make_table <- function(years=c(1952, 2007), 
#                        continents=all_continents){
  
#   gapminder %>%
#     filter(year >= years[1] & year <= years[2]) %>%
#     filter(continent %in% continents) %>%
#     df_to_list()
  
# }

# # Table that can be sorted by column
# table <- dashDataTable(
#   id = "gap-table",
#   # these make the table scrollable
#   fixed_rows= list(headers = TRUE, data = 0),
#   style_table= list(
#     maxHeight = '200',
#     overflowY = 'scroll'
#   ),
#   columns = lapply(colnames(gapminder), 
#                    function(colName){
#                      list(
#                        id = colName,
#                        name = colName
#                      )
#                    }),
#   data = make_table(), #this gets initial data using argument defaults
#   sort_action="native"
# )
# #### End of Component Making
# app$layout(
#   htmlDiv(
#     list(
#       htmlH1('Gapminder Dash Demo'),
#       htmlH2('Looking at country data interactively'),
#       #selection components
#       htmlLabel('Select a year range:'),
#       yearSlider,
#       htmlIframe(height=15, width=10, style=list(borderWidth = 0)), #space
#       htmlLabel('Select continents:'),
#       continentDropdown,
#       htmlLabel('Select y-axis metric:'),
#       yaxisDropdown,
#       #graph and table
#       graph, 
#       htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
#       htmlLabel('Try sorting by table columns!'),
#       table,
#       htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
#       dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")
#     )
#   )
# )

# # Adding callbacks for interactivity
# # We need separate callbacks to update graph and table
# # BUT can use multiple inputs for each!
# app$callback(
#   #update figure of gap-graph
#   output=list(id='gap-graph', property='figure'),
#   #based on values of year, continent, y-axis components
#   params=list(input(id='year', property='value'),
#               input(id='continent', property='value'),
#               input(id='y-axis', property='value')),
#   #this translates your list of params into function arguments
#   function(year_value, continent_value, yaxis_value) {
#     make_graph(year_value, continent_value, yaxis_value)
#   })

# app$callback(
#   #update data of gap-table
#   output=list(id='gap-table', property='data'),
#   params=list(input(id='year', property='value'),
#               input(id='continent', property='value')),
#   function(year_value, continent_value) {
#     make_table(year_value, continent_value)
#   })

app$run_server()