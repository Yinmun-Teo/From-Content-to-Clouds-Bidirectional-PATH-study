//////////////////////////////////////////////////////////////////////////

***Merge & data cleaning of w5, w5.5 & w6***
***Written by Yin Mun Teo***
***Date 22/4/2024***

//////////////////////////////////////////////////////////////////////////

***Check working directory***
pwd

cd "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files"


set maxvar 10000


***Open w5 dataset***
use "C:\Users\Acer\OneDrive - The University of Queensland\Desktop\Stata18\PATH\ICPSR_36498 (wave 5)\DS5002\36498-5002-Data.dta", clear


***Saving w5***
save w5_youth


***Open w5.5 dataset***
use "C:\Users\Acer\OneDrive - The University of Queensland\Desktop\Stata18\PATH\ICPSR_37786 (wave 5.5)\DS2002\37786-2002-Data.dta", clear


***Saving shorten w5.5***
save w5_5_youth


***Open w6 dataset***
use "C:\Users\Acer\OneDrive - The University of Queensland\Desktop\Stata18\PATH\ICPSR_36498 (wave 6)\DS6002\36498-6002-Data.dta", clear


***Saving shorten w6***
save w6_youth



///////////////////////////////////////////////////////////////////////

***Merge w5, w5.5 & w6***

***Use w5 dataset***
use "w5_youth", clear

***Merge w5.5 with PERSONID***
 merge 1:1 PERSONID using "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files\w5_5_youth.dta"
rename _merge _merge_w5point5

***Save merged w5 & w5.5 dataset***
save "w5_w5.5_youth", replace

***Merge w6 dataset using PERSONID***
 merge 1:1 PERSONID using "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files\w6_youth.dta"
tab _merge
***Keep only observations that are common in w5 & w5.5***
***Drop 51 observations that did not participate in w5 & / w5.5; as they cannot be imputed***
drop if _merge==2
rename _merge _merge_w5_to_w6
tab _merge_w5_to_w6, m


***Save final merged dataset***
save "w5_w5.5_w6_youth", replace

use "w5_w5.5_w6_youth", clear

///////////////////////////////////////////////////////////////////////////

***RECODE e-cigarette use***

label define use_label 0 "0 = No use" 1 "1 = Yes / use"

label define use_1 0 "0= no use / missing" 1 "1 = Use in w5 only" 2 "2 = Use in w5.5 only" 3 "3 = Use in w5 & w5.5"


***W5 & W6: lifetime use***

foreach x of numlist 5/6 {
		replace R0`x'R_Y_EVR_EPRODS=. if (R0`x'R_Y_EVR_EPRODS>=-99999 & R0`x'R_Y_EVR_EPRODS<=-1)
		replace R0`x'R_Y_EVR_EPRODS=0 if R0`x'R_Y_EVR_EPRODS==2
		replace R0`x'R_Y_EVR_EPRODS=1 if R0`x'R_Y_EVR_EPRODS==1
		label values R0`x'R_Y_EVR_EPRODS use_label
		tab R0`x'R_Y_EVR_EPRODS, m
}

***Missing values in w6_ever_use***
tab R06R_Y_EVR_EPRODS R06R_Y_P12M_EPRODS, m
tab R06R_Y_EVR_EPRODS R06R_Y_CUR_EPRODS, m

//RECODE missing ever use based on p12m & p30d
replace R06R_Y_EVR_EPRODS=0 if (R06R_Y_EVR_EPRODS==. & R06R_Y_P12M_EPRODS==0 |R06R_Y_EVR_EPRODS==.& R06R_Y_CUR_EPRODS==0)

tab R06R_Y_EVR_EPRODS, m
tab R06R_Y_EVR_EPRODS R06R_Y_P12M_EPRODS, m
tab R06R_Y_EVR_EPRODS R06R_Y_CUR_EPRODS, m

***W5.5: lifetime use***
recode X05R_Y_EVR_EPRODS (2 = 0) (1 = 1)
label values X05R_Y_EVR_EPRODS use_label
tab X05R_Y_EVR_EPRODS, m

***Missing values in w5_ever_use***
tab X05R_Y_EVR_EPRODS X05R_Y_P12M_EPRODS, m
tab X05R_Y_EVR_EPRODS X05R_Y_CUR_EPRODS, m

