shinyServer(
  

function(input,output,session) {

  #Create 'observor' object that changes dropdown menu of "Start Period" / "End Period" based on user's choice of Annual vs. Monthly vs. Weekly
  observe({
  if(input$annual_monthly_weekly == 1)
    period_dropdown_menu = unique(US_land_rig_counts_by_year$Year)
  else if (input$annual_monthly_weekly == 2)
    period_dropdown_menu = unique(US_land_rig_counts_by_month$Month_Year)
  else
    period_dropdown_menu = unique(US_land_rig_counts_by_week$Year_Week) 
  
  updateSelectInput(session,"start_period",choices = period_dropdown_menu, selected=period_dropdown_menu[1])
  updateSelectInput(session,"end_period",choices = period_dropdown_menu, selected=period_dropdown_menu[-1])

  })

  US_land_rig_counts_filtered <- reactive({
    US_land_rig_counts %>% {
      if (input$oil_or_gas == 1)
        filter(., DrillFor %in% c("Gas","Oil","Miscellaneous"))
      else if (input$oil_or_gas == 2)
        filter(., DrillFor == "Oil")
      else
        filter(., DrillFor == "Gas")}
    
  })
  
      
#Create dataframe, filter for oil and/or gas input from user, group by year AND basin and use the spread function to create new columns for each basin
  
  output$rigPlot = renderGvis({
    
    #Create reactive function that filters for oil rigs only, gas rigs only, or both - based on user input
    
    
    
    
    
    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston'))) 
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
      Other_Avg = round(Other / weeks_during_year, digits =0),
      Permian_Avg = round(Permian / weeks_during_year, digits =0),
      Utica_Avg = round(Utica / weeks_during_year, digits =0),
      Williston_Avg = round(Williston / weeks_during_year, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston'))) 
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
      Other_Avg = round(Other / weeks_during_month, digits =0),
      Permian_Avg = round(Permian / weeks_during_month, digits =0),
      Utica_Avg = round(Utica / weeks_during_month, digits =0),
      Williston_Avg = round(Williston / weeks_during_month, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston'))) 
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
      Other_Avg = round(Other / weeks_during_week, digits =0),
      Permian_Avg = round(Permian / weeks_during_week, digits =0),
      Utica_Avg = round(Utica / weeks_during_week, digits =0),
      Williston_Avg = round(Williston / weeks_during_week, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )  
    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))
      
    })
    
    
    
    
#Column chart    
    gvisColumnChart(
      xvar = if(input$annual_monthly_weekly == 1) "Year" else if (input$annual_monthly_weekly == 2) "Month_Year" else "Year_Week",
      yvar = if(input$allbasins_or_selectbasins==1) "Sum_all_basins_Avg" else c(input$basin_group),
      data = US_land_rig_counts_by_period(),
      options = list(
        isStacked=TRUE,
        # hAxes = paste0("[{viewWindowMode:'explicit',
        #   viewWindow:{min:",input$start_period,", max:",input$end_period,"}}]"),
        vAxes = "[{viewWindowMode:'explicit',
          viewWindow:{min:0, max:2000}}]",
        width = "1000",
        height = "600",
        title = paste('US land rig counts from',input$start_period,'to',input$end_period)
      )  
      
    )
  })
 
  output$oilpricePlot = renderGvis({
    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))    
    })
        
    gvisLineChart(
      xvar = if(input$annual_monthly_weekly == 1) "Year" else if (input$annual_monthly_weekly == 2) "Month_Year" else "Year_Week",
      yvar = "Avg_WTI_oil_price",
      data = US_land_rig_counts_by_period(),
      options = list(
        width = "1000",
        height = "600",
        title = paste('WTI oil price from',input$start_period,'to',input$end_period)
      )  
      
    )
    
  })
  
  output$gaspricePlot = renderGvis({
    
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))    
    })
    
    gvisLineChart(
      xvar = if(input$annual_monthly_weekly == 1) "Year" else if (input$annual_monthly_weekly == 2) "Month_Year" else "Year_Week",
      yvar = "Avg_gas_price",
      data = US_land_rig_counts_by_period(),
      options = list(
        width = "1000",
        height = "600",
        title = paste('Henry Hub gas price from',input$start_period,'to',input$end_period)
      )  
      
    )
    
  })
  
  ##### Tables and Charts for 2nd Tab #####
  
  
  output$rigPlotTable = DT::renderDataTable({
    
    ### THIS IS A COPY/PASTE OF output$rigPlot ABOVE ###


    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
      Other_Avg = round(Other / weeks_during_year, digits =0),
      Permian_Avg = round(Permian / weeks_during_year, digits =0),
      Utica_Avg = round(Utica / weeks_during_year, digits =0),
      Williston_Avg = round(Williston / weeks_during_year, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )

    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
      Other_Avg = round(Other / weeks_during_month, digits =0),
      Permian_Avg = round(Permian / weeks_during_month, digits =0),
      Utica_Avg = round(Utica / weeks_during_month, digits =0),
      Williston_Avg = round(Williston / weeks_during_month, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )

    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
      Other_Avg = round(Other / weeks_during_week, digits =0),
      Permian_Avg = round(Permian / weeks_during_week, digits =0),
      Utica_Avg = round(Utica / weeks_during_week, digits =0),
      Williston_Avg = round(Williston / weeks_during_week, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )


    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))    
    })

    ##Create subset dataframe with just 'start period' and 'end period' columns
    if (input$annual_monthly_weekly == 1)
      x = US_land_rig_counts_by_period() %>% filter(., Year == input$start_period | Year == input$end_period)
    else if (input$annual_monthly_weekly == 2)
      x = US_land_rig_counts_by_period() %>% filter(., Month_Year == input$start_period | Month_Year == input$end_period)
    else
      x = US_land_rig_counts_by_period() %>% filter(., Year_Week == input$start_period | Year_Week == input$end_period)

    y = as_tibble(t(x), rownames = "row_names")
    names(y) <- y %>% slice(1) %>% unlist()
    y <- y %>% slice(-1)
    y = as.data.frame(y)
    colnames(y)[1] = "Basin"
    y[,2] = as.numeric(as.character(y[,2]))
    y[,3] = as.numeric(as.character(y[,3]))
    y = y %>% mutate(., pct_change = (y[,3] / y[,2])-1)
    y = y[18:nrow(y),]
    
    
    ##data table
    datatable(y, rownames=FALSE, options = list(pageLength = 100)) %>% 
      formatStyle("pct_change", background="skyblue", fontWeight="bold") %>% 
      formatStyle("Basin", target = 'row', backgroundColor = styleEqual(c("Avg_WTI_oil_price","Avg_gas_price","Sum_all_basins_Avg"),c("#FFC700","#FFC700","#FF870099"))) %>% 
      formatPercentage("pct_change",0)
  })

  output$rigChangeChart = renderGvis({
    

    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_year, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_year, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_year, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_year, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
                                                                         Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
                                                                         Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
                                                                         Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
                                                                         Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
                                                                         Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
                                                                         Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
                                                                         Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
                                                                         Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
                                                                         Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
                                                                         Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
                                                                         Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
                                                                         Other_Avg = round(Other / weeks_during_month, digits =0),
                                                                         Permian_Avg = round(Permian / weeks_during_month, digits =0),
                                                                         Utica_Avg = round(Utica / weeks_during_month, digits =0),
                                                                         Williston_Avg = round(Williston / weeks_during_month, digits =0),
                                                                         Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_week, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_week, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_week, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_week, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )
    

    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))    
    })
    
    ##Create subset dataframe with just 'start period' and 'end period' columns
    if (input$annual_monthly_weekly == 1)
      x = US_land_rig_counts_by_period() %>% filter(., Year == input$start_period | Year == input$end_period)
    else if (input$annual_monthly_weekly == 2)
      x = US_land_rig_counts_by_period() %>% filter(., Month_Year == input$start_period | Month_Year == input$end_period)
    else
      x = US_land_rig_counts_by_period() %>% filter(., Year_Week == input$start_period | Year_Week == input$end_period)
    
    y = as_tibble(t(x), rownames = "row_names")
    names(y) <- y %>% slice(1) %>% unlist()
    y <- y %>% slice(-1)
    y = as.data.frame(y)
    colnames(y)[1] = "Basin"
    y[,2] = as.numeric(as.character(y[,2]))
    y[,3] = as.numeric(as.character(y[,3]))
    y = y %>% mutate(., pct_change = (y[,3] / y[,2])-1)
    y = y[18:nrow(y),]
    
    y = y[y$Basin!="Sum_all_basins_Avg",]
    
    gvisColumnChart(
      data = y 
      ,xvar = "Basin"
      ,yvar = c(input$start_period,input$end_period)
      ,options = list(
        width = "1000",
        height = "600",
        title = paste('US land rig counts from',input$start_period,'to',input$end_period)
      )
    )
    }) 

  output$pctChangeChart = renderGvis({
    

    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_year, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_year, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_year, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_year, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
                                                                         Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
                                                                         Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
                                                                         Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
                                                                         Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
                                                                         Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
                                                                         Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
                                                                         Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
                                                                         Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
                                                                         Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
                                                                         Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
                                                                         Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
                                                                         Other_Avg = round(Other / weeks_during_month, digits =0),
                                                                         Permian_Avg = round(Permian / weeks_during_month, digits =0),
                                                                         Utica_Avg = round(Utica / weeks_during_month, digits =0),
                                                                         Williston_Avg = round(Williston / weeks_during_month, digits =0),
                                                                         Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_week, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_week, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_week, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_week, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )
    

    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))    
    })
    
    ##Create subset dataframe with just 'start period' and 'end period' columns
    if (input$annual_monthly_weekly == 1)
      x = US_land_rig_counts_by_period() %>% filter(., Year == input$start_period | Year == input$end_period)
    else if (input$annual_monthly_weekly == 2)
      x = US_land_rig_counts_by_period() %>% filter(., Month_Year == input$start_period | Month_Year == input$end_period)
    else
      x = US_land_rig_counts_by_period() %>% filter(., Year_Week == input$start_period | Year_Week == input$end_period)
    
    y = as_tibble(t(x), rownames = "row_names")
    names(y) <- y %>% slice(1) %>% unlist()
    y <- y %>% slice(-1)
    y = as.data.frame(y)
    colnames(y)[1] = "Basin"
    y[,2] = as.numeric(as.character(y[,2]))
    y[,3] = as.numeric(as.character(y[,3]))
    y = y %>% mutate(., pct_change = (y[,3] / y[,2])-1)
    y = y[18:nrow(y),]    
    
    gvisColumnChart(
      data = y 
      ,xvar = "Basin"
      ,yvar = "pct_change"
      ,options = list(
        width = "1000",
        height = "600",
        title = paste('US land rig counts percentage change from',input$start_period,'to',input$end_period)
      )
    )
  })  
  
  
  output$correlationTable = DT::renderDataTable({

    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
      Other_Avg = round(Other / weeks_during_year, digits =0),
      Permian_Avg = round(Permian / weeks_during_year, digits =0),
      Utica_Avg = round(Utica / weeks_during_year, digits =0),
      Williston_Avg = round(Williston / weeks_during_year, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )

    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
      Other_Avg = round(Other / weeks_during_month, digits =0),
      Permian_Avg = round(Permian / weeks_during_month, digits =0),
      Utica_Avg = round(Utica / weeks_during_month, digits =0),
      Williston_Avg = round(Williston / weeks_during_month, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )

    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
      Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
      Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
      Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
      Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
      Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
      Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
      Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
      Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
      Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
      Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
      Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
      Other_Avg = round(Other / weeks_during_week, digits =0),
      Permian_Avg = round(Permian / weeks_during_week, digits =0),
      Utica_Avg = round(Utica / weeks_during_week, digits =0),
      Williston_Avg = round(Williston / weeks_during_week, digits =0),
      Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )

    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period))
    })

    ##Create dataframe with three columns... 1) Basin, 2) Correlation with WTI oil prices, 3) Correlation with gas prices
    # if (input$oil_or_gas == 1)
      g = data.frame(matrix(ncol=3,nrow=16))
      x = c("Basin","Correlation_to_WTI_oil_price","Correlation_to_gas_price")
      colnames(g) = x
      g$Basin = c(colnames(US_land_rig_counts_by_year)[2:17])
      g$Correlation_to_WTI_oil_price = c(
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Ardmore_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Arkoma_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Barnett_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Cana_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Dj_Niobrara_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Eagle_Ford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Fayetteville_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Granite_Wash_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Haynesville_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Marcellus_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Mississippian_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Other_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Permian_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Utica_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Williston_Avg),
        cor(US_land_rig_counts_by_period()$Avg_WTI_oil_price, US_land_rig_counts_by_period()$Sum_all_basins_Avg)
      )
      g$Correlation_to_gas_price = c(
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Ardmore_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Arkoma_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Barnett_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Cana_Woodford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Dj_Niobrara_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Eagle_Ford_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Fayetteville_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Granite_Wash_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Haynesville_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Marcellus_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Mississippian_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Other_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Permian_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Utica_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Williston_Avg),
        cor(US_land_rig_counts_by_period()$Avg_gas_price, US_land_rig_counts_by_period()$Sum_all_basins_Avg)
      )
      
      datatable(g) %>% formatRound("Correlation_to_WTI_oil_price", digits = 3)
      

    ##data table
    datatable(g, rownames=FALSE, options = list(pageLength = 100))
  })

  
  output$proportionalChart = renderPlot({
    
    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_year, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_year, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_year, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_year, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
                                                                         Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
                                                                         Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
                                                                         Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
                                                                         Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
                                                                         Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
                                                                         Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
                                                                         Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
                                                                         Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
                                                                         Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
                                                                         Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
                                                                         Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
                                                                         Other_Avg = round(Other / weeks_during_month, digits =0),
                                                                         Permian_Avg = round(Permian / weeks_during_month, digits =0),
                                                                         Utica_Avg = round(Utica / weeks_during_month, digits =0),
                                                                         Williston_Avg = round(Williston / weeks_during_month, digits =0),
                                                                         Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_week, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_week, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_week, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_week, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )
    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period)
               %>% select(., -(2:20)) %>% select(., -last_col()))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period)
               %>% select(., -(2:20)) %>% select(., -last_col()))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period)
               %>% select(., -(2:20)) %>% select(., -last_col()))
    })
    
    data.melt = melt(US_land_rig_counts_by_period(),id=colnames(US_land_rig_counts_by_period())[1])
    data.melt %>% 
      ggplot(aes(x=if(input$annual_monthly_weekly == 1) Year else if (input$annual_monthly_weekly == 2) Month_Year else Year_Week,y=value,group=variable,fill=variable)) +
      geom_area(color='black', size=0.3,position=position_fill() ) +
      scale_fill_discrete() +
      ggtitle(paste('US land rig counts (by basin) from',input$start_period,'to',input$end_period))
    
  })
  
