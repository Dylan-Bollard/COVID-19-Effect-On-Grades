/* AUTHOR, INTRO, PURPOSE, VARIABLES, EXPLANATIONS, notes
//
// generatedata.do
//
// created by Dylan Bollard - 02/27/2021
// 
//
// The purpose of this program is to generate data to be used in the ECON 571
// project analyzing how grades have been affected by online learning. 
// Unfortunately, securing data from PPS has proved difficult, and it has become
// necessary to generate data to use. 
//
// It's important to note that although subjects in school vary by term and 
// grade, the data has been compressed into three generic tests that are assumed
// to take place for each grade level each trimester term. Then, "reading", 
// "writing", and "math" are meant to be markers for student progress. An
// overview of how the scores were generated is given.
// 
// There is also a set of scores at the "state" level. It is assumed that grade
// inflation would affect student scores, however, access to state level data 
// would help to determine if school scores were significantly different from
// 
// 
//
// VARIABLES used in the program 
//
// NAME 			DATATYPE 					PURPOSE
//
// PERSONAL INFORMATION
//
// studentID		into					Number assigned to student. 
// school			dummy 0/1, bool			1=school B (poor), 0= school A (wealthy)
// gradelevel		int						Determine grade level of child.
// gender			dummy 0/1, bool   		1=male, 0=female
// covidpos			dummy 0/1				1=child had Covid, 0=null
// freelunch		dummy 0/1				1=takes free and reduced lunch, 0=null
// timeperiod		categorical				{0,1,2}=in-person learning, {3,4,5}=online learning
// numcomputers		into					Defines number of computers in child's home.
// familysize 		int						Defines size of family, parents and siblings
// householdincome	float					Household income for child.
// fathereduc 		categorical 			System of values for highest level of father education
//			/*
//			no HS diploma 		0			--
//			High School diploma 1			Highest level of education is High School.
//			Bachelor degre  	2			" " bachelors degree.
//			Master's Degree		3			" " masters degree.
//			Doctoral Degree		4			" " PhD. 
//			\\
//			\\
//			then, if fathereduc=0, father did not finish High School.
//			*/
// mothereduc 		categorical 			System of values for highest level of mother education
//			/*
//			no HS diploma 		0			--
//			High School diploma 1			Highest level of education is High School.
//			Bachelor degre  	2			" " bachelors degree.
//			Master's Degree		3			" " masters degree.
//			Doctoral Degree		4			" " PhD. 
//			\\
//			\\
//			then, if mothereduc=0, mother did not finish High School.
//			*/
//
// SCHOOL PERFORMANCE INFORMATION
//
// readingscore	    	float				Score for "reading" test in school.
// writingscore 		float				Score for "writing" test in school.
// mathscore			float 				Score for "math" test in school.		
// 
// STATE PERFORMANCE INFORMATION
//
// readingscoreSL		float 				Score for "reading" test at state level. 
// writingscoreSL 		float				Score for "writing" test at state level.
// mathscoreSL			float				Score for "math" test at state level.
*/

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
drop _all
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\

*~~~~ set observations, seed ~~~~*
set obs 1400
set seed (98765)


// GENERATE VARIABLES, DISTRIBUTIONS, and DEFINE datatype
//
// The section of the program is meant to create variables, generate data for 
// for those variables, and define the datatypes for each. A brief explanation
// is given for the reasoning behind each distribution creation, with the main 
// focus on bimodal and unimodal normal distributions. The size of the generated
// dataset yields support for using these distributions.
//
// There are two schools that data was created for, and three grades for each
// meant to emulate junior high school (middle school) and high school. 
// There are 700 students at both school A and school B, with 100 students in 
// each grade, for a total of 1,400 observations.


// PERSONAL INFORMATION \\

** studentID **
generate int studentID = _n
display c(rngstate)
** school **
* SCHOOL A
generate int school = 0 if studentID < 701
* SCHOOL B
replace school = 1 if studentID > 700

