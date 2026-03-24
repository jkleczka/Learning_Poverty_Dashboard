*************************************************************************
* LOAD THE UIS DATA
*************************************************************************

* Load UIS data downloaded Oct 25, 2025
    import delimited using "${network}\GDB\Projects\WLD_2025_FGT-CLO\input_data_for_figures\UIS\UIS_data_downloaded_10.25.2025\SDG\SDG_DATA_NATIONAL.csv", clear
    drop magnitude qualifier // JK: I don't think we need these

* Keep relevant variables
    keep if indicator_id == "LR.AG15T24" | indicator_id == "LR.AG15T24.M" | indicator_id == "LR.AG15T24.F" | /// youth literacy rate, age 15-24 
        indicator_id == "LR.AG15T99" | indicator_id == "LR.AG15T99.M" | indicator_id == "LR.AG15T99.F" | /// adult literacy rate, age 15+
        indicator_id == "LR.AG25T64" | indicator_id == "LR.AG25T64.M" | indicator_id == "LR.AG25T64.F" | /// literacy rate, age 25-64
        indicator_id == "LR.AG65T99" | indicator_id == "LR.AG65T99.M" | indicator_id == "LR.AG65T99.F" | /// elderly literacy rate, age 65+
        indicator_id == "LR.GALP.AG15T24" | indicator_id == "LR.GALP.AG15T24.M" | indicator_id == "LR.GALP.AG15T24.F" | /// youth literacy rate, 15-24 using GALP
        indicator_id == "LR.GALP.AG15T99" | indicator_id == "LR.GALP.AG15T99.M" | indicator_id == "LR.GALP.AG15T99.F" | /// adult literacy rate using GALP
        indicator_id == "LR.GALP.AG25T64" | indicator_id == "LR.GALP.AG25T64.M" | indicator_id == "LR.GALP.AG25T64.F" | /// literacy rate 25-64 using GALP 
        indicator_id == "LR.GALP.AG65T99" | indicator_id == "LR.GALP.AG65T99.M" | indicator_id == "LR.GALP.AG65T99.F" | /// elderly literacy rate using GALP 
        indicator_id == "YADULT.PROFILITERACY" | indicator_id == "YADULT.PROFILITERACY.M" | indicator_id == "YADULT.PROFILITERACY.F" | /// Proportion of pop achieving proficiency in literarcy YADULT.PROFILITERACY
        indicator_id == "TRTP.1" | indicator_id == "TRTP.1.M" | indicator_id == "TRTP.1.F" | /// Proportion of teachers with the minimum required qualifications in primary education
        indicator_id == "PTRHC.1.TRAINED" | /// Pupil-trained teacher ratio in primary ed (headcount basis)
        indicator_id == "PTRHC.1.QUALIFIED" | /// Pupil-qualified teacher ratio in primary education (headcount basis)
        indicator_id == "QUTP.1" | indicator_id == "QUTP.1.M" | indicator_id == "QUTP.1.F" | /// % of Qualified teachers in Primary ed
        indicator_id == "TSALARY.1" | /// Average teacher salary relative to other professions requiring a similar level of qualification
        indicator_id == "TATTRR.1" | indicator_id == "TATTRR.1.M" | indicator_id == "TATTRR.1.F" | /// Teacher Attrition rate from primary education
        indicator_id == "TPROFD.1" | indicator_id == "TPROFD.1.M" | indicator_id == "TPROFD.1.F" | /// Percentage of Teachers in Primary Ed who received in service training in the last 12 months
        indicator_id == "XGDP.FSGOV" | /// Government expenditure on education as % of GDP
        indicator_id == "XGOVEXP.IMF" | /// Expenditure on education as % of total gov expenditure
        indicator_id == "PREPFUTURE.1.READ" | /// Proportion of children/young people at primary age prepared for the future in reading
        indicator_id == "PREPFUTURE.2.READ" | /// Proportion of children/young people at lower secondary age prepared for the future in reading
        indicator_id == "READ.G2" | indicator_id == "READ.G2.M" |  indicator_id == "READ.G2.F" | /// Proportion of grade 2 students at or above minimum proficiency level in reading
        indicator_id == "READ.G3" | indicator_id == "READ.G3.M" | indicator_id == "READ.G3.F" | /// Proportion of grade 3 students at or above minimum proficiency level in reading
        indicator_id == "READ.LOWERSEC" | indicator_id == "READ.LOWERSEC.M" | indicator_id == "READ.LOWERSEC.F" | /// Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in reading, both
        indicator_id == "XUNIT.GDPCAP.1.FSHH.FFNTR" | /// Initial household funding per primary student as a percentage of GDP per capita
        indicator_id == "XUNIT.GDPCAP.1.FSGOV.FFNTR" | /// Initial government funding per primary student as a percentage of GDP per capita
        indicator_id == "XUNIT.PPPCONST.1.FSGOV.FFNTR" | /// Initial government funding per primary student, constant PPP$
        indicator_id == "XUNIT.PPPCONST.1.FSHH.FFNTR" | /// Initial household funding per primary student, constant PPP$
        indicator_id == "SCHBSP.1.WELEC" | /// Proportion of primary schools with access to electricity (%)
        indicator_id == "SCHBSP.1.WINTERN" | /// Proportion of primary schools with access to Internet for pedagogical purposes (%)
        indicator_id == "SCHBSP.1.WCOMPUT" | /// Proportion of primary schools with access to computers for pedagogical purposes (%)
        indicator_id == "SCHBSP.1.WWATA" | /// Proportion of primary schools with basic drinking water (%)
        indicator_id == "SCHBSP.1.WTOILA" | /// Proportion of primary schools with single-sex basic sanitation facilities (%)
        indicator_id == "SCHBSP.1.WWASH"  | /// Proportion of primary schools with basic handwashing facilities (%)
        indicator_id == "MATH.G2" | indicator_id == "MATH.G2.M" | indicator_id == "MATH.G2.F" | /// Proportion of students at the end of Grade 2 achieving at least a minimum proficiency level in mathematics,(%) 
        indicator_id == "MATH.G3" | indicator_id == "MATH.G3.M" | indicator_id == "MATH.G3.F" |  /// Proportion of students at the end of Grade 3 achieving at least a minimum proficiency level in mathematics,(%) 
        indicator_id == "MATH.PRIMARY" | indicator_id == "MATH.PRIMARY.M" | indicator_id == "MATH.PRIMARY.F" |  /// Proportion of students at the end of primary education achieving at least a minimum proficiency level in mathematics,(%)
        indicator_id == "MATH.LOWERSEC" | indicator_id == "MATH.LOWERSEC.M" | indicator_id == "MATH.LOWERSEC.F" | /// Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in mathematics, (%)       
        indicator_id == "CR.1" |  indicator_id == "CR.1.M" |  indicator_id == "CR.1.F" | /// Completion rate, primary education, (%)
        indicator_id == "CR.2" |  indicator_id == "CR.2.M" |  indicator_id == "CR.2.F" |  /// Completion rate, lower secondary education, (%)
        indicator_id == "CR.MOD.1" |  indicator_id == "CR.MOD.1.M" |  indicator_id == "CR.MOD.1.F" |  /// Completion rate, primary education, (modelled data) (%)
        indicator_id == "CR.MOD.2" |  indicator_id == "CR.MOD.2.M" |  indicator_id == "CR.MOD.2.F" | /// Completion rate, lower secondary education,  (modelled data) (%)
        indicator_id == "PREPFUTURE.1.MATH" |  indicator_id == "PREPFUTURE.1.MATH.M" |  indicator_id == "PREPFUTURE.1.MATH.F" |  /// Proportion of children/young people at the age of primary education prepared for the future in mathematics, (%)
        indicator_id == "PREPFUTURE.2.MATH" |  indicator_id == "PREPFUTURE.2.MATH.M" |  indicator_id == "PREPFUTURE.2.MATH.F" |  /// Proportion of children/young people at the age of lower secondary education prepared for the future in mathematics, (%)
        indicator_id == "READ.PRIMARY" |  indicator_id == "READ.PRIMARY.M" |  indicator_id == "READ.PRIMARY.F" | /// Proportion of students at the end of primary education achieving at least a minimum proficiency level in reading, (%)
        indicator_id == "YEARS.FC.FREE.1T3" |  /// Number of years of free primary and secondary education guaranteed in legal frameworks
        indicator_id == "YEARS.FC.COMP.1T3" |  /// Number of years of compulsory primary and secondary education guaranteed in legal frameworks
        indicator_id == "ONTRACK.THREE.DOMAINS" | indicator_id == "ONTRACK.THREE.DOMAINS.M" | indicator_id == "ONTRACK.THREE.DOMAINS.F" |  /// Proportion of children aged 24-59 months who are developmentally on track in health, learning and psychosocial well-being, (%)
        indicator_id == "NERA.AGM1.CP" | indicator_id == "NERA.AGM1.M.CP" | indicator_id == "NERA.AGM1.F.CP" |  /// Adjusted net enrolment rate, one year before the official primary entry age, (%)
        indicator_id == "NARA.AGM1" | indicator_id == "NARA.AGM1.M" | indicator_id == "NARA.AGM1.F" |  /// Adjusted net attendance rate, one year before the official primary entry age, (%)
        indicator_id == "POSTIMUENV" | indicator_id == "POSTIMUENV.M" | indicator_id == "POSTIMUENV.F" |  /// Percentage of children under 5 years experiencing positive and stimulating home learning environments, (%)
        indicator_id == "NER.0.CP" | indicator_id == "NER.0.M.CP" | indicator_id == "NER.0.F.CP" |  /// Net enrolment rate, early childhood education, (%)
        indicator_id == "NER.01.CP" | indicator_id == "NER.01.M.CP" | indicator_id == "NER.01.F.CP" |  /// Net enrolment rate, early childhood educational development programmes, (%)
        indicator_id == "NER.02.CP" | indicator_id == "NER.02.M.CP" | indicator_id == "NER.02.F.CP" |  /// Net enrolment rate, pre-primary, (%)
        indicator_id == "YEARS.FC.FREE.02" |  /// Number of years of free pre-primary education guaranteed in legal frameworks
        indicator_id == "YEARS.FC.COMP.02" | /// Number of years of compulsory pre-primary education guaranteed in legal frameworks
        indicator_id == "GER.5T8" | indicator_id == "GER.5T8.M" | indicator_id == "GER.5T8.F" |  /// Gross enrolment ratio for tertiary education, (%)
        indicator_id == "GAR.5T8" | indicator_id == "GAR.5T8.M" | indicator_id == "GAR.5T8.F" |  /// Gross attendance ratio for tertiary education,  (%)
        indicator_id == "EV1524P.2T5.V" | indicator_id == "EV1524P.2T5.V.M" | indicator_id == "EV1524P.2T5.V.F" |  /// Proportion of 15- to 24-year-olds enrolled in vocational education, (%)
        indicator_id == "EA.5T8.AG25T99" | indicator_id == "EA.5T8.AG25T99.M" | indicator_id == "EA.5T8.AG25T99.F" // Educational attainment rate, completed short-cycle tertiary education or higher, population 25+ years,  (%)
        *indicator_id == "" | indicator_id == "" | indicator_id == "" |  ///


