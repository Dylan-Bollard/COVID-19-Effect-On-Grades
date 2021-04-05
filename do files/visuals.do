// VISUALS
//
// visuals.do
//
// created by Dylan Bollard - 02/27/2021
// 
//
// The purpose of this program is to present visuals to help analyze the 
// relationships between variables. Essentially, regression diagnostics. 


*~~~~ general summary ~~~~*
summarize

//~~~~~~~~~~~~~~~~~~~~~~~~ INTERACTION OF SCORES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// INTERACTION BETWEEN SCORES \\
*~~~~ graph in matrix ~~~~*
graph matrix mathscoreSL readingscoreSL writingscoreSL
// obvious trends between readingscoreSL and writingscoreSL 



//~~~~~~~~~~~~~~~~~~~~~~~~~~ SCORE TRENDS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// STATE LEVEL TRENDS IN SCORE \\
scatter mathscoreSL studentID || lfit mathscoreSL studentID
scatter writingscoreSL studentID || lfit mathscoreSL studentID
scatter readingscoreSL studentID || lfit mathscoreSL studentID
// clear trends showing different schools will produce different results on the 
// state level exam


// LOCAL/SCHOOL LEVEL TRENDS IN SCORE \\
scatter mathscore studentID || lfit mathscore studentID
scatter writingscore studentID || lfit mathscore studentID
scatter readingscore studentID || lfit mathscore studentID
// again, clear trends



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ERRORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
regress mathscoreSL i.mothereduc i.fathereduc school gender covidpos freelunch numcomputers familysize i.grade
predict regresid, rstudent
stem regresid
// nasty, nasty residuals

kdensity regresid, normal
// residuals are approximately normal, but not perfectly

pnorm regresid 
drop regresid 



// Dylan Generated Trends In Data \\
scatter householdincome mathscoreSL || lfit householdincome mathscoreSL

* could play around in here looking at data for awhile *
* easy to see linearity assumption is met though *

graph matrix mathscoreSL readingscore writingscore 

* etc...
