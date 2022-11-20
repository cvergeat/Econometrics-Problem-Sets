% Econometrics I
% Question 2, Problem Set 3
% Chiara Vergeat

clear;
rng('default')

%% Q2.c)
[data, headers] = xlsread('Nerlove1963.xlsx');

%transforming variables in logs
data = log(data)

%adding constant 
data =[ data ones(145,1)]
headers(1,6) = {'constant'}

%impose restriction on paramethers modifying the variables
%log plabour = log_plabour-log_pfuel
data(:, 1) = data(:,1) - data(:,5) ; 
data(:,3) = data(:,3)-data(:,5) ;
%log pcapital = log_pcapital-log_pfuel
data(:,4) = data(:,4)-data(:,5) ;
data = [data(:, 1:4) data(:,6)];

%creating vector of betas
betas = linspace(3.76,8.66,1000);
RSS = zeros(1000,1);

for i=1:1000
    i
    z = (data(:,5) + exp((ones(145,1)*betas(1,i))-data(:,2))).^(-1).*data(:,2); 
    data_helper = [data z];  
    Y = data_helper(:,1);
    X = data_helper(:,2:end);
    %keyboard; 
    Y_fit = X*inv(X'*X)*X'*Y;

    res = Y - Y_fit;
    res = res.^2;
    res=sum(res);
    RSS(i,1)=res;
    
end

%finding value of beta that minimizes RSS

[min_val min_ind]=min(RSS)
%finding the value for beta
betas(1,min_ind)

%% Q3.c)

%estimating sigma
sigma = min_val/(145-6)


%creating the variable z  
z = (data(:,5) + exp((ones(145,1)*betas(1,min_ind))-data(:,2))).^(-1).*data(:,2)


%estimating beta 
X = [data(:, 2:end) z] ;
beta = inv(X'*X)*X'*Y; 

%creating the derivative 
d_z = beta(end,1)*(-1)*((data(:,5) + exp((ones(145,1)*betas(1,min_ind))-data(:,2))).^(-2)).*data(:,2).*(exp((ones(145,1)*betas(1,min_ind))-data(:,2)))

%appending data z and derivative
d_d = [data(:, 2:end) z d_z]; 

helper = zeros(6,6)

%estimate a matrix for each observation in d_d and taking average 
for i=1:145
    helper1 = d_d(i,:)'*d_d(i,:);
    helper = helper+helper1
end

helper = helper/145
estimate = inv(helper)*sigma/145

%estimated standard errors
SE = sqrt(diag(estimate))








