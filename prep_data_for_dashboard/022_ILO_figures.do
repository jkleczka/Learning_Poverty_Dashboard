
*************************************************************************
* Prepare the ILO data for plotting: Employment-to-Population Ratio by Age Group
*************************************************************************
*labor productivty might be another interesting variable to consider

use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\emp_to_pop_ratio_13th_def.dta", clear
rename ref_area_label countryname
rename obs_value emp_to_pop_ratio
rename time year
destring year, replace
keep if sex_label == "Total" 
encode classif1_label, gen(classif)
*browse countryname year classif1_label classif emp_to_pop_ratio if classif == 21 | classif == 27

* for now, we only are interested in the 5 years groupings and the total
drop if classif < 9
drop if classif > 21

tab classif
tab classif, nolabel
keep countryname year classif emp_to_pop_ratio
reshape wide emp_to_pop_ratio, i(countryname year) j(classif) 

* rename variables
rename emp_to_pop_ratio9 emp_to_pop_ratio_10_14
rename emp_to_pop_ratio10 emp_to_pop_ratio_15_19
rename emp_to_pop_ratio11 emp_to_pop_ratio_20_24
rename emp_to_pop_ratio12 emp_to_pop_ratio_25_29
rename emp_to_pop_ratio13 emp_to_pop_ratio_30_34
rename emp_to_pop_ratio14 emp_to_pop_ratio_35_39
rename emp_to_pop_ratio15 emp_to_pop_ratio_40_44
rename emp_to_pop_ratio16 emp_to_pop_ratio_45_49
rename emp_to_pop_ratio17 emp_to_pop_ratio_50_54
rename emp_to_pop_ratio18 emp_to_pop_ratio_55_59
rename emp_to_pop_ratio19 emp_to_pop_ratio_60_64
rename emp_to_pop_ratio20 emp_to_pop_ratio_65_plus
rename emp_to_pop_ratio21 emp_to_pop_ratio_total

* save for merging later
save "${clone}/01_inputs/ILO/temp/emp_to_pop_ratio_for_merge.dta", replace



*************************************************************************
* Prepare the ILO data for plotting: Child Labor Share
*************************************************************************
use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\child_labor_share.dta", clear
rename ref_area_label countryname
rename obs_value child_labor_share
rename time year
destring year, replace
keep if sex_label == "Total" 
encode classif1_label, gen(classif)

tab classif
tab classif, nolabel
keep countryname year classif child_labor_share
reshape wide child_labor_share, i(countryname year) j(classif) 

* rename variables
rename child_labor_share1 child_labor_share_5_11
rename child_labor_share2 child_labor_share_5_17
rename child_labor_share3 child_labor_share_12_14
rename child_labor_share4 child_labor_share_15_17

* save for merging later
save "${clone}/01_inputs/ILO/temp/child_labor_share_for_merge.dta", replace



*************************************************************************
* Prepare the ILO data for plotting: Average Hourly Earnings
*************************************************************************
use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\average_hourly_earnings.dta", clear
rename ref_area_label countryname
rename obs_value avg_hourly_earnings
rename time year
destring year, replace
keep if sex_label == "Total" 
keep if classif2_label == "Currency: 2021 PPP $"
encode classif1_label, gen(classif)

tab classif
tab classif, nolabel
keep countryname year classif avg_hourly_earnings
reshape wide avg_hourly_earnings, i(countryname year) j(classif) 

* rename variables
rename avg_hourly_earnings1 avg_hourly_earnings_15_24
rename avg_hourly_earnings2 avg_hourly_earnings_25_54 
rename avg_hourly_earnings3 avg_hourly_earnings_55_64 
rename avg_hourly_earnings4 avg_hourly_earnings_65_plus 
rename avg_hourly_earnings5 avg_hourly_earnings_total 
rename avg_hourly_earnings6 avg_hourly_earnings_15_plus
rename avg_hourly_earnings7 avg_hourly_earnings_15_24_youth 
rename avg_hourly_earnings8 avg_hourly_earnings_25_plus 

