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

/// DOSE-RESPONSE ASSOCIATION ///

**UNADJUSTED**

***Lifetime***

mi estimate, or: svy: ologit 
freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.ever_baseline

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.ever_baseline

mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.ever_baseline


**Past 12 months**
mi estimate, or: svy: ologit 
freq_dummy2 i.freq_dummy3 i.freq_dummy4 i.p12m_baselinew

mi estimate, or: svy: ologit freq_dummy3 i.freq_dummy2 i.freq_dummy4 i.p12m_baseline

mi estimate, or: svy: ologit freq_dummy4 i.freq_dummy3 i.freq_dummy2 i.p12m_baseline