//RECODE missing ever use based on p12m & p30d
replace X05R_Y_EVR_EPRODS=0 if (X05R_Y_EVR_EPRODS==. & X05R_Y_P12M_EPRODS==0 |X05R_Y_EVR_EPRODS==.& X05R_Y_CUR_EPRODS==0)

tab X05R_Y_EVR_EPRODS X05R_Y_P12M_EPRODS, m
tab X05R_Y_EVR_EPRODS X05R_Y_CUR_EPRODS, m


***Lifetime vaping in either w5 / w5.5***
gen ever_baseline=.
	replace ever_baseline=1 if (R05R_Y_EVR_EPRODS==1 & X05R_Y_EVR_EPRODS!=1)
	replace ever_baseline=2 if (R05R_Y_EVR_EPRODS!=1 & X05R_Y_EVR_EPRODS==1)
	replace ever_baseline=3 if (R05R_Y_EVR_EPRODS==1 & X05R_Y_EVR_EPRODS==1)
	replace ever_baseline=0 if (R05R_Y_EVR_EPRODS==0 & X05R_Y_EVR_EPRODS==0)
	replace ever_baseline=0 if (R05R_Y_EVR_EPRODS==0 & X05R_Y_EVR_EPRODS==.)
	replace ever_baseline=0 if (R05R_Y_EVR_EPRODS==. & X05R_Y_EVR_EPRODS==0)
	replace ever_baseline=. if (R05R_Y_EVR_EPRODS==. & X05R_Y_EVR_EPRODS==.)
	label values ever_baseline use_1
	tab ever_baseline, m
	
	
***W5 & W6: past 12 months use***

foreach x of numlist 5/6 {
		replace R0`x'R_Y_P12M_EPRODS=. if (R0`x'R_Y_P12M_EPRODS>=-99999 & R0`x'R_Y_P12M_EPRODS<=-1)
		replace R0`x'R_Y_P12M_EPRODS=0 if R0`x'R_Y_P12M_EPRODS==2
		replace R0`x'R_Y_P12M_EPRODS=1 if R0`x'R_Y_P12M_EPRODS==1
		label values R0`x'R_Y_P12M_EPRODS use_label
		tab R0`x'R_Y_P12M_EPRODS, m
}

***W5.5: past 12 months use***
recode X05R_Y_P12M_EPRODS (2 = 0) (1 = 1)
label values X05R_Y_P12M_EPRODS use_label
tab X05R_Y_P12M_EPRODS, m

***past 12m vaping in either w5 / w5.5***
gen p12m_baseline=.
	replace p12m_baseline=1 if (R05R_Y_P12M_EPRODS==1 & X05R_Y_P12M_EPRODS!=1)
	replace p12m_baseline=2 if (R05R_Y_P12M_EPRODS!=1 & X05R_Y_P12M_EPRODS==1)
	replace p12m_baseline=3 if (R05R_Y_P12M_EPRODS==1 & X05R_Y_P12M_EPRODS==1)
	replace p12m_baseline=0 if (R05R_Y_P12M_EPRODS==0 & X05R_Y_P12M_EPRODS==0)
	replace p12m_baseline=0 if (R05R_Y_P12M_EPRODS==0 & X05R_Y_P12M_EPRODS==.)
	replace p12m_baseline=0 if (R05R_Y_P12M_EPRODS==. & X05R_Y_P12M_EPRODS==0)
	replace p12m_baseline=. if (R05R_Y_P12M_EPRODS==. & X05R_Y_P12M_EPRODS==.)
	label values p12m_baseline use_1
	tab p12m_baseline, m

***W5 & W6: current (past 30d) use***
foreach x of numlist 5/6 {
		replace R0`x'R_Y_CUR_EPRODS=. if (R0`x'R_Y_CUR_EPRODS>=-99999 & R0`x'R_Y_CUR_EPRODS<=-1)
		replace R0`x'R_Y_CUR_EPRODS=0 if R0`x'R_Y_CUR_EPRODS==2
		replace R0`x'R_Y_CUR_EPRODS=1 if R0`x'R_Y_CUR_EPRODS==1
		label values R0`x'R_Y_CUR_EPRODS use_label
		tab R0`x'R_Y_CUR_EPRODS, m
}