** gradelevel **
// arbitrary labeling, chose segments of 100 for each school \\
generate int gradelevel = 0 
* Grade Level 6 
replace gradelevel = 6 if studentID < 101 | studentID < 801 & studentID > 700
* Grade Level 7
replace gradelevel = 7 if studentID < 201 & studentID > 100 | studentID < 901 & studentID > 800
* Grade Level 8
replace gradelevel = 8 if studentID < 301 & studentID > 200 | studentID < 1001 & studentID > 900
* Grade Level 9
replace gradelevel = 9 if studentID < 401 & studentID > 300 | studentID < 1101 & studentID > 1000
* Grade Level 10
replace gradelevel = 10 if studentID < 501 & studentID > 400 | studentID < 1201 & studentID > 1100
* Grade Level 11
replace gradelevel = 11 if studentID < 601 & studentID > 500 | studentID < 1301 & studentID > 1200
* Grade Level 12
replace gradelevel = 12 if studentID < 701 & studentID > 600 | studentID > 1300

** gender **
generate int gender = rnormal(1, 1)
replace gender = 1 if gender >= 1
replace gender = 0 if gender <= 0

sum gender if gender == 0 // ----> 678 obs.
sum gender if gender == 1 // ----> 722 obs.

** covidpos **
// We wish to create different frequencies of Covid-19 cases between the two
// communities, to simulate the differences between rich and impoverished 
// communities. 
//
// SCHOOL A - Wealthy Community
generate int covidpos = rnormal(0, 1) if studentID < 701
replace covidpos = 1 if covidpos >= 1 & studentID < 701
replace covidpos = 0 if covidpos <= 0 & studentID < 701

sum covidpos if covidpos == 0 & studentID < 701 // ----> 582
sum covidpos if covidpos == 1 & studentID < 701 // ----> 118 ~16% infection rate


// SCHOOL B - Impoverished Community
replace covidpos = rnormal(1, 5) if studentID > 700
replace covidpos = 1 if covidpos > 0.5 & studentID > 700
replace covidpos = 0 if covidpos < 0.5 & studentID > 700

sum covidpos if covidpos == 0 & studentID > 700 // ----> 330 obs.
sum covidpos if covidpos == 1 & studentID > 700 // ----> 370 obs. ~52% infection rate


** householdincome **
// per census.gov, Oregon had a median household income of $62,818 in Portland,
// and $115,600 for Lake Oswego
// so School B median income is $52,818 and School A median income is $115,600
// variances chosen to make graph look compelling
// think I need help emulating this one, but I did two separate normals.

// SCHOOL A - Wealthy Community
generate float householdincome = rnormal(115600, 20000) if studentID < 701
replace householdincome = 0 if studentID > 700

// SCHOOL B - Impoverished Community
replace householdincome = rnormal(52818, 20000) if studentID > 700
replace householdincome = 0 if householdincome < 0 

// look at distribution \\
// scatter householdincome studentID 


** freelunch **
// 
//	Assume that more children at School B will take free and reduced lunch.
//
// SCHOOL A - Wealthy Community 
//
// specify desired level; 9%
generate freelunch = runiform() if studentID < 701 & householdincome <=60000
count if studentID < 701 & householdincome <=60000
replace freelunch = 1 if freelunch >= 0.91 & studentID < 701
replace freelunch = 0 if freelunch != 1 & studentID < 701

// SCHOOL B - Impoverished Community 
//
// specify desired level; 24%
replace freelunch = runiform() if studentID > 700 & householdincome <=60000
replace freelunch = 1 if freelunch >= 0.48 & studentID > 700
replace freelunch = 0 if freelunch != 1 & studentID > 700


** numcomputers **
// assume that more children have computers now than before Covid-19 closures
// census.gov has 93% of households owning a computer 
// variance was set to reflect 
//
// SCHOOL A - Wealthy Community
generate int numcomputersA = rnormal(4, 2.5) if studentID < 701
replace numcomputersA = 0 if numcomputersA <= 0 & studentID < 701
replace numcomputersA = 5 if numcomputersA >= 5 & studentID < 701
replace numcomputersA = 0 if studentID > 700