### proportion chart for oil vs. gas rigs (no basins)

  output$proportionalChartOilVsGas = renderPlot({

    #Create rig counts by YEAR with Oil and Gas split
    US_land_rig_counts_by_year_filtered = US_land_rig_counts %>% filter(., DrillFor %in% c("Gas","Oil")) %>% group_by(., Year, DrillFor)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., DrillFor, sum_rigs_every_wk_total, fill=0)
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
      Gas_Avg = round(Gas / weeks_during_year, digits=0),
      Oil_Avg = round(Oil / weeks_during_year, digits =0)
    )

    #Create rig counts by MONTH with Oil and Gas split
    US_land_rig_counts_by_month_filtered = US_land_rig_counts %>% filter(., DrillFor %in% c("Gas","Oil")) %>% group_by(., Month_Year, DrillFor)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., DrillFor, sum_rigs_every_month_total, fill=0)
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
      Gas_Avg = round(Gas / weeks_during_month, digits=0),
      Oil_Avg = round(Oil / weeks_during_month, digits =0),
    )

    #Create rig counts by WEEK with Oil and Gas split
    US_land_rig_counts_by_week_filtered = US_land_rig_counts %>% filter(., DrillFor %in% c("Gas","Oil")) %>% group_by(., Year_Week, DrillFor)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., DrillFor, sum_rigs_every_week_total, fill=0)
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))

    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
      Gas_Avg = round(Gas / weeks_during_week, digits=0),
      Oil_Avg = round(Oil / weeks_during_week, digits =0),
    )

    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period)
               %>% select(., -(2:6)) )
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period)
               %>% select(., -(2:6)) )
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period)
               %>% select(., -(2:6)) )
    })

    data.melt = melt(US_land_rig_counts_by_period(),id=colnames(US_land_rig_counts_by_period())[1])
    data.melt %>%
      ggplot(aes(x=if(input$annual_monthly_weekly == 1) Year else if (input$annual_monthly_weekly == 2) Month_Year else Year_Week,y=value,group=variable,fill=variable)) +
      geom_area(color='black', size=0.3,position=position_fill() ) +
      scale_fill_discrete() +
      ggtitle(paste('US land rig counts (oil vs. gas) from',input$start_period,'to',input$end_period))

  })

  
  
  