* Rename indicators because otherwise they create invalid names in the reshape step
    replace indicator_id = "lit_rate_youth" if indicator_id == "LR.AG15T24" // Youth literacy rate, population 15-24 years, both sexes (%)
    replace indicator_id = "lit_rate_youth_m" if indicator_id == "LR.AG15T24.M" // Youth literacy rate, population 15-24 years, male (%)
    replace indicator_id = "lit_rate_youth_f" if indicator_id == "LR.AG15T24.F" // Youth literacy rate, population 15-24 years, female (%)

    replace indicator_id = "lit_rate_adult" if indicator_id == "LR.AG15T99" // Adult literacy rate, population 15+ years, both sexes (%)
    replace indicator_id = "lit_rate_adult_m" if indicator_id == "LR.AG15T99.M" // Adult literacy rate, population 15+ years, male (%)
    replace indicator_id = "lit_rate_adult_f" if indicator_id == "LR.AG15T99.F" // Adult literacy rate, population 15+ years, female (%)

    replace indicator_id = "lit_rate" if indicator_id == "LR.AG25T64" // Literacy rate, population 25-64 years, both sexes (%)
    replace indicator_id = "lit_rate_m" if indicator_id == "LR.AG25T64.M" // Literacy rate, population 25-64 years, male (%)
    replace indicator_id = "lit_rate_f" if indicator_id == "LR.AG25T64.F"  // Literacy rate, population 25-64 years, female (%)

    replace indicator_id = "lit_rate_elderly" if indicator_id == "LR.AG65T99" // Elderly literacy rate, population 65+ years, both sexes (%)
    replace indicator_id = "lit_rate_elderly_m" if indicator_id == "LR.AG65T99.M" // Elderly literacy rate, population 65+ years, male (%)
    replace indicator_id = "lit_rate_elderly_f" if indicator_id == "LR.AG65T99.F" // Elderly literacy rate, population 65+ years, female (%)

    replace indicator_id = "lit_rate_youth_galp" if indicator_id == "LR.GALP.AG15T24" // Youth literacy rate, population 15-24 years, both sexes (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_youth_galp_m" if indicator_id == "LR.GALP.AG15T24.M" // Youth literacy rate, population 15-24 years, male (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_youth_galp_f" if indicator_id == "LR.GALP.AG15T24.F" // Youth literacy rate, population 15-24 years, female (estimate using the Global Age-Specific Literacy Projections Model) (%)

    replace indicator_id = "lit_rate_adult_galp" if indicator_id == "LR.GALP.AG15T99" // Adult literacy rate, population 15+ years, both sexes (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_adult_galp_m" if indicator_id == "LR.GALP.AG15T99.M" // Adult literacy rate, population 15+ years, male (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_adult_galp_f" if indicator_id == "LR.GALP.AG15T99.F" // Adult literacy rate, population 15+ years, female (estimate using the Global Age-Specific Literacy Projections Model) (%)

    replace indicator_id = "lit_rate_galp" if indicator_id == "LR.GALP.AG25T64" // Literacy rate, population 25-64 years, both sexes (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_galp_m" if indicator_id == "LR.GALP.AG25T64.M" // Literacy rate, population 25-64 years, male (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_galp_f" if indicator_id == "LR.GALP.AG25T64.F" // Literacy rate, population 25-64 years, female (estimate using the Global Age-Specific Literacy Projections Model) (%)

    replace indicator_id = "lit_rate_elderly_galp" if indicator_id == "LR.GALP.AG65T99" // Elderly literacy rate, population 65+ years, both sexes (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_elderly_galp_m" if indicator_id == "LR.GALP.AG65T99.M" // Elderly literacy rate, population 65+ years, male (estimate using the Global Age-Specific Literacy Projections Model) (%)
    replace indicator_id = "lit_rate_elderly_galp_f" if indicator_id == "LR.GALP.AG65T99.F" // Elderly literacy rate, population 65+ years, female (estimate using the Global Age-Specific Literacy Projections Model) (%)

    replace indicator_id = "lit_proficiency_rate" if indicator_id == "YADULT.PROFILITERACY" // Proportion of population achieving at least a fixed level of proficiency in functional literacy skills, both sexes (%)
    replace indicator_id = "lit_proficiency_rate_m" if indicator_id == "YADULT.PROFILITERACY.M" // Proportion of population achieving at least a fixed level of proficiency in functional literacy skills, male (%)
    replace indicator_id = "lit_proficiency_rate_f" if indicator_id == "YADULT.PROFILITERACY.F" // Proportion of population achieving at least a fixed level of proficiency in functional literacy skills, female (%)

    replace indicator_id = "prop_teach_min_qual" if indicator_id == "TRTP.1" // Proportion of teachers with the minimum required qualifications in primary education, both sexes (%)
    replace indicator_id = "prop_teach_min_qual_m" if indicator_id == "TRTP.1.M" // Proportion of teachers with the minimum required qualifications in primary education, male (%)
    replace indicator_id = "prop_teach_min_qual_f" if indicator_id == "TRTP.1.F" // Proportion of teachers with the minimum required qualifications in primary education, female (%)

    replace indicator_id = "teach_trained_ratio_primary" if indicator_id == "PTRHC.1.TRAINED" // Pupil-trained teacher ratio in primary education (headcount basis)
    replace indicator_id = "teach_qualed_ratio_primary" if indicator_id == "PTRHC.1.QUALIFIED" // Pupil-qualified teacher ratio in primary education (headcount basis)

    replace indicator_id = "teacher_qual_primary" if indicator_id == "QUTP.1" // Percentage of qualified teachers in primary education, both sexes (%)
    replace indicator_id = "teacher_qual_primary_m" if indicator_id == "QUTP.1.M" // Percentage of qualified teachers in primary education, male (%)
    replace indicator_id = "teacher_qual_primary_f" if indicator_id == "QUTP.1.F" // Percentage of qualified teachers in primary education, female (%)

    replace indicator_id = "teacher_salary_primary" if indicator_id == "TSALARY.1" // Average teacher salary in primary education relative to other professions requiring a comparable level of qualification, both sexes

    replace indicator_id = "teacher_attrition_primary" if indicator_id == "TATTRR.1" // Teacher attrition rate from primary education, both sexes (%)
    replace indicator_id = "teacher_attrition_primary_m" if indicator_id == "TATTRR.1.M" // Teacher attrition rate from primary education, male (%)
    replace indicator_id = "teacher_attrition_primary_f" if indicator_id == "TATTRR.1.F" // Teacher attrition rate from primary education, female (%)

    replace indicator_id = "teacher_training_primary" if indicator_id == "TPROFD.1" // Percentage of teachers in primary education who received in-service training in the last 12 months by type of training, both sexes
    replace indicator_id = "teacher_training_primary_m" if indicator_id == "TPROFD.1.M" // Percentage of teachers in primary education who received in-service training in the last 12 months by type of training, male
    replace indicator_id = "teacher_training_primary_f" if indicator_id == "TPROFD.1.F" // Percentage of teachers in primary education who received in-service training in the last 12 months by type of training, female

    replace indicator_id = "gov_expend_percent_gdp" if indicator_id == "XGDP.FSGOV" // Government expenditure on education as % of GDP
    replace indicator_id = "edu_expend_percent_total" if indicator_id == "XGOVEXP.IMF" // Expenditure on education as % of total gov expenditure

    replace indicator_id = "prep_future_prim_read" if indicator_id == "PREPFUTURE.1.READ" // Proportion of children/young people at primary age prepared for the future in reading
    replace indicator_id = "prep_future_prim_read_m" if indicator_id == "PREPFUTURE.1.READ.M" // Proportion of children/young people at primary age prepared for the future in reading, male
    replace indicator_id = "prep_future_prim_read_f" if indicator_id == "PREPFUTURE.1.READ.F" // Proportion of children/young people at primary age prepared for the future in reading, female

    replace indicator_id = "prep_future_lowsec_read" if indicator_id == "PREPFUTURE.2.READ" // Proportion of children/young people at lower secondary age prepared for the future in reading
    replace indicator_id = "prep_future_lowsec_read_m" if indicator_id == "PREPFUTURE.2.READ.M" // Proportion of children/young people at lower secondary age prepared for the future in reading, male
    replace indicator_id = "prep_future_lowsec_read_f" if indicator_id == "PREPFUTURE.2.READ.F" // Proportion of children/young people at lower secondary age prepared for the future in reading, female

    replace indicator_id = "sdg_411a_grade2_read" if indicator_id == "READ.G2" // Proportion of grade 2 students at or above minimum proficiency level in reading
    replace indicator_id = "sdg_411a_grade2_read_m" if indicator_id == "READ.G2.M" // Proportion of grade 2 students at or above minimum proficiency level in reading, male
    replace indicator_id = "sdg_411a_grade2_read_f" if indicator_id == "READ.G2.F" // Proportion of grade 2 students at or above minimum proficiency level in reading, female

    replace indicator_id = "sdg_411a_grade3_read" if indicator_id == "READ.G3" // Proportion of grade 3 students at or above minimum proficiency level in reading
    replace indicator_id = "sdg_411a_grade3_read_m" if indicator_id == "READ.G3.M" // Proportion of grade 3 students at or above minimum proficiency level in reading
    replace indicator_id = "sdg_411a_grade3_read_f" if indicator_id == "READ.G3.F" // Proportion of grade 3 students at or above minimum proficiency level in reading

    replace indicator_id = "sdg_411c_lowersec_read" if indicator_id == "READ.LOWERSEC"  // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in reading, both
    replace indicator_id = "sdg_411c_lowersec_read_m" if indicator_id == "READ.LOWERSEC.M"  // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in reading, male
    replace indicator_id = "sdg_411c_lowersec_read_f" if indicator_id == "READ.LOWERSEC.F"  // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in reading, female

    replace indicator_id = "hh_fund_per_stud_prim_gdp" if indicator_id == "XUNIT.GDPCAP.1.FSHH.FFNTR" // Initial household funding per primary student as a percentage of GDP per capita
    replace indicator_id = "gov_fund_per_stud_prim_gdp" if indicator_id == "XUNIT.GDPCAP.1.FSGOV.FFNTR" // Initial government funding per primary student as a percentage of GDP per capita
    replace indicator_id = "gov_fund_per_stud_prim_ppp" if indicator_id == "XUNIT.PPPCONST.1.FSGOV.FFNTR" // Initial government funding per primary student, constant PPP$
    replace indicator_id = "hh_fund_per_stud_prim_ppp" if indicator_id == "XUNIT.PPPCONST.1.FSHH.FFNTR" // Initial household funding per primary student, constant PPP$

    replace indicator_id = "primary_schools_electricity" if indicator_id == "SCHBSP.1.WELEC" // Proportion of primary schools with access to electricity (%)
    replace indicator_id = "primary_schools_internet" if indicator_id == "SCHBSP.1.WINTERN" // Proportion of primary schools with access to Internet for pedagogical purposes (%)
    replace indicator_id = "primary_schools_computers" if indicator_id == "SCHBSP.1.WCOMPUT" // Proportion of primary schools with access to computers for pedagogical purposes (%)
    replace indicator_id = "primary_schools_water" if indicator_id == "SCHBSP.1.WWATA" // Proportion of primary schools with basic drinking water (%)
    replace indicator_id = "primary_schools_sanitation" if indicator_id == "SCHBSP.1.WTOILA" // Proportion of primary schools with single-sex basic sanitation facilities (%)
    replace indicator_id = "primary_schools_handwashing" if  indicator_id == "SCHBSP.1.WWASH"   // Proportion of primary schools with basic handwashing facilities (%)

    replace indicator_id = "sdg_411a_grade2_math" if indicator_id == "MATH.G2" // Proportion of students at the end of Grade 2 achieving at least a minimum proficiency level in mathematics,(%)
    replace indicator_id = "sdg_411a_grade2_math_m" if indicator_id == "MATH.G2.M" // Proportion of students at the end of Grade 2 achieving at least a minimum proficiency level in mathematics,(%) male
    replace indicator_id = "sdg_411a_grade2_math_f" if indicator_id == "MATH.G2.F" // Proportion of students at the end of Grade 2 achieving at least a minimum proficiency level in mathematics,(%) female
        
    replace indicator_id = "sdg_411a_grade3_math" if indicator_id == "MATH.G3" // Proportion of students at the end of Grade 3 achieving at least a minimum proficiency level in mathematics,(%)
    replace indicator_id = "sdg_411a_grade3_math_m" if indicator_id == "MATH.G3.M" // Proportion of students at the end of Grade 3 achieving at least a minimum proficiency level in mathematics,(%) male
    replace indicator_id = "sdg_411a_grade3_math_f" if indicator_id == "MATH.G3.F" // Proportion of students at the end of Grade 3 achieving at least a minimum proficiency level in mathematics,(%) female

    replace indicator_id = "sdg_411b_prim_math" if indicator_id == "MATH.PRIMARY" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in mathematics,(%)
    replace indicator_id = "sdg_411b_prim_math_m" if indicator_id == "MATH.PRIMARY.M" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in mathematics,(%) male
    replace indicator_id = "sdg_411b_prim_math_f" if indicator_id == "MATH.PRIMARY.F" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in mathematics,(%) female
       
    replace indicator_id = "sdg_411c_lowersec_math" if indicator_id == "MATH.LOWERSEC" // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in mathematics, (%)
    replace indicator_id = "sdg_411c_lowersec_math_m" if indicator_id == "MATH.LOWERSEC.M" // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in mathematics, (%) male
    replace indicator_id = "sdg_411c_lowersec_math_f" if indicator_id == "MATH.LOWERSEC.F" // Proportion of students at the end of lower secondary education achieving at least a minimum proficiency level in mathematics, (%) female       
      
    replace indicator_id = "complete_rate_prim" if indicator_id == "CR.1" // Completion rate, primary education, both sexes (%)
    replace indicator_id = "complete_rate_prim_m" if indicator_id == "CR.1.M" // Completion rate, primary education, (%)
    replace indicator_id = "complete_rate_prim_f" if indicator_id == "CR.1.F" // Completion rate, primary education, (%)
       
    replace indicator_id = "complete_rate_lowersec" if indicator_id == "CR.2" // Completion rate, lower secondary education, both sexes (%)
    replace indicator_id = "complete_rate_lowersec_m" if indicator_id == "CR.2.M" // Completion rate, lower secondary education,(%)
    replace indicator_id = "complete_rate_lowersec_f" if indicator_id == "CR.2.F" // Completion rate, lower secondary education,(%)
     
    replace indicator_id = "complete_rate_prim_model" if indicator_id == "CR.MOD.1" // Completion rate, primary education, both sexes (modelled data) (%)
    replace indicator_id = "complete_rate_prim_model_m" if indicator_id == "CR.MOD.1.M" // Completion rate, primary education, (modelled data) (%) 
    replace indicator_id = "complete_rate_prim_model_f" if indicator_id == "CR.MOD.1.F" // Completion rate, primary education, (modelled data) (%)
     
    replace indicator_id = "complete_lowersec_model" if indicator_id == "CR.MOD.2" // Completion rate, lower secondary education, both sexes (modelled data) (%)
    replace indicator_id = "complete_lowersec_model_m" if indicator_id == "CR.MOD.2.M" // Completion rate, lower secondary education,(modelled data) (%)
    replace indicator_id = "complete_lowersec_model_f" if indicator_id == "CR.MOD.2.F" // Completion rate, lower secondary education, (modelled data) (%)

    replace indicator_id = "prep_future_prim_math" if indicator_id == "PREPFUTURE.1.MATH" // Proportion of children/young people at the age of primary education prepared for the future in mathematics, both sexes (%)
    replace indicator_id = "prep_future_prim_math_m" if indicator_id == "PREPFUTURE.1.MATH.M" // Proportion of children/young people at the age of primary education prepared for the future in mathematics, male (%) 
    replace indicator_id = "prep_future_prim_math_f" if indicator_id == "PREPFUTURE.1.MATH.F" // Proportion of children/young people at the age of primary education prepared for the future in mathematics, female (%)
        
    replace indicator_id = "prep_future_lowsec_math" if indicator_id == "PREPFUTURE.2.MATH" // Proportion of children/young people at the age of lower secondary education prepared for the future in mathematics, both sexes (%)
    replace indicator_id = "prep_future_lowsec_math_m" if indicator_id == "PREPFUTURE.2.MATH.M" // Proportion of children/young people at the age of lower secondary education prepared for the future in mathematics, male (%)
    replace indicator_id = "prep_future_lowsec_math_f" if indicator_id == "PREPFUTURE.2.MATH.F" // Proportion of children/young people at the age of lower secondary education prepared for the future in mathematics, female (%)
           
    replace indicator_id = "sdg411b_prim_read" if indicator_id == "READ.PRIMARY" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in reading, both sexes (%)
    replace indicator_id = "sdg411b_prim_read_m" if indicator_id == "READ.PRIMARY.M" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in reading, male (%)
    replace indicator_id = "sdg411b_prim_read_f" if indicator_id == "READ.PRIMARY.F" // Proportion of students at the end of primary education achieving at least a minimum proficiency level in reading, female(%)

    replace indicator_id = "years_free_prim_sec_edu" if indicator_id == "YEARS.FC.FREE.1T3" // Number of years of free primary and secondary education guaranteed in legal frameworks
    replace indicator_id = "years_comp_prim_sec_edu" if indicator_id == "YEARS.FC.COMP.1T3" // Number of years of compulsory primary and secondary education guaranteed in legal frameworks

    replace indicator_id = "prop_on_track_children" if indicator_id == "ONTRACK.THREE.DOMAINS" // Proportion of children aged 24-59 months who are developmentally on track in health, learning and psychosocial well-being, (%)
    replace indicator_id = "prop_on_track_children_m" if indicator_id == "ONTRACK.THREE.DOMAINS.M" // Proportion of children aged 24-59 months who are developmentally on track in health, learning and psychosocial well-being, male (%) 
    replace indicator_id = "prop_on_track_children_f" if indicator_id == "ONTRACK.THREE.DOMAINS.F" // Proportion of children aged 24-59 months who are developmentally on track in health, learning and psychosocial well-being, female (%)
        
    replace indicator_id = "aner_before_primary_mf" if indicator_id == "NERA.AGM1.CP" // Adjusted net enrolment rate, one year before the official primary entry age, (%)
    replace indicator_id = "aner_before_primary_m" if indicator_id == "NERA.AGM1.M.CP" // Adjusted net enrolment rate, one year before the official primary entry age, male (%) 
    replace indicator_id = "aner_before_primary_f" if indicator_id == "NERA.AGM1.F.CP" // Adjusted net enrolment rate, one year before the official primary entry age, female (%)
        
    replace indicator_id = "anar_before_primary_mf" if indicator_id == "NARA.AGM1" // Adjusted net attendance rate, one year before the official primary entry age, (%)
    replace indicator_id = "anar_before_primary_m" if indicator_id == "NARA.AGM1.M" // Adjusted net attendance rate, one year before the official primary entry age, male (%)  
    replace indicator_id = "anar_before_primary_f" if indicator_id == "NARA.AGM1.F" // Adjusted net attendance rate, one year before the official primary entry age, female (%)
        
    replace indicator_id = "share_children_stimulated" if indicator_id == "POSTIMUENV" // Percentage of children under 5 years experiencing positive and stimulating home learning environments, (%)
    replace indicator_id = "share_children_stimulated_m" if indicator_id == "POSTIMUENV.M" // Percentage of children under 5 years experiencing positive and stimulating home learning environments, male (%)
    replace indicator_id = "share_children_stimulated_f" if indicator_id == "POSTIMUENV.F" // Percentage of children under 5 years experiencing positive and stimulating home learning environments, female (%)
        
    replace indicator_id = "ner_ece_mf" if indicator_id == "NER.0.CP" // Net enrolment rate, early childhood education, (%)
    replace indicator_id = "ner_ece_m" if indicator_id == "NER.0.M.CP" // Net enrolment rate, early childhood education, male (%)
    replace indicator_id = "ner_ece_f" if indicator_id == "NER.0.F.CP" // Net enrolment rate, early childhood education, female (%)
        
    replace indicator_id = "ner_ece_programs_mf" if indicator_id == "NER.01.CP" // Net enrolment rate, early childhood educational development programmes, (%)
    replace indicator_id = "ner_ece_programs_m" if indicator_id == "NER.01.M.CP" // Net enrolment rate, early childhood educational development programmes, male (%) 
    replace indicator_id = "ner_ece_programs_f" if indicator_id == "NER.01.F.CP" // Net enrolment rate, early childhood educational development programmes, female (%)
        
    replace indicator_id = "ner_pp_mf" if indicator_id == "NER.02.CP" // Net enrolment rate, pre-primary, (%)
    replace indicator_id = "ner_pp_m" if indicator_id == "NER.02.M.CP" // Net enrolment rate, pre-primary, male (%)
    replace indicator_id = "ner_pp_f" if indicator_id == "NER.02.F.CP" // Net enrolment rate, pre-primary, female (%)
    replace indicator_id = "years_free_pp_edu" if indicator_id == "YEARS.FC.FREE.02" // Number of years of free pre-primary education guaranteed in legal frameworks
    replace indicator_id = "years_comp_pp_edu" if indicator_id == "YEARS.FC.COMP.02" // Number of years of compulsory pre-primary education guaranteed in legal frameworks
        
    replace indicator_id = "ger_tertiary_mf" if indicator_id == "GER.5T8" // Gross enrolment ratio for tertiary education, (%)
    replace indicator_id = "ger_tertiary_m" if indicator_id == "GER.5T8.M" // Gross enrolment ratio for tertiary education, male (%)
    replace indicator_id = "ger_tertiary_f" if indicator_id == "GER.5T8.F"  // Gross enrolment ratio for tertiary education, female (%)
        
    replace indicator_id = "gar_tertiary_mf" if indicator_id == "GAR.5T8"  // Gross attendance ratio for tertiary education,  (%)
    replace indicator_id = "gar_tertiary_m" if indicator_id == "GAR.5T8.M"  // Gross attendance ratio for tertiary education,  male (%)
    replace indicator_id = "gar_tertiary_f" if indicator_id == "GAR.5T8.F" // Gross attendance ratio for tertiary education, female (%)
        
    replace indicator_id = "prop_enroll_vocational_ed" if indicator_id == "EV1524P.2T5.V" // Proportion of 15- to 24-year-olds enrolled in vocational education, (%)
    replace indicator_id = "prop_enroll_vocational_ed_m" if indicator_id == "EV1524P.2T5.V.M" // Proportion of 15- to 24-year-olds enrolled in vocational education, male (%) 
    replace indicator_id = "prop_enroll_vocational_ed_f" if indicator_id == "EV1524P.2T5.V.F"  // Proportion of 15- to 24-year-olds enrolled in vocational education, female (%)
        
    replace indicator_id = "attain_tertiary_25plus" if indicator_id == "EA.5T8.AG25T99" // Educational attainment rate, completed short-cycle tertiary education or higher, population 25+ years,  (%)
    replace indicator_id = "attain_tertiary_25plus_m" if indicator_id == "EA.5T8.AG25T99.M" // Educational attainment rate, completed short-cycle tertiary education or higher, population 25+ years, male (%) 
    replace indicator_id = "attain_tertiary_25plus_f" if indicator_id == "EA.5T8.AG25T99.F" // Educational attainment rate, completed short-cycle tertiary education or higher, population 25+ years, female (%)