sum numcomputersA if numcomputersA == 0 & studentID < 701 // ----> ~7% without computers 

// SCHOOL B - Impoversihed Community
// had trouble with values turning into float datatype
// created second variable, merged the two, then deleted newly created one
generate int numcomputersB = rnormal(2, 0.8) if studentID > 700
replace numcomputersB = 0 if numcomputersB <= 0 & studentID > 700
replace numcomputersB = 5 if numcomputersB >= 5 & studentID > 700
replace numcomputersB = 0 if studentID < 701

sum numcomputersB if numcomputersB == 0 & studentID > 700 // ----> ~10% without computers

generate numcomputers = numcomputersA + numcomputersB
drop numcomputersA numcomputersB
** familysize **
// per census.gov info on family size, mean fam size was 2.51
// variance chosen arbitrarily to make it seem more realistic, +- 3.5 SD's
// assume equal family size over both populations
generate int familysize = rnormal(2.51, 1)
replace familysize = 0 if familysize < 0

// sum familysize if familysize == 0


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\

// EDUCATIONAL ATTAINMENT \\
/* INFORMATION ABOUT EDUCATIONAL ATTAINMENT IN OREGON
LINK: https://statisticalatlas.com/state/Oregon/Educational-Attainment

~~~~~~~~~
Highest Level of Education 
~~~~~~~~~
11% -----> Did Not Complete High School
24% -----> Completed High School
20% -----> Bachelor's Degree
8%  -----> Master's Degree
1.5%-----> Doctoral Degree
35% -----> some other form of degree, mainly Associate's Degree or "Some College"
			these people will get a '1' for High School, and '0' for everything
			else

Assume similar levels of parent education between the two schools, for now. Seems
like a lot of work to add in the difference between the two communities. Ask Dr. 
Gallup if appropriate or not.

~~~~~~~~~
GENERATION / Uniform Distribution Concept
~~~~~~~~~
Use uniform distributions to assign a random number between 0 and 1 for each 
variable. 

generate fathereducHS = runiform()											(1)

Then, if we seek 24% of individuals to have a "1" in fathereducHS, 

replace fathereducHS = 1 if fathereducHS >= 0.76							(2)

This would give ~24% a "1" signaling they completed High School. However, would 
also say 76% do not have a High School diploma. We seek 11% to have a "0" in
fathereducHS, so for the time being,

replace fathereduc = "random number" if fathereducHS <= 0.11				(3)

Then, we can say 

generate fathereducBD = runiform() if fathereducHS == 0						(4)

It was necessary to assign the random number for the original 11% not completing
High School in order to do this. NBow we want 20% of the total population though
not the number of people with '0' for High School. 20% of population of 1400 is
280. Then, we need (280/x) = k% where x = number of individuals with a '0' for 
fathereducHS and k% = desired percentage for the command below. If 931 individuals
have a '0' for fathereducHS, then (280/931) = 0.3. Then, k=0.3 in the equation
below. Use count command to replicate.

replace fathereducBD = 1 if fathereducBD >= (fathernumBD/fathereducHScount) (5)

Make all else equal to 0.

replace fathereducBD = 0 if fathereduc != 1									(6)

Iterate for all other degrees. Then replace/collapse values into one categorical 
variable.

Exact same procedure for mothereduc. Obviously, multicollinearity will
exist between these two sets of variables. Two different variables because if it 
wasn't then a student would have (assuming one mother and one father) two 
parents with same education level.
*/

** fathereduc **

// High School \\
generate fathereducHS = runiform()
replace fathereducHS = 1 if fathereducHS >= 0.76				// -> For 24% completing HS
replace fathereducHS = -1 if fathereducHS <= 0.11
replace fathereducHS = 0 if fathereducHS != 1 & fathereduc != -1

