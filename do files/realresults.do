// REAL RESULTS 
//
//
// realresults.do
//
// created by Dylan Bollard - 02/27/2021
// 
//
// The purpose of this program is to alter the data made previously in 
// generatedata.do in order to realize interesting regression results, and have
// a reasonable analysis of the model in general.
//
// Although an instrumental variable would be helpful in the analysis, generating
// something fitting the necessary conditions is frankly, beyond me. 


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// STUDENT ID \\
//
// This variable says nothing about the regression and is not included in any 
// calculations. Simply meant to aid in data creation. 


// SCHOOL \\
/* 

This variable should have a lot of explanatory power, as the data is generated 
to support this conclusion. In the initial regression, this was the only variable
with a significant p-value. It is omitted from being changed unless other corrections
are going to change it. Also, want to show that students from poor community 
perform noticeably worse on state level exams.
*/ 
replace mathscore = (mathscoreSL - 1) if school == 1
replace readingscore = (readingscoreSL - 1) if school == 1
replace writingscore = (writingscoreSL - 1) if school == 1

replace mathscoreSL = (mathscoreSL - 1) if school == 1
replace readingscoreSL = (readingscoreSL - 1) if school == 1
replace writingscoreSL = (writingscoreSL - 1) if school == 1


// GRADE LEVEL \\ 
/*

Grade level should have an effect on exams, if the exam didn't scale in difficulty. 
We assume that these "fake exams" scale in difficulty though. Also, want to show
that students from poor community perform noticeably worse on state level exams.
*/


// GENDER \\
/* 

It would be interesting if we realized real results for the difference in gender.
Let's assume that men perform worse at the school level, but not at the state
level. 

Also let's say men perform better at the state level.
*/
replace mathscore = (mathscore - 2) if gender == 1
replace readingscore = (readingscore - 2) if gender == 1
replace writingscore = (writingscore - 2) if gender == 1

replace mathscoreSL = (mathscoreSL + 3) if gender == 1
replace readingscoreSL = (readingscoreSL + 3) if gender == 1
replace writingscoreSL = (writingscoreSL + 3) if gender == 1

// Then, gender becomes significant. This now shows that men perform worse at
// the school level but better at the state level.


// COVIDPOS \\
/*

Considering the thesis behind the paper was trying to discern if covid had an
impact on student perofrmance, it would make sense that covidpos should significant.
Then we could say that the illness had an effect on online learning. Also want to
show grade inflation though 
*/
replace mathscore = (mathscore - 2) if covidpos == 1
replace readingscore = (readingscore - 2) if covidpos == 1
replace writingscore = (writingscore - 2) if covidpos == 1

replace mathscoreSL = (mathscoreSL - 3) if covidpos == 1
replace readingscoreSL = (readingscoreSL - 3) if covidpos == 1
replace writingscoreSL = (writingscoreSL - 3) if covidpos == 1


// FREELUNCH \\ 
/*

Traditionally, those students who would be on the free and reduced lunch program
would come families with lower household incomes. Then, it would make sense for
the variable to be significant, and, to be negative. However, if at the school
level it were positive, it would give reason to increase availability for students.
*/
replace mathscore = (mathscore + 4) if freelunch == 1
replace readingscore = (readingscore + 4) if freelunch == 1
replace writingscore = (writingscore + 4) if freelunch == 1

replace mathscoreSL = (mathscoreSL - 3) if freelunch == 1
replace readingscoreSL = (readingscoreSL - 3) if freelunch == 1
replace writingscoreSL = (writingscoreSL - 3) if freelunch == 1


// HOUSEHOLD INCOME \\
/*

It would make sense that if household income were higher, state scores would be
higher. So, if household income is in the top 25%, then state scores are raised.
If household income is in the bottom 25%, state scores are lowered.
*/

*~~~~~ TOP 25% ~~~~~*
sum householdincome, detail
gen top = r(p75)

replace mathscore = (mathscore + 4) if householdincome >= top
replace readingscore = (readingscore + 4) if householdincome >= top
replace writingscore = (writingscore + 4) if householdincome >= top

