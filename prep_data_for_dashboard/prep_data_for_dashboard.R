library(tidyverse)
library(haven)
library(wbstats)

#data_folder <- "C:\Users\wb633382\OneDrive - WBG\Documents\GitHub\Learning_Poverty_Dashboard\prep_data_for_dashboard"

#setwd("C:\Users\wb633382\OneDrive - WBG\Documents\GitHub\Learning_Poverty_Dashboard\prep_data_for_dashboard")
network <- "//wbgfscifs01/GEDEDU/"
output_folder <- "C:/Users/wb633382/OneDrive - WBG/Documents/GitHub/Learning_Poverty_Dashboard/prep_data_for_dashboard"

# =========================================================================
# LOAD THE UIS DATA
# =========================================================================

# Load UIS data downloaded Oct 25, 2025
uis_raw <- read_csv(file.path(network, "GDB/Projects/WLD_2025_FGT-CLO/input_data_for_figures/UIS/UIS_data_downloaded_10.25.2025/SDG/SDG_DATA_NATIONAL.csv")) %>%
  select(-MAGNITUDE, -QUALIFIER)

# Import variable labels
uis_labels <- read_csv(file.path(network, "GDB/Projects/WLD_2025_FGT-CLO/input_data_for_figures/UIS/UIS_data_downloaded_10.25.2025/SDG/SDG_Label.csv"))
# merge in the labels to uis_raw (left join to keep all rows in uis_raw), only keep matched rows in uis_labels
uis_raw <- uis_raw %>%
  left_join(uis_labels, by = c("INDICATOR_ID" = "INDICATOR_ID")) %>%
  select(COUNTRY_ID, YEAR, INDICATOR_ID, VALUE, INDICATOR_LABEL_EN)

# Make all the variable names lowercase
names(uis_raw) <- tolower(names(uis_raw))