* Reshape the data to wide format
    reshape wide value, i(country_id year) j(indicator_id) string

*Rename variables to match the code later in the workflow
    ds value*
    foreach var of varlist `r(varlist)' {
        local newname = subinstr("`var'", "value", "", 1)
        rename `var' `newname'
    }
    rename country_id countrycode




*************************************************************************
* CLEAN THE UIS DATA
*************************************************************************

* Check to see if there are some values that need cleaning?
    summarize *

* Top-code enrollment/attendance rates at 100%? 
foreach gender in mf m f {
    replace aner_before_primary_`gender' = 100 if aner_before_primary_`gender' > 100
    replace anar_before_primary_`gender' = 100 if anar_before_primary_`gender' > 100
    replace ner_ece_`gender' = 100 if ner_ece_`gender' > 100
    replace ner_ece_programs_`gender' = 100 if ner_ece_programs_`gender' > 100
    replace ner_pp_`gender' = 100 if ner_pp_`gender' > 100
    replace gar_tertiary_`gender' = 100 if gar_tertiary_`gender' > 100
    replace ger_tertiary_`gender' = 100 if ger_tertiary_`gender' > 100

}

* Drop the outlier in hh_fund_per_stud_prim_ppp
    replace hh_fund_per_stud_prim_ppp = . if hh_fund_per_stud_prim_ppp > 10000