*these are duplicative
drop avg_hourly_earnings_15_plus avg_hourly_earnings_15_24_youth

* Check and Address Outliers
*summ *
*browse countryname year avg_hourly_earnings*
tab avg_hourly_earnings_15_24
tab avg_hourly_earnings_25_54 
tab avg_hourly_earnings_total 
tab avg_hourly_earnings_25_plus

foreach var in avg_hourly_earnings_15_24 avg_hourly_earnings_25_54 avg_hourly_earnings_total avg_hourly_earnings_25_plus {
    replace `var' = . if `var' > 50
}
*browse countryname year avg_hourly_earnings_15_24 if avg_hourly_earnings_15_24 > 100 & avg_hourly_earnings_15_24 != .


* save for merging later
save "${clone}/01_inputs/ILO/temp/avg_hourly_earnings_for_merge.dta", replace



*************************************************************************
* Prepare the ILO data for plotting: Inactivity Rate
*************************************************************************
use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\inactivity_rate.dta", clear
rename ref_area_label countryname
rename obs_value inactivity_rate
rename time year
destring year, replace
keep if sex_label == "Total" 
tab classif1_label
encode classif1_label, gen(classif)

tab classif
tab classif, nolabel
keep countryname year classif inactivity_rate
reshape wide inactivity_rate, i(countryname year) j(classif) 

* rename variables
rename inactivity_rate1 inactivity_rate_15_24
rename inactivity_rate2 inactivity_rate_25_54 
rename inactivity_rate3 inactivity_rate_55_64 
rename inactivity_rate4 inactivity_rate_65_plus 
rename inactivity_rate5 inactivity_rate_total 
rename inactivity_rate6 inactivity_rate_15_plus
rename inactivity_rate7 inactivity_rate_15_24_youth  
rename inactivity_rate8 inactivity_rate_15_64 
rename inactivity_rate9 inactivity_rate_25_plus 

*drop these because they are duplicative
drop inactivity_rate_15_plus inactivity_rate_15_24_youth

* save for merging later
save "${clone}/01_inputs/ILO/temp/inactivity_rate_for_merge.dta", replace


*************************************************************************
* Prepare the ILO data for plotting: Youth LFP Rate
*************************************************************************
use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\youth_lfp_rate.dta", clear
rename ref_area_label countryname
rename obs_value youth_lfp_rate
rename time year
destring year, replace
keep if sex_label == "Total" 
tab classif1_label
encode classif1_label, gen(classif)
tab classif2_label 
keep if classif2_label == "Education (Aggregate levels): Total"


tab classif
tab classif, nolabel
keep countryname year classif youth_lfp_rate
reshape wide youth_lfp_rate, i(countryname year) j(classif) 

* rename variables
rename youth_lfp_rate1 youth_lfp_rate_15_24
rename youth_lfp_rate2 youth_lfp_rate_15_29
rename youth_lfp_rate3 youth_lfp_rate_20_24
rename youth_lfp_rate4 youth_lfp_rate_25_29

* save for merging later
save "${clone}/01_inputs/ILO/temp/youth_lfp_rate_for_merge.dta", replace


*************************************************************************
* Prepare the ILO data for plotting: Youth Neet Rate
*************************************************************************

use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\youth_neet_rate.dta", clear
rename ref_area_label countryname
rename obs_value youth_neet_rate
rename time year
destring year, replace
keep if sex_label == "Total" 
tab classif1_label
encode classif1_label, gen(classif)

tab classif
tab classif, nolabel
keep countryname year classif youth_neet_rate
reshape wide youth_neet_rate, i(countryname year) j(classif) 

* rename variables
rename youth_neet_rate1 youth_neet_rate_15_19
rename youth_neet_rate2 youth_neet_rate_20_24
rename youth_neet_rate3 youth_neet_rate_total



* save for merging later
save "${clone}/01_inputs/ILO/temp/youth_neet_rate_for_merge.dta", replace


