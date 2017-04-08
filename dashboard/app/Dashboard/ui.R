# Define the overall UI
header <- dashboardHeader(
  title = "PISA analytics - (v0.1)",
  titleWidth = "800px"
)

sidebar <- dashboardSidebar(
  sidebarUserPanel(
    "DataVis",
    subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
    # Image file should be in www/ subdir
    image = "Barcelonagse.jpg"
  ),
  sidebarMenu(
    id = "tabs",
    menuItem(
      "About the project",
      tabName = "About",
      icon = icon("hand-paper-o"),
      menuSubItem("The project",
                  tabName = "PISA_about")
    ),
    menuItem(
      "Exploration area",
      tabName = "EA",
      icon = icon("search-plus")
    )
  ),
  conditionalPanel("input.tabs=='EA'",
     fluidRow(
       column(1),
       column(10,
          radioButtons("map_test", "Map filter:",
                       c("math" = "math",
                         "science" = "science",
                         "reading" = "reading",
                         "Hierarchical clustering" = "clustering"))
       )
     )
  ),
  sidebarMenuOutput("menu")
)

body <- dashboardBody(
  tabItems(
    # //////////
    # EA ####
    tabItem("EA",
      box(title = 'PISA Map',
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 14,
        fluidRow(
          column(12,
                 leafletOutput("map")  
          )
        )
      ),
      box(title = 'Macroeconomic variables',
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        collapsed = TRUE,
        width = 14,
        fluidRow(
          column(12,
                 valueBoxOutput("vbox_gdp_pc"),
                 valueBoxOutput("vbox_life_exp"),
                 valueBoxOutput("vbox_youth_unemp")
          ),
          column(12,
                 valueBoxOutput("vbox_p_urb"),
                 valueBoxOutput("vbox_p_rur"),
                 valueBoxOutput("vbox_gini")
          )
        )
      ),
      box(title = 'Variable impact on score',
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 14,
          fluidRow(
            column(12,
                   plotlyOutput("Plot_var")
            )
          )
      ),
      box(title = 'PISA News',
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          width = 14,
          fluidRow(
            column(6,
                   plotOutput("Plot_sentiment")
            ),
            column(6,
                   plotOutput("Plot_wc")
            )
          )
      )
    ),
    # About the project ####
    tabItem("PISA_about",
      fluidPage(
        fluidRow(
          includeMarkdown("content/PISA_about.md")
        )
      )
    )
  )
  # //////////
)
dashboardPage(header, sidebar, body)