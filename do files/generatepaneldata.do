// GENERATE PANEL DATA 
//
//
// generatedatapanel.do
//
// created by Dylan Bollard - 03/05/2021
// 
//
// The purpose of this program is to create five other sets of data for use with 
// the EC 571 final project to analyze how grades have been affected by online
// learning. 
//
// By creating six data sets, it'll be possible to create a panel data set and
// utilize more recent tools from the class to derive trends over time.
//
// Can use the same generatedata.do file to create five more data sets. Then, 
// save and merge them into one panel set. 

// CREATE FIVE MORE DATA SETS \\ 
* would write a if/then counter to do this, but can't figure out how to do a loop
* in Stata

cls
*~~~~~ FIRST ~~~~~~*
drop _all
do generatedata.do
generate paneldata = 1
sort studentID

export excel using "paneldata1.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldata1.dta", replace

*~~~~~ SECOND ~~~~~*
drop _all
do generatedata.do
generate paneldata = 2
sort studentID

export excel using "paneldata2.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldata2.dta", replace

*~~~~~ THIRD ~~~~~*
drop _all
do generatedata.do
generate paneldata = 3
sort studentID

export excel using "paneldata3.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldata3.dta", replace

*~~~~~ FOURTH ~~~~~*
drop _all
do generatedata.do
generate paneldata = 4
sort studentID

export excel using "paneldata4.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldata4.dta", replace

*~~~~~ FIFTH ~~~~~*
drop _all
do generatedata.do
generate paneldata = 5
sort studentID

export excel using "paneldata5.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldata5.dta", replace

drop _all 
use "generateddataset.dta"
generate paneldata = 0
sort studentID

// MERGE THEM \\
append using paneldata1
append using paneldata2
append using paneldata3 
append using paneldata4 
append using paneldata5 
sort studentID

// EXPORT NEW PANEL DATA SHEET \\
export excel using "paneldataset.xlsx", replace
save "/Users/dylanbollard/Desktop/ec571project/paneldataset.dta", replace
