## App Reflection

**Note: Reflections from previous weeks have been added for context. For a reflection on this week, please see the bottom of the document under the following section, *"Milestone 4 Reflection"*. This section has been prepared under the 500 word limit specified in Milestone 4.**

### Areas of Strength
- The app gives users different perspectives for which they can analyze the data, through a variety of plots. Clients can use the heatmap to discover locations of interest and then investigate these locations further by looking at distributions and time-series plots.
- Using a color code, it is intuitive for the user to distinguish the global controls (affect every plot) from the local controls (affect a single plot).
- The controls give the users flexibility in how they want to observe the data, with regards to time, location, and pollutant type. This allows users optimize the plots to better approach their research questions.

### Limitations
- There is a large proportion of missing data which limits what conclusions can be made using the app.
- We have data from 55 unique locations in BC, which doesn't work optimally with the multi-option dropdown dash component. When multiple locations are selected the app's layout becomes distorted.
- Currently, we only use monthly pollutant averages in all our plots. As a result, the user cannot assess individual data points. We made this decision to reduce the size of the data and make the plots easier to grasp.

### Future Improvements
- Adding a map of BC would be beneficial because it would geographically show pollutant hotspots. This can help users who aren't familiar with BC.
- Fix the multi-option dropdown to eliminate the observed distortions. For example, instead of having a drop-down menu with all the locations, we could have a dropdown menu with different regions in BC (West Coast, Northern BC, etc.). Below the dropdown menu, there could be checkboxes with all the locations contained within a selected region.
- It would be worth exploring alternative statistics that could be added to application, such as quartile ranges, correlational analysis, and variance.

### Addressing TA Feedback on milestone1 app sketch

1. You could add a couple of sentences with information about your dashboard in the menu panel, including your data source

    Action Taken: In the menu panel, we added source information and clearly stated that we are using weighted monthly averages.

2. Make sure it is clear to the user which controls affect which plots. If possible make this distinction even clearer than what your sketch is showing

    Action Taken: In addition to color coding the charts and control panels, we also gave explicit labels like "Chart 1", Chart 2", etc.

3. State this data is not for the entire province

    Action Taken: Added a footnote to clarify that the data is not for the entire province.

4. I am not sure right now what your y-axis represents in the heat map

    Action Taken: We ended up having to remove x-axis and y-axis ticks because of spacing issues. Instead we point the user to using the tooltip for information on time, location, and pollutant concentration. We acknowledge that this is not optimal and we will look to find an alternative in the next two weeks of the course.
 

    
## Summary of changes made following peer and TA dashboard feedback

Our first priority item from issue #51 was to fix the bug in the date slider which didn't allow the full time series to be selected. Next, we simplified the controls menu since the Chart 1 time series and the Chart 3 distribution histograms can be made to present the same locations. With this change we also moved the histogram to be next to the time series in Chart 1. To assist with interpretting the time series charts, we added a description informing users that the grey lines represent provincial averages. With regards to the heatmap, we decided to filter the locations down to the top 10 most populous regions, add a description noting that the redlines mark the selected daterange and add a second tab which allows the users to see an enlarged version.

On the organization and readability front, we've refactored the code to separate out the app layouts into a new `tabs.py`, much like the `utils.py` which stores all our plot functions. This change leads to tidier `app.py` file. 


## Wishlist features/bugfixes

1. The typo in Chart 2 of 'PM25' instead of 'PM2.5' requires an update to the wrangling as well as the function calls and callbacks. Ultimately we decided to log this as fix going forward into milestone4. 

2. Updating the plot functions to maintain consistent x-axis when changing the time range


## Other feedback

While all of the above changes and wishlist features were raised in the feedback from our peers and the TA, we also received feedback on items we decided not to implement.

1. Combine the two time series charts into one.
    Counterpoint: We saw there being merit in having separate a multilocation chart with a single pollutant and a multi-pollution chart for a single location. This prevents users from adding too many comparisons on one chart. e.g. two different pollutants for two different locations. 
    
2. Add a tab for FAQs
    Counterpoint: In this case we think fewer tabs are better as we saw the inclusion of the definitions of PM2.5 and PM10 and explanations for provincial averages and the red line date markers as sufficient. 


# Milestone 4 Reflection

Our mission for Milestone 4 was to replicate our [python app](https://pollutantsmatterbc.herokuapp.com) using R, while streamlining our interface with what we learned from feedback on the previous app. Many of the areas of strength/limitations have not changed from our python app reflection. In this reflection, we focus on some of the new additions that have not been talked about.

### Areas of Strength

- In the first week of our group project, we set off on an ambitious journey to include all available locations in BC within our app. However, we began to realize this caused overplotting issues for us, especially with regards to our heatmap. Our decision to narrow our focus on the top 10 BC cities, in terms of data availability, helps the user focus on a smaller subgroup of the data without getting overwhelmed.
- Instead of using a dropdown menu for the pollutant options (PM2.5 and PM10), we proceeded to use radio buttons instead. This is effective because the user can see the two different pollutant options at all times and reduces the amount of clicking required to get the desired change in the plots.
- One major difference from our R app to our python app is that there is useful zoom interactivity. This especially helpful for our heatmap when users only care about a specific time range. 

### Limitations

- After testing how our app worked on Heroku, we observed that our R app is noticeably slower compared to our python app. This may have something to do with the interactivity components
- Our plan was to remove some of the icons to limit what the user could do with our graphs. At the current moment, we are unable to do this, due to a bug with the most recent version of plotly. The excess of modebar options is not ideal for a user who may get overwhelmed with these unnecessary icons.
- Our dataset only contains info for a subset of cities in BC, which means the data shown is not necessarily representative of BC as a whole. We explicitly mention this limitation in our app so that the user is aware. 

### Future Improvements/Wishlist

- In a previous reflection, we suggested that adding a map plot would be extremely helpful to at geographical context to our plot. We want to re-emphasize that this addition would take our app to the next level.
- Once the plotly bug is fixed, it would be helpful to reduce the amount of interactive options the users have with our plots.
- Although not explored this week, some type of animation could be helpful. For example, it would be interesting to animate our plots to show how the pollutant concentrations have changed over time.


