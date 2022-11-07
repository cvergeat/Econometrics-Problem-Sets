% Econometrics I
% Question 2, Problem Set 2
% Chiara Vergeat

clear;
rng('default')

%% a) Monte Carlo Simulation for Bols is unbiased 

%creating vector to fill with estimated values of beta and alpha
auxAB = zeros(1000,2)

%Monte Carlo simulation - 1000 times with sample size == 1000
for i=1:1000
    i
%generating random shocks
e = -1+2*rand(1000,1); %uniform distribution
z = chi2rnd(3,1000,1); % chi2 distribution

% calculating the correspondent value for y
Y=1+(.5*z)+e;

%creating matrix of regressors
X = [ones(1000,1) z];

%Estimating beta OLS
beta = inv(X'*X)*X'*Y;
beta = beta' ;

%storing the estimated alpha and beta in the vector with all betas
auxAB(i,1:2) = beta(:,1:2);

end


% computing the average values obtained
coeff = mean(auxAB)

% the average value of beta is very close to 0.5, i.e. the true value of
% beta. 

%% b) B ols converges to beta 
%1)
% the same estimation is done with small to large sample size, the
% estimated beta should converge to the true parameter as the sample size
% increases. 

%vector of sample sizes
%sizes=linspace(1,100,10)'; 
%sizes=[100 250 500 750 1000 2500 5000 7500 10000 25000 50000 75000 100000]'
sizes=[10 50 100 200 300 400 500 600 700 800 900 1000 2000 5000 10000]'
%sizes = 1000*sizes 

%creating vector to fill with estimated values of beta and alpha
auxAB = zeros(size(sizes,1),2)

%Estimation of beta with increasing sample size 
for i=1:size(sizes,1)
    i
%generating random shocks
e = -1+2*rand(sizes(i,1),1); %uniform distribution
z = chi2rnd(3,sizes(i,1),1); % chi2 distribution

% calculating the correspondent value for y
Y=1+(.5*z)+e;

%creating matrix of regressors
X = [ones(sizes(i,1),1) z];

%Estimating beta OLS and its SE
beta = inv(X'*X)*X'*Y;
beta = beta' ;

%storing the estimated alpha and beta in the vector with all betas
auxAB(i,1:2) = beta(:,1:2);

end

toplot = auxAB(:, 2)
plot(sizes, toplot,'m', 'LineWidth',2)
yline(0.5)
xlabel('Sample Size')
ylabel('Estimated and true parameter beta')
%plot(sizes, toplot)

%% 2) looking at the distribution of the estimated betas for 5 (increasing)
%sample sizes running a monte carlo simulation. 
hold off;

%sizes=[10 50 100 200 300 400 500 600 700 800 900 1000 2000 5000 10000]' %defining the sample sizes
sizes=[10 50 200 400 600 800 1000 2000 5000 10000]' %defining the sample sizes
nm = 1000 %number of monte carlo simulations for each sample size

AuxB=zeros(nm,size(sizes,1), 2) % defining the (3 dym) object to fill with the estimated alphas and betas for each sample size and monte carlo simulation.
%each row is a different monte carlo simulation, each column is a different
%sample size, the first layer contains the estimated alphas, the secon the
%estimated betas.

for i=1:size(sizes,1)

    %monte carlo simulations
    for j=1:nm
    %generating random shocks
    e = -1+2*rand(sizes(i),1); %uniform distribution
    z = chi2rnd(3,sizes(i),1); % chi2 distribution
    
    % calculating the correspondent value for y
    Y=1+(.5*z)+e;
    
    %creating matrix of regressors
    X = [ones(sizes(i),1) z];
    
    %Estimating beta OLS
    beta = inv(X'*X)*X'*Y;
    beta = beta';    
    %storing the estimated paramethers in AuxB
    auxB(j,i, :) = beta;
    end
end


% PLOTTING THE ESTIMATED DISTRIBUTION OF ALPHA AND BETA, FOR INCREASING
% SAMPLE SIZES

%alpha
for i=1:size(sizes,1)
    alpha =auxB(:,i,1)
    ksdensity(alpha, linspace(0,2,100))
    hold on;
    grid on; 
    legend({'s=10','s=50','s=200', 's=400', 's=600' , ...
        's=800' , 's=1000', 's=2000', 's=5000', 's=10000', },'Location','northwest', 'fontsize', 8)
end

hold off;

%beta
for i=1:size(sizes,1)
    beta =auxB(:,i,2)
    ksdensity(beta, linspace(0,1,100))
    hold on;
     grid on; 
    legend({'s=10','s=50','s=200', 's=400', 's=600' , ...
        's=800' , 's=1000', 's=2000', 's=5000', 's=10000', },'Location','northwest', 'fontsize', 8)
end

hold off;

%% 3) Checking that b_ols is asymptotically normal, with asymptotic variance \sigma_2/Var(z)

%we want to plot the pdf of a normal with mean 0.5, variance
%sigma^2/var(zi) , where sigma is the variance of e together with the pdf
%of the estimated beta for a large sample

sigma = (1/3) % variance of a uniform 
var_z = 6 % variance of z distributed as Chi(3)

var = sigma/var_z
mean = 0.5

figure
r=normrnd(mean,var,10000,1)
histogram(beta)
hold on;
histfit(r)
 

%% 4) RSS/n-k is an unbiased estimator - CHECK WHAT IS WRONG HERE
%creating vector to fill with estimated values of beta and alpha
auxRSS = zeros(1000,1)

%Monte Carlo simulation - 1000 times with sample size == 1000
for i=1:1000
    i
%generating random shocks
e = unifrnd(-1, 1, 1000,1); %uniform distribution
z = chi2rnd(3,1000,1); % chi2 distribution

% calculating the correspondent value for y
Y=1+(.5*z)+e;

%creating matrix of regressors
X = [ones(1000,1) z];

%Estimating beta OLS
beta = inv(X'*X)*X'*Y;
A = X*beta;

%computing residuals and residuals sum of squares
resid = Y - A;
resid = resid.^2;
RSS=sum(resid)/(1000-2);

%storing the estimated alpha and beta in the vector with all betas
auxRSS(i,1) = RSS;
end

clear mean
% computing the average values obtained to check if it coincides with
% variance
a = mean(auxRSS, 1) % the variance should be 1.8333 while i have 0.3333 ??? 








