// MAIN PROGRAM 
//
//
// main.do
//
// created by Dylan Bollard - 03/05/2021
// 
//
// The purpose of this program is to exectue all .do programs associated with 
// the Econ 571 final project. The compilation makes it easier to diagnose 
// coding issues or change the way the main program is built. This file should:
//
// i) build the dataset 
// ii) run OLS assumption tests
// ii) create scatterplots, graphs, summaries
// iv) run regressions and output to .tex files for final report
// 
// .do files include 
// 1) generatedata.do 
// 2) generatepaneldata.do
// 3) realresults.do
// 4) panelrealresults.do
// 5) visuals.do
// 6) regress.do

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
drop _all
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// GENERAL PARAMETERS \\

*~~~~ set directory to ec571project folder ~~~~*
pwd 
cd "~/ec571project"

// Generating the data produces a data set that was not used for the analysis 
// and the paper, given that random sampling is different for two data sets. 
// If you do generate the data, results may vary.
// Preload data set in order to ensure regression results in paper are true.
use "generateddataset.dta"


// GENERATE DATA - Single Time Observation \\
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
* do generatedata.do
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
// Exporting this to excel requires manipulation of the end of the .do file.


// To see the panel data generation process, run the .do. However, this data set
// will also be different from the one used in the analysis for the same reasons.

// GENERATE DATA - Multiple Time Observations \\
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
*do generatedatapanel.do
drop _all 
use "paneldataset.dta"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// In order to make the analysis more interesting instead of "almost nothing is
// significant", the data has been changed so that significant results 
// are realized in the realresults.do file. 
// The panelrealresults file makes changes for the panel data set across time.
// Running the first is helpful for cross-sectional, running both is required for
// interesting results in the panel data set.

// SPICY DATA \\ 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
do realresults.do
do panelrealresults.do
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// A collection of graphs, stem plots, etc. that aided in data generation and 
// analysis. Running the whole file will result in the fans on your computer
// speeding up.

// CREATE VISUALS - Run at own risk\\ 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
do visuals.do
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\


// RUN REGRESSIONS / TESTS / OUTPUT \\ 
* specify data type in regress.do *
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
do regress.do
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\\
