# DSCI 532: Group 215 - ParticulatesMatter

Members: Tejas Phaterpekar, Karlos Muradyan, Jarome Leslie

Dataset: Time series of particulate matter concentrations across BC

## Important Links


## Description/Functionality

In our app, we plan to have four plots that give different insights into the air pollution situation in British Columbia. In particular, we are focusing on the top 10 BC cities, in terms of data availability. One time-series plot will track pollutant concentration over time, across multiple different locations. The second time-series plot will be similar to the first, except it will feature only one location (selected by the user) and will show the trend of both types of pollutants over time. In the two mentioned graphs, we will have a permanent line that represents average pollutant concentration for the whole of BC. This will help the user compare how a particular location is doing compared to the provincial average. In a different tab, we will also have a heatmap that highlights all locations in the study to allow the user to compare pollutant concentrations by intensity. The heatmap will be equipped with a tooltip that informs the user of exact pollutant values when they hove over different areas of the plot. Finally, we will have a histogram that will contain the distributions of pollutants for multiple locations. The interactivity of the four graphs will focus on giving the user flexibility in which locations and pollutant types they want to analyze. Changes in the plot, with respect to what data is being displayed, will depend on what filters the user selects from dropdown menus and checkbox features. Furthermore, a range slider is provided to give users global control over what time range is being observed across all four plots. Finally, the interactive controls have been color coded to connect the interactive components to their corresponding graph. 

### Design Sketch

Our plan for the R app will stay the same as what is shown below except we will have a new tab that will contain an enlarged heatmap, which will allow the user to better visualize subtle changes in the heatmap color gradient.

Screenshot of dashboard design sketch:


![img](img/revised_dashboard_design_sketch.png)

### Progress on Rplots

Below are screenshots of the applications plots, made by R functions. These plots will be implemented into our ```app.R```

![img](img/rplot-snapshot.png)

