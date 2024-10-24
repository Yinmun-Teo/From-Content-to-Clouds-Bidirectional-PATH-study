//////////////////////////////////////////////////////////////////////////

***Applying weights & MI of w5, w5.5 & w6***
***Written by Yin Mun Teo***
***Date 19/6/2024***

//////////////////////////////////////////////////////////////////////////
cd "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files"

set maxvar 10000

**Load cleaned PATH dataset***
use "05082024 cleaned PATH", clear

***Applying w4 cohort all-wave weight***

merge 1:1 PERSONID using "weights5_w4allwave_specialcollection.dta"
**3460 youths without weights

***Save final merged dataset***
save "merged_youth_weights_data", replace


////////////////////////////////////////////////////// WEIGH W4 COVARIATES ////////////

***Apply w4 all waves weights according to PATH user guide*** 
svyset [pweight=R05_Y_AX04WGT], psu(VARPSU) strata(VARSTRAT) brr(R05_Y_AX04WGT1 - R05_Y_AX04WGT100) mse vce(brr) fay(0.3)

set level 95.0

////////////////////////////////////////////////////// WEIGH W4 COVARIATES ////////////

***Age**
svy:tab X04R_Y_AGECAT2, percent ci

**Sex***
svy: tab X04R_Y_SEX, percent ci

**Ethinicity / race**
svy: tab race, percent ci

**Academic performance**
svy: tab X04_PT0019, percent ci

//Income//
svy: tab X04R_Y_PM0130, percent ci

* Generate quintiles
xtile income_quartiles = X04R_Y_PM0130, nq(5)
*Quintiles set to 5 as STATA include =. as a quintile


*Frequency distribution of quintiles*
label define income1 1 "1 = <$10,000 - $24,999" 2 "2 = $25,000 to $49,999" 3 "3 = $50,000 to $99,999" 4 "4 = $100,000 or more", replace
label values income_quartiles income1
tab income_quartiles, m

*Summary stat for income by quintile*
bysort income_quintile: tab X04R_Y_PM0130


//Parental education//
svy: tab X04R_P_PARSP_EDUC, percent ci

recode X04R_P_PARSP_EDUC (0=0) (1=1) (2/3=2)
label define edu_1 0 "0 = High school diploma or less" 1 "1 = Some college (no degree) or associate degree" 2 "2 = Bachelor's degree or higher", replace
label values X04R_P_PARSP_EDUC edu_1
tab X04R_P_PARSP_EDUC, m

**Parent use e-cigarette**
svy: tab X04_PN0337_01, percent ci

**Parent use cigarette**
svy: tab X04_PN0335_01, percent ci

**Peer use e-cigarette**
svy: tab X04_YX0681, percent ci

tab X04_YX0681, m

recode X04_YX0681 (0=0) (1/2=1)
label values X04_YX0681 use_label
tab X04_YX0681, m

**Peer use cigarette**
svy: tab X04_YX0680, percent ci

tab X04_YX0680, m

recode X04_YX0680 (0=0) (1/2=1)
label values X04_YX0680 use_label
tab X04_YX0680, m

**Alcohol use in p30d**
svy: tab X04_YX0673, percent ci


///////////////////////////////////////////

***Sample characteristics***

***Age group***
svy: tab R05R_Y_AGECAT2, ci
//153 missing from w5.5

gen age_group=.

	replace age_group=1 if (R05R_Y_AGECAT2==1 | X05R_Y_AGECAT2==1)
	replace age_group=2 if (R05R_Y_AGECAT2==2 | X05R_Y_AGECAT2==2)
	label values age_group R05R_Y_AGECAT2
	tab age_group, m
	svy: tab age_group, se obs percent ci

***Sex***
tab sex, m
svy: tab sex, se obs percent ci

***Race / ethinicity***
tab race_baseline, m
svy: tab race_baseline, se obs percent ci

***Academic performance***
tab R05_PT0019, m
tab X05_PT0019, m