// Bachelor's Degree \\ 
*~~~~ get count/percentage for bachelor's degree ~~~~*
generate fathernumBD = 0.2*1400
count if fathereducHS == 0
generate fathereducHScount = r(N)
generate bdpercentage = 1 - (fathernumBD/fathereducHScount)
display bdpercentage
*~~~~ get sample ~~~~*
generate fathereducBD = runiform() if fathereducHS == 0 & fathereducHS != -1
replace fathereducBD = 0 if fathereducBD == .
replace fathereducBD = 1 if fathereducBD >= bdpercentage		// For 20% completing Bachelors Degree
replace fathereducBD = 0 if fathereducBD != 1
sum fathereducBD if fathereducBD != 0

*~~~~ drop irrelavent stuff ~~~~*
drop fathernumBD fathereducHScount bdpercentage

// Master's Degree \\
*~~~~ get count/percentage for master's degree ~~~~*
generate fathernumMD = 0.08*1400
count if fathereducBD == 0 & fathereducHS != 1 & fathereducHS != -1
generate fathereducMDcount = r(N)
generate mdpercentage = (1 - fathernumMD/fathereducMDcount)

*~~~~ get sample ~~~~*
generate fathereducMD = runiform() if fathereducBD == 0 & fathereducHS != 1 & fathereducHS != -1
replace fathereducMD = 0 if fathereducMD == .
replace fathereducMD = 1 if fathereducMD >= mdpercentage		// For 8% completing Masters Degree
replace fathereducMD = 0 if fathereducMD != 1

*~~~~ drop irrelavent stuff ~~~~*
drop fathernumMD fathereducMDcount mdpercentage

// Doctoral Degree \\
*~~~~ get count/percentage for doctoral degree ~~~~*
generate fathernumPhD = 0.015*1400
count if fathereducMD == 0 & fathereducBD == 0 & fathereducHS == 0
generate fathereducPhDcount = r(N)
generate phdpercentage = (1 - fathernumPhD/fathereducPhDcount)

*~~~~ get sample ~~~~*
generate fathereducPhD = runiform() if fathereducMD == 0 & fathereducBD == 0 & fathereducHS == 0
replace fathereducPhD = 0 if fathereducPhD == .
replace fathereducPhD = 1 if fathereducPhD >= phdpercentage		// For 1.5% obtaining a Doctoral Degree
replace fathereducPhD = 0 if fathereducPhD != 1

*~~~~ drop irrelavent stuff ~~~~*
drop fathernumPhD fathereducPhDcount phdpercentage


// REST OF SAMPLE - Some College / Associate's Degree 
//
// Basically, if they don't have a higher level degree, but they finished High School.
replace fathereducHS = 1 if fathereducPhD == 0 & fathereducMD == 0 & fathereducBD == 0 & fathereducHS !=-1

*~~~~ "put back" those who did not attain a high school diploma ~~~~*
replace fathereducHS = 0 if fathereducHS == -1


*~~~~ Collapse into Categorical Variable ~~~~*
generate fathereduc = fathereducHS
replace fathereduc = 2 if fathereducBD == 1
replace fathereduc = 3 if fathereducMD == 1
replace fathereduc = 4 if fathereducPhD == 1

*~~~~ drop everything else ~~~~*
drop fathereducHS fathereducBD fathereducMD fathereducPhD 



** mothereduc **

// High School \\
generate mothereducHS = runiform()
replace mothereducHS = 1 if mothereducHS >= 0.76				// -> For 24% completing HS
replace mothereducHS = -1 if mothereducHS <= 0.11
replace mothereducHS = 0 if mothereducHS != 1 & mothereduc != -1

// Bachelor's Degree \\ 
*~~~~ get count/percentage or bachelor's degree ~~~~*
generate mothernumBD = 0.2*1400
count if mothereducHS == 0
generate mothereducHScount = r(N)
generate bdpercentage = 1 - (mothernumBD/mothereducHScount)
display bdpercentage
*~~~~ get sample ~~~~*
generate mothereducBD = runiform() if mothereducHS == 0 & mothereducHS != -1
replace mothereducBD = 0 if mothereducBD == .
replace mothereducBD = 1 if mothereducBD >= bdpercentage		// For 20% completing Bachelors Degree
replace mothereducBD = 0 if mothereducBD != 1
sum mothereducBD if mothereducBD != 0

