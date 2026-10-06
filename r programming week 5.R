
packages <- c("shiny", "ggplot2", "DT")

for (p in packages) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p)
  }
}

library(shiny)
library(ggplot2)
library(DT)


# ============================================================
# 3. READ DATASET
# ============================================================

data <- read.csv(
  "R WEEK 5 DATAS.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)


# ============================================================
# 4. CLEAN COLUMN NAMES
# ============================================================

names(data) <- trimws(names(data))


# Convert required columns to correct data types

if ("Crop" %in% names(data)) {
  data$Crop <- as.character(data$Crop)
}

if ("Region" %in% names(data)) {
  data$Region <- as.character(data$Region)
}

if ("SoilType" %in% names(data)) {
  data$SoilType <- as.character(data$SoilType)
}

if ("YieldGrade" %in% names(data)) {
  data$YieldGrade <- as.character(data$YieldGrade)
}


# ============================================================
# 5. UI
# ============================================================

ui <- fluidPage(
  
  # ----------------------------------------------------------
  # CSS DESIGN
  # ----------------------------------------------------------
  
  tags$head(
    
    tags$style(HTML("

      body {
        background-color: #f4f6f7;
        font-family: Arial, sans-serif;
      }

      .title-box {
        background-color: #1b5e20;
        color: white;
        padding: 25px;
        text-align: center;
        border-radius: 10px;
        margin-bottom: 20px;
      }

      .title-box h1 {
        font-weight: bold;
        margin-bottom: 10px;
      }

      .title-box h4 {
        font-weight: normal;
      }

      .kpi {
        background-color: white;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0px 2px 8px rgba(0,0,0,0.12);
      }

      .kpi-title {
        font-size: 15px;
        color: #666666;
        font-weight: bold;
      }

      .kpi-value {
        font-size: 27px;
        color: #1b5e20;
        font-weight: bold;
        margin-top: 8px;
      }

      .section-title {
        font-size: 21px;
        color: #1b5e20;
        font-weight: bold;
        margin-top: 10px;
        margin-bottom: 15px;
      }

      .sidebarPanel {
        background-color: white;
      }

    "))
    
  ),
  
  
  # =========================================================
  # TITLE
  # =========================================================
  
  div(
    class = "title-box",
    
    h1("🌾 CropSense"),
    
    h4(
      "A Regional Crop Yield Dashboard Using R Shiny"
    ),
    
    p(
      "Interactive analysis of crop yield, rainfall, fertilizer and soil conditions"
    )
  ),
  
  
  # =========================================================
  # SIDEBAR + MAIN PANEL
  # =========================================================
  
  sidebarLayout(
    
    # --------------------------------------------------------
    # SIDEBAR
    # --------------------------------------------------------
    
    sidebarPanel(
      
      h3("🔎 Filters"),
      
      selectInput(
        "crop",
        "Select Crop:",
        choices = c(
          "All",
          sort(unique(data$Crop))
        ),
        selected = "All"
      ),
      
      selectInput(
        "region",
        "Select Region:",
        choices = c(
          "All",
          sort(unique(data$Region))
        ),
        selected = "All"
      ),
      
      selectInput(
        "soil",
        "Select Soil Type:",
        choices = c(
          "All",
          sort(unique(data$SoilType))
        ),
        selected = "All"
      ),
      
      selectInput(
        "grade",
        "Select Yield Grade:",
        choices = c(
          "All",
          sort(unique(data$YieldGrade))
        ),
        selected = "All"
      ),
      
      br(),
      
      actionButton(
        "reset",
        "Reset Filters",
        class = "btn-success"
      ),
      
      hr(),
      
      strong("Dashboard Purpose"),
      
      p(
        "CropSense helps analyze regional agricultural performance using interactive data visualization."
      )
    ),
    
    
    # --------------------------------------------------------
    # MAIN PANEL
    # --------------------------------------------------------
    
    mainPanel(
      
      tabsetPanel(
        
        # ====================================================
        # TAB 1 - DASHBOARD
        # ====================================================
        
        tabPanel(
          
          "📊 Dashboard",
          
          br(),
          
          # --------------------------------------------------
          # KPI CARDS
          # --------------------------------------------------
          
          fluidRow(
            
            column(
              3,
              
              div(
                class = "kpi",
                
                div(
                  class = "kpi-title",
                  "TOTAL FARMS"
                ),
                
                div(
                  class = "kpi-value",
                  textOutput("total_farms")
                )
              )
            ),
            
            column(
              3,
              
              div(
                class = "kpi",
                
                div(
                  class = "kpi-title",
                  "TOTAL AREA"
                ),
                
                div(
                  class = "kpi-value",
                  textOutput("total_area")
                )
              )
            ),
            
            column(
              3,
              
              div(
                class = "kpi",
                
                div(
                  class = "kpi-title",
                  "AVERAGE YIELD"
                ),
                
                div(
                  class = "kpi-value",
                  textOutput("average_yield")
                )
              )
            ),
            
            column(
              3,
              
              div(
                class = "kpi",
                
                div(
                  class = "kpi-title",
                  "AVERAGE RAINFALL"
                ),
                
                div(
                  class = "kpi-value",
                  textOutput("average_rainfall")
                )
              )
            )
          ),
          
          br(),
          
          # --------------------------------------------------
          # FIRST ROW OF CHARTS
          # --------------------------------------------------
          
          fluidRow(
            
            column(
              6,
              
              div(
                class = "section-title",
                "Average Yield by Crop"
              ),
              
              plotOutput(
                "crop_plot",
                height = "400px"
              )
            ),
            
            column(
              6,
              
              div(
                class = "section-title",
                "Average Yield by Region"
              ),
              
              plotOutput(
                "region_plot",
                height = "400px"
              )
            )
          ),
          
          # --------------------------------------------------
          # SECOND ROW OF CHARTS
          # --------------------------------------------------
          
          fluidRow(
            
            column(
              6,
              
              div(
                class = "section-title",
                "Yield Grade Distribution"
              ),
              
              plotOutput(
                "grade_plot",
                height = "400px"
              )
            ),
            
            column(
              6,
              
              div(
                class = "section-title",
                "Average Yield by Soil Type"
              ),
              
              plotOutput(
                "soil_plot",
                height = "400px"
              )
            )
          )
        ),
        
        
        # ====================================================
        # TAB 2 - REGIONAL ANALYSIS
        # ====================================================
        
        tabPanel(
          
          "🌍 Regional Analysis",
          
          br(),
          
          div(
            class = "section-title",
            "Regional Crop Yield Analysis"
          ),
          
          plotOutput(
            "regional_yield",
            height = "500px"
          ),
          
          br(),
          
          DTOutput("regional_table")
        ),
        
        
        # ====================================================
        # TAB 3 - CROP ANALYSIS
        # ====================================================
        
        tabPanel(
          
          "🌱 Crop Analysis",
          
          br(),
          
          div(
            class = "section-title",
            "Crop-wise Yield Analysis"
          ),
          
          plotOutput(
            "crop_analysis",
            height = "500px"
          ),
          
          br(),
          
          DTOutput("crop_table")
        ),
        
        
        # ====================================================
        # TAB 4 - RAINFALL & FERTILIZER
        # ====================================================
        
        tabPanel(
          
          "🌧 Rainfall & Fertilizer",
          
          br(),
          
          fluidRow(
            
            column(
              6,
              
              div(
                class = "section-title",
                "Rainfall vs Yield"
              ),
              
              plotOutput(
                "rainfall_plot",
                height = "450px"
              )
            ),
            
            column(
              6,
              
              div(
                class = "section-title",
                "Fertilizer vs Yield"
              ),
              
              plotOutput(
                "fertilizer_plot",
                height = "450px"
              )
            )
          )
        ),
        
        
        # ====================================================
        # TAB 5 - SOIL ANALYSIS
        # ====================================================
        
        tabPanel(
          
          "🌾 Soil Analysis",
          
          br(),
          
          div(
            class = "section-title",
            "Soil Type and Crop Yield"
          ),
          
          plotOutput(
            "soil_analysis",
            height = "500px"
          ),
          
          br(),
          
          DTOutput("soil_table")
        ),
        
        
        # ====================================================
        # TAB 6 - DATASET
        # ====================================================
        
        tabPanel(
          
          "📋 Dataset",
          
          br(),
          
          div(
            class = "section-title",
            "Agricultural Dataset"
          ),
          
          DTOutput("data_table")
        )
        
      )
    )
  )
)


# ============================================================
# 6. SERVER
# ============================================================

server <- function(input, output, session) {
  
  
  # ==========================================================
  # RESET FILTERS
  # ==========================================================
  
  observeEvent(input$reset, {
    
    updateSelectInput(
      session,
      "crop",
      selected = "All"
    )
    
    updateSelectInput(
      session,
      "region",
      selected = "All"
    )
    
    updateSelectInput(
      session,
      "soil",
      selected = "All"
    )
    
    updateSelectInput(
      session,
      "grade",
      selected = "All"
    )
    
  })
  
  
  # ==========================================================
  # FILTER DATA
  # ==========================================================
  
  filtered_data <- reactive({
    
    d <- data
    
    if (input$crop != "All") {
      d <- d[d$Crop == input$crop, ]
    }
    
    if (input$region != "All") {
      d <- d[d$Region == input$region, ]
    }
    
    if (input$soil != "All") {
      d <- d[d$SoilType == input$soil, ]
    }
    
    if (input$grade != "All") {
      d <- d[d$YieldGrade == input$grade, ]
    }
    
    d
  })
  
  
  # ==========================================================
  # KPI - TOTAL FARMS
  # ==========================================================
  
  output$total_farms <- renderText({
    
    nrow(filtered_data())
    
  })
  
  
  # ==========================================================
  # KPI - TOTAL AREA
  # ==========================================================
  
  output$total_area <- renderText({
    
    total <- sum(
      filtered_data()$Area_Hectares,
      na.rm = TRUE
    )
    
    paste(
      round(total, 2),
      "Ha"
    )
    
  })
  
  
  # ==========================================================
  # KPI - AVERAGE YIELD
  # ==========================================================
  
  output$average_yield <- renderText({
    
    if (nrow(filtered_data()) == 0) {
      return("0")
    }
    
    avg <- mean(
      filtered_data()$Yield_Tons,
      na.rm = TRUE
    )
    
    paste(
      round(avg, 2),
      "Tons"
    )
    
  })
  
  
  # ==========================================================
  # KPI - AVERAGE RAINFALL
  # ==========================================================
  
  output$average_rainfall <- renderText({
    
    if (nrow(filtered_data()) == 0) {
      return("0")
    }
    
    avg <- mean(
      filtered_data()$Rainfall_mm,
      na.rm = TRUE
    )
    
    paste(
      round(avg, 2),
      "mm"
    )
    
  })
  
  
  # ==========================================================
  # CROP PLOT
  # ==========================================================
  
  output$crop_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ Crop,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(Crop, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        x = "Crop",
        y = "Average Yield (Tons)",
        title = "Average Crop Yield"
      ) +
      
      theme_minimal() +
      
      theme(
        plot.title = element_text(
          face = "bold"
        )
      )
    
  })
  
  
  # ==========================================================
  # REGION PLOT
  # ==========================================================
  
  output$region_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ Region,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(Region, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        x = "Region",
        y = "Average Yield (Tons)",
        title = "Regional Crop Yield"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # GRADE PLOT
  # ==========================================================
  
  output$grade_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- as.data.frame(
      table(d$YieldGrade)
    )
    
    names(x) <- c(
      "YieldGrade",
      "Count"
    )
    
    ggplot(
      x,
      aes(
        x = YieldGrade,
        y = Count
      )
    ) +
      
      geom_col() +
      
      labs(
        x = "Yield Grade",
        y = "Number of Farms",
        title = "Yield Grade Distribution"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # SOIL PLOT
  # ==========================================================
  
  output$soil_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ SoilType,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(SoilType, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        x = "Soil Type",
        y = "Average Yield (Tons)",
        title = "Yield by Soil Type"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # REGIONAL ANALYSIS
  # ==========================================================
  
  output$regional_yield <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ Region,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(Region, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        title = "Regional Average Crop Yield",
        x = "Region",
        y = "Average Yield (Tons)"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # REGIONAL TABLE
  # ==========================================================
  
  output$regional_table <- renderDT({
    
    d <- filtered_data()
    
    x <- aggregate(
      cbind(
        Area_Hectares,
        Rainfall_mm,
        Fertilizer_kg,
        Yield_Tons
      ) ~ Region,
      data = d,
      FUN = mean
    )
    
    x$Area_Hectares <- round(
      x$Area_Hectares,
      2
    )
    
    x$Rainfall_mm <- round(
      x$Rainfall_mm,
      2
    )
    
    x$Fertilizer_kg <- round(
      x$Fertilizer_kg,
      2
    )
    
    x$Yield_Tons <- round(
      x$Yield_Tons,
      2
    )
    
    datatable(
      x,
      rownames = FALSE,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      )
    )
    
  })
  
  
  # ==========================================================
  # CROP ANALYSIS
  # ==========================================================
  
  output$crop_analysis <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ Crop,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(Crop, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        title = "Crop-wise Average Yield",
        x = "Crop",
        y = "Average Yield (Tons)"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # CROP TABLE
  # ==========================================================
  
  output$crop_table <- renderDT({
    
    d <- filtered_data()
    
    x <- aggregate(
      cbind(
        Area_Hectares,
        Rainfall_mm,
        Fertilizer_kg,
        Yield_Tons
      ) ~ Crop,
      data = d,
      FUN = mean
    )
    
    x$Area_Hectares <- round(
      x$Area_Hectares,
      2
    )
    
    x$Rainfall_mm <- round(
      x$Rainfall_mm,
      2
    )
    
    x$Fertilizer_kg <- round(
      x$Fertilizer_kg,
      2
    )
    
    x$Yield_Tons <- round(
      x$Yield_Tons,
      2
    )
    
    datatable(
      x,
      rownames = FALSE,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      )
    )
    
  })
  
  
  # ==========================================================
  # RAINFALL VS YIELD
  # ==========================================================
  
  output$rainfall_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    ggplot(
      d,
      aes(
        x = Rainfall_mm,
        y = Yield_Tons
      )
    ) +
      
      geom_point(
        size = 3,
        alpha = 0.7
      ) +
      
      geom_smooth(
        method = "lm",
        se = FALSE
      ) +
      
      labs(
        title = "Rainfall vs Crop Yield",
        x = "Rainfall (mm)",
        y = "Yield (Tons)"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # FERTILIZER VS YIELD
  # ==========================================================
  
  output$fertilizer_plot <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    ggplot(
      d,
      aes(
        x = Fertilizer_kg,
        y = Yield_Tons
      )
    ) +
      
      geom_point(
        size = 3,
        alpha = 0.7
      ) +
      
      geom_smooth(
        method = "lm",
        se = FALSE
      ) +
      
      labs(
        title = "Fertilizer vs Crop Yield",
        x = "Fertilizer (kg)",
        y = "Yield (Tons)"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # SOIL ANALYSIS
  # ==========================================================
  
  output$soil_analysis <- renderPlot({
    
    d <- filtered_data()
    
    if (nrow(d) == 0) {
      plot.new()
      text(
        0.5,
        0.5,
        "No data available"
      )
      return()
    }
    
    x <- aggregate(
      Yield_Tons ~ SoilType,
      data = d,
      FUN = mean
    )
    
    ggplot(
      x,
      aes(
        x = reorder(SoilType, Yield_Tons),
        y = Yield_Tons
      )
    ) +
      
      geom_col() +
      
      coord_flip() +
      
      labs(
        title = "Average Yield by Soil Type",
        x = "Soil Type",
        y = "Average Yield (Tons)"
      ) +
      
      theme_minimal()
    
  })
  
  
  # ==========================================================
  # SOIL TABLE
  # ==========================================================
  
  output$soil_table <- renderDT({
    
    d <- filtered_data()
    
    x <- aggregate(
      cbind(
        Area_Hectares,
        Rainfall_mm,
        Fertilizer_kg,
        Yield_Tons
      ) ~ SoilType,
      data = d,
      FUN = mean
    )
    
    x$Area_Hectares <- round(
      x$Area_Hectares,
      2
    )
    
    x$Rainfall_mm <- round(
      x$Rainfall_mm,
      2
    )
    
    x$Fertilizer_kg <- round(
      x$Fertilizer_kg,
      2
    )
    
    x$Yield_Tons <- round(
      x$Yield_Tons,
      2
    )
    
    datatable(
      x,
      rownames = FALSE,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      )
    )
    
  })
  
  
  # ==========================================================
  # COMPLETE DATASET
  # ==========================================================
  
  output$data_table <- renderDT({
    
    datatable(
      filtered_data(),
      filter = "top",
      rownames = FALSE,
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        autoWidth = TRUE
      )
    )
    
  })
  
}


# ============================================================
# 7. RUN SHINY APPLICATION
# ============================================================

shinyApp(
  ui = ui,
  server = server
)