*************************************************************************
* Prepare the ILO data for plotting: Youth Unemployment Rate
*************************************************************************
use "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\ILO\ilo_data_nov_11_2025\youth_unemployment_rate.dta", clear
rename ref_area_label countryname
rename obs_value youth_unemp_rate
rename time year
destring year, replace
keep if sex_label == "Total" 
keep if classif2_label == "Education (Aggregate levels): Total"
tab classif1_label
encode classif1_label, gen(classif)

tab classif
tab classif, nolabel
keep countryname year classif youth_unemp_rate
reshape wide youth_unemp_rate, i(countryname year) j(classif) 

* rename variables
rename youth_unemp_rate1 youth_unemp_rate_15_19
rename youth_unemp_rate2 youth_unemp_rate_15_29
rename youth_unemp_rate3 youth_unemp_rate_20_24
rename youth_unemp_rate4 youth_unemp_rate_25_29

* save for merging later
save "${clone}/01_inputs/ILO/temp/youth_unemp_rate_for_merge.dta", replace


*************************************************************************
* Merge all the ILO datasets together
*************************************************************************
use "${clone}/01_inputs/ILO/temp/emp_to_pop_ratio_for_merge.dta", clear
merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/child_labor_share_for_merge.dta"
drop _merge

merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/avg_hourly_earnings_for_merge.dta"
drop _merge

merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/inactivity_rate_for_merge.dta"
drop _merge

merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/youth_lfp_rate_for_merge.dta"
drop _merge

merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/youth_neet_rate_for_merge.dta"
drop _merge

merge 1:1 countryname year using "${clone}/01_inputs/ILO/temp/youth_unemp_rate_for_merge.dta"
drop _merge

save "${clone}/01_inputs/ILO/ilo_data_merged.dta", replace



*************************************************************************
* Merge in CountryCode data and then LP data
*************************************************************************

* get countrycode data from DLW
datalibweb_inventory
tempfile dlw 
save `dlw'

* Reload the ILO data
use "${clone}/01_inputs/ILO/ilo_data_merged.dta", clear

* fix the countrynames before merging with DLW
replace countryname = "Bahamas, The" if countryname == "Bahamas"
replace countryname = "Bolivia" if countryname == "Bolivia (Plurinational State of)"
replace countryname = "Congo, Dem. Rep." if countryname == "Congo, Democratic Republic of the"
replace countryname = "Czech Republic" if countryname == "Czechia"
replace countryname = "Côte dIvoire" if countryname == "Côte d'Ivoire"
replace countryname = "Egypt, Arab Rep." if countryname == "Egypt"
replace countryname = "Gambia, The" if countryname == "Gambia"
replace countryname = "Hong Kong SAR, China" if countryname == "Hong Kong, China"
replace countryname = "Iran, Islamic Rep." if countryname == "Iran (Islamic Republic of)"
replace countryname = "Kyrgyz Republic" if countryname == "Kyrgyzstan"
replace countryname = "Lao PDR" if countryname == "Lao People's Democratic Republic"
replace countryname = "Macao SAR, China" if countryname == "Macao, China"
replace countryname = "Micronesia, Fed. Sts." if countryname == "Micronesia (Federated States of)"
replace countryname = "Korea, Rep." if countryname == "Republic of Korea"
replace countryname = "St. Kitts and Nevis" if countryname == "Saint Kitts and Nevis"
replace countryname = "Moldova" if countryname == "Republic of Moldova"
replace countryname = "St. Lucia" if countryname == "Saint Lucia"
replace countryname = "St. Vincent and the Grenadines" if countryname == "Saint Vincent and the Grenadines"
replace countryname = "São Tomé and Principe" if countryname == "Sao Tome and Principe"
replace countryname = "Slovak Republic" if countryname == "Slovakia"
replace countryname = "United Kingdom" if countryname == "United Kingdom of Great Britain and Northern Ireland"
replace countryname = "Venezuela, RB" if countryname == "Venezuela (Bolivarian Republic of)"
replace countryname = "Yemen, Rep." if countryname == "Yemen"
replace countryname = "Congo, Rep." if countryname == "Congo"
replace countryname = "Tanzania" if countryname == "Tanzania, United Republic of"
replace countryname = "United States" if countryname == "United States of America"
*replace countryname = "" if countryname == ""


merge m:1 countryname using `dlw'
drop if _merge != 3
drop _merge region