***W5.5: current (past 30d) use***
recode X05R_Y_CUR_EPRODS (2 = 0) (1 = 1)
label values X05R_Y_CUR_EPRODS use_label
tab X05R_Y_CUR_EPRODS, m

***past 30d vaping in either w5 / w5.5***
gen p30d_baseline=.
	replace p30d_baseline=1 if (R05R_Y_CUR_EPRODS==1 & X05R_Y_CUR_EPRODS!=1)
	replace p30d_baseline=2 if (R05R_Y_CUR_EPRODS!=1 & X05R_Y_CUR_EPRODS==1)
	replace p30d_baseline=3 if (R05R_Y_CUR_EPRODS==1 & X05R_Y_CUR_EPRODS==1)
	replace p30d_baseline=0 if (R05R_Y_CUR_EPRODS==0 & X05R_Y_CUR_EPRODS==0)
	replace p30d_baseline=0 if (R05R_Y_CUR_EPRODS==0 & X05R_Y_CUR_EPRODS==.)
	replace p30d_baseline=0 if (R05R_Y_CUR_EPRODS==. & X05R_Y_CUR_EPRODS==0)
	replace p30d_baseline=. if (R05R_Y_CUR_EPRODS==. & X05R_Y_CUR_EPRODS==.)
	label values p30d_baseline use_1
	tab p30d_baseline, m
	
***W5, W5.5 & W6: frequency of vaping***
recode R05R_Y_NUMDAYS_EPRODS (-99999 / -97777 = .)
sum R05R_Y_NUMDAYS_EPRODS, d

sum X05R_Y_NUMDAYS_EPRODS, d

sum R06R_Y_NUMDAYS_EPRODS, d


***RECODE exposure to ads***

label define exp_ads_label 0 "0 = No exposure" 1 "1 = Exposed"

label define exp_1 0 "0 = not exposed / missing" 1 "1 = Exposed in w5 only" 2 "2 = Exposed in w5.5 only" 3 "3 = Exposed in w5 & w5.5"

***W5: expose to ENDS ads on websites / social media in past 30d*** 
recode R05_YX0203_09 (2 = 0) (1 = 1) (-8/-7=.)
label values R05_YX0203_09 exp_ads_label
tab R05_YX0203_09, m

***W5.5: expose to ENDS ads on websites / social media in past 30d*** 
recode X05_YX0203_09 (2 = 0) (1 = 1) (-8/-7=.)
label values X05_YX0203_09 exp_ads_label
tab X05_YX0203_09, m

***Exposure to ads variable either w5 / w5.5***
gen exp_ads=. 
	replace exp_ads=1 if (R05_YX0203_09==1 & X05_YX0203_09!=1)
	replace exp_ads=2 if (R05_YX0203_09!=1 & X05_YX0203_09==1)
	replace exp_ads=3 if (R05_YX0203_09==1 & X05_YX0203_09==1)
	replace exp_ads=0 if (R05_YX0203_09==0 & X05_YX0203_09==0)
		replace exp_ads=0 if (R05_YX0203_09==0 & X05_YX0203_09==.)
		replace exp_ads=0 if (R05_YX0203_09==. & X05_YX0203_09==0)
	replace exp_ads=. if (R05_YX0203_09==. & X05_YX0203_09==.)
	label values exp_ads exp_1
	tab exp_ads, m


***W6: expose to ENDS ads social media in past 30d***
recode R06_YX0203_10 (2 = 0) (1 = 1) (-8/-7=.)
label values R06_YX0203_10 exp_ads_label
tab R06_YX0203_10, m


***W6: seen ENDS on social media in p30d***
recode R06_YX0378_02 (-8/-7=.) (1=1) (2=0)

replace R06_YX0378_02=0 if (R06_YX0062==2 | R06_YX0062==-8 | R06_YX0062==-7)

replace R06_YX0378_02=0 if (R06_YX0372==1 | R06_YX0372==-7 | R06_YX0372==-8)

label values R06_YX0378_02 exp_ads_label
tab R06_YX0378_02, m


