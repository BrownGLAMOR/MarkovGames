
% Script to demonstrate use of the lp_solve toolkit

lp=lpmex('make_lp',0,4);
lpmex('add_constraint',lp,[3 2 2 1],0,4);
lpmex('add_constraint',lp,[0 4 3 1],2,3);
lpmex('set_obj_fn',lp,[2 3 -2 3]);
result = lpmex('solve',lp);

clc;
[obj,x,duals] = lpmex('get_solution',lp)
pause;

% Change a single element, and maximize

lpmex('set_mat',lp,2,1,0.5);
lpmex('set_maxim',lp);
lpmex('solve',lp);

clc;
[obj,x,duals] = lpmex('get_solution',lp)
pause;

% Change RHS

lpmex('set_rh',lp,1,7.45);
lpmex('solve',lp);

clc;
[obj,x,duals] = lpmex('get_solution',lp)
pause;

% Set var 4 to an integer

lpmex('set_int',lp,4,1)
lpmex('solve',lp);

clc;
[obj,x,duals] = lpmex('get_solution',lp)
pause;

% Put in lower and upper bounds

lpmex('set_lowbo',lp,2,2);
lpmex('set_upbo',lp,4,5.3);
lpmex('solve',lp);

clc;
[obj,x,duals] = lpmex('get_solution',lp)
pause;

% Delete a constraint

lpmex('del_constraint',lp,1);
lpmex('add_constraint',lp,[1 2 1 4],1,8);

%%%%%%%%%%%%%

% More examples

% ex1.lp from the lp_solve distribution

lp=lpmex('make_lp',2,2);
lpmex('set_mat',lp,[2 1;-4 4]);
lpmex('set_obj_fn',lp,[-1 2]);
lpmex('set_int',lp,1,1);
lpmex('set_int',lp,2,1);
lpmex('set_rh_vec',lp,[5 5]);
lpmex('set_maxim',lp);
lpmex('solve',lp);
[obj,x,duals] = lpmex('get_solution',lp)

% Example 2

f = [50 100];
A = sparse([10 5;4 10; 1 1.5]);
b = [2500 2000 450];
e = [-1 -1 -1];

[m,n] = size(A);
lp=lpmex('make_lp',m,n);
lpmex('set_obj_fn',lp,f);
lpmex('set_mat',lp,A);
lpmex('set_rh_vec',lp,b);
lpmex('set_maxim',lp);
lpmex('solve',lp);
[obj,x,duals] = lpmex('get_solution',lp)

% Example 3

f = -[40 36];
vub = [8 10];
A = sparse([5 3]);
b = [45];
e = 1;

[m,n] = size(A);
lp=lpmex('make_lp',m,n);
lpmex('set_obj_fn',lp,f);
lpmex('set_mat',lp,A);
lpmex('set_rh_vec',lp,b);
lpmex('set_constr_type',lp,1,2);
lpmex('set_upbo',lp,1,8);
lpmex('set_upbo',lp,2,10);
lpmex('set_maxim',lp);
lpmex('solve',lp);
[obj,x,duals] = lpmex('get_solution',lp)

% L1 Data fitting example with integer constraint on the intercept

% Generate data

n = 40;
t = (0:n-1)';
y = 3.5 -.2*t;
y = y + 0.5*randn(size(y));

m = [ones(n,1),t(:)];
a = [m,-m,speye(n)];
f = -[sum(m),sum(-m),2*ones(1,n)];
e = ones(n,1);

vub = [10 10, 10 10, 5*ones(1,n)];

[v,x] = lp_solve(f,sparse(a),y,e,[],vub,[1,3]);
p = x(1:2)-x(3:4);
err = y-m*p;

plot(t,y,'o',t,m*p);
xlabel('t');
ylabel('y');

disp('Press any key to continue.');
pause

clc;
% Now solve bigger problem

n = 200;
m = 100;
a = rand(m,n);
idx = find(a<0.8);
a(idx) = zeros(length(idx),1);
a = sparse(a);
z = rand(n,1);
b = a*z;

[v,x] = lp_solve(-ones(1,n),a,b,zeros(m,1));

plot(a*x-b);
title('Residuals');
xlabel('Equation Number');

echo off


