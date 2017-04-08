# Define server logic required to draw a histogram
shinyServer(function(input, output){
  map_layers_event <- eventReactive(input$map_test, {
    if(input$map_test == "math"){
      map_aux <- leaflet(data = joined_basic) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(fillColor = ~math_pal(M),
                    smoothFactor = 0.2,
                    fillOpacity = 1, 
                    weight = 1.2,
                    color = "grey60",
                    popup = math_popup,
                    layerId = joined_basic$wb_a3) %>%
        addLegend("bottomleft", pal = math_pal, values = ~M,
                  title = "math score",
                  opacity = 1)
    }
    if(input$map_test == "science") {
      map_aux <- leaflet(data = joined_basic) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(fillColor = ~sci_pal(S),
                    smoothFactor = 0.2,
                    fillOpacity = 1, 
                    weight = 1.2,
                    color = "grey60",
                    popup = sci_popup,
                    layerId = joined_basic$wb_a3) %>%
        addLegend("bottomleft", pal = sci_pal, values = ~S,
                  title = "science score",
                  opacity = 1)
    }
    if(input$map_test == "reading") {
      map_aux <- leaflet(data = joined_basic) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(fillColor = ~read_pal(R),
                    smoothFactor = 0.2,
                    fillOpacity = 1, 
                    weight = 1.2,
                    color = "grey60",
                    popup = read_popup,
                    layerId = joined_basic$wb_a3) %>%
        addLegend("bottomleft", pal = read_pal, values = ~R,
                  title = "reading score",
                  opacity = 1)
    }
    if(input$map_test == "clustering") {
      map_aux <- leaflet(data = joined_basic) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(fillColor = ~clustering_pal(clus),
                    smoothFactor = 0.2,
                    fillOpacity = 1, 
                    weight = 1.2,
                    color = "grey60",
                    popup = clustering_popup,
                    layerId = joined_basic$wb_a3)
    }
    map_aux
  })

  output$map <- renderLeaflet({
    map_layers_event()
  })
  
  country_click_event <- reactive({
    d <- input$map_shape_click
    if (is.null(d)) "-" else d$id
  })
  
  output$vbox_gdp_pc <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("gdp_pc")), 2)
    }
    valueBox(aux,
             "GDP per capita",
             icon = icon("dollar"),
             color = "purple"
    )
  })
  
  output$vbox_life_exp <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("life_exp")), 2)
    }
    valueBox(aux,
             "life expectancy",
             icon = icon("hand-peace-o"),
             color = "orange"
    )
  })
  
  output$vbox_youth_unemp <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("youth_unemp")), 2)
    }
    valueBox(aux,
             "youth unemployment",
             icon = icon("thumbs-o-down"),
             color = "green"
    )
  })
  
  output$vbox_p_urb <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("p_urb")), 2)
    }
    valueBox(aux,
             "urban population",
             icon = icon("building-o"),
             color = "blue"
    )
  })
  
  output$vbox_p_rur <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("p_rur")), 2)
    }
    valueBox(aux,
             "rural population",
             icon = icon("leaf"),
             color = "red"
    )
  })
  
  output$vbox_gini <- renderValueBox({
    if(country_click_event() == "-"){
      aux <- country_click_event()
    } else{
      aux <- round(df_basic %>% filter(IDcountry == country_click_event()) %>% 
                     select(one_of("gini")), 2)
    }
    valueBox(aux,
             "gini",
             icon = icon("balance-scale"),
             color = "yellow"
    )
  })
  
  output$Plot_sentiment <- renderPlot({
    if(country_click_event() == "-"){
      NULL
    } else{
      plots_sentiment[[country_click_event()]]
    }  
  })
  
  output$Plot_wc <- renderPlot({
    if(country_click_event() == "-"){
      NULL
    } else{
      wordcloud(data_news[[country_click_event()]]$freq.df$translation,
                data_news[[country_click_event()]]$freq.df$freq,
                scale=c(5,0.1), random.order=FALSE, 
                use.r.layout=FALSE, colors=pal_wc)
    }
  })
  
  output$Plot_var <- renderPlotly({
    plot_coef(parameters_cnt, parameters_cnt_names, country_click_event())
  })
})
