*==============================================================================*
*  PS1 
*==============================================================================*
*
*@Chiara Vergeat 
*
*==============================================================================*
* Preparing workspace - uploading data
*==============================================================================*

	clear all
	
	global in "C:\Users\cvergeat\OneDrive - London Business School\COURSES\AUT\ECONOMETRICS\PS\1"
	
	use "$in\PS1.dta", clear 
	
***1)
	 
	 *generating variables for regressions
	 gen exp = a0 - ed0-6
	 
	 gen l_wage = log(w0)
	 gen exp_2 = exp*exp 
	 
	 reg l_wage ed0 exp exp_2 
	 eststo m1
	 
	/*esttab using "$in\Q5a.tex", replace ///
		stats( N  r2_a    , fmt(0 3 ) layout("\multicolumn{1}{c}{@}") labels(  `"Observations"' `"Adjusted R-Squared"')) ///
		b(3) se(3) star(* 0.10 ** 0.05 *** .01) /* Keep Betas and Standard Errors with 3 digits and set significance levels for stars*/ ///
		booktabs compress l  wrap fragment varwidth(30) nonumbers nomtitles noobs nonotes*/  	


***2)
	 
	 predict l_wage_hat 
	 
	 reg l_wage l_wage_hat ed0 exp
	 eststo m2
	 drop l_wage_hat
		

***3) PARTITION REGRESSION THEOREM
	 
	reg l_wage ed0 exp_2 
	predict l_wage_hat_2, resid 
	
	reg exp ed0 exp_2 
	predict exp_hat_2 , resid 
	
	reg l_wage_hat_2 exp_hat_2
	eststo m3
		
		
***4)
 	
	reg l_wage exp_hat_2 
	eststo m4

	
*==============================================================================*
* Output
*==============================================================================*
	
	
			estout m1 m2 m3 m4 , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* 0.10 ** 0.05 *** 0.01) ///
stats(N r2 , fmt(%9.0fc 3 3) l("Observations" "R_squared")) ///
 varlabels( ed0 "education" exp "experience" exp_2 "experience^2" l_wage_hat "pred.ln(wage)" exp_hat_2 "p.o. experience") 


	
	
	
	 
	 
	 