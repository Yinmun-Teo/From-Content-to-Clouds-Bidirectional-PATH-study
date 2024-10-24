//////////////////////////////////////////////////////////////////////////

***Data analysis of w5, w5.5 & w6 PATH***
***Written by Yin Mun Teo***
***Date 25/6/2024***

//////////////////////////////////////////////////////////////////////////
cd "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files"


set maxvar 10000

/// MODEL 1: exposure to e-cigs content (W5/W5.5) -> vaping (W6) ///

use "07082024 imputated PATH model 1", clear


mi svyset [pweight=R05_Y_AX04WGT], psu(VARPSU) strata(VARSTRAT) brr(R05_Y_AX04WGT1 - R05_Y_AX04WGT100) fay(0.3)

**Set CI to 99.17% based on correction**
set level 99.17


**UNADJUSTED**

mi estimate, or: svy: logistic R06R_Y_EVR_EPRODS exp_ads

mi estimate, or: svy: logistic R06R_Y_P12M_EPRODS exp_ads

mi estimate, or: svy: logistic R06R_Y_CUR_EPRODS exp_ads


**ADJUSTED**

mi estimate, or: svy: logit R06R_Y_EVR_EPRODS exp_ads ///
X04R_Y_AGECAT2 X04R_Y_SEX i.X04R_Y_RACE* ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
X04_PN0337_01 X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 X04_YX0673


mi estimate, or: svy: logit R06R_Y_P12M_EPRODS exp_ads X04R_Y_AGECAT2 X04R_Y_SEX i.X04R_Y_RACE* ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
X04_PN0337_01 X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 X04_YX0673


mi estimate, or: svy: logistic R06R_Y_CUR_EPRODS exp_ads X04R_Y_AGECAT2 X04R_Y_SEX i.X04R_Y_RACE* ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
X04_PN0337_01 X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 X04_YX0673


**PARAMETRIC TEST FOR FREQ OF E-PRODUCT USED (n=96)**
**UNIVARIATE & MULTIVARIATE**
regress R06R_Y_NUMDAYS_EPRODS exp_ads ///
X04R_Y_AGECAT2 X04R_Y_SEX i.X04R_Y_RACE* ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
X04_PN0337_01 X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 X04_YX0673

**NON PARAMETRIC WILCOXON RANK-SUM TEST**
ranksum R06R_Y_NUMDAYS_EPRODS, by (exp_ads) porder


/// SENSITIVITY ANALYSIS ///////

use "sensitivity_analysis_model_1.0", clear

mi svyset [pweight=R05_Y_AX04WGT], psu(VARPSU) strata(VARSTRAT) brr(R05_Y_AX04WGT1 - R05_Y_AX04WGT100) fay(0.3)

**Set CI to 99.7% based on correction**
set level 99.17


**ADJUSTED**

mi estimate, or: svy: logit R06R_Y_EVR_EPRODS exp_ads ///
age_group sex i.race_baseline ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


mi estimate, or: svy: logit R06R_Y_P12M_EPRODS exp_ads age_group sex i.race_baseline ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


mi estimate, or: svy: logit R06R_Y_CUR_EPRODS exp_ads age_group sex i.race_baseline ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


**PARAMETRIC TEST FOR FREQ OF E-PRODUCT USED (n=96)**
**Parametric test**
ttest R06R_Y_NUMDAYS_EPRODS, by (exp_ads) 


**NON PARAMETRIC WILCOXON RANK-SUM TEST**
ranksum R06R_Y_NUMDAYS_EPRODS, by (exp_ads)


****************************************************************************************************************************************************************

/// MODEL 2: Vaping (W5/W5.5) -> exposure to e-cigs content (W6) ///

use "07082024 imputated PATH model 2", clear


mi svyset [pweight=R05_Y_AX04WGT], psu(VARPSU) strata(VARSTRAT) brr(R05_Y_AX04WGT1 - R05_Y_AX04WGT100) fay(0.3)

**Set CI to 99.7% based on correction**
set level 99.17

**UNADJUSTED**

mi estimate, or: svy: logistic R06_YX0203_10 ever_baseline

mi estimate, or: svy: logistic R06_YX0203_10 p12m_baseline