gen academic_performance=. 

	replace academic_performance=0 if (R05_PT0019==0 | X05_PT0019==0)
	replace academic_performance=1 if (R05_PT0019==1 | X05_PT0019==1)
	replace academic_performance=2 if (R05_PT0019==2 | X05_PT0019==2)
	label values academic_performance grades_label
	tab academic_performance, m
	
svy: tab academic_performance, se obs percent ci

***Household income***
tab R05R_Y_PM0130, m
tab X05R_Y_PM0130, m

gen income=. 
	replace income=1 if R05R_Y_PM0130==1 | X05R_Y_PM0130==1
	replace income=2 if R05R_Y_PM0130==2 | X05R_Y_PM0130==2
	replace income=3 if R05R_Y_PM0130==3 | X05R_Y_PM0130==3
	replace income=4 if R05R_Y_PM0130==4 | X05R_Y_PM0130==4
	replace income=5 if R05R_Y_PM0130==5 | X05R_Y_PM0130==5
	
svy: tab income, se obs percent ci
	
recode income (1/2=1) (3=2) (4=3) (5=4)
	
	label values income income1 
	tab income, m
	

***Parent education***
tab R05R_P_PARSP_EDUC, m
tab X05R_P_PARSP_EDUC, m

gen parent_education=.

	replace parent_education=0 if R05R_P_PARSP_EDUC==0 | X05R_P_PARSP_EDUC==0
	replace parent_education=1 if R05R_P_PARSP_EDUC==1 | X05R_P_PARSP_EDUC==1
	replace parent_education=2 if R05R_P_PARSP_EDUC==2 | X05R_P_PARSP_EDUC==2
	replace parent_education=3 if R05R_P_PARSP_EDUC==3 | X05R_P_PARSP_EDUC==3
	svy: tab parent_education, se obs percent ci

	recode parent_education (0=0) (1=1) (2/3=2)
	label define parent_edu_1 0 "0 = High school diploma or less" 1 "1 = Some college (no degree) or associate" 2 "2 = Bachelor degree or higher", replace
	label values parent_education parent_edu_1
	tab parent_education, m
	

	
****Parent vaping in p30d***
tab R05_PN0337_01, m
tab X05_PN0337_01, m

gen parent_vape=.

	replace parent_vape=0 if R05_PN0337_01==0 | X05_PN0337_01==0
	replace parent_vape=1 if R05_PN0337_01==1 | X05_PN0337_01==1
	label values parent_vape use_label
	tab parent_vape, m
	
	svy: tab parent_vape, se obs percent ci
	
***Parent smoking in p30d***
tab R05_PN0335_01, m
tab X05_PN0335_01, m

gen parent_smoke=.

	replace parent_smoke=0 if R05_PN0335_01==0 | X05_PN0335_01==0
	replace parent_smoke=1 if R05_PN0335_01==1 | X05_PN0335_01==1
	label values parent_smoke use_label
	tab parent_smoke, m
	
	svy: tab parent_smoke, se obs percent ci
	
	
***Peer vaping***
tab R05_YX0681, m
tab X05_YX0681, m

gen peer_vape=.

	replace peer_vape=0 if R05_YX0681==0 | X05_YX0681==0
	replace peer_vape=1 if R05_YX0681==1 | X05_YX0681==1
	replace peer_vape=2 if R05_YX0681==2 | X05_YX0681==2
	label values peer_vape peer_label
	svy: tab peer_vape, se obs percent ci
	
	recode peer_vape (0=0) (1/2=1)
	label values peer_vape use_label
	tab peer_vape, m
	
	
	
***Peer smoking***
tab R05_YX0680, m
tab X05_YX0680, m

gen peer_smoke=.

	replace peer_smoke=0 if R05_YX0680==0 | X05_YX0680==0
	replace peer_smoke=1 if R05_YX0680==1 | X05_YX0680==1
	replace peer_smoke=2 if R05_YX0680==2 | X05_YX0680==2
	
label values peer_smoke peer_label
	
	recode peer_smoke (0=0) (1/2=1)
	label values peer_smoke use_label
	tab peer_smoke, m
svy: tab peer_smoke, se obs percent ci

***Alcohol use in p30d***
tab R05_YX0673, m
tab X05_YX0673, m