* Create a combined variable for 4.1.1 grade 2 and grade 3 reading
    gen sdg_411a_grade2_3_read = .
    replace sdg_411a_grade2_3_read = sdg_411a_grade2_read if sdg_411a_grade2_read != .
    replace sdg_411a_grade2_3_read = sdg_411a_grade3_read if sdg_411a_grade2_read == .
    *browse countrycode year sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_3_read 

* Repeat for math
    gen sdg_411a_grade2_3_math = .
    replace sdg_411a_grade2_3_math = sdg_411a_grade2_math if sdg_411a_grade2_math != .
    replace sdg_411a_grade2_3_math = sdg_411a_grade3_math if sdg_411a_grade2_math == .
    *browse countrycode year sdg_411a_grade2_math sdg_411a_grade3_math sdg_411a_grade2_3_math

* Save as .dta
    save "${clone}/01_inputs/UIS/uis_sdg_temp.dta", replace



*************************************************************************
* Bring in EFW Variables
*************************************************************************

* Load in the PPP adjustment data from WDI
wbopendata, indicator(NY.GDP.MKTP.PP.KD) clear long
keep countrycode year ny_gdp_mktp_pp_kd
rename ny_gdp_mktp_pp_kd ppp_adjustment
tempfile ppp
save `ppp'

* Load in the EFW database
use "C:\Users\wb633382\OneDrive - WBG\EduAnalytics Teams - WB Group - Shared Documents\Education Finance Watch\EFW_2025\comp\Output\efwdatabase_2025.dta", clear

* Keep relevant variables
keep iso3 year gov_educgdp_pri enrol_pri
rename iso3 countrycode

* Merge in the PPP data
merge m:1 countrycode year using `ppp'
keep if _merge == 3
drop _merge