mi estimate, or: svy: logistic R06_YX0203_10 p30d_baseline


**ADJUSTED**

mi estimate, or: svy: logit R06_YX0203_10 ever_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE X04R_Y_EVR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673

mi estimate, or: svy: logit R06_YX0203_10 p12m_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE X04R_Y_P12M_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


mi estimate, or: svy: logit R06_YX0203_10 p30d_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE X04R_Y_CUR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


/// DOSE-RESPONSE ASSOCIATION ///

**Creating dummy variables to compute OR for R06_YX0372**

tab R06_YX0372, gen(freq_dummy)

**Check dummy variables created**
tab freq_dummy2,m
tab freq_dummy3,m
tab freq_dummy4,m

**Dummy1 is for non-exposed**
**Dummy2 is for few time**
**Dummy3 is for weekly**
**Dummy4 is for daily**


**UNADJUSTED**

***Lifetime***

mi estimate, or: svy: ologit 
freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.ever_baseline

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.ever_baseline

mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.ever_baseline


**Past 12 months**
mi estimate, or: svy: ologit 
freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p12m_baseline

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p12m_baseline

mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p12m_baseline

**Curent use**
mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p30d_baseline

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p30d_baseline

mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy2 i.freq_dummy3 i.p30d_baseline


**ADJUSTED**

**Lifetime**
mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.ever_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE X04R_Y_EVR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.ever_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_EVR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.ever_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_EVR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


**Past 12-months**

mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p12m_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE X04R_Y_P12M_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p12m_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_P12M_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p12m_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_P12M_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


**Curent use**

mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p30d_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_CUR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p30d_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_CUR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p30d_baseline ///
i.X04R_Y_AGECAT2 i.X04R_Y_SEX i.X04R_Y_RACE* X04R_Y_CUR_EPRODS ///
i. X04_PT0019 i.income_quartiles i.X04R_P_PARSP_EDUC ///
i.X04_PN0337_01 i.X04_PN0335_01 i.X04_YX0681 ///
i.X04_YX0680 i.X04_YX0673


// SENSITIVITY ANALYSIS //

use "sensitivity_analysis_model_2.0", clear


mi svyset [pweight=R05_Y_AX04WGT], psu(VARPSU) strata(VARSTRAT) brr(R05_Y_AX04WGT1 - R05_Y_AX04WGT100) fay(0.3)

**Set CI to 99.7% based on correction**
set level 99.17

**ADJUSTED**

mi estimate, or: svy: logit R06_YX0203_10 ever_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_EVR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use

mi estimate, or: svy: logit R06_YX0203_10 p12m_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_P12M_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: logit R06_YX0203_10 p30d_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_CUR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


/// DOSE-RESPONSE ASSOCIATION ///

**Creating dummy variables to compute OR for R06_YX0372**

tab R06_YX0372, gen(freq_dummy)

**Check dummy variables created**
tab freq_dummy2,m
tab freq_dummy3,m
tab freq_dummy4,m

**Dummy1 is for non-exposed**
**Dummy2 is for few time**
**Dummy3 is for weekly**
**Dummy4 is for daily**


**ADJUSTED**

**Lifetime**

mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.ever_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_EVR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.ever_baseline ///
age_group sex i.race_baseline i.X04R_Y_EVR_EPRODS ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.ever_baseline ///
i.age_group sex i.race_baseline i.X04R_Y_EVR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


***Past 12-months***

mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p12m_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_P12M_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p12m_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_P12M_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p12m_baseline ///
age_group sex i.race_baseline X04R_Y_P12M_EPRODS ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


**Cuurent use***

mi estimate, or: svy: ologit freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p30d_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_CUR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p30d_baseline ///
i.age_group i.sex i.race_baseline i.X04R_Y_CUR_EPRODS ///
i.academic_performance i.income ///
i.parent_education i.parent_vape i.parent_smoke ///
i.peer_vape i.peer_smoke i.alcohol_use


mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p30d_baseline ///
age_group sex i.race_baseline X04R_Y_CUR_EPRODS ///
i.academic_performance i.income ///
i.parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use

/// END OF DO FILE ///