library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
#library(tidyverse)
library(plotly)
source("./src/utils.R")

get_first_tab <- function(pm_df, avg_df) {

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

	slidebar_marks <- map(2000:2017, as.character)
	names(slidebar_marks) <- 2000:2017


  return(htmlDiv(
    list(
      htmlDiv(className="row", children = list(

        ## SIDE BAR - COLUMN 1
        htmlDiv(className = "two columns", children =list(

          htmlDiv(className = "row", 
            style=list(backgroundColor ="#8BBEE8FF",padding_left="10", padding_right="10", padding_top="2", padding_bottom="195",border= '1px solid'), 
            children = list(
                      htmlP("Chart 1 & 2 controls:\n\n\n"),
                      dccRadioItems(
		       id = 'radio1',
                       options=list(
                       list("label" = "PM10", "value" = "PM10"),
                       list("label" = "PM2.5", "value" = "PM25")
                       ),
                       value = "PM10"
                       ),
       		    htmlP("Pollutant:"),

                      ### INSERT RADIO BUTTONS HERE

                      htmlP("Location:"),

	              dccDropdown(
	                # purrr:map can be used as a shortcut instead of writing the whole list
	                # especially useful if you wanted to filter by country!
	                id = 'dropdown2',
	                options = map(
	          	levels(pm_df$STATION_NAME), function(x){
	          	list(label=x, value=x)
	                }),
	                value = 'Vancouver', #Selects all by default
	                multi = TRUE
	              )
                      ### INSERT DROPDOWN LIST HERE
                    ))      
        )
      ),
      ## CHART 3 
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 3: <Polutant> Concentration for given locations", 
	      id = 'chart-3-title',
              style=list(backgroundColor ="#8BBEE8FF", border='1px solid', text_align='center', padding_left= "5")),
            chart_3))
        )
      ),

        ## CHART 2
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
            htmlDiv(className = "row", children=list(
              htmlH6("Chart 2: Distribution of <Pollutant> Concentrations for BC cities",
		id = 'chart-2-title',
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
                      htmlP("Location:"),

	              dccDropdown(
	                # purrr:map can be used as a shortcut instead of writing the whole list
	                # especially useful if you wanted to filter by country!
	                id = 'dropdown1',
	                options = map(
	                  levels(pm_df$STATION_NAME), function(x){
	                  list(label=x, value=x)
	                }),
	                value = 'Vancouver', #Selects all by default
	                multi = FALSE
	              )
                    )),

          ### BOX 3
          htmlDiv(className = "row", 
          style=list(backgroundColor ="#E3D1FB",padding_left="10", padding_right="10", padding_top="2", padding_bottom="195",border= '1px solid'), 
          children = list(
                    htmlP("Chart 4 controls:\n\n\n"),
                    htmlP("Pollutant:"),

                      dccRadioItems(
		       id = 'radio2',
                       options=list(
                       list("label" = "PM10", "value" = "PM10"),
                       list("label" = "PM2.5", "value" = "PM25")
                       ),
                       value = "PM10"
                       )
                    ### INSERT RADIO BUTTONS LIST HERE
                  ))      
        )
      ),
        ## CHART 3 
      htmlDiv(className = "five columns", children =list(
        htmlDiv(className = "row", children=list(
          htmlH6("Chart 3: Pollutant Concentration in <Location>",
	    id = 'chart-3-title',
            style=list(backgroundColor ="#A8D5BAFF", border='1px solid', text_align='center', padding_left= "5")),
          chart_1))
      )
    ),

      ## CHART 4
      htmlDiv(className = "five columns", children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 4: <Pollutant> Concentration Heatmap",
	      id = 'chart-4-title',
              style=list(backgroundColor ="#E3D1FB", border='1px solid', text_align='center', padding_left= "5")),
            chart_4))
        )
    ))
    ),



      htmlDiv(className = "row", children = list(
          #htmlP("Date control slider"),
           #BOX5 DATE CONTROLLER
          htmlDiv(className="row",  style=list(backgroundColor="#d2d7df", padding_bottom ="30", padding_left="10",  border ='1px solid'), children=list(
              htmlP("Date control slider", style=list(padding_top="0")),
              
	      dccRangeSlider(
	        id = 'datarange',
	        marks = slidebar_marks,
	        min = 2000,
	        max = 2017,
	        step=1,
	        value = list(2000, 2017))
              ### DATE SLIDER COMPONENT GOES HERE


              ),
          htmlA("BC Ministry of Environment and Climate Change Strategy", href = "https://catalogue.data.gov.bc.ca/dataset/77eeadf4-0c19-48bf-a47a-fa9eef01f409", target = "_blank"),
          htmlP("Data is limited to the stations where measurements were taken and therefore does not account for the entirety of BC")
      ))
      )
  
    )
    
  ))

	# return(
	#   htmlDiv(
	#     list(
	#       # dccGraph(
	#       #     id = "chart-1",
	#       #     figure = ggplotly(linechart(pm_df, avg_df, init_locations = list("Vancouver")))
	#       # ),
	#       chart_1,
	#       chart_2,
	#       chart_3,
	#       chart_4,
	#     

	#     dccRangeSlider(
	#       id = 'datarange',
	#       marks = slidebar_marks,
	#       min = 2000,
	#       max = 2017,
	#       step=1,
	#       value = list(2000, 2017)),

	#     dccDropdown(
	#       # purrr:map can be used as a shortcut instead of writing the whole list
	#       # especially useful if you wanted to filter by country!
	#       id = 'dropdown1',
	#       options = map(
	# 	levels(pm_df$STATION_NAME), function(x){
	# 	list(label=x, value=x)
	#       }),
	#       value = 'Vancouver', #Selects all by default
	#       multi = FALSE
	#     ),

	#     dccDropdown(
	#       # purrr:map can be used as a shortcut instead of writing the whole list
	#       # especially useful if you wanted to filter by country!
	#       id = 'dropdown2',
	#       options = map(
	# 	levels(pm_df$STATION_NAME), function(x){
	# 	list(label=x, value=x)
	#       }),
	#       value = 'Vancouver', #Selects all by default
	#       multi = TRUE
	#     )

	#     ),


	#     className = "row"
	#   )
	# )
}

get_second_tab <- function(pm_df){
	list(

      dccDropdown(
	# purrr:map can be used as a shortcut instead of writing the whole list
	# especially useful if you wanted to filter by country!
	id = 'heatmap_pm',
        options=list(
          list("label" = "PM10", "value" = "PM10"),
          list("label" = "PM2.5", "value" = "PM25")
        ),
	value = 'PM10', #Selects all by default
	multi = FALSE
      ),
	dccGraph(
	  id = "chart-heatmap",
	  figure = ggplotly(heatmap(pm_df, include_years=TRUE))))
}
