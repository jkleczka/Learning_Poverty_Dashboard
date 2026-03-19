# ============================================================
# Learning Poverty Dashboard - R Shiny App
# ============================================================
# Required packages:
#   shiny, readxl, dplyr, ggplot2, ggtext, scales,
#   rmarkdown, knitr, ggrepel, grDevices
# ============================================================

library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(ggtext)
library(scales)
library(rmarkdown)
library(knitr)

# ── UI ───────────────────────────────────────────────────────────────────────

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

      * { box-sizing: border-box; }

      body {
        font-family: 'Inter', sans-serif;
        background-color: #F7F9FC;
        color: #1A2332;
        margin: 0;
        padding: 0;
      }

      /* ── Header ── */
      .dashboard-header {
        background: linear-gradient(135deg, #003366 0%, #0055A5 100%);
        color: white;
        padding: 28px 40px 24px;
        margin-bottom: 0;
        border-bottom: 4px solid #E8A020;
      }
      .dashboard-header h1 {
        margin: 0 0 6px;
        font-size: 26px;
        font-weight: 700;
        letter-spacing: -0.3px;
      }
      .dashboard-header p {
        margin: 0;
        font-size: 14px;
        opacity: 0.85;
        font-weight: 300;
      }

      /* ── Main layout ── */
      .main-content {
        padding: 28px 40px;
        max-width: 1200px;
        margin: 0 auto;
      }

      /* ── Card ── */
      .card {
        background: #FFFFFF;
        border-radius: 10px;
        padding: 28px 32px;
        margin-bottom: 22px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.07);
        border: 1px solid #E6EBF3;
      }
      .card-title {
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        color: #6B7A90;
        margin: 0 0 18px;
      }

      /* ── Selector ── */
      .selector-row {
        display: flex;
        align-items: flex-end;
        gap: 20px;
        flex-wrap: wrap;
      }
      .selector-label {
        font-size: 13px;
        font-weight: 600;
        color: #3A4A5C;
        margin-bottom: 7px;
      }
      .selectize-input {
        border: 1.5px solid #D0D8E8 !important;
        border-radius: 6px !important;
        font-family: 'Inter', sans-serif !important;
        font-size: 14px !important;
        padding: 9px 12px !important;
        min-width: 260px;
      }
      .selectize-input.focus { border-color: #0055A5 !important; box-shadow: 0 0 0 3px rgba(0,85,165,0.12) !important; }

      /* ── KPI chips ── */
      .kpi-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 6px; }
      .kpi-chip {
        flex: 1;
        min-width: 160px;
        border-radius: 8px;
        padding: 14px 18px;
        position: relative;
        border-left: 4px solid;
      }
      .kpi-chip .kpi-label { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.7px; opacity: 0.75; margin-bottom: 6px; }
      .kpi-chip .kpi-value { font-size: 28px; font-weight: 700; line-height: 1; }
      .kpi-chip .kpi-sub   { font-size: 12px; margin-top: 4px; opacity: 0.7; }

      .kpi-country  { background:#EEF4FF; border-color:#0055A5; color:#0055A5; }
      .kpi-region   { background:#FFF7EC; border-color:#E8A020; color:#C47D00; }
      .kpi-income   { background:#ECF9F4; border-color:#1BA866; color:#137A4A; }

      /* ── Narrative box ── */
      .narrative-box {
        background: #F0F5FF;
        border-left: 5px solid #0055A5;
        border-radius: 0 8px 8px 0;
        padding: 18px 22px;
        font-size: 15px;
        line-height: 1.7;
        color: #1A2332;
      }
      .narrative-box .highlight-country { color:#0055A5; font-weight:600; }
      .narrative-box .highlight-region  { color:#C47D00; font-weight:600; }
      .narrative-box .highlight-income  { color:#137A4A; font-weight:600; }

      /* ── Download button ── */
      .btn-download {
        background: #003366;
        color: white;
        border: none;
        border-radius: 7px;
        padding: 11px 22px;
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }
      .btn-download:hover { background: #0055A5; }

      /* ── Upload area ── */
      .upload-hint {
        font-size: 13px;
        color: #6B7A90;
        margin-top: 8px;
      }
      .shiny-input-container { margin-bottom: 0 !important; }

      /* ── Plot area ── */
      #dotplot { width: 100% !important; }

      /* ── Footer ── */
      .footer {
        text-align: center;
        padding: 20px;
        font-size: 12px;
        color: #9AA5B4;
        border-top: 1px solid #E6EBF3;
        margin-top: 10px;
      }
    "))
  ),
  
  # Header
  div(class = "dashboard-header",
      h1("🎓 Learning Poverty Dashboard"),
      p("Country-level insights into learning poverty rates across regions and income groups")
  ),
  
  div(class = "main-content",
      
      # ── Step 1: Upload data ──────────────────────────────────────────────────
      div(class = "card",
          p(class = "card-title", "① Data Source"),
          div(class = "selector-row",
              div(
                div(class = "selector-label", "Upload your .xlsx file"),
                fileInput("data_file", label = NULL,
                          accept = c(".xlsx", ".xls"),
                          buttonLabel = "Browse…",
                          placeholder = "No file selected"),
                p(class = "upload-hint",
                  "Expected columns: country_name, country_code, region, income_level, learning_poverty")
              ),
              div(
                div(class = "selector-label", "Or use built-in sample data"),
                actionButton("use_sample", "Load Sample Data",
                             style = "background:#E8A020;color:white;border:none;border-radius:7px;
                                padding:10px 18px;font-family:'Inter',sans-serif;
                                font-size:14px;font-weight:600;cursor:pointer;")
              )
          )
      ),
      
      # ── Step 2: Country selector ─────────────────────────────────────────────
      conditionalPanel("output.data_loaded",
                       div(class = "card",
                           p(class = "card-title", "② Select Country"),
                           div(class = "selector-row",
                               div(
                                 div(class = "selector-label", "Country"),
                                 selectInput("country", label = NULL, choices = NULL, width = "320px")
                               )
                           )
                       ),
                       
                       # ── KPI chips ───────────────────────────────────────────────────────────
                       div(class = "kpi-row",
                           div(class = "kpi-chip kpi-country",
                               div(class = "kpi-label", "Country"),
                               div(class = "kpi-value", textOutput("kpi_country_val", inline = TRUE)),
                               div(class = "kpi-sub",  textOutput("kpi_country_name", inline = TRUE))
                           ),
                           div(class = "kpi-chip kpi-region",
                               div(class = "kpi-label", "Regional Average"),
                               div(class = "kpi-value", textOutput("kpi_region_val", inline = TRUE)),
                               div(class = "kpi-sub",  textOutput("kpi_region_name", inline = TRUE))
                           ),
                           div(class = "kpi-chip kpi-income",
                               div(class = "kpi-label", "Income Group Average"),
                               div(class = "kpi-value", textOutput("kpi_income_val", inline = TRUE)),
                               div(class = "kpi-sub",  textOutput("kpi_income_name", inline = TRUE))
                           )
                       ),
                       
                       # ── Chart card ──────────────────────────────────────────────────────────
                       div(class = "card",
                           p(class = "card-title", "③ Learning Poverty Distribution"),
                           plotOutput("dotplot", height = "320px")
                       ),
                       
                       # ── Narrative card ──────────────────────────────────────────────────────
                       div(class = "card",
                           p(class = "card-title", "④ Key Findings"),
                           htmlOutput("narrative")
                       ),
                       
                       # ── Download card ────────────────────────────────────────────────────────
                       div(class = "card",
                           p(class = "card-title", "⑤ Export"),
                           p(style = "font-size:14px;color:#3A4A5C;margin-bottom:14px;",
                             "Download a PDF brief containing the chart and narrative summary for the selected country."),
                           downloadButton("download_pdf", "⬇  Download PDF Brief", class = "btn-download")
                       )
      )
  ),
  
  div(class = "footer", "Learning Poverty Dashboard • Built with R Shiny")
)


# ── Server ───────────────────────────────────────────────────────────────────

server <- function(input, output, session) {
  
  # ── Reactive data source ─────────────────────────────────────────────────
  lp_data <- reactiveVal(NULL)
  
  # Sample data (World Bank-style illustrative values)
  sample_data <- data.frame(
    country_name   = c("India","Brazil","Nigeria","Ethiopia","Indonesia",
                       "Pakistan","Bangladesh","Mexico","Kenya","Vietnam",
                       "South Africa","Philippines","Egypt","Morocco","Ghana",
                       "Tanzania","Uganda","Cameroon","Senegal","Mali",
                       "Peru","Colombia","Argentina","Chile","Bolivia",
                       "Thailand","Malaysia","Myanmar","Cambodia","Nepal"),
    country_code   = c("IND","BRA","NGA","ETH","IDN",
                       "PAK","BGD","MEX","KEN","VNM",
                       "ZAF","PHL","EGY","MAR","GHA",
                       "TZA","UGA","CMR","SEN","MLI",
                       "PER","COL","ARG","CHL","BOL",
                       "THA","MYS","MMR","KHM","NPL"),
    region         = c("South Asia","Latin America & Caribbean","Sub-Saharan Africa",
                       "Sub-Saharan Africa","East Asia & Pacific",
                       "South Asia","South Asia","Latin America & Caribbean",
                       "Sub-Saharan Africa","East Asia & Pacific",
                       "Sub-Saharan Africa","East Asia & Pacific",
                       "Middle East & North Africa","Middle East & North Africa",
                       "Sub-Saharan Africa","Sub-Saharan Africa","Sub-Saharan Africa",
                       "Sub-Saharan Africa","Sub-Saharan Africa","Sub-Saharan Africa",
                       "Latin America & Caribbean","Latin America & Caribbean",
                       "Latin America & Caribbean","Latin America & Caribbean",
                       "Latin America & Caribbean","East Asia & Pacific",
                       "East Asia & Pacific","East Asia & Pacific",
                       "East Asia & Pacific","South Asia"),
    income_level   = c("Lower Middle Income","Upper Middle Income","Lower Middle Income",
                       "Low Income","Lower Middle Income",
                       "Lower Middle Income","Lower Middle Income","Upper Middle Income",
                       "Lower Middle Income","Lower Middle Income",
                       "Upper Middle Income","Lower Middle Income",
                       "Lower Middle Income","Lower Middle Income",
                       "Lower Middle Income","Low Income","Low Income",
                       "Lower Middle Income","Low Income","Low Income",
                       "Upper Middle Income","Upper Middle Income",
                       "Upper Middle Income","High Income","Lower Middle Income",
                       "Upper Middle Income","Upper Middle Income",
                       "Lower Middle Income","Lower Middle Income","Lower Middle Income"),
    learning_poverty = c(55.5, 48.0, 87.0, 90.0, 53.5,
                         75.0, 68.0, 33.0, 83.0, 33.0,
                         78.0, 52.0, 66.0, 69.0, 80.0,
                         88.0, 91.0, 76.0, 84.0, 95.0,
                         29.0, 42.0, 20.0, 15.0, 55.0,
                         27.0, 18.0, 65.0, 58.0, 70.0),
    stringsAsFactors = FALSE
  )
  
  # Load sample data
  observeEvent(input$use_sample, { lp_data(sample_data) })
  
  # Load uploaded file
  observeEvent(input$data_file, {
    req(input$data_file)
    tryCatch({
      df <- read_excel(input$data_file$datapath)
      required_cols <- c("country_name","country_code","region","income_level","learning_poverty")
      missing <- setdiff(required_cols, names(df))
      if (length(missing) > 0) {
        showNotification(paste("Missing columns:", paste(missing, collapse=", ")),
                         type = "error", duration = 8)
      } else {
        df$learning_poverty <- as.numeric(df$learning_poverty)
        lp_data(df)
      }
    }, error = function(e) {
      showNotification(paste("Error reading file:", e$message), type = "error", duration = 8)
    })
  })
  
  output$data_loaded <- reactive({ !is.null(lp_data()) })
  outputOptions(output, "data_loaded", suspendWhenHidden = FALSE)
  
  # Update country dropdown
  observe({
    req(lp_data())
    choices <- sort(unique(lp_data()$country_name))
    updateSelectInput(session, "country", choices = choices, selected = choices[1])
  })
  
  # ── Derived reactive values ──────────────────────────────────────────────
  selected <- reactive({
    req(lp_data(), input$country)
    lp_data() %>% filter(country_name == input$country) %>% slice(1)
  })
  
  region_avg <- reactive({
    req(lp_data(), selected())
    lp_data() %>%
      filter(region == selected()$region) %>%
      summarise(avg = mean(learning_poverty, na.rm = TRUE)) %>%
      pull(avg)
  })
  
  income_avg <- reactive({
    req(lp_data(), selected())
    lp_data() %>%
      filter(income_level == selected()$income_level) %>%
      summarise(avg = mean(learning_poverty, na.rm = TRUE)) %>%
      pull(avg)
  })
  
  # ── KPI outputs ──────────────────────────────────────────────────────────
  output$kpi_country_val  <- renderText({ paste0(round(selected()$learning_poverty, 1), "%") })
  output$kpi_country_name <- renderText({ selected()$country_name })
  output$kpi_region_val   <- renderText({ paste0(round(region_avg(), 1), "%") })
  output$kpi_region_name  <- renderText({ selected()$region })
  output$kpi_income_val   <- renderText({ paste0(round(income_avg(), 1), "%") })
  output$kpi_income_name  <- renderText({ selected()$income_level })
  
  # ── Plot builder function ─────────────────────────────────────────────────
  build_plot <- function(df, sel, reg_avg, inc_avg, for_pdf = FALSE) {
    
    country_val <- sel$learning_poverty
    country_nm  <- sel$country_name
    region_nm   <- sel$region
    income_nm   <- sel$income_level
    
    diff_region <- round(country_val - reg_avg, 1)
    diff_income <- round(country_val - inc_avg, 1)
    
    # Jitter y positions for dots
    set.seed(42)
    df_plot <- df %>%
      mutate(
        y_jitter  = runif(n(), 0.55, 1.45),
        dot_color = case_when(
          country_name == country_nm ~ "#0055A5",
          TRUE                       ~ "#CBD5E1"
        ),
        dot_size = case_when(
          country_name == country_nm ~ 3.8,
          TRUE                       ~ 2.0
        ),
        dot_alpha = case_when(
          country_name == country_nm ~ 1,
          TRUE                       ~ 0.7
        )
      )
    
    base_text <- if (for_pdf) 10 else 11
    
    p <- ggplot() +
      # ── All country dots ──
      geom_point(data = df_plot,
                 aes(x = learning_poverty, y = y_jitter,
                     color = dot_color, size = dot_size, alpha = dot_alpha),
                 shape = 16) +
      scale_color_identity() +
      scale_size_identity() +
      scale_alpha_identity() +
      
      # ── Axis line ──
      geom_hline(yintercept = 0.5, color = "#94A3B8", linewidth = 0.6) +
      
      # ── Country callout ──
      geom_segment(aes(x = country_val, xend = country_val,
                       y = 0.50, yend = 0.25),
                   color = "#0055A5", linewidth = 0.9, linetype = "solid") +
      geom_label(aes(x = country_val, y = 0.14,
                     label = paste0(country_nm, "\n", round(country_val, 1), "%")),
                 fill = "#0055A5", color = "white", size = 3.2,
                 fontface = "bold", label.size = 0, label.padding = unit(0.35, "lines")) +
      
      # ── Regional average callout ──
      geom_segment(aes(x = reg_avg, xend = reg_avg,
                       y = 0.50, yend = 0.30),
                   color = "#E8A020", linewidth = 0.9, linetype = "dashed") +
      geom_label(aes(x = reg_avg, y = -0.03,
                     label = paste0("Regional avg\n", round(reg_avg, 1), "%")),
                 fill = "#FFF7EC", color = "#C47D00", size = 2.9,
                 fontface = "bold", label.size = 0.4,
                 label.r = unit(0.2, "lines"),
                 label.padding = unit(0.30, "lines")) +
      
      # ── Income average callout ──
      geom_segment(aes(x = inc_avg, xend = inc_avg,
                       y = 0.50, yend = 0.35),
                   color = "#1BA866", linewidth = 0.9, linetype = "dotdash") +
      geom_label(aes(x = inc_avg, y = -0.26,
                     label = paste0("Income avg\n", round(inc_avg, 1), "%")),
                 fill = "#ECF9F4", color = "#137A4A", size = 2.9,
                 fontface = "bold", label.size = 0.4,
                 label.r = unit(0.2, "lines"),
                 label.padding = unit(0.30, "lines")) +
      
      # ── Axis labels ──
      scale_x_continuous(
        name   = "Learning Poverty Rate (%)",
        limits = c(0, 100),
        breaks = seq(0, 100, 20),
        labels = function(x) paste0(x, "%")
      ) +
      scale_y_continuous(limits = c(-0.45, 1.6)) +
      
      # ── Legend annotation ──
      annotate("point", x = 6, y = 1.54, color = "#CBD5E1", size = 3) +
      annotate("text",  x = 9, y = 1.54, label = "All countries",
               hjust = 0, size = 3, color = "#64748B") +
      annotate("point", x = 22, y = 1.54, color = "#0055A5", size = 4) +
      annotate("text",  x = 25, y = 1.54, label = country_nm,
               hjust = 0, size = 3, color = "#0055A5", fontface = "bold") +
      
      labs(title = NULL, y = NULL) +
      
      theme_minimal(base_size = base_text) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.x = element_line(color = "#E2E8F0", linewidth = 0.4),
        axis.text.y        = element_blank(),
        axis.ticks.y       = element_blank(),
        axis.title.x       = element_text(size = base_text, color = "#475569",
                                          margin = margin(t = 8)),
        axis.text.x        = element_text(size = base_text - 1, color = "#64748B"),
        plot.margin        = margin(10, 20, 10, 10)
      )
    
    return(p)
  }
  
  # ── Render plot ───────────────────────────────────────────────────────────
  output$dotplot <- renderPlot({
    req(lp_data(), selected(), region_avg(), income_avg())
    build_plot(lp_data(), selected(), region_avg(), income_avg())
  }, res = 110)
  
  # ── Narrative text ────────────────────────────────────────────────────────
  narrative_text <- reactive({
    req(selected(), region_avg(), income_avg())
    
    country_val <- selected()$learning_poverty
    country_nm  <- selected()$country_name
    region_nm   <- selected()$region
    income_nm   <- selected()$income_level
    
    diff_r <- round(country_val - region_avg(), 1)
    diff_i <- round(country_val - income_avg(), 1)
    
    fmt_diff <- function(d, ref_name, type) {
      abs_d <- abs(d)
      dir   <- ifelse(d > 0, "higher", "lower")
      color <- if (type == "region") "#C47D00" else "#137A4A"
      cls   <- if (type == "region") "highlight-region" else "highlight-income"
      if (abs_d < 0.05) {
        paste0("roughly equal to the <span class='", cls, "'>",
               ref_name, " average</span> (", round(region_avg(), 1), "%)")
      } else {
        paste0("<strong>", abs_d, " percentage point", if (abs_d != 1) "s" else "",
               "</strong> <em>", dir, "</em> than the <span class='", cls, "'>",
               ref_name, " average</span> (",
               if (type == "region") round(region_avg(), 1) else round(income_avg(), 1), "%)")
      }
    }
    
    severity <- dplyr::case_when(
      country_val >= 80 ~ "extremely high",
      country_val >= 60 ~ "very high",
      country_val >= 40 ~ "high",
      country_val >= 20 ~ "moderate",
      TRUE              ~ "relatively low"
    )
    
    paste0(
      "<span class='highlight-country'>", country_nm, "</span> has a learning poverty rate of ",
      "<strong>", round(country_val, 1), "%</strong>, which is considered <strong>", severity, "</strong>. ",
      "This is ", fmt_diff(diff_r, region_nm, "region"), ", and ",
      fmt_diff(diff_i, income_nm, "income"), "."
    )
  })
  
  output$narrative <- renderUI({
    req(narrative_text())
    div(class = "narrative-box", HTML(narrative_text()))
  })
  
  # ── PDF download ──────────────────────────────────────────────────────────
  output$download_pdf <- downloadHandler(
    filename = function() {
      paste0("Learning_Poverty_Brief_",
             gsub(" ", "_", input$country), "_",
             format(Sys.Date(), "%Y%m%d"), ".pdf")
    },
    content = function(file) {
      req(lp_data(), selected(), region_avg(), income_avg())
      
      # Save plot to temp PNG
      tmp_plot <- tempfile(fileext = ".png")
      p <- build_plot(lp_data(), selected(), region_avg(), income_avg(), for_pdf = TRUE)
      ggsave(tmp_plot, plot = p, width = 9, height = 3.8, dpi = 180, bg = "white")
      
      # Build plain narrative (no HTML) for PDF
      country_val <- selected()$learning_poverty
      country_nm  <- selected()$country_name
      region_nm   <- selected()$region
      income_nm   <- selected()$income_level
      
      diff_r <- round(country_val - region_avg(), 1)
      diff_i <- round(country_val - income_avg(), 1)
      
      fmt_plain <- function(d, ref_name, avg_val) {
        abs_d <- abs(d)
        dir   <- ifelse(d > 0, "higher", "lower")
        if (abs_d < 0.05) {
          paste0("roughly equal to the ", ref_name, " average (", round(avg_val, 1), "%)")
        } else {
          paste0(abs_d, " percentage point", if (abs_d != 1) "s" else "",
                 " ", dir, " than the ", ref_name, " average (", round(avg_val, 1), "%)")
        }
      }
      
      severity <- dplyr::case_when(
        country_val >= 80 ~ "extremely high",
        country_val >= 60 ~ "very high",
        country_val >= 40 ~ "high",
        country_val >= 20 ~ "moderate",
        TRUE              ~ "relatively low"
      )
      
      narrative_plain <- paste0(
        country_nm, " has a learning poverty rate of ", round(country_val, 1),
        "%, which is considered ", severity, ". ",
        "This is ", fmt_plain(diff_r, region_nm, region_avg()), ", and ",
        fmt_plain(diff_i, income_nm, income_avg()), "."
      )
      
      # Write Rmd
      tmp_rmd <- tempfile(fileext = ".Rmd")
      rmd_content <- paste0(
        '---
title: "Learning Poverty Country Brief"
subtitle: "', country_nm, ' | ', format(Sys.Date(), "%B %d, %Y"), '"
output:
  pdf_document:
    latex_engine: xelatex
    fig_caption: false
geometry: "left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm"
header-includes:
  - \\usepackage{xcolor}
  - \\usepackage{graphicx}
  - \\usepackage{fancyhdr}
  - \\usepackage{mdframed}
  - \\usepackage{fontspec}
  - \\setmainfont{DejaVu Sans}
  - \\pagestyle{fancy}
  - \\fancyhf{}
  - \\fancyhead[L]{\\textbf{\\textcolor[HTML]{003366}{Learning Poverty Dashboard}}}
  - \\fancyhead[R]{\\textcolor[HTML]{888888}{\\today}}
  - \\fancyfoot[C]{\\textcolor[HTML]{888888}{\\thepage}}
  - \\renewcommand{\\headrulewidth}{0.4pt}
  - \\definecolor{worldblue}{HTML}{003366}
  - \\definecolor{accent}{HTML}{E8A020}
---

\\begin{center}
{\\Large \\textbf{\\textcolor{worldblue}{', country_nm, '}}}\\\\[4pt]
{\\normalsize Learning Poverty Rate: \\textbf{', round(country_val, 1), '\\%}}\\\\[2pt]
{\\small Region: ', region_nm, ' \\quad|\\quad Income Group: ', income_nm, '}
\\end{center}

\\vspace{4pt}
\\textcolor{accent}{\\rule{\\linewidth}{2pt}}
\\vspace{8pt}

## Distribution of Learning Poverty

The chart below shows learning poverty rates across all countries, with ', country_nm, ' highlighted alongside regional and income group averages.

\\vspace{6pt}

\\includegraphics[width=\\linewidth]{', tmp_plot, '}

\\vspace{10pt}

## Key Findings

\\begin{mdframed}[backgroundcolor=blue!6, linecolor=worldblue, linewidth=1.5pt, leftmargin=0pt, rightmargin=0pt, innertopmargin=10pt, innerbottommargin=10pt]
', narrative_plain, '
\\end{mdframed}

\\vspace{10pt}

## Reference Values

| Benchmark | Value |
|:---|---:|
| **', country_nm, '** | **', round(country_val, 1), '%** |
| Regional average (', region_nm, ') | ', round(region_avg(), 1), '% |
| Income group average (', income_nm, ') | ', round(income_avg(), 1), '% |

\\vspace{8pt}
\\textcolor[HTML]{999999}{\\small \\textit{Note: Learning poverty is defined as the share of children unable to read and understand a simple text by age 10. Data sourced from user-uploaded dataset.}}
'
      )
      
      writeLines(rmd_content, tmp_rmd)
      
      tryCatch({
        rmarkdown::render(tmp_rmd, output_file = file, quiet = TRUE)
      }, error = function(e) {
        # Fallback: plain PDF via base R
        showNotification(
          "PDF generation requires a LaTeX installation (e.g. TinyTeX). Install with: install.packages('tinytex'); tinytex::install_tinytex()",
          type = "warning", duration = 12
        )
      })
    }
  )
}

shinyApp(ui = ui, server = server)