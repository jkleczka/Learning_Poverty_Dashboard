

*************************************************************************
* Plot : LAYS vs LP and LD, Regions
*************************************************************************

* Begin Loop
foreach var in eys_mf eys_pp_mf hlo_mf lays_mf ter_ya_mf /// education inputs
               lfp_ya_mf emp_ya_mf shr_wemp_ya_mf lfp_wa_mf emp_wa_mf shr_wemp_wa_mf /// labor inputs
               hcip_mf hcip_health_component_mf hcip_schooling_component_mf hcip_work_component_mf /// HCI vars
               {
    foreach var2 in lpv_all ld_all sd_all {
    
    *Load in the merged data
    use "${clone}/01_inputs/LAYS/official_hci_feb_2026.dta",  clear
    keep if year == 2025
    rename wbcode countrycode

    merge m:1 countrycode using "${clone}/03_outputs/Clean/lpv_panel_1402.dta"
    keep if _merge == 3
    drop _merge

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
    quietly regress `var2' `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' `var2' if region_num == 1, mlabel(countrycode) mlabcolor(purple) mcolor(purple) msymbol(+) jitter(5)) ///
        (scatter `var' `var2' if region_num == 2, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Dh) jitter(5)) ///
        (scatter `var' `var2' if region_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' `var2' if region_num == 4, mlabel(countrycode) mlabcolor(orange) mcolor(orange)  msymbol(Sh) jitter(5)) ///
        (scatter `var' `var2' if region_num == 5, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(X) jitter(5)) ///
        (scatter `var' `var2' if region_num == 6, mlabel(countrycode) mlabcolor(red) mcolor(red)  msymbol(Oh) jitter(5)) ///
        (lfit `var' `var2', lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        , title("`var' vs `var2'") ///
        ytitle("`var'") xtitle("`var2'") ///
        legend(order(1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" ) rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/LAYS_vars/regions_combined/`var'_vs_`var2'.gph", replace)
        graph export "${clone}/03_outputs/Figures/LAYS_vars/regions_combined/`var'_vs_`var2'.png", replace


    * Save a table of the data to excel
    keep countrycode region `var' `var2' year
    order countrycode region `var' `var2' year
    export excel using "${clone}/03_outputs/Tables/LAYS_vars/regions_combined/`var'_vs_`var2'_data.xlsx", firstrow(variables) replace

}
}