# Keep relevant indicators
indicators_to_keep <- c(
  # Youth literacy rate, age 15-24
  "LR.AG15T24", "LR.AG15T24.M", "LR.AG15T24.F",
  # Adult literacy rate, age 15+
  "LR.AG15T99", "LR.AG15T99.M", "LR.AG15T99.F",
  # Literacy rate, age 25-64
  "LR.AG25T64", "LR.AG25T64.M", "LR.AG25T64.F",
  # Elderly literacy rate, age 65+
  "LR.AG65T99", "LR.AG65T99.M", "LR.AG65T99.F",
  # Youth literacy rate, 15-24 using GALP
  "LR.GALP.AG15T24", "LR.GALP.AG15T24.M", "LR.GALP.AG15T24.F",
  # Adult literacy rate using GALP
  "LR.GALP.AG15T99", "LR.GALP.AG15T99.M", "LR.GALP.AG15T99.F",
  # Literacy rate 25-64 using GALP
  "LR.GALP.AG25T64", "LR.GALP.AG25T64.M", "LR.GALP.AG25T64.F",
  # Elderly literacy rate using GALP
  "LR.GALP.AG65T99", "LR.GALP.AG65T99.M", "LR.GALP.AG65T99.F",
  # Proportion of pop achieving proficiency in literacy
  "YADULT.PROFILITERACY", "YADULT.PROFILITERACY.M", "YADULT.PROFILITERACY.F",
  # Proportion of teachers with minimum required qualifications in primary
  "TRTP.1", "TRTP.1.M", "TRTP.1.F",
  # Pupil-trained teacher ratio in primary ed
  "PTRHC.1.TRAINED",
  # Pupil-qualified teacher ratio in primary education
  "PTRHC.1.QUALIFIED",
  # % of Qualified teachers in Primary ed
  "QUTP.1", "QUTP.1.M", "QUTP.1.F",
  # Average teacher salary relative to other professions
  "TSALARY.1",
  # Teacher Attrition rate from primary education
  "TATTRR.1", "TATTRR.1.M", "TATTRR.1.F",
  # % Teachers in Primary Ed who received in-service training in last 12 months
  "TPROFD.1", "TPROFD.1.M", "TPROFD.1.F",
  # Government expenditure on education as % of GDP
  "XGDP.FSGOV",
  # Expenditure on education as % of total gov expenditure
  "XGOVEXP.IMF",
  # Proportion of children/young people at primary age prepared for the future in reading
  "PREPFUTURE.1.READ",
  # Proportion of children/young people at lower secondary age prepared for the future in reading
  "PREPFUTURE.2.READ",
  # Proportion of grade 2 students at or above minimum proficiency level in reading
  "READ.G2", "READ.G2.M", "READ.G2.F",
  # Proportion of grade 3 students at or above minimum proficiency level in reading
  "READ.G3", "READ.G3.M", "READ.G3.F",
  # Proportion of students at end of lower secondary achieving min proficiency in reading
  "READ.LOWERSEC", "READ.LOWERSEC.M", "READ.LOWERSEC.F",
  # Initial household funding per primary student as % of GDP per capita
  "XUNIT.GDPCAP.1.FSHH.FFNTR",
  # Initial government funding per primary student as % of GDP per capita
  "XUNIT.GDPCAP.1.FSGOV.FFNTR",
  # Initial government funding per primary student, constant PPP$
  "XUNIT.PPPCONST.1.FSGOV.FFNTR",
  # Initial household funding per primary student, constant PPP$
  "XUNIT.PPPCONST.1.FSHH.FFNTR",
  # Proportion of primary schools with access to electricity
  "SCHBSP.1.WELEC",
  # Proportion of primary schools with access to Internet for pedagogical purposes
  "SCHBSP.1.WINTERN",
  # Proportion of primary schools with access to computers for pedagogical purposes
  "SCHBSP.1.WCOMPUT",
  # Proportion of primary schools with basic drinking water
  "SCHBSP.1.WWATA",
  # Proportion of primary schools with single-sex basic sanitation facilities
  "SCHBSP.1.WTOILA",
  # Proportion of primary schools with basic handwashing facilities
  "SCHBSP.1.WWASH",
  # Proportion of students at end of Grade 2 achieving min proficiency in mathematics
  "MATH.G2", "MATH.G2.M", "MATH.G2.F",
  # Proportion of students at end of Grade 3 achieving min proficiency in mathematics
  "MATH.G3", "MATH.G3.M", "MATH.G3.F",
  # Proportion of students at end of primary achieving min proficiency in mathematics
  "MATH.PRIMARY", "MATH.PRIMARY.M", "MATH.PRIMARY.F",
  # Proportion of students at end of lower secondary achieving min proficiency in mathematics
  "MATH.LOWERSEC", "MATH.LOWERSEC.M", "MATH.LOWERSEC.F",
  # Completion rate, primary education
  "CR.1", "CR.1.M", "CR.1.F",
  # Completion rate, lower secondary education
  "CR.2", "CR.2.M", "CR.2.F",
  # Completion rate, primary education (modelled)
  "CR.MOD.1", "CR.MOD.1.M", "CR.MOD.1.F",
  # Completion rate, lower secondary education (modelled)
  "CR.MOD.2", "CR.MOD.2.M", "CR.MOD.2.F",
  # Proportion prepared for the future in mathematics, primary age
  "PREPFUTURE.1.MATH", "PREPFUTURE.1.MATH.M", "PREPFUTURE.1.MATH.F",
  # Proportion prepared for the future in mathematics, lower secondary age
  "PREPFUTURE.2.MATH", "PREPFUTURE.2.MATH.M", "PREPFUTURE.2.MATH.F",
  # Proportion of students at end of primary achieving min proficiency in reading
  "READ.PRIMARY", "READ.PRIMARY.M", "READ.PRIMARY.F",
  # Number of years of free primary and secondary education in legal frameworks
  "YEARS.FC.FREE.1T3",
  # Number of years of compulsory primary and secondary education in legal frameworks
  "YEARS.FC.COMP.1T3",
  # Proportion of children aged 24-59 months developmentally on track
  "ONTRACK.THREE.DOMAINS", "ONTRACK.THREE.DOMAINS.M", "ONTRACK.THREE.DOMAINS.F",
  # Adjusted net enrolment rate, one year before official primary entry age
  "NERA.AGM1.CP", "NERA.AGM1.M.CP", "NERA.AGM1.F.CP",
  # Adjusted net attendance rate, one year before official primary entry age
  "NARA.AGM1", "NARA.AGM1.M", "NARA.AGM1.F",
  # % of children under 5 experiencing positive and stimulating home learning environments
  "POSTIMUENV", "POSTIMUENV.M", "POSTIMUENV.F",
  # Net enrolment rate, early childhood education
  "NER.0.CP", "NER.0.M.CP", "NER.0.F.CP",
  # Net enrolment rate, early childhood educational development programmes
  "NER.01.CP", "NER.01.M.CP", "NER.01.F.CP",
  # Net enrolment rate, pre-primary
  "NER.02.CP", "NER.02.M.CP", "NER.02.F.CP",
  # Number of years of free pre-primary education in legal frameworks
  "YEARS.FC.FREE.02",
  # Number of years of compulsory pre-primary education in legal frameworks
  "YEARS.FC.COMP.02",
  # Gross enrolment ratio for tertiary education
  "GER.5T8", "GER.5T8.M", "GER.5T8.F",
  # Gross attendance ratio for tertiary education
  "GAR.5T8", "GAR.5T8.M", "GAR.5T8.F",
  # Proportion of 15-24 year-olds enrolled in vocational education
  "EV1524P.2T5.V", "EV1524P.2T5.V.M", "EV1524P.2T5.V.F",
  # Educational attainment, completed short-cycle tertiary or higher, 25+ years
  "EA.5T8.AG25T99", "EA.5T8.AG25T99.M", "EA.5T8.AG25T99.F"
)

