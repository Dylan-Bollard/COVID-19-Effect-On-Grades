# COVID-19-Effect-On-Grades
Artificial dataset to satisfy graduate course requirement. 


---

This dataset was *generated* in order to fullfill a requirement for a graduate class in applied econometrics. I originally wanted to collect data on the effect of COVID-19 on student performance from a school district, but was unable to given that our local district was already conducting their own research. 

The set contains a panel dataset, meant to emulate 6 semesters/trimesters with the first three taking place before the COVID-19 lockdowns, and the final three coming after the lockdowns. It also contains a cross-sectional dataset that is meant to be a single semester/trimester after the COVID-19 lockdowns. Variables were included and manipulated to model real world trends, or local demographics in Portland Oregon. There is a full list of variables at the end of this markdown.

**It should be noted that student performance has *greatly* been diminished as a result of online education.**

The Stata code was immense and I thought that it might prove to be interesting/helpful to someone else. 

# Variables Used
All of the variables were generated and manipulated to model real world trends and local demographics in Portland, Oregon during the 2020-2021 timeline. There were several categories of information to consider, and they're divied up between *Personal Information*, *School Performance*, and *State Performance*. The idea was that state level examinations would be less liekly to have grade inflation, and so may be a more accurate measure of performance. 

## Personal Information
**studentID** was used mainly as a means to efficiently differentiate students. The first 700 are in **school** #1 (the impoverished school), and the rest are in **school** #2 (the wealthy school). In addition, **gradelevel** and **gender** easy to imagine uses for. **covidpos** is meant to show a negative relationship between having the Covid-19 virus and school performance, assuming time spent off recovering. **timeperiod** is simply the number of semesters/trimesters from the beginning of the pandemic and online learning. For the panel dataset, the first three time periods are before the pandemic beginning, and the last three from after the switch to online learning. 

## School Performance
+ **readingscore**
+ **writingscore**
+ **mathscore**
Three "tests" were created to measure performance in macro subject areas. A reading, writing, and math exam could then be good indicators and ways to measure effects of other variables. 

## State Performance
+ **readingscoreSL**
+ **writingscoreSL**
+ **mathscoreSL**
The tests are considered at the state level as well. 