replace mathscoreSL = (mathscoreSL + 4) if householdincome >= top
replace readingscoreSL = (readingscoreSL + 4) if householdincome >= top
replace writingscoreSL = (writingscoreSL + 4) if householdincome >= top


*~~~~~ BOTTOM 25% ~~~~~*
sum householdincome, detail
gen bottom = r(p25)

replace mathscore = (mathscore - 2) if householdincome <= bottom 
replace readingscore = (readingscore - 2) if householdincome <= bottom 
replace writingscore = (writingscore - 2) if householdincome <= bottom
 
replace mathscoreSL = (mathscoreSL - 2) if householdincome <= bottom 
replace readingscoreSL = (readingscoreSL - 2) if householdincome <= bottom 
replace writingscoreSL = (writingscoreSL - 2) if householdincome <= bottom

*~~~~ drop irrelevant variables ~~~~*
drop top bottom


// FAMSIZE \\
/*

It makes sense that as family size grows, grades would be negatively affected since
parents would have less time and other resources to spend on each child. 
*/

replace mathscore = (mathscore - 1.5) if familysize >= 3
replace readingscore = (readingscore - 1.5) if familysize >= 3
replace writingscore = (writingscore - 1.5) if familysize >= 3

replace mathscoreSL = (mathscoreSL - 1) if familysize >= 3
replace readingscoreSL = (readingscoreSL - 1) if familysize >= 3
replace writingscoreSL = (writingscoreSL - 1) if familysize >= 3


// NUMCOMPUTERS \\
/*

Want to show that numbers of computer in home results in higher state level scores
to support idea that household income changes it.
*/

replace mathscoreSL = (mathscoreSL + 1) if numcomputers >= 5
replace readingscoreSL = (readingscoreSL + 1) if numcomputers >= 5
replace writingscoreSL = (writingscoreSL + 1) if numcomputers >= 5


// MOTHEREDUC \\
/*

Educated parents could suggest they would value their child's education more. 
Then, if mothereduc grows, it should significantly impact grades. Created to only
show increase for bachelors degree.
*/

*~~ Bachelor's ~~*
replace mathscore = (mathscore + 2) if mothereduc == 2
replace readingscore = (readingscore + 2) if mothereduc == 2
replace writingscore = (writingscore + 2) if mothereduc == 2

replace mathscoreSL = (mathscoreSL + 4) if mothereduc == 2
replace readingscoreSL = (readingscoreSL + 4) if mothereduc == 2
replace writingscoreSL = (writingscoreSL + 4) if mothereduc == 2



// FATHEREDUC \\
/*

Educated parents could suggest they would value their child's education more. 
Then, if mothereduc grows, it should significantly impact grades. Created to only
show increase for bachelors degree and master's degree for father.
*/

*~~ Bachelor's ~~*
replace mathscore = (mathscore + 3) if fathereduc == 2
replace readingscore = (readingscore + 3) if fathereduc == 2
replace writingscore = (writingscore + 3) if fathereduc == 2

replace mathscoreSL = (mathscoreSL + 3) if fathereduc == 2
replace readingscoreSL = (readingscoreSL + 3) if fathereduc == 2
replace writingscoreSL = (writingscoreSL + 3) if fathereduc == 2


*~~ Master's ~~*
replace mathscore = (mathscore + 5) if fathereduc == 3
replace readingscore = (readingscore + 5) if fathereduc == 3
replace writingscore = (writingscore + 5) if fathereduc == 3

replace mathscoreSL = (mathscoreSL + 5) if fathereduc == 3
replace readingscoreSL = (readingscoreSL + 5) if fathereduc == 3
replace writingscoreSL = (writingscoreSL + 5) if fathereduc == 3


// Changes may have produced scores above 100. These commands fix that. 
replace readingscore = 100 if readingscore > 100 
replace writingscore = 100 if writingscore > 100 
replace mathscore = 100 if mathscore > 100 

replace readingscoreSL = 100 if readingscoreSL > 100 
replace writingscoreSL = 100 if writingscoreSL > 100 
replace mathscoreSL = 100 if mathscoreSL > 100 
