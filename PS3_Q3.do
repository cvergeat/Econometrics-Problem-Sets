*==============================================================================*
*  PS3 - Q2 - Q6 
*==============================================================================*
*
*@Chiara Vergeat 
*
*==============================================================================*
* 
*==============================================================================*

	clear all
	
	global in "C:\Users\cvergeat\OneDrive - London Business School\COURSES\AUT\ECONOMETRICS\PS\3"
	
	import delimited "$in\wage.csv", varnames(1) clear
	
	gen log_wage = log(wage)
	
	* generating K 
	egen n_1 = count(male) if male==0
	egen n_2 = count(male) if male==1
	egen N = max(n_1) 
	egen helper = max(n_2)
	replace N = N+helper 
	drop helper
	
	bys male: egen m= mean(log_wage)
	gen m_4 = (log_wage - m)^4
	gen m_2 = (log_wage - m)^2
	egen sum_m4 = sum(m_4)
	egen sum_m2 = sum(m_2)
	drop m_4 m_2
	replace sum_m2 = sum_m2^2
	
	gen K = N*sum_m4/sum_m2
	drop sum_m2 sum_m4
	
	*generating s_1 s_2 
	gen s = (log_wage - m)^2	
	egen s_1 = sum(s) if male==0
	replace s_1 = s_1/n_1
	egen s_2 = sum(s) if male==1
	replace s_2 = s_2 /n_2
	egen helper1 = max(s_1)
	egen helper2 = max(s_2)
	gen trad_test = helper1/helper2
	drop helper1 helper2 s m
	
	*generating T 
	egen max_n_1 = max(n_1)
	egen max_n_2 = max(n_2)
	gen helper1 = max_n_1*max_n_2
	gen helper2 = max_n_1+max_n_2
	gen helper = (helper1/helper2)^(1/2)
	drop helper1 helper2
	egen helper1 = max(s_1)
	egen helper2 = max(s_2)
	replace helper1 = log(helper1)
	replace helper2 = log(helper2)
	gen T =helper*(helper1 - helper2)
	
	gen test = T /((K-1)^(1/2))
	
	sum test trad_test

	
	
	* f test reject  ( check critical value), asymptotic test do not reject ( N (0,k-1))
	