* Calculate gov expenditure per student in PPP terms
gen gov_expend_per_student_ppp = ((gov_educgdp_pri/100) * ppp_adjustment) / enrol_pri
drop if gov_expend_per_student_ppp == .

keep countrycode year gov_expend_per_student_ppp

* Drop outliers
drop if gov_expend_per_student_ppp > 30000
drop if gov_expend_per_student_ppp < 10

* Create a log version of the datapoint
gen log_gov_exp_per_stud_ppp = log(gov_expend_per_student_ppp)

* merge into the UIS data
merge 1:m countrycode year using "${clone}/01_inputs/UIS/uis_sdg_temp.dta"
drop if _merge == 1
drop _merge

* Compare the EFW data to a similar datapoint we have from UIS
*merge 1:m countrycode year using "${clone}/07_figures_for_global_report/071_rawdata/uis_sdg.dta"
*drop if _merge == 2
*drop _merge
* Check for outliers
*gen expend_diff = gov_expend_per_student_ppp - gov_fund_per_stud_prim_ppp
*summ expend_diff, detail
*ssc install extremes
*extremes expend_diff
*Croatia and norway could be outliers

* Anyways, we will add this variable to the loop

* Save as .dta
    save "${clone}/01_inputs/UIS/uis_sdg.dta", replace