### plot for scatterplot: OIL
  
  output$scatterplotOil = renderPlot({
    
    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_year, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_year, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_year, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_year, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
                                                                         Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
                                                                         Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
                                                                         Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
                                                                         Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
                                                                         Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
                                                                         Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
                                                                         Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
                                                                         Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
                                                                         Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
                                                                         Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
                                                                         Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
                                                                         Other_Avg = round(Other / weeks_during_month, digits =0),
                                                                         Permian_Avg = round(Permian / weeks_during_month, digits =0),
                                                                         Utica_Avg = round(Utica / weeks_during_month, digits =0),
                                                                         Williston_Avg = round(Williston / weeks_during_month, digits =0),
                                                                         Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_week, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_week, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_week, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_week, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )
    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period)
               %>% ungroup() %>% select(., -c(1:18,20,last_col())))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period)
               %>% ungroup() %>% select(., -c(1:18,20,last_col())))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period)
               %>% ungroup() %>% select(., -c(1:18,20,last_col())))
    })
    
    data.melt = melt(US_land_rig_counts_by_period(),id=colnames(US_land_rig_counts_by_period())[1])
    data.melt %>% 
      ggplot(aes(x = Avg_WTI_oil_price, y = value)) +
      geom_point() + geom_smooth(method = "lm") +
      facet_wrap( ~ variable) + 
      ggtitle(paste('US land rig counts from',input$start_period,'to',input$end_period,'vs. WTI oil price')) +
      stat_cor(label.x = 0, label.y = 700) +
      stat_regline_equation(label.x = 0, label.y = 550)
      
  })
  
  
  ### plot for scatterplot: GAS
  
  output$scatterplotGas = renderPlot({
    
    #Use reactive function to create rig counts by YEAR, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_year_filtered = US_land_rig_counts_filtered() %>% group_by(., Year, Basin)
    US_land_rig_counts_by_year_filtered_summarised = US_land_rig_counts_by_year_filtered %>% summarise(., sum_rigs_every_wk_total = n())
    US_land_rig_counts_by_year = US_land_rig_counts_by_year_filtered_summarised %>% spread(., Basin, sum_rigs_every_wk_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% inner_join(., US_land_rig_counts_by_year_filtered_groupby_year_only, by="Year")
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_year = US_land_rig_counts_by_year %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_year, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_year, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_year, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_year, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_year, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_year, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_year, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_year, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_year, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_year, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_year, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_year, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_year, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_year, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_year, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_year, digits =0)
    )
    
    #Use reactive function to create rig counts by MONTH, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_month_filtered = US_land_rig_counts_filtered() %>% group_by(., Month_Year, Basin)
    US_land_rig_counts_by_month_filtered_summarised = US_land_rig_counts_by_month_filtered %>% summarise(., sum_rigs_every_month_total = n())
    US_land_rig_counts_by_month = US_land_rig_counts_by_month_filtered_summarised %>% spread(., Basin, sum_rigs_every_month_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% inner_join(., US_land_rig_counts_by_month_filtered_groupby_month_only, by="Month_Year")
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_month = US_land_rig_counts_by_month %>% mutate(.,
                                                                         Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_month, digits=0),
                                                                         Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_month, digits =0),
                                                                         Barnett_Avg = round(Barnett / weeks_during_month, digits =0),
                                                                         Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_month, digits =0),
                                                                         Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_month, digits =0),
                                                                         Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_month, digits =0),
                                                                         Fayetteville_Avg = round(Fayetteville / weeks_during_month, digits =0),
                                                                         Granite_Wash_Avg = round(Granite_Wash / weeks_during_month, digits =0),
                                                                         Haynesville_Avg = round(Haynesville / weeks_during_month, digits =0),
                                                                         Marcellus_Avg = round(Marcellus / weeks_during_month, digits =0),
                                                                         Mississippian_Avg = round(Mississippian / weeks_during_month, digits =0),
                                                                         Other_Avg = round(Other / weeks_during_month, digits =0),
                                                                         Permian_Avg = round(Permian / weeks_during_month, digits =0),
                                                                         Utica_Avg = round(Utica / weeks_during_month, digits =0),
                                                                         Williston_Avg = round(Williston / weeks_during_month, digits =0),
                                                                         Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_month, digits =0)
    )
    
    #Use reactive function to create rig counts by WEEK, join with 'weeks per period' and oil/gas price info (from global sheet) and add columns for each basin
    US_land_rig_counts_by_week_filtered = US_land_rig_counts_filtered() %>% group_by(., Year_Week, Basin)
    US_land_rig_counts_by_week_filtered_summarised = US_land_rig_counts_by_week_filtered %>% summarise(., sum_rigs_every_week_total = n())
    US_land_rig_counts_by_week = US_land_rig_counts_by_week_filtered_summarised %>% spread(., Basin, sum_rigs_every_week_total, fill=0) %>% mutate(., Sum_all_basins=sum(c_across('Ardmore Woodford':'Williston')))
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% inner_join(., US_land_rig_counts_by_week_filtered_groupby_week_only, by="Year_Week")
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% rename_all(~str_replace_all(., "\\s+", "_")) %>% rename_all(~str_replace_all(., "\\-", "_"))
    
    US_land_rig_counts_by_week = US_land_rig_counts_by_week %>% mutate(.,
                                                                       Ardmore_Woodford_Avg = round(Ardmore_Woodford / weeks_during_week, digits=0),
                                                                       Arkoma_Woodford_Avg = round(Arkoma_Woodford / weeks_during_week, digits =0),
                                                                       Barnett_Avg = round(Barnett / weeks_during_week, digits =0),
                                                                       Cana_Woodford_Avg = round(Cana_Woodford / weeks_during_week, digits =0),
                                                                       Dj_Niobrara_Avg = round(Dj_Niobrara / weeks_during_week, digits =0),
                                                                       Eagle_Ford_Avg = round(Eagle_Ford / weeks_during_week, digits =0),
                                                                       Fayetteville_Avg = round(Fayetteville / weeks_during_week, digits =0),
                                                                       Granite_Wash_Avg = round(Granite_Wash / weeks_during_week, digits =0),
                                                                       Haynesville_Avg = round(Haynesville / weeks_during_week, digits =0),
                                                                       Marcellus_Avg = round(Marcellus / weeks_during_week, digits =0),
                                                                       Mississippian_Avg = round(Mississippian / weeks_during_week, digits =0),
                                                                       Other_Avg = round(Other / weeks_during_week, digits =0),
                                                                       Permian_Avg = round(Permian / weeks_during_week, digits =0),
                                                                       Utica_Avg = round(Utica / weeks_during_week, digits =0),
                                                                       Williston_Avg = round(Williston / weeks_during_week, digits =0),
                                                                       Sum_all_basins_Avg = round(Sum_all_basins / weeks_during_week, digits =0)
    )
    
    #Create reactive function that stores which dataframe to use based on user's choice of Annual vs. Monthly vs. Weekly
    US_land_rig_counts_by_period <- reactive({
      if (input$annual_monthly_weekly == 1)
        return(US_land_rig_counts_by_year %>% filter(., Year>=input$start_period & Year<=input$end_period)
               %>% ungroup() %>% select(., -c(1:19,last_col())))
      else if (input$annual_monthly_weekly == 2)
        return(US_land_rig_counts_by_month %>% filter(., Month_Year>=input$start_period & Month_Year<=input$end_period)
               %>% ungroup() %>% select(., -c(1:19,last_col())))
      else
        return(US_land_rig_counts_by_week %>% filter(., Year_Week>=input$start_period & Year_Week<=input$end_period)
               %>% ungroup() %>% select(., -c(1:19,last_col())))
    })
    
    data.melt = melt(US_land_rig_counts_by_period(),id=colnames(US_land_rig_counts_by_period())[1])
    data.melt %>% 
      ggplot(aes(x = Avg_gas_price, y = value)) +
      geom_point() + geom_smooth(method = "lm") +
      facet_wrap( ~ variable) + 
      ggtitle(paste('US land rig counts from',input$start_period,'to',input$end_period,'vs. gas price')) +
      stat_cor(label.x = 0, label.y = 350) +
      stat_regline_equation(label.x = 0, label.y = 250)
    
  })
  
}
)  