***W6: expose to tobacco products on social media in past 30d***
tab R06_YX0372, m

	replace R06_YX0372=0 if (R06_YX0372==1 | R06_YX0062==2 | R06_YX0062==-8 | R06_YX0062==-7)
	replace R06_YX0372=1 if (R06_YX0372==2 | R06_YX0372==3) 
	replace R06_YX0372=2 if (R06_YX0372==4 | R06_YX0372==5) 
	replace R06_YX0372=3 if (R06_YX0372==6 | R06_YX0372==7)
	replace R06_YX0372=. if (R06_YX0372==-8 | R06_YX0372==-7)
	label define cat_label 0 "0 = Never in the past 30 days" 1 "1 = About few times in the past 30 days" 2 "2 = About a few times a week in the past 30 days" 3 "3 = About daily"
label values R06_YX0372 cat_label

tab R06_YX0372, m


/////////////////////////////////////////////////////

***RECODE covariates***

***Age group***
foreach x of numlist 5/6 {
	tab R0`x'R_Y_AGECAT2, m
}

tab X05R_Y_AGECAT2, m


***W5, W5.5 & W6: Sex***
label define sex_label 0 "0 = Male" 1 "1 = Female"

recode R05R_Y_SEX (-100000000/-1 = .)

generate sex= .
	replace sex = 0 if R05R_Y_SEX == 1
	replace sex = 1 if R05R_Y_SEX == 2
	replace sex = 0 if X05R_Y_SEX == 1
	replace sex = 1 if X05R_Y_SEX == 2
	replace sex = 0 if R06R_Y_SEX == 1
	replace sex = 1 if R06R_Y_SEX == 2

label values sex sex_label 
tab sex, m

***W5 & W5.5: Ethinicity & race***
label define race_label 0 "0 = White only" 1 "1 = Black only" 2 "2 = Other", replace 

generate race_baseline = .
	replace race_baseline = 0 if (X05R_Y_RACECAT3 == 1 | R05R_Y_RACECAT3 == 1)
	replace race_baseline = 1 if (X05R_Y_RACECAT3 == 2 | R05R_Y_RACECAT3 == 2)
	replace race_baseline = 2 if (X05R_Y_RACECAT3 == 3 | R05R_Y_RACECAT3 == 3)

label values race_baseline race_label
tab race_baseline, m

***W5, W5.5 & W6: Academic performance***
label define grades_label 0 "0 = Above Average / Excellent (A's & B's)" 1 "1 = Average (B's to C's)" 2 "2 = Below Average (C's & D's to F's)", replace

recode R05_PT0019 (-8/-1=.) (10=.) (1/2=0) (3/5=1) (6/9=2)
label values R05_PT0019 grades_label
tab R05_PT0019, m

recode X05_PT0019 (-8/-1=.) (10=.) (1/2=0) (3/5=1) (6/9=2)
label values X05_PT0019 grades_label
tab X05_PT0019, m

recode R06_PT0019 (-8/-1=.) (10=.) (1/2=0) (3/5=1) (6/9=2)
label values R06_PT0019 grades_label
tab R06_PT0019, m

///FYI ungraded students were coded to missing

***W5, W5.5 & W6: Annual household income***
recode R05R_Y_PM0130 (-99999/-99911=.)
tab R05R_Y_PM0130, m
tab X05R_Y_PM0130, m
tab R06R_Y_PM0130, m

***W5, W5.5 & W6: Highest parent's education***
label define edu_label 0 "0 = High school diploma or less" 1 "1 = Some college (no degree) or associate" 2 "2 = Bachelor's degree" 3 " 3 = Advanced degree"

recode R05R_P_PARSP_EDUC (-99999/-99911=.) (1/3=0) (4=1) (5=2) (6=3)
label values R05R_P_PARSP_EDUC edu_label
tab R05R_P_PARSP_EDUC, m

recode X05R_P_PARSP_EDUC (1/3=0) (4=1) (5=2) (6=3)
label values X05R_P_PARSP_EDUC edu_label
tab X05R_P_PARSP_EDUC, m

recode R06R_P_PARSP_EDUC (1/3=0) (4=1) (5=2) (6=3)
label values R06R_P_PARSP_EDUC edu_label
tab R06R_P_PARSP_EDUC, m


***W5 & W6: parental vaping in past 30d***
foreach x of numlist 5/6 {
	recode R0`x'_PN0337_01 (-9/-1=.) (1=1) (2=0)
	label values R0`x'_PN0337_01 use_label
	tab R0`x'_PN0337_01, m
}
//Skip logic applied here; however unable to resolve inapplicable repsondents

