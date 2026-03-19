# ============================================================
# Learning Poverty Dashboard - R Shiny App
# ============================================================
# Required packages:
#   shiny, readxl, dplyr, ggplot2, ggtext, scales, gridExtra
# Install missing packages with:
#   install.packages(c("shiny","readxl","dplyr","ggplot2","ggtext","scales","gridExtra"))
# ============================================================

library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(ggtext)
library(scales)
library(gridExtra)

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
      
      # ── Country selector ──────────────────────────────────────────────────────
      div(class = "card",
          p(class = "card-title", "① Select Country"),
          div(class = "selector-row",
              div(
                div(class = "selector-label", "Country"),
                selectInput("country", label = NULL, choices = NULL, width = "320px")
              )
          )
      ),
      
      # ── KPI chips ─────────────────────────────────────────────────────────────
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
  ),
  
  div(class = "footer", "Learning Poverty Dashboard • Built with R Shiny")
)


# ── Server ───────────────────────────────────────────────────────────────────

server <- function(input, output, session) {
  
  # ── Load data from file on startup ──────────────────────────────────────
  lp_data <- reactive({
    df <- read_excel("example1.xlsx")
    df$learning_poverty <- as.numeric(df$learning_poverty)
    df
  })
  
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
      scale_y_continuous(limits = c(-0.60, 1.6)) +
      
      # ── Legend annotation (below axis) ──
      annotate("point", x = 6,  y = -0.52, color = "#CBD5E1", size = 3) +
      annotate("text",  x = 9,  y = -0.52, label = "All countries",
               hjust = 0, size = 3, color = "#64748B") +
      annotate("point", x = 22, y = -0.52, color = "#0055A5", size = 4) +
      annotate("text",  x = 25, y = -0.52, label = country_nm,
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
        "%, which is considered ", severity, ". This is ",
        fmt_plain(diff_r, region_nm, region_avg()), ", and ",
        fmt_plain(diff_i, income_nm, income_avg()), "."
      )
      
      # Build the dot-plot (reuse existing function)
      chart <- build_plot(lp_data(), selected(), region_avg(), income_avg(), for_pdf = TRUE)
      
      # ── Reference table as a ggplot ──────────────────────────────────────
      tbl_df <- data.frame(
        Benchmark = c(country_nm,
                      paste0("Regional average (", region_nm, ")"),
                      paste0("Income group average (", income_nm, ")")),
        Value     = paste0(c(round(country_val, 1),
                             round(region_avg(), 1),
                             round(income_avg(), 1)), "%"),
        stringsAsFactors = FALSE
      )
      
      tbl_grob <- gridExtra::tableGrob(
        tbl_df,
        rows  = NULL,
        theme = gridExtra::ttheme_minimal(
          core    = list(fg_params = list(fontsize = 9, hjust = c(0, 1),
                                          x = c(0.02, 0.98))),
          colhead = list(fg_params = list(fontsize = 9, fontface = "bold",
                                          hjust = c(0, 1), x = c(0.02, 0.98)))
        )
      )
      
      # ── Assemble PDF with grid ────────────────────────────────────────────
      pdf(file, width = 10, height = 7.5, title = paste("Learning Poverty Brief –", country_nm))
      
      grid::grid.newpage()
      
      # ── Header band ──────────────────────────────────────────────────────
      grid::grid.rect(x = 0.5, y = 1, width = 1, height = 0.12,
                      just = "top",
                      gp = grid::gpar(fill = "#003366", col = NA))
      grid::grid.text("Learning Poverty Country Brief",
                      x = 0.04, y = 0.96,
                      just = "left",
                      gp = grid::gpar(col = "white", fontsize = 16, fontface = "bold"))
      grid::grid.text(format(Sys.Date(), "%B %d, %Y"),
                      x = 0.96, y = 0.96,
                      just = "right",
                      gp = grid::gpar(col = "#CCDDEE", fontsize = 10))
      # Accent rule
      grid::grid.rect(x = 0.5, y = 0.88, width = 1, height = 0.004,
                      just = "top",
                      gp = grid::gpar(fill = "#E8A020", col = NA))
      
      # ── Country title ────────────────────────────────────────────────────
      grid::grid.text(country_nm,
                      x = 0.04, y = 0.845,
                      just = "left",
                      gp = grid::gpar(col = "#003366", fontsize = 18, fontface = "bold"))
      grid::grid.text(
        paste0("Learning Poverty: ", round(country_val, 1), "%   |   Region: ",
               region_nm, "   |   Income Group: ", income_nm),
        x = 0.04, y = 0.805,
        just = "left",
        gp = grid::gpar(col = "#475569", fontsize = 9)
      )
      
      # ── Section: Chart ───────────────────────────────────────────────────
      grid::grid.text("Distribution of Learning Poverty",
                      x = 0.04, y = 0.770,
                      just = "left",
                      gp = grid::gpar(col = "#6B7A90", fontsize = 8,
                                      fontface = "bold"))
      
      # Draw the ggplot chart in a viewport
      vp_chart <- grid::viewport(x = 0.5, y = 0.575, width = 0.93, height = 0.34,
                                 just = c("centre", "centre"))
      print(chart, vp = vp_chart)
      
      # ── Section: Narrative ───────────────────────────────────────────────
      grid::grid.rect(x = 0.5, y = 0.375, width = 0.93, height = 0.095,
                      just = c("centre", "top"),
                      gp = grid::gpar(fill = "#EEF4FF", col = "#0055A5", lwd = 1.5,
                                      linejoin = "round"))
      grid::grid.text("Key Findings",
                      x = 0.04, y = 0.370,
                      just = "left",
                      gp = grid::gpar(col = "#6B7A90", fontsize = 8, fontface = "bold"))
      
      # Word-wrap narrative manually
      chars_per_line <- 115
      words  <- strsplit(narrative_plain, " ")[[1]]
      lines  <- character(0)
      cur    <- ""
      for (w in words) {
        test <- if (nchar(cur) == 0) w else paste(cur, w)
        if (nchar(test) <= chars_per_line) { cur <- test
        } else { lines <- c(lines, cur); cur <- w }
      }
      if (nchar(cur) > 0) lines <- c(lines, cur)
      narrative_wrapped <- paste(lines, collapse = "\n")
      
      grid::grid.text(narrative_wrapped,
                      x = 0.05, y = 0.356,
                      just = c("left", "top"),
                      gp = grid::gpar(col = "#1A2332", fontsize = 9, lineheight = 1.5))
      
      # ── Section: Reference table ─────────────────────────────────────────
      grid::grid.text("Reference Values",
                      x = 0.04, y = 0.245,
                      just = "left",
                      gp = grid::gpar(col = "#6B7A90", fontsize = 8, fontface = "bold"))
      
      vp_tbl <- grid::viewport(x = 0.5, y = 0.18, width = 0.93, height = 0.10,
                               just = c("centre", "centre"))
      gridExtra::grid.arrange(tbl_grob, vp = vp_tbl)
      
      # ── Footer ───────────────────────────────────────────────────────────
      grid::grid.rect(x = 0.5, y = 0, width = 1, height = 0.055,
                      just = "bottom",
                      gp = grid::gpar(fill = "#F7F9FC", col = "#E6EBF3"))
      grid::grid.text(
        paste0("Note: Learning poverty is defined as the share of children unable to read and ",
               "understand a simple text by age 10."),
        x = 0.5, y = 0.030, just = "centre",
        gp = grid::gpar(col = "#9AA5B4", fontsize = 7, fontface = "italic")
      )
      
      dev.off()
    }
  )
}

shinyApp(ui = ui, server = server)