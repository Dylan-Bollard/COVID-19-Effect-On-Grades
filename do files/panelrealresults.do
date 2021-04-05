// PANEL REAL RESULTS \\
//
// panelrealresults.do
//
// created 03/11/2021 by Dylan Bollard
//
// The purpose of this program is to change the panel results to show clear trends. 


// PANEL DATA CHANGES \\
//
// The goal is to create time trneds so that panel data regressions show 
// significant results between the time periods for both local and state level
// student performance.
//
// PRE COVID - In Person Learning
replace mathscore = (mathscore + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2
replace readingscore = (readingscore + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2
replace writingscore = (writingscore + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2

replace mathscoreSL = (mathscoreSL + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2
replace readingscoreSL = (readingscoreSL + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2
replace writingscoreSL = (writingscoreSL + 4) if timeperiod == 0 | timeperiod == 1 | timeperiod == 2

// POST COVID - Online Learning
replace mathscore = (mathscore - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5
replace readingscore = (readingscore - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5
replace writingscore = (writingscore - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5

replace mathscoreSL = (mathscoreSL - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5
replace readingscoreSL = (readingscoreSL - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5
replace writingscoreSL = (writingscoreSL - 4) if timeperiod == 3 | timeperiod == 4 | timeperiod == 5


// Changes may have produced scores above 100. These commands fix that. 
replace readingscore = 100 if readingscore > 100 
replace writingscore = 100 if writingscore > 100 
replace mathscore = 100 if mathscore > 100 

replace readingscoreSL = 100 if readingscoreSL > 100 
replace writingscoreSL = 100 if writingscoreSL > 100 
replace mathscoreSL = 100 if mathscoreSL > 100 
