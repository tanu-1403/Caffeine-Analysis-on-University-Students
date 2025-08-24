library(shiny)
library(shinyWidgets)
library(bslib)

# Caffeine content per 100ml
caffeine_data <- list(
  "Tea" = c("Dwarkesh" = 37.86, "Girnar" = 25, "Lipton" = 23.25 ,"Red Label"=48 ,"Taj"=58.8, "Tata"=37,"Tetley"=33,"Tulsi"=0,"Waghbakri"=20),
  "Coffee" = c("Amul" = 70, "Nescafe" = 60, "Bru" = 80,"Davidoff"=57,"Ajay"=38, "MSU Nescafe"=24.08,"Continental"=62,"Starbucks"=73,"Sunrise"=90,"Others(Regular)"=75),
  "Energy Drink" = c("Red Bull" = 30, "Monster" = 36, "Mountain Dew" = 54,"Coca cola"=38,"Sting"=29,"Others"=31)
)

ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty"),
  
  tags$style(HTML("
    h2, h3 { margin-top: 20px; }
    .shiny-input-container { margin-bottom: 15px; }
    img { max-width: 100px; margin: 10px auto; display: block; }
    .info-text { font-size: 16px; font-weight: 500; color: #444; }
  ")),
  
  tags$img(src = "C:\\Users\\DELL\\Downloads\\download.jpeg"),  # Add your own image to www/ folder
  titlePanel("☕ Caffeine Intake Calculator (Multi-Drink Session)"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("weight", "Your Weight (kg):", 70, min = 30),
      pickerInput("type", "Drink Type:", choices = names(caffeine_data)),
      uiOutput("brand_ui"),
      fluidRow(
        column(6, numericInput("size", "Cup Size (ml):", 250, min = 50, step = 50)),
        column(6, numericInput("servings", "Servings:", 1, min = 1))
      ),
      textOutput("cup_caffeine"),  # <- live caffeine per cup
      actionButton("add", "Add Drink", class = "btn-success"),
      br(), br(),
      actionButton("calc", "Calculate Total", class = "btn-primary"),
      actionButton("refresh", "🔄 Refresh Session", class = "btn-danger")
      
    ),
    
    mainPanel(
      h3("Drinks Summary"),
      tableOutput("drink_table"),
      h3(textOutput("total_caffeine")),
      h3(textOutput("comparison"))
    )
  )
)

server <- function(input, output, session) {
  drinks <- reactiveVal(data.frame(
    Type = character(),
    Brand = character(),
    Size = numeric(),
    Servings = numeric(),
    Caffeine_mg = numeric(),
    stringsAsFactors = FALSE
    
  ))
  
  # Update brand choices based on selected type
  output$brand_ui <- renderUI({
    req(input$type)
    selectInput("brand", "Select Brand:", choices = caffeine_data[[input$type]])
  })
  
  # Dynamic caffeine per cup
  output$cup_caffeine <- renderText({
    req(input$brand, input$size)
    caffeine_per_100ml <- as.numeric(input$brand)
    caffeine_per_cup <- (caffeine_per_100ml / 100) * input$size
    paste("☕ Caffeine per cup:", round(caffeine_per_cup, 2), "mg")
  })
  
  # Add drink to session
  observeEvent(input$add, {
    req(input$type, input$brand, input$size, input$servings)
    caffeine_per_100ml <- as.numeric(input$brand)
    caffeine_amount <- (caffeine_per_100ml / 100) * input$size * input$servings
    
    new_row <- data.frame(
      Type = input$type,
      Brand = names(which(caffeine_data[[input$type]] == caffeine_per_100ml)),
      Size = input$size,
      Servings = input$servings,
      Caffeine_mg = round(caffeine_amount, 2),
      stringsAsFactors = FALSE
    )
    
    drinks(rbind(drinks(), new_row))
  })
  
  output$drink_table <- renderTable({
    drinks()
  })
  
  observeEvent(input$calc, {
    total_caf <- sum(drinks()$Caffeine_mg)
    limit <- 2.5 * input$weight
    
    observeEvent(input$refresh, {
      drinks(data.frame(
        Type = character(),
        Brand = character(),
        Size = numeric(),
        Servings = numeric(),
        Caffeine_mg = numeric(),
        stringsAsFactors = FALSE
      ))
      
      output$total_caffeine <- renderText({ "" })
      output$comparison <- renderText({ "" })
    })
    
    
    output$total_caffeine <- renderText({
      paste("☕ Total Caffeine Consumed:", round(total_caf, 2), "mg")
    })
    
    output$comparison <- renderText({
      if (total_caf < limit) {
        paste("✅ You're within the safe limit of", round(limit, 2), "mg.")
      } else if (total_caf == limit) {
        "⚖️ You're exactly at the recommended limit."
      } else {
        paste("⚠️ Warning: You exceeded the safe limit of", round(limit, 2), "mg!")
      }
    })
  })
}

shinyApp(ui, server)