save "${clone}/01_inputs/ILO/ilo_data_merged_final.dta", replace


* for now, let's not worry about matching cohorts/years
*************************************************************************
* Plots 5: Plots by Region, Combined Plots
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/ILO_vars/reg_results.xlsx", modify sheet(Region_Combined)
    local row= 2

* Begin Loop
foreach var in  child_labor_share_5_11 child_labor_share_5_17 child_labor_share_12_14 child_labor_share_15_17 ///
                youth_neet_rate_15_19 youth_neet_rate_20_24 youth_neet_rate_total ///
                avg_hourly_earnings_15_24 avg_hourly_earnings_25_54 avg_hourly_earnings_total avg_hourly_earnings_25_plus /// 
                emp_to_pop_ratio_15_19  emp_to_pop_ratio_20_24 emp_to_pop_ratio_25_29 emp_to_pop_ratio_total ///
                youth_unemp_rate_15_19 youth_unemp_rate_15_29 youth_unemp_rate_20_24  youth_unemp_rate_25_29 ///
                youth_lfp_rate_15_24 youth_lfp_rate_15_29 youth_lfp_rate_20_24 youth_lfp_rate_25_29 ///    
                inactivity_rate_15_24 inactivity_rate_15_64 inactivity_rate_25_54 inactivity_rate_total inactivity_rate_25_plus  {
    
        *Load in the ILO data
    use "${clone}/01_inputs/ILO/ilo_data_merged_final.dta", clear


    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile ilo_latest
        save `ilo_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `ilo_latest'
        drop if _merge == 2
        
        * Keep observations where the assessment year and UIS variable year are closest
        gen year_diff = abs(year_assessment - year_`var')
        sort countrycode year_diff
        bysort countrycode (year_diff): egen min_year_diff = min(year_diff)
        keep if year_diff == min_year_diff
        drop min_year_diff _merge

        * Now, keep observations where the year of the lpv value is closest to the year of the UIS variable
        gen year_diff_lp = abs(year - year_`var')
        sort countrycode year_diff_lp
        bysort countrycode (year_diff_lp): egen min_year_diff_lp = min(year_diff_lp)
        keep if year_diff_lp == min_year_diff_lp
        drop min_year_diff_lp year_diff year_diff_lp

    * Encode the Region variable so we can use it for plotting
    gen region_num = .
    replace region_num = 1 if region == "ECS"
    replace region_num = 2 if region == "EAS"
    replace region_num = 3 if region == "LCN"
    replace region_num = 4 if region == "MEA"
    replace region_num = 5 if region == "SAS"
    replace region_num = 6 if region == "SSF"
    replace region_num = 7 if region == "NAC"
    label define region_lbl 1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" 7 "NAC"
    label values region_num region_lbl

    * Run regression
    quietly regress lpv_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all if region_num == 1, mlabel(countrycode) mlabcolor(purple) mcolor(purple) msymbol(+) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 2, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Dh) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 4, mlabel(countrycode) mlabcolor(orange) mcolor(orange)  msymbol(Sh) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 5, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(X) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 6, mlabel(countrycode) mlabcolor(red) mcolor(red)  msymbol(Oh) jitter(5)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        , xlabel(0(10)100) title("`var' vs Learning Poverty") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(order(1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" ) rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/regions_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/regions_combined/`var'_vs_lp.png", replace

    * Save Regression Results to Excel
    putexcel A`row' = "`var'"
    putexcel B`row' = `b0'
    putexcel C`row' = `b1'
    putexcel D`row' = `r2'
    putexcel E`row' = `pval'
    putexcel F`row' = `n_countries'
    local row = `row' + 1

    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode region `var' lpv_all year year_`var' year_assessment
    order countrycode region `var' lpv_all year year_`var' year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/regions_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace


}

putexcel save


*************************************************************************
* Plots 6: Plots by Region, Separate Plots
*************************************************************************


* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/ILO_vars/reg_results.xlsx", modify sheet(Region_Separate)
    local row= 2

* Begin Loop
foreach var in  child_labor_share_5_11 child_labor_share_5_17 child_labor_share_12_14 child_labor_share_15_17 ///
                youth_neet_rate_15_19 youth_neet_rate_20_24 youth_neet_rate_total ///
                avg_hourly_earnings_15_24 avg_hourly_earnings_25_54 avg_hourly_earnings_total avg_hourly_earnings_25_plus /// 
                emp_to_pop_ratio_15_19  emp_to_pop_ratio_20_24 emp_to_pop_ratio_25_29 emp_to_pop_ratio_total ///
                youth_unemp_rate_15_19 youth_unemp_rate_15_29 youth_unemp_rate_20_24  youth_unemp_rate_25_29 ///
                youth_lfp_rate_15_24 youth_lfp_rate_15_29 youth_lfp_rate_20_24 youth_lfp_rate_25_29 ///    
                inactivity_rate_15_24 inactivity_rate_15_64 inactivity_rate_25_54 inactivity_rate_total inactivity_rate_25_plus  {
    
    * Additional Loop for Regions
    foreach region in ECS LCN MEA SAS SSF EAS  {

    * Load in the ILO data
    use "${clone}/01_inputs/ILO/ilo_data_merged_final.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile ilo_latest
        save `ilo_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if region == "`region'"

        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `ilo_latest'
        drop if _merge == 2
        
        * Keep observations where the assessment year and UIS variable year are closest
        gen year_diff = abs(year_assessment - year_`var')
        sort countrycode year_diff
        bysort countrycode (year_diff): egen min_year_diff = min(year_diff)
        keep if year_diff == min_year_diff
        drop min_year_diff _merge

        * Now, keep observations where the year of the lpv value is closest to the year of the UIS variable
        gen year_diff_lp = abs(year - year_`var')
        sort countrycode year_diff_lp
        bysort countrycode (year_diff_lp): egen min_year_diff_lp = min(year_diff_lp)
        keep if year_diff_lp == min_year_diff_lp
        drop min_year_diff_lp year_diff year_diff_lp

    * Check if there are any observations; skip region-var combo if none
    count if !missing(`var') & !missing(lpv_all)
    if r(N) < 3 continue

    * Run regression
    quietly regress lpv_all `var' 
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all, mlabel(countrycode) mlabcolor(black) mcolor(black) msymbol(Oh) jitter(3)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(gray%75) lwidth(thin)) ///
        , xlabel(0(10)100) title("`var' vs Learning Poverty - `region'" ) ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        graphregion(color(white)) ///
        legend(off) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/regions_separate/`var'_vs_lp_`region'.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/regions_separate/`var'_vs_lp_`region'.png", replace

    * Save Regression Results to Excel
    putexcel A`row' = "`var'"
    putexcel B`row' = "`region'"
    putexcel C`row' = `b0'
    putexcel D`row' = `b1'
    putexcel E`row' = `r2'
    putexcel F`row' = `pval'
    putexcel G`row' = `n_countries'
    local row = `row' + 1

    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode region `var' lpv_all year year_`var' year_assessment
    order countrycode region `var' lpv_all year year_`var' year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/regions_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace
}
                }

putexcel save


*************************************************************************
* Plots 7: Plots by Income, Combined Plots
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/ILO_vars/reg_results.xlsx", modify sheet(Income_Combined)
    local row= 2

* Begin Loop
foreach var in  child_labor_share_5_11 child_labor_share_5_17 child_labor_share_12_14 child_labor_share_15_17 ///
                youth_neet_rate_15_19 youth_neet_rate_20_24 youth_neet_rate_total ///
                avg_hourly_earnings_15_24 avg_hourly_earnings_25_54 avg_hourly_earnings_total avg_hourly_earnings_25_plus /// 
                emp_to_pop_ratio_15_19  emp_to_pop_ratio_20_24 emp_to_pop_ratio_25_29 emp_to_pop_ratio_total ///
                youth_unemp_rate_15_19 youth_unemp_rate_15_29 youth_unemp_rate_20_24  youth_unemp_rate_25_29 ///
                youth_lfp_rate_15_24 youth_lfp_rate_15_29 youth_lfp_rate_20_24 youth_lfp_rate_25_29 ///    
                inactivity_rate_15_24 inactivity_rate_15_64 inactivity_rate_25_54 inactivity_rate_total inactivity_rate_25_plus  {
    
        *Load in the ILO data
    use "${clone}/01_inputs/ILO/ilo_data_merged_final.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile ilo_latest
        save `ilo_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `ilo_latest'
        drop if _merge == 2
        
        * Keep observations where the assessment year and UIS variable year are closest
        gen year_diff = abs(year_assessment - year_`var')
        sort countrycode year_diff
        bysort countrycode (year_diff): egen min_year_diff = min(year_diff)
        keep if year_diff == min_year_diff
        drop min_year_diff _merge

        * Now, keep observations where the year of the lpv value is closest to the year of the UIS variable
        gen year_diff_lp = abs(year - year_`var')
        sort countrycode year_diff_lp
        bysort countrycode (year_diff_lp): egen min_year_diff_lp = min(year_diff_lp)
        keep if year_diff_lp == min_year_diff_lp
        drop min_year_diff_lp year_diff year_diff_lp

    * Encode the Income variable so we can use it for plotting
    gen incomelevel_num = .
    replace incomelevel_num = 1 if incomelevel == "LIC"
    replace incomelevel_num = 2 if incomelevel == "LMC"
    replace incomelevel_num = 3 if incomelevel == "UMC"
    replace incomelevel_num = 4 if incomelevel == "HIC"
    replace incomelevel_num = 5 if incomelevel == "INX"
    label define incomelevel_lbl 1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC" 5 "INX" 
    label values incomelevel_num incomelevel_lbl

    * Run regression
    quietly regress lpv_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all if incomelevel_num == 1, mlabel(countrycode) mlabcolor(red) mcolor(red) msymbol(Oh) jitter(5)) ///
        (scatter `var' lpv_all if incomelevel_num == 2, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(Dh) jitter(5)) ///
        (scatter `var' lpv_all if incomelevel_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' lpv_all if incomelevel_num == 4, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Sh) jitter(5)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        ,  xlabel(0(10)100) title("`var' vs Learning Poverty") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(order(1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC") rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/income_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/income_combined/`var'_vs_lp.png", replace

    * Save Regression Results to Excel
    putexcel A`row' = "`var'"
    putexcel B`row' = `b0'
    putexcel C`row' = `b1'
    putexcel D`row' = `r2'
    putexcel E`row' = `pval'
    putexcel F`row' = `n_countries'
    local row = `row' + 1

    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode incomelevel `var' lpv_all year year_`var' year_assessment
    order countrycode incomelevel `var' lpv_all year year_`var' year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/income_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}

putexcel save




*************************************************************************
* Plots 8: Plots by Income, Separate Plots
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/ILO_vars/reg_results.xlsx", modify sheet(Income_Separate)
    local row=2

* Begin Loop
foreach var in  child_labor_share_5_11 child_labor_share_5_17 child_labor_share_12_14 child_labor_share_15_17 ///
                youth_neet_rate_15_19 youth_neet_rate_20_24 youth_neet_rate_total ///
                avg_hourly_earnings_15_24 avg_hourly_earnings_25_54 avg_hourly_earnings_total avg_hourly_earnings_25_plus /// 
                emp_to_pop_ratio_15_19  emp_to_pop_ratio_20_24 emp_to_pop_ratio_25_29 emp_to_pop_ratio_total ///
                youth_unemp_rate_15_19 youth_unemp_rate_15_29 youth_unemp_rate_20_24  youth_unemp_rate_25_29 ///
                youth_lfp_rate_15_24 youth_lfp_rate_15_29 youth_lfp_rate_20_24 youth_lfp_rate_25_29 ///    
                inactivity_rate_15_24 inactivity_rate_15_64 inactivity_rate_25_54 inactivity_rate_total inactivity_rate_25_plus  {

    foreach income in HIC LIC LMC UMC {

    *Load in the ILO data
    use "${clone}/01_inputs/ILO/ilo_data_merged_final.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile ilo_latest
        save `ilo_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if incomelevel == "`income'"
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `ilo_latest'
        drop if _merge == 2
        
        * Keep observations where the assessment year and UIS variable year are closest
        gen year_diff = abs(year_assessment - year_`var')
        sort countrycode year_diff
        bysort countrycode (year_diff): egen min_year_diff = min(year_diff)
        keep if year_diff == min_year_diff
        drop min_year_diff _merge

        * Now, keep observations where the year of the lpv value is closest to the year of the UIS variable
        gen year_diff_lp = abs(year - year_`var')
        sort countrycode year_diff_lp
        bysort countrycode (year_diff_lp): egen min_year_diff_lp = min(year_diff_lp)
        keep if year_diff_lp == min_year_diff_lp
        drop min_year_diff_lp year_diff year_diff_lp

    * Check if there are any observations; skip region-var combo if none
    count if !missing(`var') & !missing(lpv_all)
    if r(N) < 3 continue

    * Run regression
    quietly regress lpv_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all, mlabel(countrycode) mlabcolor(black) mcolor(black) msymbol(Oh) jitter(5)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(gray%75) lwidth(thin)) ///
        ,  xlabel(0(10)100) title("`var' vs Learning Poverty - `income'") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(off) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/income_separate/`var'_vs_lp_`income'.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/income_separate/`var'_vs_lp_`income'.png", replace

    * Save Regression Results to Excel
    putexcel A`row' = "`var'"
    putexcel B`row' = "`income'"
    putexcel C`row' = `b0'
    putexcel D`row' = `b1'
    putexcel E`row' = `r2'
    putexcel F`row' = `pval'
    putexcel G`row' = `n_countries'
    local row = `row' + 1

    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds


    * Save a table of the data to excel
    keep countrycode incomelevel `var' lpv_all year year_`var' year_assessment
    order countrycode incomelevel `var' lpv_all year year_`var' year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/income_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}
                }

putexcel save







*************************************************************************
* Compare LP to the Labor Inputs of the HCI
*************************************************************************

* Note: the HCI component is confidential until the HCI is officially released, so I am keeping the file on my personal drive for now
* For now, we want to match the 2025 LP data to the 2025 HCI Component data


foreach var in youth_score_mf_2025 work_score_mf_2025 hcip_work_component_mf_2025 ///
               lfp_ya_mf_2025 emp_ya_mf_2025 shr_wemp_ya_mf_2025 lfp_wa_mf_2025 emp_wa_mf_2025 shr_wemp_wa_mf_2025 {

*Load the LP data to start
use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM (the latest release)
        keep if preference == "1402"
        
        rename countrycode wbcode

        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 wbcode using "C:\Users\wb633382\OneDrive - WBG\Desktop\hcip_workcomponent.dta"
        drop if _merge == 2
        rename wbcode countrycode

    * Encode the Region variable so we can use it for plotting
    gen region_num = .
    replace region_num = 1 if region == "ECS"
    replace region_num = 2 if region == "EAS"
    replace region_num = 3 if region == "LCN"
    replace region_num = 4 if region == "MEA"
    replace region_num = 5 if region == "SAS"
    replace region_num = 6 if region == "SSF"
    replace region_num = 7 if region == "NAC"
    label define region_lbl 1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" 7 "NAC"
    label values region_num region_lbl

    * Run regression
    quietly regress lpv_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all if region_num == 1, mlabel(countrycode) mlabcolor(purple) mcolor(purple) msymbol(+) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 2, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Dh) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 4, mlabel(countrycode) mlabcolor(orange) mcolor(orange)  msymbol(Sh) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 5, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(X) jitter(5)) ///
        (scatter `var' lpv_all if region_num == 6, mlabel(countrycode) mlabcolor(red) mcolor(red)  msymbol(Oh) jitter(5)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        , xlabel(0(10)100) title("`var' vs Learning Poverty") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(order(1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" ) rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/regions_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/regions_combined/`var'_vs_lp.png", replace


    * Save a table of the data to excel
    keep countrycode region `var' lpv_all year
    order countrycode region `var' lpv_all year
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/regions_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}







*************************************************************************
* LP to the Labor Inputs of the HCI, Income Separate Plots
*************************************************************************

* Begin Loop
foreach var in youth_score_mf_2025 work_score_mf_2025 hcip_work_component_mf_2025 ///
               lfp_ya_mf_2025 emp_ya_mf_2025 shr_wemp_ya_mf_2025 lfp_wa_mf_2025 emp_wa_mf_2025 shr_wemp_wa_mf_2025 {

    foreach income in HIC LIC LMC UMC {

*Load the LP data to start
use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if incomelevel == "`income'"

        *keep only preferences with GEM (the latest release)
        keep if preference == "1402"
        
        rename countrycode wbcode

        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 wbcode using "C:\Users\wb633382\OneDrive - WBG\Desktop\hcip_workcomponent.dta"
        drop if _merge == 2
        rename wbcode countrycode

    * Check if there are any observations; skip region-var combo if none
    count if !missing(`var') & !missing(lpv_all)
    if r(N) < 3 continue

    * Run regression
    quietly regress lpv_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all, mlabel(countrycode) mlabcolor(black) mcolor(black) msymbol(Oh) jitter(5)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(gray%75) lwidth(thin)) ///
        ,  xlabel(0(10)100) title("`var' vs Learning Poverty - `income'") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(off) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/income_separate/`var'_vs_lp_`income'.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/income_separate/`var'_vs_lp_`income'.png", replace


    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode incomelevel `var' lpv_all year year_assessment
    order countrycode incomelevel `var' lpv_all year year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/income_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}
                }






*************************************************************************
* LP vs. Labor HCI Components: Plots by Region, Separate Plots
*************************************************************************

* Begin Loop
foreach var in youth_score_mf_2025 work_score_mf_2025 hcip_work_component_mf_2025 ///
               lfp_ya_mf_2025 emp_ya_mf_2025 shr_wemp_ya_mf_2025 lfp_wa_mf_2025 emp_wa_mf_2025 shr_wemp_wa_mf_2025 {

    foreach region in ECS LCN MEA SAS SSF EAS {

*Load the LP data to start
use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if region == "`region'"

        *keep only preferences with GEM (the latest release)
        keep if preference == "1402"
        
        rename countrycode wbcode

        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 wbcode using "C:\Users\wb633382\OneDrive - WBG\Desktop\hcip_workcomponent.dta"
        drop if _merge == 2
        rename wbcode countrycode

    * Check if there are any observations; skip region-var combo if none
    count if !missing(`var') & !missing(lpv_all)
    if r(N) < 3 continue

    * Run regression
    quietly regress lpv_all `var' 
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' lpv_all, mlabel(countrycode) mlabcolor(black) mcolor(black) msymbol(Oh) jitter(3)) ///
        (lfit `var' lpv_all, lpattern(dash) lcolor(gray%75) lwidth(thin)) ///
        , xlabel(0(10)100) title("`var' vs Learning Poverty - `region'" ) ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        graphregion(color(white)) ///
        legend(off) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/ILO_vars/regions_separate/`var'_vs_lp_`region'.gph", replace)
        graph export "${clone}/03_outputs/Figures/ILO_vars/regions_separate/`var'_vs_lp_`region'.png", replace


    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode region `var' lpv_all year year_assessment
    order countrycode region `var' lpv_all year year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/ILO_vars/regions_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace
}
                }