gen alcohol_use=.

	replace alcohol_use=0 if R05_YX0673==0 | X05_YX0673==0
	replace alcohol_use=1 if R05_YX0673==1 | X05_YX0673==1
	label values alcohol_use use_label
	tab alcohol_use, m
	
svy: tab alcohol_use, se obs percent ci


***Unweighted % of baseline characteristics***
table1_mc, vars(age_group cat \ sex cat \ race cat \ academic_performance cat \ income cat \ parent_education cat \ parent_vape cat \ parent_smoke cat \peer_vape cat \ peer_smoke cat \ alcohol_use cat) missing



***E-cigarette use in w5***
svy: tab R05R_Y_EVR_EPRODS, se obs percent ci
svy: tab R05R_Y_P12M_EPRODS, se obs percent ci
svy: tab R05R_Y_CUR_EPRODS, se obs percent ci
svy: mean R05R_Y_NUMDAYS_EPRODS

***E-cigarette use in w5.5***
svy: tab X05R_Y_EVR_EPRODS, se obs percent ci
svy: tab X05R_Y_P12M_EPRODS, se obs percent ci
svy: tab X05R_Y_CUR_EPRODS, se obs percent ci
svy: mean X05R_Y_NUMDAYS_EPRODS

***E-cigarette use in w6***
svy:tab R06R_Y_EVR_EPRODS, se obs percent ci
svy: tab R06R_Y_P12M_EPRODS, se obs percent ci
svy: tab R06R_Y_CUR_EPRODS, se obs percent ci
svy: mean R06R_Y_NUMDAYS_EPRODS

***E-ciagrette use in w5 & or w5.5***

recode ever_baseline (0=0) (1/3=1)
label values ever_baseline use_label
tab ever_baseline, m
svy: tab ever_baseline, se obs percent ci

recode p12m_baseline (0=0) (1/3=1)
label values p12m_baseline use_label
tab p12m_baseline, m
svy: tab p12m_baseline, se obs percent ci

recode p30d_baseline (0=0) (1/3=1)
label values p30d_baseline use_label
tab p30d_baseline, m
svy: tab p30d_baseline, se obs percent ci

////////////////////////////////////////

***Exposure to ads in w5 & w5.5.***
svy: tab R05_YX0203_09, se obs percent ci
svy: tab X05_YX0203_09, se obs percent ci

**Exposure to ads in w5 and or w5.5**
recode exp_ads (0=0) (1/3=1)
label values exp_ads exp_ads_label
tab exp_ads, m
svy: tab exp_ads, se obs percent ci

***Exposure to ads in w6***
svy: tab R06_YX0203_10, se obs percent ci

svy: tab R06_YX0378_02, se obs percent ci

svy: tab R06_YX0372, se obs percent ci


***Save weighted PATH dataset***
save "06082024 weighted PATH", replace


///// MI MODEL 1: (social media exposure -> vaping) ///

use "06082024 weighted PATH", clear


**Only keep respondents that answer w6 vaping questions**

drop if (R06R_Y_EVR_EPRODS==. | R06R_Y_CUR_EPRODS==.)

codebook PERSONID

***n=5591 for model 1; missing from R06R_Y_NUMDAYS_EPRODS due to high number of missingness***

**Drop respondent who already vape at baseline (w5 / w5.5)**

drop if ever_baseline==1 

codebook PERSONID
***n = 4818 all are never user in w5.5 -> to track subsequent vape use on w6

***MI***
mi set wide

mi varying
**Do not have to use mi flong or flongsep**

mi register impute exp_ads X04R_Y_AGECAT2 X04R_Y_SEX race X04R_Y_RACECAT3 ///
X04_PT0019 income_quartiles X04R_P_PARSP_EDUC X04_PN0337_01 /// 
X04_PN0335_01 X04_YX0681 X04_YX0680 X04_YX0673 /// 
X05_YX0203_09 R05R_Y_AGECAT2 R05R_Y_SEX R05R_Y_RACECAT3 R05R_Y_HIS R05_PT0019 ///
R05R_Y_PM0130 R05R_P_PARSP_EDUC R05_PN0337_01 ///
R05_PN0335_01 R05_YX0681 R05_YX0680 R05_YX0673 /// 
age_group sex race_baseline ///
academic_performance income ///
parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use