***W5.5: parental vaping in past 30d***
recode X05_PN0337_01 (-1=.) (1=1) (2=0)
label values X05_PN0337_01 use_label
tab X05_PN0337_01, m
//same skip logic applied & similarily unresolvable

***W5 & W6: parental smoking in past 30d***
foreach x of numlist 5/6 {
	recode R0`x'_PN0335_01 (-9/-1=.) (1=1) (2=0)
	label values R0`x'_PN0335_01 use_label
	tab R0`x'_PN0335_01, m
}
//same skip logic applied & similarily unresolvable

***W5.5: parental smoking in past 30d***
recode X05_PN0335_01 (-1=.) (1=1) (2=0)
label values X05_PN0335_01 use_label
tab X05_PN0335_01, m
//same skip logic applied & similarily unresolvable

***RECODE peer vaping***
label define peer_label 0 "0 = None" 1 "1 = Some" 2 "2 = Most", replace

***W5 & W6: peer vaping***
foreach x of numlist 5/6 {
	recode R0`x'_YX0681 (-9/-1=.) (1=0) (2/3 = 1) (4/5 = 2)
	label values R0`x'_YX0681 peer_label
	tab R0`x'_YX0681, m
}

***W5.5: peer vaping***
recode X05_YX0681 (-9/-1=.) (1=0) (2/3 = 1) (4/5 = 2)
label values X05_YX0681 peer_label
tab X05_YX0681, m

