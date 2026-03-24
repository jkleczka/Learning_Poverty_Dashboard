# ============================================================
# World Bank Global Education — Learning Poverty Dashboard
# ============================================================

library(shiny)
library(tidyverse)
library(plotly)
library(bslib)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(shinyjs)

# ---- Load data -----------------------------------------------
lp_data  <- readRDS("lp_final.rds")
edu_data <- readRDS("data_final.rds")

# ---- World Bank colour palette --------------------------------
WB_BLUE   <- "#002244"
WB_CYAN   <- "#009FDA"
WB_ORANGE <- "#F05023"
WB_YELLOW <- "#FDB714"
WB_GREEN  <- "#00A651"
WB_GREY   <- "#6C757D"
WB_LIGHT  <- "#F5F7FA"
WB_WHITE  <- "#FFFFFF"

# ---- Helper: build variable column name ----------------------
get_var_label <- function(metric, gender) {
  suffix <- switch(gender,
                   "All"    = "_all",
                   "Male"   = "_ma",
                   "Female" = "_fe"
  )
  prefix <- switch(metric,
                   "Learning Poverty"      = "lp",
                   "Learning Deprivation"  = "ld",
                   "Schooling Deprivation" = "sd"
  )
  paste0(prefix, suffix)
}

# ---- Pre-compute ONCE at startup -----------------------------
world_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  select(iso_a3, name, geometry)

lp_latest_global <- lp_data %>%
  group_by(countrycode) %>%
  slice_max(release_year, n = 1, with_ties = FALSE) %>%
  ungroup()

country_choices <- c("Global", sort(unique(lp_data$country_name)))
edu_vars        <- setdiff(names(edu_data), c("countrycode", "year"))

