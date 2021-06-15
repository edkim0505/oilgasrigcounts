library(shinydashboard)

shinyUI(
  dashboardPage(
  dashboardHeader(title = "US onshore rig counts since 2011"),
  
  dashboardSidebar(
    sidebarUserPanel("Eddie", image = "data:image/jpeg;base64,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"),
    sidebarMenu(
        menuItem("Oil and gas basins", tabName = "basins", icon = icon("image")),
        menuItem("Time series", tabName = "time_series", icon = icon("chart-bar")),
        menuItem("Table & pct change", tabName = "table_pct_change", icon = icon("clipboard-list")),
        menuItem("Proportional chart", tabName = "proportional_chart", icon = icon("database")),
        menuItem("Correlation", tabName = "correlation", icon = icon("clipboard-list")),
        menuItem("Scatterplot", tabName = "scatterplot", icon = icon("chart-line")),
        selectInput(inputId = "annual_monthly_weekly",
                    label = "Annual or Monthly or Weekly", 
                    choices = list("Annual" = 1, "Monthly"=2, "Weekly" = 3),
                    selected = 1),
        selectInput(inputId = "start_period",
                    label = "Start period",
                    choices = unique(US_land_rig_counts_by_year$Year),
                    selected = ""),
        selectInput(inputId = "end_period",
                    label = "End period",
                    choices = unique(US_land_rig_counts_by_year$Year),
                    selected = ""),
        selectInput(inputId = "oil_or_gas",
                    label = "Oil or gas rigs", 
                    choices = list("Both oil and gas rigs" = 1, "Oil rigs only"=2, "Gas rigs only" = 3),
                    selected = 1),
        selectInput(inputId = "allbasins_or_selectbasins",
                    label = "Basins", 
                    choices = list("All basins" = 1, "Select basins"=2),
                    selected = 1),
        conditionalPanel(
            condition = "input.allbasins_or_selectbasins == 2",
            checkboxGroupInput(inputId = "basin_group",
                           label = "US oil and gas basins", 
                           choices = list("Permian" = "Permian_Avg",
                                          "Haynesville" = "Haynesville_Avg",
                                          "Eagle Ford" = "Eagle_Ford_Avg",
                                          "Marcellus" = "Marcellus_Avg",
                                          "Williston" = "Williston_Avg",
                                          "Cana Woodford" = "Cana_Woodford_Avg",
                                          "DJ-Niobrara" = "Dj_Niobrara_Avg",
                                          "Utica" = "Utica_Avg",
                                          "Ardmore Woodford" = "Ardmore_Woodford_Avg",
                                          "Arkoma Woodford" = "Arkoma_Woodford_Avg",
                                          "Barnett" = "Barnett_Avg",
                                          "Granite Wash" = "Granite_Wash_Avg",
                                          "Fayetteville" = "Fayetteville_Avg",
                                          "Mississippian" = "Mississippian_Avg",
                                          "Other" = "Other_Avg"
                           ),
                           selected = "Permian_Avg")
        )
        
      )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "basins",
          # fluidRow(box(img(src = "BasinsImage.jpg")), height = 600, width = 1300)
          fluidRow(img(src = "BasinsImage.jpg"))
              )
      ,tabItem(tabName = "time_series",
      
          #gvisColumnChart
          fluidRow(box(htmlOutput("rigPlot"), height = 600))
         ,fluidRow(box(htmlOutput("oilpricePlot"), height = 600))
         ,fluidRow(box(htmlOutput("gaspricePlot"), height = 600))
                   )

      ,tabItem(tabName = "table_pct_change",
           fluidRow(box(DT::dataTableOutput("rigPlotTable"), height = 850))
          ,fluidRow(box(htmlOutput("rigChangeChart"), height = 600))
          ,fluidRow(box(htmlOutput("pctChangeChart"), height = 600))
             )

      ,tabItem(tabName = "proportional_chart",
          fluidRow(box(plotOutput("proportionalChart"), height = "100%"))
         ,fluidRow(box(plotOutput("proportionalChartOilVsGas"), height = "100%"))
             )
    
      
      ,tabItem(tabName = "correlation",
          fluidRow(box(DT::dataTableOutput("correlationTable"), height = 850))
          )
      
      ,tabItem(tabName = "scatterplot",
               fluidRow(box(plotOutput("scatterplotOil"), height = "100%"))
              ,fluidRow(box(plotOutput("scatterplotGas"), height = "100%"))
      )

      
      
        )
  
  )

)
)
