# =============================================================================
# Learning Poverty Dashboard — World Bank
# =============================================================================

library(shiny)
library(bslib)
library(tidyverse)
library(plotly)
library(leaflet)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(RColorBrewer)
library(scales)
library(ggtext)
library(glue)

# =============================================================================
# DATA LOADING
# =============================================================================

lp_raw <- readRDS("lp_final.rds")
uis_raw <- readRDS("uis_final.rds")

# Identify UIS indicator columns (everything except countrycode and year)
uis_indicator_cols <- setdiff(names(uis_raw), c("countrycode", "year"))

# For each country × indicator, keep the latest non-missing UIS observation
uis_latest <- uis_raw %>%
  pivot_longer(cols = all_of(uis_indicator_cols),
               names_to  = "indicator",
               values_to = "uis_value") %>%
  filter(!is.na(uis_value)) %>%
  group_by(countrycode, indicator) %>%
  slice_max(order_by = year, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  rename(uis_year = year)

# Wide form: one row per country × indicator (latest value + year)
uis_wide_latest <- uis_latest %>%
  pivot_wider(names_from  = indicator,
              values_from = c(uis_value, uis_year),
              names_glue  = "{indicator}__{.value}")

# Scatter merge is handled reactively inside the render function (Tab 4)

# =============================================================================
# WORLD POLYGONS FOR CHOROPLETH
# =============================================================================

world_sf <- ne_countries(scale = "medium", returnclass = "sf") %>%
  select(iso_a3, name_long, geometry) %>%
  rename(countrycode = iso_a3, ne_name = name_long)

# =============================================================================
# WORLD BANK COLOUR PALETTE
# =============================================================================

wb_blue        <- "#002244"
wb_light_blue  <- "#009FDA"
wb_orange      <- "#F05023"
wb_yellow      <- "#FDB714"
wb_green       <- "#00A651"
wb_grey        <- "#6C757D"
wb_bg          <- "#F7F9FC"
wb_panel       <- "#FFFFFF"
wb_text        <- "#1A1A2E"

# Diverging green→white→red (for bar chart and choropleth)
lp_palette <- colorRampPalette(c("#005a32", "#74c476", "#FFFFFF", "#fc8d59", "#b30000"))

# =============================================================================
# HELPER: variable label lookup
# =============================================================================

var_label <- function(stem, gender) {
  g_suffix <- switch(gender, "All" = "_all", "Male" = "_ma", "Female" = "_fe")
  paste0(tolower(stem), g_suffix)
}

indicator_display_name <- function(code) {
  # Simple prettifier; extend as needed
  code
}

# =============================================================================
# UI
# =============================================================================

ui <- fluidPage(
  title = "Learning Poverty Dashboard",
  theme = bs_theme(
    version      = 5,
    bg           = wb_bg,
    fg           = wb_text,
    primary      = wb_blue,
    secondary    = wb_light_blue,
    base_font    = font_google("Source Sans Pro"),
    heading_font = font_google("Merriweather")
  ),
  
  # ── Custom CSS ──────────────────────────────────────────────────────────────
  tags$head(tags$style(HTML(glue("
    /* ── Layout ── */
    body {{ background: {wb_bg}; }}
    .navbar-brand {{ font-family: 'Merriweather', serif; font-weight: 700; color: #FFFFFF !important; }}
    .main-header {{ background: {wb_blue}; padding: 14px 28px; display:flex; align-items:center; gap:16px; }}
    .main-header img {{ height:40px; }}
    .main-header h1 {{ color:#FFFFFF; font-size:1.35rem; font-family:'Merriweather',serif; margin:0; }}
    .main-header .subtitle {{ color:{wb_light_blue}; font-size:0.82rem; margin:0; }}

    /* ── Tabs ── */
    .nav-tabs .nav-link {{ color:{wb_blue}; font-weight:600; font-size:0.9rem; }}
    .nav-tabs .nav-link.active {{ color:{wb_blue}; border-bottom:3px solid {wb_orange}; background:transparent; }}

    /* ── Sidebar ── */
    .sidebar-panel {{
      background:{wb_panel};
      border-right:1px solid #dee2e6;
      padding:20px 16px;
      height:100%;
    }}
    .sidebar-label {{ font-size:0.78rem; font-weight:700; text-transform:uppercase;
                      letter-spacing:.06em; color:{wb_grey}; margin-bottom:4px; }}

    /* ── Cards ── */
    .wb-card {{
      background:{wb_panel};
      border:1px solid #dee2e6;
      border-radius:4px;
      padding:18px 20px;
      margin-bottom:16px;
    }}
    .wb-card-title {{
      font-family:'Merriweather',serif;
      font-size:1rem;
      font-weight:700;
      color:{wb_blue};
      border-bottom:2px solid {wb_orange};
      padding-bottom:8px;
      margin-bottom:14px;
    }}

    /* ── Plot containers ── */
    .plot-container {{ min-height:520px; }}

    /* ── Footer ── */
    .wb-footer {{
      background:{wb_blue};
      color:#ccd6e0;
      font-size:0.75rem;
      padding:12px 28px;
      margin-top:32px;
    }}
  ")))),
  
  # ── Header ────────────────────────────────────────────────────────────────
  div(class = "main-header",
      tags$img(src = "https://www.worldbank.org/content/dam/wbr/logo/logo-wb-header-en.svg",
               onerror = "this.style.display='none'"),
      div(
        tags$h1("Learning Poverty Dashboard"),
        tags$p(class = "subtitle", "Cross-Country Analysis | World Bank Education Global Practice")
      )
  ),
  
  # ── Body ──────────────────────────────────────────────────────────────────
  div(style = "padding:20px 28px;",
      
      # Global filters row
      div(class = "wb-card",
          fluidRow(
            column(3,
                   div(class = "sidebar-label", "Indicator"),
                   radioButtons("indicator_type", NULL,
                                choices  = c("Learning Poverty (LP)" = "lp",
                                             "Learning Deprivation (LD)" = "ld",
                                             "Schooling Deprivation (SD)" = "sd"),
                                selected = "lp",
                                inline   = TRUE)
            ),
            column(3,
                   div(class = "sidebar-label", "Gender"),
                   radioButtons("gender", NULL,
                                choices  = c("All", "Male", "Female"),
                                selected = "All",
                                inline   = TRUE)
            ),
            column(3,
                   div(class = "sidebar-label", "Release Year (LP only)"),
                   uiOutput("release_year_ui")
            ),
            column(3,
                   div(class = "sidebar-label", "Region Filter"),
                   uiOutput("region_filter_ui")
            )
          )
      ),
      
      # Tabs
      tabsetPanel(id = "main_tabs", type = "tabs",
                  
                  # ── Tab 1: Choropleth ────────────────────────────────────────────────
                  tabPanel("🌍  Global Map",
                           br(),
                           div(class = "wb-card",
                               div(class = "wb-card-title", uiOutput("map_title")),
                               leafletOutput("choropleth_map", height = "560px")
                           )
                  ),
                  
                  # ── Tab 2: Bar Chart ─────────────────────────────────────────────────
                  tabPanel("📊  Change Over Time",
                           br(),
                           div(class = "wb-card",
                               div(class = "wb-card-title", uiOutput("bar_title")),
                               fluidRow(
                                 column(4,
                                        div(class = "sidebar-label", "From Release Year"),
                                        uiOutput("bar_year_from_ui")
                                 ),
                                 column(4,
                                        div(class = "sidebar-label", "To Release Year"),
                                        uiOutput("bar_year_to_ui")
                                 ),
                                 column(4,
                                        div(class = "sidebar-label", "Top N Countries"),
                                        sliderInput("top_n_bar", NULL, min = 10, max = 100, value = 40, step = 5)
                                 )
                               ),
                               br(),
                               div(class = "plot-container",
                                   plotlyOutput("bar_chart", height = "600px"))
                           )
                  ),
                  
                  # ── Tab 3: Dumbbell ──────────────────────────────────────────────────
                  tabPanel("⚤  Gender Gaps",
                           br(),
                           div(class = "wb-card",
                               div(class = "wb-card-title", uiOutput("dumbbell_title")),
                               fluidRow(
                                 column(4,
                                        div(class = "sidebar-label", "Release Year"),
                                        uiOutput("dumbbell_year_ui")
                                 ),
                                 column(4,
                                        div(class = "sidebar-label", "Top N Countries"),
                                        sliderInput("top_n_dumbbell", NULL, min = 10, max = 100, value = 40, step = 5)
                                 )
                               ),
                               br(),
                               div(class = "plot-container",
                                   plotlyOutput("dumbbell_plot", height = "700px"))
                           )
                  ),
                  
                  # ── Tab 4: Scatterplot ───────────────────────────────────────────────
                  tabPanel("🔵  LP vs UIS Indicators",
                           br(),
                           div(class = "wb-card",
                               div(class = "wb-card-title", uiOutput("scatter_title")),
                               fluidRow(
                                 column(4,
                                        div(class = "sidebar-label", "UIS Indicator (Y-Axis)"),
                                        selectInput("uis_indicator", NULL,
                                                    choices  = sort(uis_indicator_cols),
                                                    selected = uis_indicator_cols[1])
                                 ),
                                 column(4,
                                        div(class = "sidebar-label", "Release Year"),
                                        uiOutput("scatter_year_ui")
                                 ),
                                 column(4,
                                        div(class = "sidebar-label", "Show Trend Line"),
                                        checkboxInput("show_trend", "OLS trend line", value = TRUE)
                                 )
                               ),
                               br(),
                               div(class = "plot-container",
                                   plotlyOutput("scatter_plot", height = "560px"))
                           )
                  )
      )
  ),
  
  # ── Footer ────────────────────────────────────────────────────────────────
  div(class = "wb-footer",
      "© World Bank Group | Learning Poverty Dashboard | Data: World Bank & UNESCO UIS"
  )
)

# =============================================================================
# SERVER
# =============================================================================

server <- function(input, output, session) {
  
  # ── Dynamic UIs ────────────────────────────────────────────────────────────
  all_release_years <- reactive(sort(unique(lp_raw$release_year), decreasing = TRUE))
  all_regions       <- reactive(sort(na.omit(unique(lp_raw$region))))
  
  output$release_year_ui <- renderUI({
    selectInput("release_year", NULL,
                choices  = all_release_years(),
                selected = max(all_release_years()))
  })
  
  output$region_filter_ui <- renderUI({
    checkboxGroupInput("region_filter", NULL,
                       choices  = all_regions(),
                       selected = all_regions())
  })
  
  output$bar_year_from_ui <- renderUI({
    yrs <- all_release_years()
    selectInput("bar_year_from", NULL,
                choices  = yrs,
                selected = yrs[min(2, length(yrs))])
  })
  
  output$bar_year_to_ui <- renderUI({
    yrs <- all_release_years()
    selectInput("bar_year_to", NULL,
                choices  = yrs,
                selected = yrs[1])
  })
  
  output$dumbbell_year_ui <- renderUI({
    selectInput("dumbbell_year", NULL,
                choices  = all_release_years(),
                selected = max(all_release_years()))
  })
  
  output$scatter_year_ui <- renderUI({
    selectInput("scatter_year", NULL,
                choices  = all_release_years(),
                selected = max(all_release_years()))
  })
  
  # ── Reactive: column names ─────────────────────────────────────────────────
  col_main <- reactive({
    var_label(input$indicator_type, input$gender)
  })
  
  indicator_label <- reactive({
    switch(input$indicator_type,
           "lp" = "Learning Poverty",
           "ld" = "Learning Deprivation",
           "sd" = "Schooling Deprivation")
  })
  
  gender_label <- reactive(input$gender)
  
  # ── Reactive: filtered LP data ─────────────────────────────────────────────
  lp_filtered <- reactive({
    req(input$release_year, input$region_filter)
    lp_raw %>%
      filter(release_year == input$release_year,
             region %in% input$region_filter)
  })
  
  # ── Titles ─────────────────────────────────────────────────────────────────
  output$map_title <- renderUI({
    HTML(glue("{indicator_label()} — {gender_label()} | Release Year {input$release_year}"))
  })
  output$bar_title <- renderUI({
    HTML(glue("Change in {indicator_label()} ({gender_label()})"))
  })
  output$dumbbell_title <- renderUI({
    HTML(glue("{indicator_label()} Gender Gap | Release Year {input$dumbbell_year}"))
  })
  output$scatter_title <- renderUI({
    HTML(glue("{indicator_label()} ({gender_label()}) vs {input$uis_indicator}"))
  })
  
  # ── TAB 1: Choropleth ─────────────────────────────────────────────────────
  output$choropleth_map <- renderLeaflet({
    req(lp_filtered(), col_main())
    
    col     <- col_main()        # resolve reactive once, outside formulas
    ind_lbl <- indicator_label() # resolve reactive once, outside formulas
    
    df <- lp_filtered() %>%
      select(countrycode, country_name, all_of(col)) %>%
      rename(value = !!sym(col)) %>%  # use !!sym() not all_of() inside rename
      filter(!is.na(value))
    
    # world_sf carries ne_name; df carries country_name from LP data
    # Use LP country_name where available, fall back to ne_name
    map_data <- world_sf %>%
      left_join(df, by = "countrycode") %>%
      mutate(display_name = dplyr::coalesce(country_name, ne_name, countrycode))
    
    pal <- colorNumeric(
      palette  = lp_palette(100),
      domain   = c(0, 100),
      na.color = "#D3D3D3"
    )
    
    # Build labels upfront as a plain list (avoids reactive inside ~ formula)
    labels <- lapply(seq_len(nrow(map_data)), function(i) {
      cn  <- map_data$display_name[i]
      val <- map_data$value[i]
      if (is.null(cn) || is.na(cn)) cn <- "Unknown"
      if (is.na(val)) {
        htmltools::HTML(paste0("<b>", cn, "</b><br>No data"))
      } else {
        htmltools::HTML(paste0("<b>", cn, "</b><br>", ind_lbl, ": ", round(val, 1), "%"))
      }
    })
    
    leaflet(map_data) %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons(
        fillColor        = ~pal(value),
        fillOpacity      = 0.85,
        color            = "#FFFFFF",
        weight           = 0.5,
        smoothFactor     = 0.3,
        label            = labels,
        labelOptions     = labelOptions(
          style     = list("font-family" = "Source Sans Pro",
                           "font-size"   = "13px",
                           "border-color" = wb_blue),
          direction = "auto"
        ),
        highlightOptions = highlightOptions(
          weight = 2, color = wb_orange, bringToFront = TRUE
        )
      ) %>%
      addLegend(
        pal      = pal,
        values   = ~value,
        title    = paste0(ind_lbl, " (%)"),
        position = "bottomright",
        labFormat = labelFormat(suffix = "%")
      )
  })
  
  # ── TAB 2: Bar Chart ──────────────────────────────────────────────────────
  output$bar_chart <- renderPlotly({
    req(input$bar_year_from, input$bar_year_to, col_main(), input$region_filter)
    
    col <- col_main()
    
    df_from <- lp_raw %>%
      filter(release_year == input$bar_year_from,
             region %in% input$region_filter) %>%
      select(countrycode, country_name, !!sym(col)) %>%
      rename(val_from = !!sym(col))
    
    df_to <- lp_raw %>%
      filter(release_year == input$bar_year_to,
             region %in% input$region_filter) %>%
      select(countrycode, !!sym(col)) %>%
      rename(val_to = !!sym(col))
    
    df <- inner_join(df_from, df_to, by = "countrycode") %>%
      mutate(change = val_to - val_from) %>%
      filter(!is.na(change)) %>%
      arrange(change) %>%
      head(input$top_n_bar)
    
    # Colour: map change onto green-red palette
    max_abs <- max(abs(df$change), na.rm = TRUE)
    if (max_abs == 0) max_abs <- 1
    
    df <- df %>%
      mutate(
        norm_val = (change + max_abs) / (2 * max_abs),   # 0-1
        bar_color = lp_palette(100)[pmax(1, pmin(100, round(norm_val * 99) + 1))],
        label_text = paste0(country_name, " (", round(change, 1), "pp)")
      )
    
    plot_ly(
      data        = df,
      x           = ~change,
      y           = ~reorder(country_name, change),
      type        = "bar",
      orientation = "h",
      marker      = list(color = ~bar_color),
      text        = ~paste0(round(change, 1), "pp"),
      textposition = "outside",
      hovertemplate = paste0(
        "<b>%{y}</b><br>",
        "Change: %{x:.1f} pp<br>",
        "From: ", input$bar_year_from, " → ", input$bar_year_to,
        "<extra></extra>"
      )
    ) %>%
      layout(
        xaxis = list(
          title      = paste0("Change in ", indicator_label(), " (percentage points)"),
          zeroline   = TRUE,
          zerolinecolor = "#555555",
          zerolinewidth = 1.5,
          ticksuffix = "pp",
          gridcolor  = "#E5E5E5"
        ),
        yaxis = list(
          title      = "",
          automargin = TRUE,
          tickfont   = list(size = 10)
        ),
        margin      = list(l = 160, r = 60, t = 20, b = 60),
        paper_bgcolor = wb_panel,
        plot_bgcolor  = wb_bg,
        font = list(family = "Source Sans Pro", color = wb_text),
        shapes = list(list(
          type = "line", x0 = 0, x1 = 0,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#333333", width = 1.5, dash = "dot")
        ))
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ── TAB 3: Dumbbell ───────────────────────────────────────────────────────
  output$dumbbell_plot <- renderPlotly({
    req(input$dumbbell_year, input$indicator_type, input$region_filter)
    
    stem <- input$indicator_type
    col_ma <- paste0(stem, "_ma")
    col_fe <- paste0(stem, "_fe")
    
    df <- lp_raw %>%
      filter(release_year == input$dumbbell_year,
             region %in% input$region_filter) %>%
      select(countrycode, country_name, all_of(c(col_ma, col_fe))) %>%
      rename(male = !!sym(col_ma), female = !!sym(col_fe)) %>%
      filter(!is.na(male), !is.na(female)) %>%
      mutate(gap = abs(male - female)) %>%
      arrange(desc(gap)) %>%
      head(input$top_n_dumbbell) %>%
      mutate(country_name = factor(country_name, levels = rev(country_name)))
    
    fig <- plot_ly() %>%
      # Segments
      add_segments(
        data = df,
        x    = ~male, xend = ~female,
        y    = ~country_name, yend = ~country_name,
        line = list(color = "#AAAAAA", width = 1.5),
        showlegend = FALSE,
        hoverinfo  = "none"
      ) %>%
      # Male dots
      add_markers(
        data   = df,
        x      = ~male,
        y      = ~country_name,
        name   = "Male",
        marker = list(color = wb_blue, size = 9, opacity = 0.9),
        hovertemplate = paste0(
          "<b>%{y}</b><br>Male ", indicator_label(), ": %{x:.1f}%<extra></extra>"
        )
      ) %>%
      # Female dots
      add_markers(
        data   = df,
        x      = ~female,
        y      = ~country_name,
        name   = "Female",
        marker = list(color = wb_orange, size = 9, opacity = 0.9),
        hovertemplate = paste0(
          "<b>%{y}</b><br>Female ", indicator_label(), ": %{x:.1f}%<extra></extra>"
        )
      ) %>%
      layout(
        xaxis = list(
          title     = paste0(indicator_label(), " (%)"),
          range     = c(0, 105),
          ticksuffix = "%",
          gridcolor = "#E5E5E5"
        ),
        yaxis = list(
          title      = "",
          automargin = TRUE,
          tickfont   = list(size = 9)
        ),
        legend = list(orientation = "h", x = 0.3, y = -0.1),
        margin = list(l = 150, r = 40, t = 20, b = 60),
        paper_bgcolor = wb_panel,
        plot_bgcolor  = wb_bg,
        font = list(family = "Source Sans Pro", color = wb_text)
      ) %>%
      config(displayModeBar = FALSE)
    
    fig
  })
  
  # ── TAB 4: Scatterplot ────────────────────────────────────────────────────
  output$scatter_plot <- renderPlotly({
    req(input$uis_indicator, input$scatter_year, col_main(), input$region_filter)
    
    col <- col_main()
    ind <- input$uis_indicator
    
    # Pull the one UIS indicator we need (latest non-missing obs per country)
    uis_ind <- uis_latest %>%
      filter(indicator == ind) %>%
      select(countrycode, uis_value, uis_year)
    
    # Start from lp_raw so country_name, region, LP columns are all available.
    # Join UIS, then apply the closest-year matching logic.
    sc <- lp_raw %>%
      filter(region %in% input$region_filter) %>%
      select(countrycode, country_name, region, release_year, year_assessment,
             all_of(col)) %>%
      rename(lp_val = !!sym(col)) %>%
      filter(!is.na(lp_val)) %>%
      inner_join(uis_ind, by = "countrycode") %>%
      filter(!is.na(uis_value)) %>%
      # Step 1: minimise |assessment_year − uis_year|
      mutate(diff_assessment = abs(year_assessment - uis_year),
             diff_release    = abs(release_year    - uis_year)) %>%
      group_by(countrycode) %>%
      arrange(diff_assessment, diff_release) %>%
      slice(1) %>%
      ungroup() %>%
      # Finally apply the release-year filter (after picking the best LP row)
      filter(release_year == input$scatter_year)
    
    if (nrow(sc) == 0) {
      return(plotly_empty() %>% layout(title = "No matching data for this selection."))
    }
    
    ind_lbl <- indicator_label()  # resolve reactive once, outside formulas
    
    region_colors <- setNames(
      colorRampPalette(c(wb_blue, wb_light_blue, wb_green,
                         wb_yellow, wb_orange, "#9B59B6", "#E67E22"))(length(unique(sc$region))),
      sort(unique(sc$region))
    )
    
    # Build per-row hover text (avoids vectorised hovertemplate issues)
    sc <- sc %>%
      mutate(hover_txt = paste0(
        "<b>", country_name, "</b><br>",
        ind_lbl, ": ", round(lp_val, 1), "%<br>",
        ind, ": ", round(uis_value, 2), "<br>",
        "LP assessment yr: ", year_assessment, " | UIS yr: ", uis_year
      ))
    
    fig <- plot_ly(
      data   = sc,
      x      = ~lp_val,
      y      = ~uis_value,
      color  = ~region,
      colors = region_colors,
      type   = "scatter",
      mode   = "markers",
      marker = list(size = 9, opacity = 0.8,
                    line = list(width = 0.5, color = "#FFFFFF")),
      text      = ~hover_txt,
      hoverinfo = "text"
    )
    
    if (input$show_trend && nrow(sc) >= 3) {
      fit    <- lm(uis_value ~ lp_val, data = sc)
      x_seq  <- seq(min(sc$lp_val, na.rm = TRUE), max(sc$lp_val, na.rm = TRUE), length.out = 100)
      y_pred <- predict(fit, newdata = data.frame(lp_val = x_seq))
      r2     <- summary(fit)$r.squared
      
      fig <- fig %>%
        add_lines(
          x    = x_seq,
          y    = y_pred,
          name = paste0("OLS (R²=", round(r2, 2), ")"),
          line = list(color = "#333333", width = 1.5, dash = "dot"),
          showlegend = TRUE,
          hoverinfo  = "none",
          inherit    = FALSE
        )
    }
    
    fig %>% layout(
      xaxis = list(
        title      = paste0(indicator_label(), " — ", gender_label(), " (%)"),
        range      = c(0, 105),
        ticksuffix = "%",
        gridcolor  = "#E5E5E5"
      ),
      yaxis = list(
        title     = ind,
        gridcolor = "#E5E5E5"
      ),
      legend = list(title = list(text = "Region"), orientation = "v"),
      paper_bgcolor = wb_panel,
      plot_bgcolor  = wb_bg,
      font = list(family = "Source Sans Pro", color = wb_text)
    ) %>%
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = c("lasso2d", "select2d"))
  })
}

# =============================================================================
# RUN
# =============================================================================
shinyApp(ui = ui, server = server)