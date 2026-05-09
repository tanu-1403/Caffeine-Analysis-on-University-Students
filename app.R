# =============================================================================
# CAFFEINE INTAKE STUDY — Shiny App: Interactive Caffeine Calculator
# Faculty of Science, MSU Baroda
# =============================================================================
# FEATURES:
#   • Multi-drink session tracker
#   • Personalised safe limit (weight-based, 2.5 mg/kg)
#   • Brand caffeine database (tea, coffee, energy drinks)
#   • Visual gauge + progress bar
#   • Session history table with delete option
#   • Health tips based on intake level
#   • Study cohort comparison tab
#   • Download session report
# =============================================================================

library(shiny)
library(shinyWidgets)
library(bslib)
library(DT)
library(ggplot2)
library(dplyr)

# =============================================================================
# DATA — Caffeine content database (mg per 100 ml)
# =============================================================================

caffeine_db <- list(
  "☕ Coffee" = c(
    "Amul"             = 70.00,
    "Nescafe"          = 60.00,
    "Bru"              = 80.00,
    "Davidoff"         = 57.00,
    "Ajay"             = 38.00,
    "MSU Nescafe"      = 24.08,
    "Continental"      = 62.00,
    "Starbucks"        = 73.00,
    "Sunrise"          = 90.00,
    "Others (Regular)" = 75.00
  ),
  "🍵 Tea" = c(
    "Dwarkesh"   = 37.86,
    "Girnar"     = 25.00,
    "Lipton"     = 23.25,
    "Red Label"  = 48.00,
    "Taj"        = 58.80,
    "Tata"       = 37.00,
    "Tetley"     = 33.00,
    "Tulsi"      =  0.00,
    "Waghbakri"  = 20.00
  ),
  "⚡ Energy Drink" = c(
    "Red Bull"     = 30.00,
    "Monster"      = 36.00,
    "Mountain Dew" = 54.00,
    "Coca-Cola"    = 38.00,
    "Sting"        = 29.00,
    "Others"       = 31.00
  ),
  "💧 Custom (enter mg/100ml)" = c(
    "Custom" = 0
  )
)

# Study cohort medians for comparison
cohort_data <- data.frame(
  Year    = c("First Year","Second Year","Third Year","Final/Masters","Previous"),
  Regular = c(60, 71.6, 40, 29, 80.14),
  Exam    = c(60, 74.14, 45.8, 29, 114)
)

# =============================================================================
# UI
# =============================================================================