uis_filtered <- uis_raw %>%
  filter(indicator_id %in% indicators_to_keep)

# Reshape to wide format and rename variables
uis_wide <- uis_filtered %>%
  pivot_wider(
    id_cols     = c(country_id, year),
    names_from  = indicator_id,
    values_from = value
  ) %>%
  rename(countrycode = country_id)

# =========================================================================
# CLEAN THE UIS DATA
# =========================================================================

# Quick summary check (equivalent to Stata's summarize)
summary(uis_wide)

# Top-code enrollment/attendance rates at 100%
# NOTE: Update these variable name mappings to match whatever names your
# downstream workflow expects. The names below follow the indicator_id
# column values used as column names after pivot_wider.
enrollment_vars <- c(
  "NERA.AGM1.CP", "NERA.AGM1.M.CP", "NERA.AGM1.F.CP",   # aner_before_primary
  "NARA.AGM1",    "NARA.AGM1.M",    "NARA.AGM1.F",       # anar_before_primary
  "NER.0.CP",     "NER.0.M.CP",     "NER.0.F.CP",        # ner_ece
  "NER.01.CP",    "NER.01.M.CP",    "NER.01.F.CP",       # ner_ece_programs
  "NER.02.CP",    "NER.02.M.CP",    "NER.02.F.CP",       # ner_pp
  "GAR.5T8",      "GAR.5T8.M",      "GAR.5T8.F",         # gar_tertiary
  "GER.5T8",      "GER.5T8.M",      "GER.5T8.F"          # ger_tertiary
)

uis_wide <- uis_wide %>%
  mutate(across(
    all_of(intersect(enrollment_vars, names(uis_wide))),
    ~ if_else(. > 100, 100, .)
  ))

# Drop outlier in household funding per student (PPP)
# (maps to XUNIT.PPPCONST.1.FSHH.FFNTR)
uis_wide <- uis_wide %>%
  mutate(`XUNIT.PPPCONST.1.FSHH.FFNTR` = if_else(
    `XUNIT.PPPCONST.1.FSHH.FFNTR` > 10000, NA_real_, `XUNIT.PPPCONST.1.FSHH.FFNTR`
  ))

# Create combined grade 2/3 reading variable
# Prefer grade 2; fall back to grade 3 when grade 2 is missing
uis_wide <- uis_wide %>%
  mutate(
    sdg_411a_grade2_3_read = case_when(
      !is.na(`READ.G2`) ~ `READ.G2`,
      !is.na(`READ.G3`) ~ `READ.G3`,
      TRUE              ~ NA_real_
    ),
    # Repeat for math
    sdg_411a_grade2_3_math = case_when(
      !is.na(`MATH.G2`) ~ `MATH.G2`,
      !is.na(`MATH.G3`) ~ `MATH.G3`,
      TRUE              ~ NA_real_
    )
  )

# Save intermediate file
#saveRDS(uis_wide, file.path(clone, "01_inputs/UIS/uis_sdg_temp.rds"))

# =========================================================================
# BRING IN EFW VARIABLES
# =========================================================================

