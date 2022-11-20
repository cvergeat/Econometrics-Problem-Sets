*==============================================================================*
*  PS3 - Q2 - Q6 
*==============================================================================*
*
*@Chiara Vergeat 
*
*
*==============================================================================*
* Preparing workspace
*==============================================================================*

	clear all
	
	global in "C:\Users\cvergeat\OneDrive - London Business School\COURSES\AUT\ECONOMETRICS\PS\3\Nerlove1963"
	global output "C:\Users\cvergeat\OneDrive - London Business School\COURSES\AUT\ECONOMETRICS\PS\3"
	
*==============================================================================*
* Q2.a
*==============================================================================*
	
	*upload data 
	use "$in\Nerlove1963.dta", clear
	
	*generating variables logs
	foreach i of varlist *{
		
		gen log_`i' = log(`i')
	}
	
	*log output ^2
	gen log_output_2 = log_output^2
	
	
	*regression 1
	reg log_cost  log_output log_Plabor log_Pfuel log_Pcapital
	eststo m1 
	
	reg log_cost  log_output log_Plabor log_Pfuel log_Pcapital log_output_2
	eststo m2
	
	estout m1 m2, cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///
stats(N r2 F, fmt(%9.0fc 3 3) l("Observations" "R2" "F")) 

*==============================================================================*
* Q2.b
*==============================================================================*

	* choosing the value of b7 to pick 
	sum log_output, detail
	* we see that the 10th and the 90th percentiles , i.e the 14.5th smaller and larger observations are 3.76 - 8.66. we pick those values for the range of \beta_7. 
	
	graph twoway scatter  log_cost log_output,  scheme(s3color)  ytitle("log-costs", size(medium))  xtitle("log-output", size(medium))  ylabel(, labsize(vsmall) angle(0)) xlabel(, labsize(small) angle(0))
	gr rename plot_1, replace 
		
	graph export "$output\plot1.png", as(png) name("plot_1") replace
	
	*THE REST OF THE CODE for this question IS IN MATLAB
	
*==============================================================================*
* Q6.a
*==============================================================================*
	
	import delimited "$output\PS4data.csv", varnames(1) clear 

	*gen vars of interest and regress 
	gen consumption = (realconsumptionofnondurables + realconsumptionofservices)/population
	gen income_xcapita = realdisposableincome/population
	
	*setting ts 
	gen date = yq(year, quarter)
	format date %tq
	tsset date 
	
	*reg 
	reg consumption l.consumption l2.consumption l3.consumption l4.consumption
	
	test l2.consumption l3.consumption l4.consumption 
	
*==============================================================================*
* Q6.c
*==============================================================================*
	
	*gen log variables 
	gen log_consumption = log(consumption/l.consumption)
	gen log_income = log(income_xcapita/l.income_xcapita)
	
	gen log_consumption_l2_l3 = log(l2.consumption/l3.consumption)
	gen log_consumption_l3_l4 = log(l3.consumption/l4.consumption)
	gen log_consumption_l4_l5 = log(l4.consumption/l5.consumption)
	gen log_consumption_l5_l6 = log(l5.consumption/l6.consumption)
	
	*ivregression 
	ivregress 2sls log_consumption (log_income = (log_consumption_l2_l3 log_consumption_l3_l4 log_consumption_l4_l5 log_consumption_l5_l6)), vce(robust) first 
	
*==============================================================================*
* Q6.d
*==============================================================================*
	
	*test endogeneity of income 
	estat endogenous 
	
	*overidentification test 
	overid
	
	
	
	