**w6 vaping (outcome) variables removed**
mi impute chain (pmm, knn(20)) exp_ads ///
X04R_Y_AGECAT2 X04R_Y_SEX X04R_Y_RACECAT3 ///
X04_PT0019 income_quartiles X04R_P_PARSP_EDUC X04_PN0337_01 /// 
X04_PN0335_01 X04_YX0681 X04_YX0680 X04_YX0673 [pweight=R05_Y_AX04WGT],add(30) rseed(12345) noisily augment

save "07082024 imputated PATH model 1", replace


***Sensitivity models**
///1. w5/w5.5 -> w6 adjust w5/w5.5
mi impute chain (pmm, knn(20)) exp_ads age_group sex race_baseline ///
academic_performance income ///
parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use [pweight=R05_Y_AX04WGT],add(10) rseed(12345) noisily augment

save "sensitivity_analysis_model_1.0", replace


****************************************************************************************************************************************************************


//// MI MODEL 2: (vaping -> social media exposure) /////

use "06082024 weighted PATH", clear

drop if (R06_YX0203_10==. | R06_YX0372==.)

codebook PERSONID
**n=5566

**Drop respondent who exposed to ads at baseline (w5 / w5.5)**

drop if exp_ads==1 

codebook PERSONID

***MI***
mi set wide

mi varying
**Do not have to use mi flong or flongsep**

mi register impute ever_baseline p12m_baseline p30d_baseline /// 
X05R_Y_EVR_EPRODS X05R_Y_P12M_EPRODS X05R_Y_CUR_EPRODS ///
X04R_Y_EVR_EPRODS X04R_Y_P12M_EPRODS X04R_Y_CUR_EPRODS ///
X04R_Y_AGECAT2 X04R_Y_RACECAT3 X04R_Y_SEX race ///
X04_PT0019 income_quartiles X04R_P_PARSP_EDUC X04_PN0337_01 /// 
X04_PN0335_01 X04_YX0681 X04_YX0680 X04_YX0673 /// 
R05R_Y_AGECAT2 R05R_Y_SEX R05R_Y_RACECAT3 R05R_Y_HIS R05_PT0019 ///
R05R_Y_PM0130 R05R_P_PARSP_EDUC R05_PN0337_01 ///
R05_PN0335_01 R05_YX0681 R05_YX0680 R05_YX0673 /// 
age_group sex race_baseline ///
academic_performance income ///
parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use


**w5/w5.5 -> w6, adjusting w4.5**
**vaping not included as there's no missing**
mi impute chain (pmm, knn(20)) ever_baseline p12m_baseline p30d_baseline ///
X04R_Y_EVR_EPRODS X04R_Y_P12M_EPRODS X04R_Y_CUR_EPRODS ///
X04R_Y_AGECAT2 X04R_Y_SEX X04R_Y_RACECAT3 ///
X04_PT0019 income_quartiles X04R_P_PARSP_EDUC X04_PN0337_01 /// 
X04_PN0335_01 X04_YX0681 X04_YX0680 X04_YX0673 [pweight=R05_Y_AX04WGT],add(30) rseed(12345) noisily augment


save "07082024 imputated PATH model 2", replace



***Sensitivity models**
///1. w5/w5.5 -> w6 adjust w5/w5.5
mi impute chain (pmm, knn(20)) ever_baseline p12m_baseline p30d_baseline ///
X04R_Y_EVR_EPRODS X04R_Y_P12M_EPRODS X04R_Y_CUR_EPRODS ///
age_group sex race_baseline ///
academic_performance income ///
parent_education parent_vape parent_smoke ///
peer_vape peer_smoke alcohol_use [pweight=R05_Y_AX04WGT],add(10) rseed(12345) noisily augment

save "sensitivity_analysis_model_2.0", replace



/////////END OF DO FILE//////////////////////