*~~~~ drop irrelavent stuff ~~~~*
drop mothernumBD mothereducHScount bdpercentage

// Master's Degree \\
*~~~~ get count/percentage for master's degree ~~~~*
generate mothernumMD = 0.08*1400
count if mothereducBD == 0 & mothereducHS != 1 & mothereducHS != -1
generate mothereducMDcount = r(N)
generate mdpercentage = (1 - mothernumMD/mothereducMDcount)

*~~~~ get sample ~~~~*
generate mothereducMD = runiform() if mothereducBD == 0 & mothereducHS != 1 & mothereducHS != -1
replace mothereducMD = 0 if mothereducMD == .
replace mothereducMD = 1 if mothereducMD >= mdpercentage		// For 8% completing Masters Degree
replace mothereducMD = 0 if mothereducMD != 1

*~~~~ drop irrelavent stuff ~~~~*
drop mothernumMD mothereducMDcount mdpercentage

// Doctoral Degree \\
*~~~~ get count/percentage for doctoral degree ~~~~*
generate mothernumPhD = 0.015*1400
count if mothereducMD == 0 & mothereducBD == 0 & mothereducHS == 0
generate mothereducPhDcount = r(N)
generate phdpercentage = (1 - mothernumPhD/mothereducPhDcount)

*~~~~ get sample ~~~~*
generate mothereducPhD = runiform() if mothereducMD == 0 & mothereducBD == 0 & mothereducHS == 0
replace mothereducPhD = 0 if mothereducPhD == .
replace mothereducPhD = 1 if mothereducPhD >= phdpercentage		// For 1.5% obtaining a Doctoral Degree
replace mothereducPhD = 0 if mothereducPhD != 1

*~~~~ drop irrelavent stuff ~~~~*
drop mothernumPhD mothereducPhDcount phdpercentage


// REST OF SAMPLE - Some College / Associate's Degree 
//
// Basically, if they don't have a higher level degree, but they finished High School.
replace mothereducHS = 1 if mothereducPhD == 0 & mothereducMD == 0 & mothereducBD == 0 & mothereducHS !=-1

*~~~~ "put back" those who did not attain a high school diploma ~~~~*
replace mothereducHS = 0 if mothereducHS == -1


*~~~~ Collapse into Categorical Variable ~~~~*
generate mothereduc = mothereducHS
replace mothereduc = 2 if mothereducBD == 1
replace mothereduc = 3 if mothereducMD == 1
replace mothereduc = 4 if mothereducPhD == 1

*~~~~ drop everything else ~~~~*
drop mothereducHS mothereducBD mothereducMD mothereducPhD 


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// SCHOOL PERFORMANCE INFORMATION \\
//
// Generated so that students perform better in school, trying to emulate grade
// inflation. Then, test scores at the state level will be lower, somewhat. Also,
// there was nothing in the documentation for skbim about changing the name of 
// the variable created. So, every bimodal is created with the variable name
// 'skewbim' and then changed and deleted.

** readingscore **
// bimodal normal distribution; my understanding is that this is the most common
// skbim command includes VARIANCES; not SD's like rnormal()

/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 70
var = 100
sd = 10

SECOND DISTRIBUTION
mean = 80
var = 30
sd = 5.5 approx
*/
skbim 0.5 70 100 80 30 1
generate float readingscore = skewbim
drop skewbim

// look at distribution \\
stem readingscore 


** writingscore **
// again, bimodal normal
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 70
var = 80
sd = 8.9 approx

SECOND DISTRIBUTION
mean = 85
var = 15
sd = 3.9 approx
*/
skbim 0.5 70 80 85 15 1
generate float writingscore = skewbim
drop skewbim

// look at distribution \\
// scatter writingscore studentID


** mathscore **
// generally one of the tougher subjects for students , so probability changed
// to reflect poorer student performance
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.75

FIRST DISTRIBUTION:
mean = 70
var = 80
sd = 8.9 approx

