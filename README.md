# COVID-19-Effect-On-Grades
Artificial dataset to satisfy graduate course requirement. 


---

This dataset was *generated* in order to fullfill a requirement for a graduate class in applied econometrics. I originally wanted to collect data on the effect of COVID-19 on student performance from a school district, but was unable to given that our local district was already conducting their own research. 

The set contains a panel dataset, meant to emulate 6 semesters/trimesters with the first three taking place before the COVID-19 lockdowns, and the final three coming after the lockdowns. It also contains a cross-sectional dataset that is meant to be a single semester/trimester after the COVID-19 lockdowns. Variables were included and manipulated to model real world trends, or local demographics in Portland Oregon. There is a full list of variables at the end of this markdown.

**It should be noted that student performance has *greatly* been diminished as a result of online education.**

Feel free to reach out about the Stata code. It ended up being about 1500 lines to generate and manipulate, but I'm happy to share it with the same Public Domain license. 


// VARIABLES used in the program 
//
// NAME 			DATATYPE 					PURPOSE
//
// PERSONAL INFORMATION
//
// studentID		into					        Number assigned to student. 
// school			dummy 0/1, bool			1=school B (poor), 0= school A (wealthy)
// gradelevel		int						Determine grade level of child.
// gender			dummy 0/1, bool   		        1=male, 0=female
// covidpos		dummy 0/1				1=child had Covid, 0=null
// freelunch		dummy 0/1				1=takes free and reduced lunch, 0=null
// timeperiod		categorical				{0,1,2}=in-person learning, {3,4,5}=online learning
// numcomputers	into					        Defines number of computers in child's home.
// familysize 		int						Defines size of family, parents and siblings
// householdincome	float				Household income for child.
// fathereduc 		categorical 			        System of values for highest level of father education
//			/*
//			no HS diploma 		0			--
//			High School diploma      1			Highest level of education is High School.
//			Bachelor degre  	        2			" " bachelors degree.
//			Master's Degree		3			" " masters degree.
//			Doctoral Degree		4			" " PhD. 
//			\\
//			\\
//			then, if fathereduc=0, father did not finish High School.
//			*/
// mothereduc 		categorical 			System of values for highest level of mother education
//			/*
//			no HS diploma 		0			--
//			High School diploma      1			Highest level of education is High School.
//			Bachelor degre  	        2			" " bachelors degree.
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
// mathscoreSL		float				Score for "math" test at state level.
*/