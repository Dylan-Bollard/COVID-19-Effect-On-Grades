// REGRESSIONS 
//
//
// regress.do
//
// created by Dylan Bollard - 03/06/2021
// 
//
// The purpose of this program is to create and export regressions for analysis
// in the EC 571 final paper. There are two options built into this program, 
// 
// i) PART 1 - regressions for non-panel data
// ii) PART II - regressions for panel data
//
// This division was implemented to ensure that data problems arising in the panel data 
// can be traced back and solved at the single time period level. It was also
// created so that future use of the data set or examples could be applied for
// more topics.

// PART I - Single Time Period Regressions \\
* to run this part of the code, ensure the proper data set is loaded *
drop _all
use "generateddataset.dta"
// Don't forget to run realresults.do, realpanelresults.do first.

cd "regressoutput"

// SCHOOL/LOCAL Level Regressions ; OLS\\
regress mathscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc readingscore writingscore
estat hettest
outreg2 using lmathall, tex replace

regress readingscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc mathscore writingscore
estat hettest
outreg2 using lreadingall, tex replace

regress writingscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc readingscore mathscore
estat hettest
outreg2 using lwritingall, tex replace


// STATE Level Regressions \\
regress mathscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc readingscoreSL writingscoreSL
outreg2 using slmathall, tex replace

regress readingscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc mathscoreSL writingscoreSL
outreg2 using slreadingall, tex replace

regress writingscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc##i.mothereduc readingscoreSL mathscoreSL
outreg2 using slwritingall, tex replace


// PART II - Panel Data Regressions \\
//
// Interestingly, the data was constructed such that multicollinearity is a 
// problem in the fixed-effects panel models. So fixed-effects are not interesting.
// Actually can't even use the Hausman test because the asymptotic assumptions
// of the Hausman test are not met by the generated data.


* to run this part of the code, ensure the proper data set is loaded *
drop _all
cd ..
use "paneldataset.dta"
cd "regressoutputpanel"
* do realresults.do 
* do panelrealresults.do


xtset, clear
xtset studentID timeperiod 

// SCHOOL/LOCAL Level Panel Regressions \\
xtreg mathscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc readingscore writingscore timeperiod, re
outreg2 using lpmathall, tex replace 

xtreg readingscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc mathscore writingscore timeperiod, re
outreg2 using lpreadingall, tex replace 

xtreg writingscore school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc readingscore mathscore timeperiod, re
outreg2 using lpwritingall, tex replace 

// STATE Level Panel Regressions \\
xtreg mathscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc readingscoreSL writingscoreSL timeperiod, re
outreg2 using slpmathall, tex replace 

xtreg readingscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc mathscoreSL writingscoreSL timeperiod, re
outreg2 using slpreadingall, tex replace 

xtreg writingscoreSL school i.gradelevel gender covidpos householdincome freelunch familysize i.fathereduc i.mothereduc readingscoreSL mathscoreSL timeperiod, re
outreg2 using slpwritingall, tex replace 