SECOND DISTRIBUTION
mean = 85
var = 15
sd = 3.9 approx
*/
skbim 0.75 70 80 85 15 1
generate float mathscore = skewbim
drop skewbim

// look at distribution \\
// scatter mathscore studentID


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// STATE PERFORMANCE INFORMATION \\
//
// Previously stated; state scores for the "subjects" are generated to be 
// slightly lower, with a higher variance in the lower mean and a lower variance
// in the upper mean. Also, the distributions for the different schools are 
// created to be slightly different. School A is in a wealthier part of town with
// fewer Covid-19 cases, and a higher average number of computers in the home. 
// So their test scores are slightly higher on the state exam. 


// SCHOOL A - Wealthy Community \\

** readingscoreSL **
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 70
var = 140
sd = 11.8

SECOND DISTRIBUTION
mean = 80
var = 15
sd =  3.9 approx
*/
skbim 0.5 70 140 80 15 1
generate float readingscoreSL = skewbim if studentID < 701
replace readingscoreSL = 0 if studentID > 700
drop skewbim
replace readingscoreSL = 100 if readingscoreSL > 100

// look at distribution \\
// scatter readingscoreSL studentID


** writingscoreSL **
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 70
var = 140
sd = 11.8

SECOND DISTRIBUTION
mean = 80
var = 15
sd =  3.9 approx
*/
skbim 0.4 70 140 80 15 1
generate float writingscoreSL = skewbim if studentID < 701
replace writingscoreSL = 0 if studentID > 700
drop skewbim
replace writingscoreSL = 100 if writingscoreSL > 100

// look at distribution \\
// scatter writingscoreSL studentID


** mathscoreSL **
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.75

FIRST DISTRIBUTION:
mean = 70
var = 100
sd = 10 approx

SECOND DISTRIBUTION
mean = 85
var = 20
sd = 4.7 approx
*/
skbim 0.75 70 100 85 20 1
generate float mathscoreSL = skewbim if studentID < 701
replace mathscoreSL = 0 if studentID > 700
drop skewbim
replace mathscoreSL = 100 if mathscoreSL > 100

// look at distribution \\
// scatter mathscoreSL studentID



// SCHOOL B - Impoverished Community

/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 60
var = 120
sd = 11 approx

SECOND DISTRIBUTION
mean = 75
var = 15
sd =  3.9 approx
*/
skbim 0.5 60 120 75 15 1
replace readingscoreSL = skewbim if studentID > 700
drop skewbim
replace readingscoreSL = 100 if readingscoreSL > 100 & studentID > 700

// look at distribution \\
// scatter readingscoreSL studentID


** writingscoreSL **
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.5

FIRST DISTRIBUTION:
mean = 60
var = 100
sd = 10

SECOND DISTRIBUTION
mean = 80
var = 15
sd =  3.9 approx
*/
skbim 0.5 60 100 80 15 1
replace writingscoreSL = skewbim if studentID > 700
drop skewbim
replace writingscoreSL = 100 if writingscoreSL > 100 & studentID > 700

// look at distribution \\
// scatter writingscoreSL studentID


** mathscoreSL **
/* CHOOOSING BIMODAL PARAMETERS 
Let the probability that either distribution is chosen be equivalent.
Then,
p = 0.75

FIRST DISTRIBUTION:
mean = 65
var = 100
sd = 10 approx

SECOND DISTRIBUTION
mean = 85
var = 20
sd = 4.7 approx
*/
skbim 0.75 65 100 85 20 1
replace mathscoreSL = skewbim if studentID > 700
drop skewbim
replace writingscoreSL = 100 if writingscoreSL > 100 & studentID > 700

// look at distribution \\
// scatter mathscoreSL studentID


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\

* ~~~~~~~~~~~~~~~~~~~~ *
 // EXPORT TO EXCEL \\
* ~~~~~~~~~~~~~~~~~~~~ *
pwd
* export excel using "generateddata.xlsx", replace

* save "/Users/dylanbollard/Desktop/generateddataset.dta", replace


// drop _all

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
**/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\**
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\