ui <- page_navbar(
  title = "☕ Caffeine Intake Calculator",
  theme = bs_theme(
    bootswatch   = "minty",
    bg           = "#FFF8E7",
    fg           = "#3B2314",
    primary      = "#6F4E37",
    secondary    = "#C4A35A",
    base_font    = font_google("Lato"),
    heading_font = font_google("Playfair Display")
  ),

  # ------------------------------------------------------------------
  # TAB 1: Calculator
  # ------------------------------------------------------------------
  nav_panel(
    title = "🧮 Calculator",
    icon  = icon("calculator"),

    layout_sidebar(
      sidebar = sidebar(
        width = 320,
        bg    = "#FFF0D0",

        h4("Your Profile", style = "color:#6F4E37; font-weight:bold;"),
        numericInput("weight", "Body Weight (kg):", 65, min = 30, max = 200),

        hr(),
        h4("Add a Drink", style = "color:#6F4E37; font-weight:bold;"),

        selectInput("drink_cat",  "Category:",     choices = names(caffeine_db)),
        uiOutput("brand_selector"),
        uiOutput("custom_input"),

        fluidRow(
          column(6, numericInput("cup_size",  "Volume (ml):", 250, min = 50, step = 25)),
          column(6, numericInput("servings",  "Servings:",      1,  min = 1))
        ),

        div(style = "font-size:13px; color:#6F4E37; margin-bottom:8px;",
            textOutput("preview_mg")),

        actionBttn("btn_add",     "➕ Add Drink",
                   style = "fill", color = "success", size = "sm"),
        br(), br(),

        actionBttn("btn_reset",   "🔄 Reset Session",
                   style = "fill", color = "danger", size = "sm")
      ),

      # Main panel
      fluidRow(
        # Gauge card
        column(4,
          card(
            card_header("⚡ Total Caffeine"),
            card_body(
              h2(textOutput("total_display"),
                 style = "text-align:center; color:#6F4E37;"),
              progressBar("gauge_bar", value = 0, total = 100,
                          status = "success", display_pct = TRUE),
              p(textOutput("limit_text"),
                style = "text-align:center; font-size:12px; color:grey;")
            )
          )
        ),

        # Status card
        column(4,
          card(
            card_header("🩺 Health Status"),
            card_body(
              uiOutput("status_badge"),
              br(),
              uiOutput("health_tip")
            )
          )
        ),

        # Equivalent cups card
        column(4,
          card(
            card_header("🔢 Equivalents"),
            card_body(
              uiOutput("equivalents_panel")
            )
          )
        )
      ),

      br(),

      # Session table
      card(
        card_header("📋 Today's Drinks Log"),
        card_body(
          DTOutput("session_table"),
          br(),
          downloadButton("btn_download", "📥 Download Session Report",
                         style = "background:#6F4E37; color:white; border:none;")
        )
      )
    )
  ),

  # ------------------------------------------------------------------
  # TAB 2: Study Comparison
  # ------------------------------------------------------------------
  nav_panel(
    title = "📊 Study Comparison",
    icon  = icon("chart-bar"),

    layout_columns(
      col_widths = c(6, 6),

      card(
        card_header("How do you compare to MSU students?"),
        card_body(
          numericInput("compare_intake", "Your estimated daily intake (mg):", 80, min = 0),
          radioButtons("compare_day", "Day type:",
                       choices = c("Regular Day" = "Regular", "Exam Day" = "Exam"),
                       inline = TRUE),
          plotOutput("comparison_plot", height = "350px")
        )
      ),

      card(
        card_header("MSU Cohort Medians"),
        card_body(
          p("Median daily caffeine intake (mg) from the Faculty of Science survey:"),
          DTOutput("cohort_table"),
          br(),
          p("Data collected from 298 students across 5 academic year groups.",
            style = "font-size:12px; color:grey;")
        )
      )
    )
  ),

  # ------------------------------------------------------------------
  # TAB 3: Brand Reference
  # ------------------------------------------------------------------
  nav_panel(
    title = "📖 Brand Reference",
    icon  = icon("book"),

    card(
      card_header("Caffeine Content Database (mg per 100 ml)"),
      card_body(
        p("Reference values used in the calculator, based on standard nutrition data."),
        DTOutput("brand_table")
      )
    )
  ),

  # ------------------------------------------------------------------
  # TAB 4: About
  # ------------------------------------------------------------------
  nav_panel(
    title = "ℹ️ About",
    icon  = icon("info-circle"),

    card(
      card_body(
        h3("About This Calculator"),
        p("This tool was developed as part of a research project on caffeine intake
           among students at the Faculty of Science, Maharaja Sayajirao University
           of Baroda (MSU Baroda)."),
        h4("Safe Limit Formula"),
        tags$blockquote("Safe limit (mg/day) = 2.5 mg × body weight (kg)",
                        style = "border-left: 4px solid #6F4E37; padding: 8px 16px;
                                 background:#FFF0D0; font-family: monospace;"),
        p("The 2.5 mg/kg threshold is a conservative guideline for healthy adults.
           EFSA (European Food Safety Authority) recommends ≤ 400 mg/day for adults,
           and ≤ 3 mg/kg/day for the general adult population."),
        h4("Caffeine Half-Life"),
        p("Caffeine has a half-life of ~5–6 hours. A 200 mg dose taken at noon
           still leaves ~50 mg active by 10 PM."),
        h4("Data Source"),
        p("Brand caffeine values sourced from manufacturer nutrition labels, USDA
           FoodData Central, and peer-reviewed literature. Student cohort medians
           from the MSU survey (n = 298, 2024–25)."),
        hr(),
        p("Faculty of Science, MSU Baroda | Statistical Analysis Project 2024–25",
          style = "color:grey; font-size:12px;")
      )
    )
  )
)

# =============================================================================
# SERVER
# =============================================================================

server <- function(input, output, session) {

  # ---- Reactive session log ------------------------------------------------
  session_log <- reactiveVal(
    data.frame(
      `#`         = integer(),
      Category    = character(),
      Brand       = character(),
      `Vol (ml)`  = numeric(),
      Servings    = numeric(),
      `Caffeine (mg)` = numeric(),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  )

  # ---- Dynamic brand dropdown ----------------------------------------------
  output$brand_selector <- renderUI({
    brands <- caffeine_db[[req(input$drink_cat)]]
    selectInput("brand", "Brand:", choices = setNames(brands, names(brands)))
  })

  output$custom_input <- renderUI({
    if (input$drink_cat == "💧 Custom (enter mg/100ml)") {
      numericInput("custom_mg", "Caffeine (mg per 100 ml):", 50, min = 0)
    }
  })

  # ---- Live preview --------------------------------------------------------
  output$preview_mg <- renderText({
    req(input$brand, input$cup_size, input$servings)
    mg_per_100 <- if (input$drink_cat == "💧 Custom (enter mg/100ml)") {
      req(input$custom_mg); input$custom_mg
    } else {
      as.numeric(input$brand)
    }
    total_mg <- (mg_per_100 / 100) * input$cup_size * input$servings
    paste0("≈ ", round(total_mg, 1), " mg caffeine in this serving")
  })

  # ---- Add drink -----------------------------------------------------------
  observeEvent(input$btn_add, {
    req(input$brand, input$cup_size, input$servings)

    mg_per_100 <- if (input$drink_cat == "💧 Custom (enter mg/100ml)") {
      req(input$custom_mg); input$custom_mg
    } else {
      as.numeric(input$brand)
    }
    brand_name <- if (input$drink_cat == "💧 Custom (enter mg/100ml)") {
      paste0("Custom (", mg_per_100, " mg/100ml)")
    } else {
      names(which(caffeine_db[[input$drink_cat]] == mg_per_100))[1]
    }

    caf_amount <- (mg_per_100 / 100) * input$cup_size * input$servings

    log      <- session_log()
    new_row  <- data.frame(
      `#`            = nrow(log) + 1L,
      Category       = input$drink_cat,
      Brand          = brand_name,
      `Vol (ml)`     = input$cup_size,
      Servings       = input$servings,
      `Caffeine (mg)`= round(caf_amount, 1),
      stringsAsFactors = FALSE, check.names = FALSE
    )
    session_log(rbind(log, new_row))

    showNotification(paste0("Added: ", brand_name, " (", round(caf_amount, 1), " mg)"),
                     type = "message", duration = 2)
  })

  # ---- Total caffeine reactive ----------------------------------------------
  total_caf <- reactive({ sum(session_log()[["Caffeine (mg)"]], na.rm = TRUE) })
  safe_limit <- reactive({ req(input$weight); 2.5 * input$weight })

  # ---- Gauge / progress bar ------------------------------------------------
  observe({
    pct <- min(round(total_caf() / safe_limit() * 100), 100)
    status <- if (pct < 60) "success" else if (pct < 90) "warning" else "danger"
    updateProgressBar(session, "gauge_bar", value = pct, status = status)
  })

  output$total_display <- renderText({
    paste0(round(total_caf(), 1), " mg")
  })

  output$limit_text <- renderText({
    paste0("Safe limit: ", round(safe_limit(), 0), " mg (2.5 mg/kg × ", input$weight, " kg)")
  })

  # ---- Health status badge -------------------------------------------------
  output$status_badge <- renderUI({
    pct <- total_caf() / safe_limit() * 100
    if (pct == 0) {
      tags$span("⬜ No caffeine recorded", class = "badge bg-secondary fs-6")
    } else if (pct < 60) {
      tags$span("✅ Well within safe range", class = "badge bg-success fs-6")
    } else if (pct < 90) {
      tags$span("⚠️ Approaching your limit", class = "badge bg-warning text-dark fs-6")
    } else if (pct < 100) {
      tags$span("🔴 Near your daily limit", class = "badge bg-danger fs-6")
    } else {
      tags$span("❌ Exceeded safe limit!", class = "badge bg-danger fs-6")
    }
  })

  output$health_tip <- renderUI({
    pct <- total_caf() / safe_limit() * 100
    tip <- if (pct == 0) {
      "No caffeine logged yet. Add drinks using the panel on the left."
    } else if (pct < 40) {
      "You're doing great! Stay hydrated with water alongside caffeinated drinks."
    } else if (pct < 70) {
      "Moderate intake. Consider spacing drinks ≥2 hrs apart for steady alertness."
    } else if (pct < 90) {
      "You're nearing your limit. Swap the next drink for water or herbal tea."
    } else if (pct < 100) {
      "⚠️ Very close to your limit. Avoid any more caffeinated drinks today."
    } else {
      "❌ Limit exceeded. You may experience jitteriness, elevated heart rate,
       or poor sleep. No more caffeine today — drink water and rest."
    }
    p(tip, style = "font-size:13px;")
  })

  # ---- Equivalents panel ---------------------------------------------------
  output$equivalents_panel <- renderUI({
    total <- total_caf()
    tagList(
      p(paste0("≈ ", round(total / 60, 1), " cups of Nescafe (250 ml)")),
      p(paste0("≈ ", round(total / 37.86, 1), " cups of Dwarkesh tea")),
      p(paste0("≈ ", round(total / 30 / 2.5, 1), " cans of Red Bull (250 ml)")),
      p(paste0("≈ ", round(total / 90, 1), " cups of Sunrise coffee")),
      hr(),
      p(paste0("Half-life clearance ~5–6 hrs"),
        style = "font-size:11px; color:grey;")
    )
  })

  # ---- Session table -------------------------------------------------------
  output$session_table <- renderDT({
    log <- session_log()
    if (nrow(log) == 0) {
      return(datatable(data.frame(Message = "No drinks added yet."),
                       options = list(dom = "t"), rownames = FALSE))
    }
    log$Total_Today <- cumsum(log[["Caffeine (mg)"]])
    datatable(log,
              rownames = FALSE,
              options  = list(dom = "t", pageLength = 20, ordering = FALSE),
              class    = "table-hover") %>%
      formatStyle("Caffeine (mg)",
                  background  = styleColorBar(range(log[["Caffeine (mg)"]]), "#C4A35A"),
                  backgroundSize = "100% 80%",
                  backgroundRepeat = "no-repeat",
                  backgroundPosition = "center")
  })

  # ---- Reset session -------------------------------------------------------
  observeEvent(input$btn_reset, {
    session_log(data.frame(
      `#`             = integer(),
      Category        = character(),
      Brand           = character(),
      `Vol (ml)`      = numeric(),
      Servings        = numeric(),
      `Caffeine (mg)` = numeric(),
      stringsAsFactors = FALSE, check.names = FALSE
    ))
    showNotification("Session reset.", type = "warning", duration = 2)
  })

  # ---- Download report -----------------------------------------------------
  output$btn_download <- downloadHandler(
    filename = function() paste0("caffeine_session_", Sys.Date(), ".csv"),
    content  = function(file) {
      log <- session_log()
      log$Safe_Limit_mg  <- round(safe_limit(), 1)
      log$Pct_of_Limit   <- round(total_caf() / safe_limit() * 100, 1)
      write.csv(log, file, row.names = FALSE)
    }
  )

  # ---- Study comparison plot -----------------------------------------------
  output$comparison_plot <- renderPlot({
    day_col <- input$compare_day
    user_val <- input$compare_intake

    plot_data <- cohort_data %>%
      mutate(Value = .data[[day_col]],
             Year  = factor(Year, levels = Year)) %>%
      mutate(bar_color = "#C4A35A")

    ggplot(plot_data, aes(x = Year, y = Value)) +
      geom_col(fill = "#C4A35A", color = "white", alpha = 0.85) +
      geom_hline(yintercept = user_val,
                 color = "#6F4E37", linewidth = 1.2, linetype = "dashed") +
      annotate("text", x = 0.6, y = user_val + 5,
               label = paste0("You: ", user_val, " mg"),
               color = "#6F4E37", fontface = "bold", hjust = 0, size = 4) +
      labs(
        title    = paste("Your Intake vs MSU Cohort Medians —", day_col, "Days"),
        x        = NULL, y = "Median Caffeine (mg/day)"
      ) +
      theme_minimal(base_size = 12) +
      theme(
        plot.background = element_rect(fill = "#FFF8E7", color = NA),
        panel.background= element_rect(fill = "#FFF8E7", color = NA),
        plot.title      = element_text(color = "#3B2314", face = "bold")
      )
  })

  output$cohort_table <- renderDT({
    datatable(cohort_data, rownames = FALSE,
              options = list(dom = "t", pageLength = 10))
  })

  # ---- Brand reference table -----------------------------------------------
  output$brand_table <- renderDT({
    brand_df <- bind_rows(lapply(names(caffeine_db), function(cat) {
      brands <- caffeine_db[[cat]]
      if (cat == "💧 Custom (enter mg/100ml)") return(NULL)
      data.frame(Category = cat, Brand = names(brands),
                 `Caffeine_mg_per_100ml` = unname(brands),
                 check.names = FALSE)
    }))
    datatable(brand_df, rownames = FALSE,
              filter = "top",
              options = list(pageLength = 15)) %>%
      formatStyle("Caffeine_mg_per_100ml",
                  background  = styleColorBar(c(0, 100), "#C4A35A"),
                  backgroundSize = "100% 80%",
                  backgroundRepeat = "no-repeat",
                  backgroundPosition = "center")
  })
}

# =============================================================================
# RUN
# =============================================================================

shinyApp(ui, server)