***W5 & W6: peer smoking***
foreach x of numlist 5/6 {
	recode R0`x'_YX0680 (-9/-1=.) (1=0) (2/3 = 1) (4/5 = 2)
	label values R0`x'_YX0680 peer_label
	tab R0`x'_YX0680, m
}

***W5.5: peer smoking***
recode X05_YX0680 (-9/-1=.) (1=0) (2/3 = 1) (4/5 = 2)
label values X05_YX0680 peer_label
tab X05_YX0680, m

///RECODE: alcohol use///

***W5 & W5.5: alcohol use in past 30d***
replace R05_YX0673=0 if R05_YX0084_NB==2 /// asking new youths

replace R05_YX0673=0 if R05_YX0084_12M==2 /// asking new & continuing youths

recode R05_YX0673 (-8/-1=.) (1=1) (2=0)
label values R05_YX0673 use_label
tab R05_YX0673, m

replace X05_YX0673=0 if X05_YX0084_NB==2
replace X05_YX0673=0 if X05_YX0084_12M==2
recode X05_YX0673 (-8/-1=.) (1=1) (2=0)
label values X05_YX0673 use_label
tab X05_YX0673, m


///RECODE: cannabis use///

***W5 & W5.5: cannabis use in the past 30d***
	replace R05_YX0675 = 0 if (R05_YX0085_NB==2 & R05_YOUTHTYPE != 1) 
	replace R05_YX0675 = 0 if (R05_YX0085_12M==2)
	
//Realized there are 'jumping' respondents: respondents that answered NO in a previous question but answered YES for cannabis use in p30d //

//So 'jumping' respondents will be force recoded into YES for cannabis use in p30d //

**Troublesome variables**
	replace R05_YX0675 = 0 if (R05_YG9105_NB == 2 & R05_YOUTHTYPE != 1 & R05_YX0675 != 1)

	replace R05_YX0675 = 0 if (R05_YH9031 == 2 & R05_YOUTHTYPE != 1 & R05_YX0675 != 1)
	
	replace R05_YX0675 = 0 if (R05_YV9042 == 2 & R05_YOUTHTYPE != 1 & R05_YX0675 != 1) 

	replace R05_YX0675 = 0 if (R05_YG9107 == 2 & R05_YOUTHTYPE != 1 & R05_YX0675 != 1)
	
	replace R05_YX0675 = 0 if (R05_YG9107 == 2 & R05_YOUTHTYPE==1 & R05_YX0675 != 1)
	
recode R05_YX0675 (1=1) (2=0) (-1=.)
label values R05_YX0675 use_label
tab R05_YX0675, m



	replace X05_YX0675 = 0 if (X05_YX0085_NB==2 & X05_YOUTHTYPE != 1) 
	replace X05_YX0675 = 0 if (X05_YX0085_12M==2)
	replace X05_YX0675 = 0 if (X05_YG9105_NB == 2 & X05_YOUTHTYPE != 1 & X05_YX0675 != 1)

	replace X05_YX0675 = 0 if (X05_YH9031 == 2 & X05_YOUTHTYPE != 1 & X05_YX0675 != 1)
	
	replace X05_YX0675 = 0 if (X05_YV9042 == 2 & X05_YOUTHTYPE != 1 & X05_YX0675 != 1) 

	replace X05_YX0675 = 0 if (X05_YG9107 == 2 & X05_YOUTHTYPE != 1 & X05_YX0675 != 1)
	
	replace X05_YX0675 = 0 if (X05_YG9107 == 2 & X05_YOUTHTYPE==1 & X05_YX0675 != 1)

recode X05_YX0675 (1=1) (2=0) (-9/-1=.)
label values X05_YX0675 use_label
tab X05_YX0675, m

//Skip logic applied here; however unable to resolve all inapplicable repsondents, hence consider missing 


////////////////////////////////////////

****Save cleaned w5, w5.5 & w6 datatset***
save "26072024 cleaned PATH",replace


//////////////////////////////////TEMPORAL SEQUENCE/////////////////////

***Adjusting with W4.5 will result in less missing** 

**Open and save W4.5 dataset**
use "C:\Users\Acer\OneDrive - The University of Queensland\Desktop\Stata18\PATH\ICPSR_37786 (wave 4.5)\DS1002\37786-1002-Data.dta", clear

save "w4.5_youth"

use "26072024 cleaned PATH", clear


**Combine w4.5 & Master file**
merge 1:1 PERSONID using "C:\Users\Acer\OneDrive - The University of Queensland\Documents\UQ\Dissertation\Submission\Data analysis\STATA files\w4.5_youth"

rename _merge _merge_w4_5
**Master = w5_w5.5_w6**

**RECODE W4 COVARIATES**
tab X04R_Y_AGECAT2, m

recode X04R_Y_SEX (-99999/-99977=.)
label values X04R_Y_SEX sex_label 
tab X04R_Y_SEX, m

***Combine Ethinicity & race***
recode X04R_Y_HISP (-99999/-99977=.)
label define race_label 0 "0 = Non-Hispanic White" 1 "1 = Non-Hispanic African" 2 "2 = Hispanic" 3 "3 = Non-Hispanic Other"

generate race = .
	replace race = 0 if (X04R_Y_HISP == 2 & X04R_Y_RACECAT3 == 1)
replace race = 1 if (X04R_Y_HISP == 2 & X04R_Y_RACECAT3 == 2)
replace race = 2 if (X04R_Y_HISP == 1)
replace race = 3 if (X04R_Y_HISP == 2 & X04R_Y_RACECAT3 == 3)
label values race race_label
tab race, m

recode X04_PT0019 (-8/-1=.) (10=.) (1/2=0) (3/5=1) (6/9=2)
label values X04_PT0019 grades_label
tab X04_PT0019, m

recode X04R_Y_PM0130 (-99999/-99911=.)
tab X04R_Y_PM0130, m

recode X04R_P_PARSP_EDUC (-99999/-99911=.) (1/3=0) (4=1) (5=2) (6=3)
label values X04R_P_PARSP_EDUC edu_label
tab X04R_P_PARSP_EDUC, m

recode X04_PN0337_01 (-9/-1=.) (1=1) (2=0)
label values X04_PN0337_01 use_label
tab X04_PN0337_01, m

recode X04_PN0335_01 (-9/-1=.) (1=1) (2=0)
label values X04_PN0335_01 use_label
tab X04_PN0335_01, m

recode X04_YX0681 (-8/-7=.) (1=0) (2/3 = 1) (4/5 = 2)
label values X04_YX0681 peer_label
tab X04_YX0681, m

recode X04_YX0680 (-8/-7=.) (1=0) (2/3 = 1) (4/5 = 2)
label values X04_YX0680 peer_label
tab X04_YX0680, m

replace X04_YX0673=0 if X04_YX0084_NB==2
replace X04_YX0673=0 if X04_YX0084_12M==2
recode X04_YX0673 (-8/-1=.) (1=1) (2=0)
label values X04_YX0673 use_label
tab X04_YX0673, m

**Cannabis use not included as covariate**

save "05082024 cleaned PATH", replace

