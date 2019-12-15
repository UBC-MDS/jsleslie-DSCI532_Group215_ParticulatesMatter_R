library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(plotly)
source("https://raw.githubusercontent.com/UBC-MDS/DSCI532_Group215_ParticulatesMatter_R/master/src/utils.R")

#' Returns the content of the first tab based on the two dataframes provided
#'
#' Creates the content of the first tab by drawing interactive 4 plots arrangeed 2x2.
#' Creates ids for each of the titles and plots for callbacks
#'
#' @param pm_df Main Dataframe
#' @param avg_df Dataframe containing pollutant averages
#' 
#' @return dash htmlDiv with all content inside
#' @examples
#' get_dirst_tab(read_csv('main.csv'), read_csv('avg.csv'))
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
            style=list(backgroundColor ="#8BBEE8FF",paddingLeft="10px", paddingRight="10px", paddingTop="5px", paddingBottom="350px",border= '1px solid'), 
            children = list(
                      htmlP("Chart 1 & 2 controls:\n\n\n"),
					  htmlP("Pollutant:"),
                      dccRadioItems(
		       id = 'radio1',
                       options=list(
                       list("label" = "PM10", "value" = "PM10"),
                       list("label" = "PM2.5", "value" = "PM25")
                       ),
                       value = "PM10"
                       ),
       		    


                      htmlP("Location:"),

	              dccDropdown(
	                id = 'dropdown2',
	                options = map(
	          	levels(pm_df$STATION_NAME), function(x){
	          	list(label=x, value=x)
	                }),
	                value = 'Vancouver', #Selects all by default
	                multi = TRUE
	              )
                    ))      
        )
      ),
      ## CHART 1 
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 1: <Polutant> Concentration for given locations", 
	      id = 'chart-1-title',
              style=list(backgroundColor ="#8BBEE8FF", border='1px solid', textAlign='center', padding_left= "5")),
            chart_3))
        )
      ),

        ## CHART 2
        htmlDiv(className = "five columns", style=list(backgroundColor= "#ffffff", margin_left='10', margin_right= '10', padding= "0"), children =list(
            htmlDiv(className = "row", children=list(
              htmlH6("Chart 2: Distribution of <Pollutant> Concentrations for BC cities",
		id = 'chart-2-title',
                style=list(backgroundColor ="#8BBEE8FF", border='1px solid', textAlign='center', padding_left= "5")),
              chart_2))
          )
      ))
      ),

      htmlDiv(className="row", children = list(

        ## SIDE BAR - COLUMN 1
        htmlDiv(className = "two columns", children =list(
          
          ### BOX 2
          htmlDiv(className = "row", 
            style=list(backgroundColor ="#A8D5BAFF",paddingLeft="10px", paddingRight="10px", paddingTop="5px", paddingBottom="150px",border= '1px solid'), 
            children = list(
                      htmlP("Chart 3 controls:\n\n\n"),
                      htmlP("Location:"),

	              dccDropdown(
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
          style=list(backgroundColor ="#E3D1FB",paddingLeft="10px", paddingRight="10px", paddingTop="5px", paddingBottom="150px",border= '1px solid'), 
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
                  ))      
        )
      ),
        ## CHART 3 
      htmlDiv(className = "five columns", children =list(
        htmlDiv(className = "row", children=list(
          htmlH6("Chart 3: Pollutant Concentration in <Location>",
	    id = 'chart-3-title',
            style=list(backgroundColor ="#A8D5BAFF", border='1px solid', textAlign='center', padding_left= "5")),
          chart_1))
      )
    ),

      ## CHART 4
      htmlDiv(className = "five columns", children =list(
          htmlDiv(className = "row", children=list(
            htmlH6("Chart 4: <Pollutant> Concentration Heatmap",
	      id = 'chart-4-title',
              style=list(backgroundColor ="#E3D1FB", border='1px solid', textAlign='center', padding_left= "5")),
            chart_4))
        )
    ))
    ),



      htmlDiv(className = "row", style=list(backgroundColor="#d2d7df", paddingTop ="5px", paddingBottom ="30px", paddingLeft="20px", paddingRight="30px",  border ='1px solid'), children = list(
          #htmlP("Date control slider"),
           #BOX5 DATE CONTROLLER
          htmlDiv(className="row",  children=list(
              htmlP("Date control slider"),
              
	      dccRangeSlider(
	        id = 'datarange',
	        marks = slidebar_marks,
	        min = 2000,
	        max = 2017,
	        step=1,
	        value = list(2000, 2017))


              ),
          htmlA("BC Ministry of Environment and Climate Change Strategy", href = "https://catalogue.data.gov.bc.ca/dataset/77eeadf4-0c19-48bf-a47a-fa9eef01f409", target = "_blank"),
          htmlP("Data is limited to the stations where measurements were taken and therefore does not account for the entirety of BC")
      ))
      )
  
    )
    
  ))
}

#' Returns the content of the second tab based on the main dataframe provided
#'
#' Creates the content of the second tab by drawing a big heatmap with x-axis labels
#' Adds id for the plot to be used in the callback
#'
#' @param pm_df Main Dataframe
#' 
#' @return list containing dropdown and the plot
#' @examples
#' get_dirst_tab(read_csv('main.csv'), read_csv('avg.csv'))
get_second_tab <- function(pm_df){
	list(

      dccDropdown(
	id = 'heatmap_pm',
        options=list(
          list("label" = "PM10", "value" = "PM10"),
          list("label" = "PM2.5", "value" = "PM25")
        ),
	value = 'PM10',
	multi = FALSE
      ),
	dccGraph(
	  id = "chart-heatmap",
	  figure = ggplotly(heatmap(pm_df, include_years=TRUE))))
}
