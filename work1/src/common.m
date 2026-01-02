f1 = @(x) 5^x + (2 - cos(x))^2;
df1 = @(x) log(5)*5^x + 2*sin(x)*(2 - cos(x)); 
f2 = @(x) (x - 1)^2 + exp(x - 5)*sin(x + 3); 
df2 = @(x) 2*(x - 1) + exp(x - 5)*(sin(x + 3) + cos(x + 3)); 
f3 = @(x) exp(-3*x) - (sin(x - 2) - 2)^2; 
df3 = @(x) -3*exp(-3*x) - 2*cos(x - 2)*(sin(x - 2) - 2);

a = -1.;
b = 3.; 
maxiter = 10000;
lnth = 1e-2;
len = 3e-3:1e-3:1e-1; 
epsilon = 1e-6:1e-6:4e-3;
epsl = 1e-3;

% l_selection = [1e-4, 1e-3, 1e-2, 1e-1];
l_selection = [3e-3, 1e-2, 1e-1];

set(groot,'DefaultLineLineWidth',2);