# Load PPP adjustment data from World Bank (NY.GDP.MKTP.PP.KD)
ppp_data <- wb_data(
  indicator = "NY.GDP.MKTP.PP.KD",
  return_wide = TRUE
) %>%
  select(countrycode = iso3c, year = date, ppp_adjustment = NY.GDP.MKTP.PP.KD)

# Load the EFW database
efw_raw <- read_dta("C:/Users/wb633382/OneDrive - WBG/EduAnalytics Teams - WB Group - Shared Documents/Education Finance Watch/EFW_2025/comp/Output/efwdatabase_2025.dta")

# Keep relevant variables and merge PPP data
efw <- efw_raw %>%
  select(countrycode = iso3, year, gov_educgdp_pri, enrol_pri) %>%
  inner_join(ppp_data, by = c("countrycode", "year")) %>%
  # Calculate gov expenditure per student in PPP terms
  mutate(gov_expend_per_student_ppp = ((gov_educgdp_pri / 100) * ppp_adjustment) / enrol_pri) %>%
  filter(!is.na(gov_expend_per_student_ppp)) %>%
  # Drop outliers
  filter(
    gov_expend_per_student_ppp <= 30000,
    gov_expend_per_student_ppp >= 10
  ) %>%
  # Create log version
  mutate(log_gov_exp_per_stud_ppp = log(gov_expend_per_student_ppp)) %>%
  select(countrycode, year, gov_expend_per_student_ppp, log_gov_exp_per_stud_ppp)


# Prep LAYS Data for dashboard and merge with uis data
LAYS_raw <- read_dta("C:/Users/wb633382/OneDrive - WBG/Documents/GitHub/Learning_Poverty_Dashboard/prep_data_for_dashboard/official_hci_feb_2026.dta")
# Keep latest year
LAYS_filtered <- LAYS_raw %>%
  filter(year == 2025) %>%
  rename(countrycode = wbcode)
  
  
# Merge LAYS and EFW data into UIS data (keep all UIS rows; drop EFW-only rows)
data_finala = merge(x = uis_wide, y = efw, by = c("countrycode", "year"), all.x = TRUE)
data_finalb = merge(x = data_finala, y = LAYS_filtered, by = c("countrycode", "year"), all.x = TRUE)


# Save final file
saveRDS(data_finalb, file.path(output_folder, "data_final.rds"))



# Prepare LP Dataset for dashboard
LP_raw <- read_dta("C:/Users/wb633382/OneDrive - WBG/Documents/GitHub/Learning_Poverty_Dashboard/prep_data_for_dashboard/lpv_panel.dta")

# Drop if pr
LP_filtered <- LP_raw %>%
  filter(preference == "1005_GEM" |
         preference == "1108_GEM" | 
         preference == "1205_GEM" | 
         preference == "1303_GEM" | 
         preference == "1402" ) %>%
  rename(release_year = year) %>%
  rename(country_name = countryname) %>%
  rename(lp_all = lpv_all) %>%
  rename(lp_ma = lpv_ma) %>%
  rename(lp_fe = lpv_fe)

saveRDS(LP_filtered, file.path(output_folder, "lp_final.rds"))          






# Sample Line Plot for LP 

library(tidyverse)
library(scales)

# Filter to one country
df_country <- LP_filtered %>%
  filter(countrycode == "AFG") %>%   # change country
  arrange(release_year)

# Plot
p <- ggplot(df_country, aes(x = release_year)) +
  
  geom_line(aes(y = lp_all, color = "Learning Poverty"), linewidth = 1.3) +
  geom_line(aes(y = ld_all, color = "Learning Deprivation"), linewidth = 1.3) +
  geom_line(aes(y = sd_all, color = "Schooling Deprivation"), linewidth = 1.3) +
  
  geom_point(
    aes(y = ld_all, shape = test),
    size = 3.5,
    stroke = 1,
    color = "black"
  ) +
  
  scale_color_manual(
    values = c(
      "Learning Poverty" = "#0072B2",
      "Learning Deprivation" = "#D55E00",
      "Schooling Deprivation" = "#009E73"
    )
  ) +
  
  scale_y_continuous(
    labels = label_percent(scale = 1),
    expand = expansion(mult = 0.1)   # <-- key change
  ) +
  
  labs(
    title = unique(df_country$country_name),
    subtitle = "Learning Poverty and its Components Over Time",
    x = "Release Year",
    y = "Share of Children (%)",
    shape = "Assessment",
    color = ""
  ) +
  
  theme_classic(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 18)
  )

p