*************************************************************************
* Some Notes on the UIS data
*************************************************************************

* what is the definition of teacher trained ratio?
*https://databrowser.uis.unesco.org/resources/glossary/3189


* look into the prepared for future variables. How are they constructed / why do they correlate so strongly?
*https://databrowser.uis.unesco.org/resources/glossary/3227
* this var is derived from the 4.1.1 (Above minimumum proficiency in primary) and 4.1.2 (primary completion rate) SDG indicators


*************************************************************************
* Plots 1a: Plots by Region, Combined Plots, Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Region_Combined)
    local row=2

* Begin Loop
foreach var in  sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_math sdg_411a_grade3_math sdg_411a_grade2_read sdg_411a_grade3_read
    lit_rate_youth lit_rate_adult lit_rate lit_rate_elderly lit_proficiency_rate ///
    lit_rate_youth_galp lit_rate_adult_galp lit_rate_galp lit_rate_elderly_galp ///
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math ///
    primary_schools_electricity primary_schools_internet primary_schools_computers primary_schools_water primary_schools_sanitation primary_schools_handwashing ///
    complete_rate_prim complete_rate_lowersec complete_rate_prim_model complete_lowersec_model ///
    ner_ece_mf ner_ece_programs_mf ner_pp_mf aner_before_primary_mf anar_before_primary_mf ///
    prop_on_track_children share_children_stimulated attain_tertiary_25plus ///
    ger_tertiary_mf gar_tertiary_mf ///
    prep_future_prim_read prep_future_lowsec_read prep_future_prim_math prep_future_lowsec_math {
    
    *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        , xlabel(0(10)100) ylabel(0(10)100) ///
        title("`var' vs Learning Poverty") ///
        ytitle("`var' (%)") xtitle("Learning Poverty (%)") ///
        legend(order(1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" ) rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/regions_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/regions_combined/`var'_vs_lp.png", replace

    * Save Regression Results to Excel
    putexcel A`row' = "`var'"
    putexcel B`row' = `b0'
    putexcel C`row' = `b1'
    putexcel D`row' = `r2'
    putexcel E`row' = `pval'
    putexcel F`row' = `n_countries'
    local row = `row' + 1

    * Save a table of the data to excel
    keep countrycode region `var' lpv_all year year_`var' year_assessment
    order countrycode region `var' lpv_all year year_`var' year_assessment
    rename year release_year
    export excel using "${clone}/03_outputs/Tables/UIS_vars/regions_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

}

putexcel save

*************************************************************************
* Plots 1b: Plots by Region, Combined Plots, Non-Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Region_Combined)
    local row=52

* Begin Loop
foreach var in prop_teach_min_qual teach_trained_ratio_primary teach_qualed_ratio_primary teacher_qual_primary ///
    teacher_salary_primary teacher_attrition_primary teacher_training_primary ///
    gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    years_free_prim_sec_edu years_comp_prim_sec_edu years_free_pp_edu years_comp_pp_edu prop_enroll_vocational_ed ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp {
    
        *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        ,  xlabel(0(10)100) title("`var' vs Learning Poverty") ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        legend(order(1 "ECS" 2 "EAS" 3 "LCN" 4 "MEA" 5 "SAS" 6 "SSF" ) rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/regions_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/regions_combined/`var'_vs_lp.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/regions_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}

putexcel save

*************************************************************************
* Plots 2a: Plots by Region, Seperate Plots, Percentage Variables
*************************************************************************
* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Region_Separate)
    local row=2

* Begin Loop
foreach var in sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_math sdg_411a_grade3_math 
    lit_rate_youth lit_rate_adult lit_rate lit_rate_elderly lit_proficiency_rate ///
    lit_rate_youth_galp lit_rate_adult_galp lit_rate_galp lit_rate_elderly_galp ///
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math ///
    primary_schools_electricity primary_schools_internet primary_schools_computers primary_schools_water primary_schools_sanitation primary_schools_handwashing ///
    complete_rate_prim complete_rate_lowersec complete_rate_prim_model complete_lowersec_model ///
    ner_ece_mf ner_ece_programs_mf ner_pp_mf aner_before_primary_mf anar_before_primary_mf ///
    prop_on_track_children share_children_stimulated attain_tertiary_25plus ///
    ger_tertiary_mf gar_tertiary_mf ///
    prep_future_prim_read prep_future_lowsec_read prep_future_prim_math prep_future_lowsec_math {
    
    * Additional Loop for Regions
    foreach region in ECS LCN MEA SAS SSF EAS  {

    * Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if region == "`region'"

        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        , xlabel(0(10)100) ylabel(0(10)100) ///
        title("`var' vs Learning Poverty - `region'" ) ///
        ytitle("`var' (%)") xtitle("Learning Poverty (%)") ///
        graphregion(color(white)) ///
        legend(off) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/regions_separate/`var'_vs_lp_`region'.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/regions_separate/`var'_vs_lp_`region'.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/regions_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}
                }

putexcel save

*************************************************************************
* Plots 2b: Plots by Region, Seperate Plots, Non-Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Region_Separate)
    local row=300

* Begin Loop
foreach var in prop_teach_min_qual teach_trained_ratio_primary teach_qualed_ratio_primary teacher_qual_primary ///
    teacher_salary_primary teacher_attrition_primary teacher_training_primary ///
    gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    years_free_prim_sec_edu years_comp_prim_sec_edu years_free_pp_edu years_comp_pp_edu prop_enroll_vocational_ed ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp {
    
    * Additional Loop for Regions
    foreach region in ECS LCN MEA SAS SSF EAS  {

    * Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

   * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if region == "`region'"

        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        ,  xlabel(0(10)100) title("`var' vs Learning Poverty - `region'" ) ///
        ytitle("`var'") xtitle("Learning Poverty (%)") ///
        graphregion(color(white)) ///
        legend(off) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/regions_separate/`var'_vs_lp_`region'.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/regions_separate/`var'_vs_lp_`region'.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/regions_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace
}
                }

putexcel save

*************************************************************************
* Plots 3a: Plots by Income Group, Combined Plots, Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Income_Combined)
    local row=2

* Begin Loop
foreach var in sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_math sdg_411a_grade3_math
    lit_rate_youth lit_rate_adult lit_rate lit_rate_elderly lit_proficiency_rate ///
    lit_rate_youth_galp lit_rate_adult_galp lit_rate_galp lit_rate_elderly_galp ///
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math ///
    primary_schools_electricity primary_schools_internet primary_schools_computers primary_schools_water primary_schools_sanitation primary_schools_handwashing ///
    complete_rate_prim complete_rate_lowersec complete_rate_prim_model complete_lowersec_model ///
    ner_ece_mf ner_ece_programs_mf ner_pp_mf aner_before_primary_mf anar_before_primary_mf ///
    prop_on_track_children share_children_stimulated attain_tertiary_25plus ///
    ger_tertiary_mf gar_tertiary_mf ///
    prep_future_prim_read prep_future_lowsec_read prep_future_prim_math prep_future_lowsec_math {
    
    *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        , xlabel(0(10)100) ylabel(0(10)100) ///
        title("`var' vs Learning Poverty") ///
        ytitle("`var' (%)") xtitle("Learning Poverty (%)") ///
        legend(order(1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC") rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/income_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/income_combined/`var'_vs_lp.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/income_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}

putexcel save


*************************************************************************
* Plots 3b: Plots by Income Group, Combined Plots, Non-Percentage Variables
*************************************************************************


* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Income_Combined)
    local row=52

* Begin Loop
foreach var in prop_teach_min_qual teach_trained_ratio_primary teach_qualed_ratio_primary teacher_qual_primary ///
    teacher_salary_primary teacher_attrition_primary teacher_training_primary ///
    gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    years_free_prim_sec_edu years_comp_prim_sec_edu years_free_pp_edu years_comp_pp_edu prop_enroll_vocational_ed ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp {
    
        *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        saving("${clone}/03_outputs/Figures/UIS_vars/income_combined/`var'_vs_lp.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/income_combined/`var'_vs_lp.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/income_combined/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}

putexcel save


*************************************************************************
* Plots 4a: Plots by Income Group, Seperate Plots, Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Income_Separate)
    local row=2

* Begin Loop
foreach var in sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_math sdg_411a_grade3_math
    lit_rate_youth lit_rate_adult lit_rate lit_rate_elderly lit_proficiency_rate ///
    lit_rate_youth_galp lit_rate_adult_galp lit_rate_galp lit_rate_elderly_galp ///
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math ///
    primary_schools_electricity primary_schools_internet primary_schools_computers primary_schools_water primary_schools_sanitation primary_schools_handwashing ///
    complete_rate_prim complete_rate_lowersec complete_rate_prim_model complete_lowersec_model ///
    ner_ece_mf ner_ece_programs_mf ner_pp_mf aner_before_primary_mf anar_before_primary_mf ///
    prop_on_track_children share_children_stimulated attain_tertiary_25plus ///
    ger_tertiary_mf gar_tertiary_mf ///
    prep_future_prim_read prep_future_lowsec_read prep_future_prim_math prep_future_lowsec_math {

    foreach income in HIC LIC LMC UMC {

    *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if incomelevel == "`income'"

        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        , xlabel(0(10)100) ylabel(0(10)100) ///
        title("`var' vs Learning Poverty - `income'") ///
        ytitle("`var' (%)") xtitle("Learning Poverty (%)") ///
        legend(off) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/income_separate/`var'_vs_lp_`income'.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/income_separate/`var'_vs_lp_`income'.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/income_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}
                }

putexcel save


*************************************************************************
* Plots 4b: Plots by Income Group, Seperate Plots, Non-Percentage Variables
*************************************************************************

* Set Excel file to save regression results
    putexcel set "${clone}/03_outputs/Figures/UIS_vars/reg_results.xlsx", modify sheet(Income_Separate)
    local row=300

* Begin Loop
foreach var in prop_teach_min_qual teach_trained_ratio_primary teach_qualed_ratio_primary teacher_qual_primary ///
    teacher_salary_primary teacher_attrition_primary teacher_training_primary ///
    gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    years_free_prim_sec_edu years_comp_prim_sec_edu years_free_pp_edu years_comp_pp_edu prop_enroll_vocational_ed ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp {

    foreach income in HIC LIC LMC UMC {

    *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

     * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        keep if incomelevel == "`income'"

        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
        saving("${clone}/03_outputs/Figures/UIS_vars/income_separate/`var'_vs_lp_`income'.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/income_separate/`var'_vs_lp_`income'.png", replace

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
    export excel using "${clone}/03_outputs/Tables/UIS_vars/income_separate/`var'_vs_lp_data.xlsx", firstrow(variables) replace

}
                }

putexcel save




*************************************************************************
* Plot Select Vars against LD
*************************************************************************
*SDG 4.1.1 a and c vars; EFW vars; service delivery vars


* Begin Loop
foreach var in gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp ///
    sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_math sdg_411a_grade3_math
    primary_schools_electricity primary_schools_internet primary_schools_computers primary_schools_water primary_schools_sanitation primary_schools_handwashing ///
    prop_teach_min_qual teach_trained_ratio_primary teach_qualed_ratio_primary teacher_qual_primary ///
    teacher_salary_primary teacher_attrition_primary teacher_training_primary ///
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math {
    
        *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

     * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
    gen incomelevel_num = .
    replace incomelevel_num = 1 if incomelevel == "LIC"
    replace incomelevel_num = 2 if incomelevel == "LMC"
    replace incomelevel_num = 3 if incomelevel == "UMC"
    replace incomelevel_num = 4 if incomelevel == "HIC"
    replace incomelevel_num = 5 if incomelevel == "INX"
    label define incomelevel_lbl 1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC" 5 "INX" 
    label values incomelevel_num incomelevel_lbl

    * Run regression
    quietly regress ld_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' ld_all if incomelevel_num == 1, mlabel(countrycode) mlabcolor(red) mcolor(red) msymbol(Oh) jitter(5)) ///
        (scatter `var' ld_all if incomelevel_num == 2, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(Dh) jitter(5)) ///
        (scatter `var' ld_all if incomelevel_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' ld_all if incomelevel_num == 4, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Sh) jitter(5)) ///
        (lfit `var' ld_all, lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        ,  xlabel(0(10)100) title("`var' vs Learning Deprivation") ///
        ytitle("`var'") xtitle("Learning Deprivation (%)") ///
        legend(order(1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC") rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/plots_vs_LD/`var'_vs_ld.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/plots_vs_LD/`var'_vs_ld.png", replace


    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds


    * Save a table of the data to excel
    keep countrycode incomelevel `var' ld_all 
    order countrycode incomelevel `var' ld_all 
    export excel using "${clone}/03_outputs/Tables/UIS_vars/plots_vs_LD/`var'_vs_ld_data.xlsx", firstrow(variables) replace

}



*************************************************************************
*Plot Select Vars against SD 
*************************************************************************
*SDG 4.1.1 a and c vars; EFW vars; 

* Begin Loop
foreach var in gov_expend_percent_gdp edu_expend_percent_total ///
    hh_fund_per_stud_prim_gdp hh_fund_per_stud_prim_ppp ///
    gov_fund_per_stud_prim_gdp gov_fund_per_stud_prim_ppp ///
    log_gov_exp_per_stud_ppp gov_expend_per_student_ppp ///
    sdg_411a_grade2_3_math sdg_411a_grade2_3_read /// sdg_411a_grade2_read sdg_411a_grade3_read sdg_411a_grade2_math sdg_411a_grade3_math
    sdg_411c_lowersec_read sdg411b_prim_read sdg_411b_prim_math sdg_411c_lowersec_math {
    
        *Load in the UIS data
    use "${clone}/01_inputs/UIS/uis_sdg.dta", clear

    * Match the UIS data to the LP data based on closest years

        * Keep the latest value of the UIS variable, by country
        sort countrycode year 
        bysort countrycode (year): egen last_`var' = max(cond(!missing(`var'), year, . ))
        keep if last_`var' == year
        rename year year_`var'
        tempfile uis_latest
        save `uis_latest'

        * Load the LP Panel data
        use "${clone}/03_outputs/Clean/lpv_panel.dta", clear

        * Drop empty lpv values
        drop if lpv_all == .
        
        *keep only preferences with GEM
        keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
        
        *Merge UIS data, drop countries not in the LPV dataset
        merge m:1 countrycode using `uis_latest'
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
    gen incomelevel_num = .
    replace incomelevel_num = 1 if incomelevel == "LIC"
    replace incomelevel_num = 2 if incomelevel == "LMC"
    replace incomelevel_num = 3 if incomelevel == "UMC"
    replace incomelevel_num = 4 if incomelevel == "HIC"
    replace incomelevel_num = 5 if incomelevel == "INX"
    label define incomelevel_lbl 1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC" 5 "INX" 
    label values incomelevel_num incomelevel_lbl

    * Run regression
    quietly regress sd_all `var'
    local r2   = round(e(r2), 0.01)
    local b1   = round(_b[`var'], 0.01)
    local b0   = round(_b[_cons], 0.01)
    local pval = round(2 * (1 - normal(abs(_b[`var'] / _se[`var']))), 0.0001)
    local n_countries = e(N)

    * Plot
    twoway ///
        (scatter `var' sd_all if incomelevel_num == 1, mlabel(countrycode) mlabcolor(red) mcolor(red) msymbol(Oh) jitter(5)) ///
        (scatter `var' sd_all if incomelevel_num == 2, mlabel(countrycode) mlabcolor(gold) mcolor(gold)  msymbol(Dh) jitter(5)) ///
        (scatter `var' sd_all if incomelevel_num == 3, mlabel(countrycode) mlabcolor(midgreen) mcolor(midgreen) msymbol(Th) jitter(5)) ///
        (scatter `var' sd_all if incomelevel_num == 4, mlabel(countrycode) mlabcolor(midblue) mcolor(midblue)  msymbol(Sh) jitter(5)) ///
        (lfit `var' sd_all, lpattern(dash) lcolor(black%75) lwidth(thin)) ///
        ,  xlabel(0(5)50) title("`var' vs Schooling Deprivation") ///
        ytitle("`var'") xtitle("Schooling Deprivation (%)") ///
        legend(order(1 "LIC" 2 "LMC" 3 "UMC" 4 "HIC") rows(1) position(6)) ///
        graphregion(color(white)) ///
        note("   R² = `r2'", pos(3) justification(right) size(small)) ///
        saving("${clone}/03_outputs/Figures/UIS_vars/plots_vs_SD/`var'_vs_sd.gph", replace)
        graph export "${clone}/03_outputs/Figures/UIS_vars/plots_vs_SD/`var'_vs_sd.png", replace


    * Set up a delay so Stata doesn't go too fast and break the loop
    sleep 2000 // 2 seconds

    * Save a table of the data to excel
    keep countrycode incomelevel `var' sd_all 
    order countrycode incomelevel `var' sd_all 
    export excel using "${clone}/03_outputs/Tables/UIS_vars/plots_vs_SD/`var'_vs_sd_data.xlsx", firstrow(variables) replace

}





*************************************************************************
* Creating Windows of SDG 4.1.1 vars vs. LD
*************************************************************************

* We are trying to reproduce the table on page 51 here. Also see page 23 for relevant plots
* https://openknowledge.worldbank.org/server/api/core/bitstreams/df1e4f78-cddd-5d74-8590-29a442429eea/content

foreach var in sdg_411a_grade2_3_read sdg_411a_grade2_3_math sdg_411c_lowersec_read sdg_411c_lowersec_math {

* Prepare the SDG data first (let's focus on reading first)
use "${clone}/01_inputs/UIS/uis_sdg.dta", clear
keep countrycode year `var'
drop if missing(`var')
rename year year_sdg
tempfile sdg
save `sdg'

* Prepare the LD data
use "${clone}/03_outputs/Clean/lpv_panel.dta", clear
browse 
drop if ld_all == .
*keep only preferences with GEM
keep if preference == "1402" | preference == "1205_GEM" | preference == "1108_GEM" | preference == "1005_GEM"
*Note: LD rarely if ever changes if the assessment-year combination remains the same, so let's drop duplicated years of assessment
duplicates drop countrycode year_assessment, force
keep countrycode year_assessment ld_all
tempfile ld 
save `ld'

* Merge the datasets
use `sdg', clear
joinby countrycode using `ld'

* Create Windows
gen year_diff = year_sdg - year_assessment

gen window = .
replace window = 1 if inrange(year_diff,  3,  5)
replace window = 2 if inrange(year_diff,  0,  4)
replace window = 3 if inrange(year_diff, -5, -3)
replace window = 4 if inrange(year_diff, -11, -6)
replace window = 5 if year_diff < -11

label define window ///
    1 "SDG +3 to +5 years" ///
    2 "SDG 0 to +4 years" ///
    3 "SDG -3 to -5 years" ///
    4 "SDG -6 to -11 years" ///
    5 "SDG < -11 years"

label values window window

* create correlation results dataset
tempname results
postfile `results' ///
    str25 window ///
    corr ///
    mean_sdg ///
    mean_ld ///
    N ///
    using "${clone}/03_outputs/Tables/UIS_vars/SDG_windows/corr_results_`var'.dta", replace

levelsof window, local(windows)

foreach w of local windows {

    * Correlation
    quietly corr `var' ld_all if window == `w'
    local rho = r(rho)
    local N   = r(N)

    * Means
    quietly summarize `var' if window == `w', meanonly
    local msdg = r(mean)

    quietly summarize ld_all if window == `w', meanonly
    local mld  = r(mean)

    * Window label
    local wlab : label window `w'

    post `results' ///
        ("`wlab'") ///
        (`rho') ///
        (`msdg') ///
        (`mld') ///
        (`N')
}

postclose `results'

use corr_results_`var'.dta, clear
format corr mean_sdg mean_ld %6.3f
list, clean

export excel using "${clone}/03_outputs/Tables/UIS_vars/SDG_windows/sdg_ld_correlations_by_window.xlsx", ///
    sheet("`var'") ///
    firstrow(variables) ///
    sheetreplace

}