# ---- Build CSS using paste0 (avoids sprintf %s/%% conflicts) -
# rgba() and other CSS % values are safe here because we're not
# using sprintf at all.
dashboard_css <- paste0("
  body {
    background: ", WB_LIGHT, ";
    font-family: 'Source Sans Pro', sans-serif;
  }
  .wb-header {
    background: ", WB_BLUE, ";
    color: ", WB_WHITE, ";
    padding: 16px 40px;
    display: flex;
    align-items: center;
    gap: 20px;
    border-bottom: 4px solid ", WB_CYAN, ";
  }
  .wb-header img { height: 46px; }
  .wb-header h1 {
    margin: 0;
    font-size: 1.4rem;
    font-family: 'Merriweather', serif;
    font-weight: 700;
    color: ", WB_WHITE, ";
  }
  .wb-header p {
    margin: 2px 0 0;
    font-size: 0.8rem;
    color: rgba(255,255,255,0.7);
  }
  .section-title {
    font-family: 'Merriweather', serif;
    font-size: 1rem;
    font-weight: 700;
    color: ", WB_BLUE, ";
    border-left: 4px solid ", WB_CYAN, ";
    padding-left: 12px;
    margin: 26px 0 12px;
  }
  .control-panel {
    background: ", WB_LIGHT, ";
    border-radius: 8px;
    padding: 18px 24px;
    margin-bottom: 22px;
    border: 1px solid #dde3ec;
  }
  .control-panel label {
    font-weight: 600;
    color: ", WB_BLUE, ";
    font-size: 0.87rem;
  }
  .plot-card {
    background: ", WB_WHITE, ";
    border-radius: 8px;
    padding: 18px 20px;
    margin-bottom: 26px;
    border: 1px solid #dde3ec;
    box-shadow: 0 2px 5px rgba(0,0,0,0.04);
  }
  .plot-title {
    font-family: 'Merriweather', serif;
    font-size: 0.93rem;
    font-weight: 700;
    color: ", WB_BLUE, ";
    margin-bottom: 3px;
  }
  .plot-subtitle {
    font-size: 0.79rem;
    color: ", WB_GREY, ";
    margin-bottom: 12px;
  }
  .btn-download {
    background: ", WB_CYAN, " !important;
    border: none !important;
    color: ", WB_WHITE, " !important;
    font-weight: 600;
    border-radius: 4px;
    padding: 7px 18px;
  }
  .btn-download:hover { background: #007ab8 !important; }
  .wb-footer {
    background: ", WB_BLUE, ";
    color: rgba(255,255,255,0.65);
    font-size: 0.76rem;
    text-align: center;
    padding: 12px;
    margin-top: 36px;
  }
  .stat-pill {
    display: inline-block;
    background: ", WB_CYAN, ";
    color: ", WB_WHITE, ";
    border-radius: 20px;
    padding: 3px 12px;
    font-size: 0.77rem;
    font-weight: 600;
    margin-right: 6px;
  }

  /* ---- Print styles ---- */
  @media print {
    @page { margin: 15mm 12mm; size: A4 portrait; }
    .wb-header .btn-download,
    .control-panel,
    .wb-footer { display: none !important; }
    .wb-header {
      padding: 10px 20px !important;
      border-bottom: 3px solid ", WB_CYAN, " !important;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }
    body, .plot-card, .wb-header {
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }
    .plot-card {
      page-break-inside: avoid;
      break-inside: avoid;
      margin-bottom: 14px !important;
      box-shadow: none !important;
      border: 1px solid #ccc !important;
    }
    .section-title {
      page-break-after: avoid;
      break-after: avoid;
      margin-top: 16px !important;
    }
    .js-plotly-plot, .plotly { width: 100% !important; }
  }
")

# ==============================================================
# UI
# ==============================================================
ui <- fluidPage(
  useShinyjs(),
  theme = bs_theme(
    version      = 5,
    bg           = WB_WHITE,
    fg           = WB_BLUE,
    primary      = WB_CYAN,
    secondary    = WB_BLUE,
    base_font    = font_google("Source Sans Pro"),
    heading_font = font_google("Merriweather")
  ),
  
  tags$head(tags$style(HTML(dashboard_css))),
  
  # ---- Header ------------------------------------------------
  div(class = "wb-header",
      tags$img(
        src = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/The_World_Bank_logo.svg/320px-The_World_Bank_logo.svg.png",
        alt = "World Bank"
      ),
      div(
        tags$h1("Learning Poverty Dashboard"),
        tags$p("Global Education | World Bank Group")
      ),
      div(style = "margin-left:auto;",
          actionButton("btn_print", "Download PDF",
                       class = "btn-download",
                       icon  = icon("download")))
  ),
  
  div(style = "max-width:1280px; margin:0 auto; padding:20px 32px;",
      
      # -- Global controls --
      div(class = "control-panel",
          fluidRow(
            column(3, selectInput("selected_country", "Select Country",
                                  choices = country_choices, selected = "Global")),
            column(3, selectInput("metric", "Metric",
                                  choices  = c("Learning Poverty", "Learning Deprivation",
                                               "Schooling Deprivation"),
                                  selected = "Learning Poverty")),
            column(3, selectInput("gender", "Gender",
                                  choices = c("All", "Male", "Female"), selected = "All")),
            column(3,
                   conditionalPanel("input.selected_country !== 'Global'",
                                    br(), uiOutput("country_stat_pills")
                   )
            )
          )
      ),
      
      # -- Plot 1 --
      div(class = "section-title", "1  Global Distribution"),
      div(class = "plot-card",
          div(class = "plot-title",    textOutput("map_title")),
          div(class = "plot-subtitle", "Red = higher values, Green = lower values. Hover for details."),
          plotlyOutput("map_plot", height = "450px")
      ),
      
      # -- Plot 2 --
      div(class = "section-title", "2  Trends Over Time"),
      div(class = "plot-card",
          div(class = "plot-title",    textOutput("trend_title")),
          div(class = "plot-subtitle",
              "LP / LD / SD by release year. LD marker shape varies by assessment type."),
          plotlyOutput("trend_plot", height = "370px")
      ),
      
      # -- Plot 3 --
      div(class = "section-title", "3  Country Positioning"),
      div(class = "plot-card",
          div(class = "plot-title",    textOutput("strip_title")),
          div(class = "plot-subtitle",
              "All countries (latest values). Selected country, regional avg, and income-level avg highlighted."),
          plotlyOutput("strip_plot", height = "260px")
      ),
      
      # -- Plot 4 (shown only when a country is selected) --
      conditionalPanel("input.selected_country !== 'Global'",
                       div(class = "section-title", "4  Gender Gap Comparison"),
                       div(class = "plot-card",
                           div(class = "plot-title", "Gender Gap in Learning Poverty"),
                           div(class = "plot-subtitle",
                               "Sorted by gap size (largest at top). Circle = Male, Diamond = Female."),
                           fluidRow(
                             column(6,
                                    tags$b(style = "font-size:.85rem; color:#002244;", "By Region"),
                                    plotlyOutput("dumbbell_region", height = "420px")
                             ),
                             column(6,
                                    tags$b(style = "font-size:.85rem; color:#002244;", "By Income Level"),
                                    plotlyOutput("dumbbell_income", height = "420px")
                             )
                           )
                       )
      ),
      
      # -- Plot 5 --
      div(class = "section-title", "5  Correlates of Learning Poverty"),
      div(class = "plot-card",
          div(class = "plot-title", "Learning Poverty vs. Education Indicator"),
          div(class = "plot-subtitle",
              "One observation per country (latest matched data). OLS fitted line; statistics below."),
          fluidRow(
            column(3,
                   selectInput("scatter_var", "Education Indicator",
                               choices = edu_vars, selected = edu_vars[1]),
                   radioButtons("scatter_color", "Color by",
                                choices = c("Region", "Income Level"), selected = "Region")
            ),
            column(9,
                   plotlyOutput("scatter_plot", height = "400px"),
                   uiOutput("regression_stats")
            )
          )
      )
      
  ),
  
  div(class = "wb-footer",
      "World Bank Group  |  Global Education Team  |  Learning Poverty Estimates")
)


# ==============================================================
# SERVER
# ==============================================================
server <- function(input, output, session) {
  
  # -- PDF: trigger browser print dialog ----------------------
  observeEvent(input$btn_print, {
    shinyjs::runjs("window.print();")
  })
  
  # -- Reactive helpers ----------------------------------------
  var_col <- reactive({
    get_var_label(input$metric, input$gender)
  })
  
  country_meta <- reactive({
    req(input$selected_country != "Global")
    lp_latest_global %>%
      filter(country_name == input$selected_country) %>%
      slice(1)
  })
  
  output$country_stat_pills <- renderUI({
    req(input$selected_country != "Global")
    d   <- country_meta()
    val <- round(d[[var_col()]], 1)
    tagList(
      span(class = "stat-pill", paste0(val, "%")),
      span(class = "stat-pill", d$region),
      span(class = "stat-pill", d$incomelevel)
    )
  })
  
  output$map_title   <- renderText(
    paste(input$metric, "-", input$gender, "| Latest Release Year"))
  output$trend_title <- renderText(
    if (input$selected_country == "Global") "Global Average over Release Years"
    else paste("Trends for", input$selected_country))
  output$strip_title <- renderText(
    paste(input$metric, "-", input$gender, "| Country Distribution (Latest)"))
  
  
  # ===========================================================
  # Plot 1: Choropleth  (plot_geo avoids duplicate colorbar)
  # ===========================================================
  output$map_plot <- renderPlotly({
    vcol    <- var_col()
    join_df <- lp_latest_global %>% select(countrycode, value = all_of(vcol))
    map_df  <- world_map %>% left_join(join_df, by = c("iso_a3" = "countrycode"))
    
    hover_txt <- paste0(
      "<b>", map_df$name, "</b><br>",
      input$metric, " (", input$gender, "): ",
      ifelse(is.na(map_df$value), "N/A",
             paste0(round(map_df$value, 1), "%"))
    )
    
    plot_geo(map_df) %>%
      add_trace(
        type       = "choropleth",
        locations  = ~iso_a3,
        z          = ~value,
        text       = hover_txt,
        hoverinfo  = "text",
        colorscale = list(
          list(0,   "#00A651"),
          list(0.5, "#FDB714"),
          list(1,   "#F05023")
        ),
        zmin      = 0,
        zmax      = 100,
        showscale = TRUE,
        colorbar  = list(
          title      = list(text = "Value (%)"),
          ticksuffix = "%",
          len        = 0.55,
          thickness  = 14
        ),
        marker = list(line = list(color = "#FFFFFF", width = 0.4))
      ) %>%
      layout(
        geo = list(
          showframe      = FALSE,
          showcoastlines = TRUE,
          coastlinecolor = "#CCCCCC",
          projection     = list(type = "natural earth"),
          bgcolor        = WB_LIGHT,
          landcolor      = "#E8EDF2",
          showland       = TRUE,
          showlakes      = FALSE,
          showrivers     = FALSE
        ),
        margin        = list(l = 0, r = 0, t = 0, b = 0),
        paper_bgcolor = WB_WHITE
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  
  # ===========================================================
  # Plot 2: Time series
  # ===========================================================
  output$trend_plot <- renderPlotly({
    suf    <- switch(input$gender, "All" = "_all", "Male" = "_ma", "Female" = "_fe")
    lp_col <- paste0("lp", suf)
    ld_col <- paste0("ld", suf)
    sd_col <- paste0("sd", suf)
    
    if (input$selected_country == "Global") {
      cols_present <- intersect(c(lp_col, ld_col, sd_col), names(lp_data))
      df <- lp_data %>%
        group_by(release_year) %>%
        summarise(across(all_of(cols_present), ~mean(.x, na.rm = TRUE)),
                  .groups = "drop") %>%
        mutate(test = "N/A")
    } else {
      df <- lp_data %>% filter(country_name == input$selected_country)
    }
    
    symbol_map <- c(PIRLS = "circle", EGRA = "square", PASEC = "diamond",
                    LLECE = "cross",  PISA  = "triangle-up",
                    Other = "star",   "N/A" = "circle")
    p <- plot_ly()
    
    if (lp_col %in% names(df)) {
      p <- add_trace(p, data = df, x = ~release_year, y = ~.data[[lp_col]],
                     type = "scatter", mode = "lines+markers",
                     name = paste("Learning Poverty |", input$gender),
                     line   = list(color = WB_ORANGE, width = 2.5),
                     marker = list(color = WB_ORANGE, size = 8, symbol = "circle"))
    }
    if (ld_col %in% names(df)) {
      for (t in unique(df$test)) {
        sub <- df %>% filter(test == t)
        sym <- if (t %in% names(symbol_map)) symbol_map[[t]] else "circle"
        p <- add_trace(p, data = sub, x = ~release_year, y = ~.data[[ld_col]],
                       type = "scatter", mode = "lines+markers",
                       name = paste("Learning Deprivation |", t),
                       line   = list(color = WB_CYAN, width = 2, dash = "dash"),
                       marker = list(color = WB_CYAN, size = 9, symbol = sym))
      }
    }
    if (sd_col %in% names(df)) {
      p <- add_trace(p, data = df, x = ~release_year, y = ~.data[[sd_col]],
                     type = "scatter", mode = "lines+markers",
                     name = paste("Schooling Deprivation |", input$gender),
                     line   = list(color = WB_GREEN, width = 2, dash = "dot"),
                     marker = list(color = WB_GREEN, size = 8, symbol = "circle"))
    }
    
    p %>% layout(
      xaxis  = list(title = "Release Year", showgrid = FALSE, color = WB_BLUE),
      yaxis  = list(title = "Value (%)", range = c(0, 100), ticksuffix = "%",
                    color = WB_BLUE, gridcolor = "#E8EDF2"),
      legend = list(orientation = "h", y = -0.2, font = list(size = 11)),
      plot_bgcolor  = WB_WHITE, paper_bgcolor = WB_WHITE,
      font   = list(family = "Source Sans Pro"),
      margin = list(b = 80)
    ) %>% config(displayModeBar = FALSE)
  })
  
  
  # ===========================================================
  # Plot 3: Strip distribution
  # ===========================================================
  output$strip_plot <- renderPlotly({
    vcol <- var_col()
    df   <- lp_latest_global %>%
      filter(!is.na(.data[[vcol]])) %>%
      mutate(y_jitter = runif(n(), 0.3, 0.9))
    
    sel_country <- if (input$selected_country != "Global") input$selected_country else NULL
    sel_val <- reg_avg <- inc_avg <- NULL
    
    if (!is.null(sel_country)) {
      meta    <- country_meta()
      sel_val <- meta[[vcol]]
      reg_avg <- df %>% filter(region       == meta$region) %>%
        summarise(v = mean(.data[[vcol]], na.rm = TRUE)) %>% pull(v)
      inc_avg <- df %>% filter(incomelevel == meta$incomelevel) %>%
        summarise(v = mean(.data[[vcol]], na.rm = TRUE)) %>% pull(v)
    }
    
    other_df <- if (!is.null(sel_country)) filter(df, country_name != sel_country) else df
    sel_df   <- if (!is.null(sel_country)) filter(df, country_name == sel_country) else NULL
    
    p <- plot_ly()
    p <- add_trace(p, data = other_df,
                   x = ~.data[[vcol]], y = ~y_jitter,
                   type = "scatter", mode = "markers", name = "Countries",
                   text = ~paste0("<b>", country_name, "</b><br>",
                                  round(.data[[vcol]], 1), "%"),
                   hoverinfo = "text",
                   marker = list(color = "#AABCD0", size = 7, opacity = 0.55,
                                 line  = list(width = 0)))
    
    if (!is.null(sel_df) && nrow(sel_df) > 0) {
      p <- add_trace(p, data = sel_df,
                     x = ~.data[[vcol]], y = ~y_jitter,
                     type = "scatter", mode = "markers", name = sel_country,
                     text = ~paste0("<b>", country_name, "</b><br>",
                                    round(.data[[vcol]], 1), "%"),
                     hoverinfo = "text",
                     marker = list(color = WB_ORANGE, size = 13, symbol = "diamond",
                                   line  = list(color = WB_WHITE, width = 1.5)))
      
      p <- add_segments(p, x = sel_val, xend = sel_val, y = 0, yend = 0.28,
                        line = list(color = WB_ORANGE, width = 2, dash = "dot"),
                        showlegend = FALSE, hoverinfo = "none") %>%
        add_annotations(x = sel_val, y = -0.08, yref = "y",
                        text = paste0("<b>", sel_country, "</b><br>",
                                      round(sel_val, 1), "%"),
                        showarrow = FALSE,
                        font = list(size = 10, color = WB_ORANGE))
      
      if (!is.null(reg_avg) && length(reg_avg) == 1 && !is.na(reg_avg)) {
        p <- add_segments(p, x = reg_avg, xend = reg_avg, y = 0, yend = 0.28,
                          line = list(color = WB_CYAN, width = 2, dash = "dot"),
                          showlegend = FALSE, hoverinfo = "none") %>%
          add_annotations(x = reg_avg, y = -0.22, yref = "y",
                          text = paste0("Regional avg<br>", round(reg_avg, 1), "%"),
                          showarrow = FALSE,
                          font = list(size = 10, color = WB_CYAN))
      }
      if (!is.null(inc_avg) && length(inc_avg) == 1 && !is.na(inc_avg)) {
        p <- add_segments(p, x = inc_avg, xend = inc_avg, y = 0, yend = 0.28,
                          line = list(color = WB_GREEN, width = 2, dash = "dot"),
                          showlegend = FALSE, hoverinfo = "none") %>%
          add_annotations(x = inc_avg, y = -0.36, yref = "y",
                          text = paste0("Income avg<br>", round(inc_avg, 1), "%"),
                          showarrow = FALSE,
                          font = list(size = 10, color = WB_GREEN))
      }
    }
    
    p %>% layout(
      xaxis  = list(title = paste(input$metric, "(%)"), range = c(0, 100),
                    ticksuffix = "%", color = WB_BLUE, showgrid = FALSE),
      yaxis  = list(visible = FALSE, range = c(-0.5, 1.1)),
      shapes = list(list(type = "line", x0 = 0, x1 = 1, xref = "paper",
                         y0 = 0.29, y1 = 0.29, yref = "y",
                         line = list(color = "#AABCD0", width = 1))),
      plot_bgcolor  = WB_WHITE, paper_bgcolor = WB_WHITE,
      font   = list(family = "Source Sans Pro"),
      margin = list(b = 90, t = 10),
      legend = list(orientation = "h", y = -0.55)
    ) %>% config(displayModeBar = FALSE)
  })
  
  
  # ===========================================================
  # Plot 4: Dumbbell helper
  # ===========================================================
  make_dumbbell <- function(df_group, selected_cc) {
    df_group <- df_group %>%
      filter(!is.na(lp_ma), !is.na(lp_fe)) %>%
      mutate(gap = abs(lp_ma - lp_fe)) %>%
      arrange(gap)
    
    if (nrow(df_group) == 0) {
      return(plot_ly() %>%
               layout(title = list(text = "No data available",
                                   font = list(size = 13, color = WB_GREY))))
    }
    
    if (nrow(df_group) > 25) {
      sel_rows <- df_group %>% filter(countrycode == selected_cc)
      oth_rows <- df_group %>% filter(countrycode != selected_cc) %>% tail(24)
      df_group <- bind_rows(sel_rows, oth_rows) %>%
        mutate(gap = abs(lp_ma - lp_fe)) %>%
        arrange(gap)
    }
    
    df_group <- df_group %>%
      mutate(y_pos  = row_number(),
             is_sel = (countrycode == selected_cc))
    
    non_sel <- df_group %>% filter(!is_sel)
    sel_row <- df_group %>% filter(is_sel)
    
    p <- plot_ly()
    
    # Segments — non-selected
    if (nrow(non_sel) > 0) {
      for (i in seq_len(nrow(non_sel))) {
        r <- non_sel[i, ]
        p <- add_segments(p,
                          x = r$lp_ma, xend = r$lp_fe, y = r$y_pos, yend = r$y_pos,
                          line = list(color = "#AABCD0", width = 1.2),
                          showlegend = FALSE, hoverinfo = "none")
      }
    }
    # Segment — selected
    if (nrow(sel_row) > 0) {
      p <- add_segments(p,
                        x = sel_row$lp_ma, xend = sel_row$lp_fe,
                        y = sel_row$y_pos, yend = sel_row$y_pos,
                        line = list(color = WB_ORANGE, width = 2.5),
                        showlegend = FALSE, hoverinfo = "none")
    }
    
    # Male markers — non-selected
    if (nrow(non_sel) > 0) {
      p <- add_trace(p, data = non_sel, x = ~lp_ma, y = ~y_pos,
                     type = "scatter", mode = "markers",
                     name = "Male", legendgroup = "Male", showlegend = TRUE,
                     text = ~paste0("<b>", country_name, "</b><br>Male LP: ",
                                    round(lp_ma, 1), "%"),
                     hoverinfo = "text",
                     marker = list(color = WB_CYAN, size = 8, symbol = "circle",
                                   line  = list(color = WB_WHITE, width = 1)))
    }
    # Male markers — selected
    if (nrow(sel_row) > 0) {
      p <- add_trace(p, data = sel_row, x = ~lp_ma, y = ~y_pos,
                     type = "scatter", mode = "markers",
                     name = "Male (sel)", legendgroup = "Male", showlegend = FALSE,
                     text = ~paste0("<b>", country_name, "</b><br>Male LP: ",
                                    round(lp_ma, 1), "%"),
                     hoverinfo = "text",
                     marker = list(color = WB_ORANGE, size = 12, symbol = "circle",
                                   line  = list(color = WB_WHITE, width = 1.5)))
    }
    # Female markers — non-selected
    if (nrow(non_sel) > 0) {
      p <- add_trace(p, data = non_sel, x = ~lp_fe, y = ~y_pos,
                     type = "scatter", mode = "markers",
                     name = "Female", legendgroup = "Female", showlegend = TRUE,
                     text = ~paste0("<b>", country_name, "</b><br>Female LP: ",
                                    round(lp_fe, 1), "%"),
                     hoverinfo = "text",
                     marker = list(color = "#E8A0B0", size = 8, symbol = "diamond",
                                   line  = list(color = WB_WHITE, width = 1)))
    }
    # Female markers — selected
    if (nrow(sel_row) > 0) {
      p <- add_trace(p, data = sel_row, x = ~lp_fe, y = ~y_pos,
                     type = "scatter", mode = "markers",
                     name = "Female (sel)", legendgroup = "Female", showlegend = FALSE,
                     text = ~paste0("<b>", country_name, "</b><br>Female LP: ",
                                    round(lp_fe, 1), "%"),
                     hoverinfo = "text",
                     marker = list(color = WB_ORANGE, size = 12, symbol = "diamond",
                                   line  = list(color = WB_WHITE, width = 1.5)))
    }
    
    p %>% layout(
      xaxis  = list(title = "Learning Poverty (%)", ticksuffix = "%",
                    range = c(0, 100), color = WB_BLUE, showgrid = FALSE),
      yaxis  = list(tickvals = df_group$y_pos, ticktext = df_group$country_name,
                    title = "", color = WB_BLUE, tickfont = list(size = 9.5)),
      plot_bgcolor  = WB_WHITE, paper_bgcolor = WB_WHITE,
      font   = list(family = "Source Sans Pro"),
      margin = list(l = 130, b = 40),
      legend = list(orientation = "h", y = -0.12)
    ) %>% config(displayModeBar = FALSE)
  }
  
  output$dumbbell_region <- renderPlotly({
    req(input$selected_country != "Global")
    meta <- country_meta()
    make_dumbbell(lp_latest_global %>% filter(region == meta$region),
                  meta$countrycode)
  })
  
  output$dumbbell_income <- renderPlotly({
    req(input$selected_country != "Global")
    meta <- country_meta()
    make_dumbbell(lp_latest_global %>% filter(incomelevel == meta$incomelevel),
                  meta$countrycode)
  })
  
  
  # ===========================================================
  # Plot 5: Scatterplot
  # ===========================================================
  scatter_data <- reactive({
    vcol <- var_col()
    
    edu_latest <- edu_data %>%
      select(countrycode, year, edu_val = all_of(input$scatter_var)) %>%
      filter(!is.na(edu_val)) %>%
      group_by(countrycode) %>%
      slice_max(year, n = 1, with_ties = FALSE) %>%
      ungroup() %>%
      rename(edu_year = year)
    
    merged <- lp_data %>%
      left_join(edu_latest, by = "countrycode") %>%
      filter(!is.na(edu_val), !is.na(.data[[vcol]]))
    
    merged <- merged %>%
      mutate(yr_diff = abs(year_assessment - edu_year)) %>%
      group_by(countrycode) %>%
      slice_min(yr_diff, n = 1, with_ties = FALSE) %>%
      ungroup()
    
    merged %>%
      mutate(rel_diff = abs(release_year - edu_year)) %>%
      group_by(countrycode) %>%
      slice_min(rel_diff, n = 1, with_ties = FALSE) %>%
      ungroup()
  })
  
  output$scatter_plot <- renderPlotly({
    df   <- scatter_data()
    req(nrow(df) > 2)
    vcol      <- var_col()
    color_col <- if (input$scatter_color == "Region") "region" else "incomelevel"
    grps      <- sort(unique(df[[color_col]]))
    pal       <- setNames(
      colorRampPalette(c(WB_BLUE, WB_CYAN, WB_GREEN, WB_YELLOW, WB_ORANGE, "#9B59B6"))(length(grps)),
      grps
    )
    
    fit        <- lm(reformulate(vcol, "edu_val"), data = df)
    df$fit_val <- predict(fit)
    fit_df     <- df %>% arrange(.data[[vcol]])
    
    p <- plot_ly()
    for (g in grps) {
      sub <- df %>% filter(.data[[color_col]] == g)
      p <- add_trace(p, data = sub, x = ~.data[[vcol]], y = ~edu_val,
                     type = "scatter", mode = "markers", name = g,
                     text = ~paste0("<b>", country_name, "</b><br>",
                                    input$metric, ": ", round(.data[[vcol]], 1), "%<br>",
                                    input$scatter_var, ": ", round(edu_val, 2)),
                     hoverinfo = "text",
                     marker = list(color = pal[[g]], size = 9, opacity = 0.8,
                                   line  = list(color = WB_WHITE, width = 1)))
    }
    
    p <- add_trace(p, data = fit_df, x = ~.data[[vcol]], y = ~fit_val,
                   type = "scatter", mode = "lines", name = "Fitted line",
                   line = list(color = WB_BLUE, width = 2, dash = "dash"),
                   hoverinfo = "none")
    
    if (input$selected_country != "Global") {
      hl <- df %>% filter(country_name == input$selected_country)
      if (nrow(hl) > 0) {
        p <- add_trace(p, data = hl, x = ~.data[[vcol]], y = ~edu_val,
                       type = "scatter", mode = "markers",
                       name = input$selected_country,
                       text = ~paste0("<b>", country_name, "</b><br>",
                                      input$metric, ": ", round(.data[[vcol]], 1), "%<br>",
                                      input$scatter_var, ": ", round(edu_val, 2)),
                       hoverinfo = "text",
                       marker = list(color = WB_ORANGE, size = 14, symbol = "star",
                                     line  = list(color = WB_WHITE, width = 1.5)))
      }
    }
    
    p %>% layout(
      xaxis  = list(title = paste(input$metric, "(%)"), ticksuffix = "%",
                    range = c(0, 100), color = WB_BLUE, showgrid = FALSE),
      yaxis  = list(title = input$scatter_var, color = WB_BLUE,
                    gridcolor = "#E8EDF2"),
      legend = list(orientation = "h", y = -0.22, font = list(size = 10)),
      plot_bgcolor  = WB_WHITE, paper_bgcolor = WB_WHITE,
      font   = list(family = "Source Sans Pro"),
      margin = list(b = 90)
    ) %>% config(displayModeBar = FALSE)
  })
  
  output$regression_stats <- renderUI({
    df   <- scatter_data()
    req(nrow(df) > 2)
    vcol <- var_col()
    fit  <- lm(reformulate(vcol, "edu_val"), data = df)
    smry <- summary(fit)
    r2   <- round(smry$r.squared, 3)
    slp  <- round(coef(fit)[2], 4)
    pval <- round(coef(smry)[2, 4], 4)
    div(style = "font-size:.78rem; color:#6C757D; margin-top:6px;",
        tags$b(style = "color:#002244;", "Regression Statistics"), tags$br(),
        paste0("R2 = ", r2, "  |  Slope = ", slp, "  |  p-value = ", pval))
  })
  
}

# ==============================================================
shinyApp(ui, server)