* ~~~~~~~~~~~~~~~~~~~~ *
   // DATA SOURCES \\
* ~~~~~~~~~~~~~~~~~~~~ *
/*
CENSUS INFORMATION
https://www.census.gov/quickfacts/fact/table/OR/PST045219

EDUCATIONAL ATTAINMENT
https://statisticalatlas.com/state/Oregon/Educational-Attainment
*/


/*
⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⣀⣀⣄⣶⡶⣦⣀⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⢠⡦⡟⠻⠛⠙⠉⠈⠄⠄⠈⠻⠛⣾⣦⣤⣀⠄⠄
⠄⠄⠄⣰⡿⠟⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⠋⠽⢿⣧⠄
⠄⢀⣴⠞⠂⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢼⠆⠄
⠄⣼⠇⠄⠄⠄⠄⠄⠄⠄⠄⣀⣠⣤⣶⣿⣶⣦⣤⣀⠄⣻⡃⠄
⠄⡿⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⢸⣧⠄
⠄⢿⡀⠄⠄⠄⠄⠄⠄⠄⢠⣾⣿⣿⣋⣩⣭⣝⣿⣿⠛⢰⡇⠄
⠄⢸⡇⠄⠄⢀⠄⠄⠄⠄⣾⣿⣿⣿⣟⣯⠉⢉⣿⠋⣟⢻⡇⠄
⠄⠄⢹⡀⢳⡗⠂⣠⠄⠄⣿⣿⣿⣿⣿⣭⣽⣿⣿⣿⣉⣸⠇⠄
⠄⠄⠈⣷⠄⢳⣷⣿⠄⠄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄
⠄⠄⠄⠘⣧⠄⠈⠙⠄⠄⠄⠉⠙⠛⠛⣿⣿⣷⣤⣄⢿⡿⠃⠄
⠄⠄⠄⠄⠉⠳⣄⡀⠄⠄⠄⢢⣦⣾⣿⠿⠿⠛⠉⢉⣽⠇⠄⠄
⠄⠄⠄⠄⠄⠄⠘⠿⣄⢀⠄⣀⣝⢻⣿⡿⠒⣀⣀⣸⠁⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠈⠳⣤⠁⠙⠎⢻⣄⠄⠄⣸⠋⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠙⠶⢦⣄⣀⣣⠴⠃⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⣀⣀⣀⣤⣶⣿⣿⣶⣶⣶⣤⣄⣠⣴⣶⣿⣿⣿⣿⣶⣦⣄⠄⠄
⠄⠄⣠⣴⣾⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦
⢠⠾⣋⣭⣄⡀⠄⠄⠈⠙⠻⣿⣿⡿⠛⠋⠉⠉⠉⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿
⡎⣾⡟⢻⣿⣷⠄⠄⠄⠄⠄⡼⣡⣾⣿⣿⣦⠄⠄⠄⠄⠄⠈⠛⢿⣿⣿⣿⣿⣿
⡇⢿⣷⣾⣿⠟⠄⠄⠄⠄⢰⠁⣿⣇⣸⣿⣿⠄⠄⠄⠄⠄⠄⠄⣠⣼⣿⣿⣿⣿
⢸⣦⣭⣭⣄⣤⣤⣤⣴⣶⣿⣧⡘⠻⠛⠛⠁⠄⠄⠄⠄⣀⣴⣿⣿⣿⣿⣿⣿⣿
⠄⢉⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⢰⡿⠛⠛⠛⠛⠻⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠸⡇⠄⠄⢀⣀⣀⠄⠄⠄⠄⠄⠉⠉⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠄⠈⣆⠄⠄⢿⣿⣿⣿⣷⣶⣶⣤⣤⣀⣀⡀⠄⠄⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠄⠄⣿⡀⠄⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠂⠄⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠄⠄⣿⡇⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠄⠄⣿⡇⠄⠠⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠄⠄⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠄⠄⣿⠁⠄⠐⠛⠛⠛⠛⠉⠉⠉⠉⠄⠄⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
⠄⠄⠻⣦⣀⣀⣀⣀⣀⣀⣤⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠄
*/
