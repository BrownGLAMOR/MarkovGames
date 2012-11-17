%LP_SOLVE  Solves mixed integer linear programming problems.
%
%  SYNOPSIS: [obj,x,duals] = lp_solve(f,a,b,e,vlb,vub,xint,autoscale,keep)
%
%     solves the MILP problem
%
%             max v = f'*x 
%               a*x <> b
%                 x >= vlb >= 0
%                 x <= vub
%                 x(int) are integer 
%
%  ARGUMENTS: The first four arguments are required: 
%
%           f: n vector of coefficients for a linear objective function.
%           a: m by n sparse matrix representing linear constraints.
%           b: m vector of right sides for the inequality constraints.
%           e: m vector that determines the sense of the inequalities:
%                     e(i) = -1  ==> Less Than 
%                     e(i) =  0  ==> Equals
%                     e(i) =  1  ==> Greater Than 
%         vlb: n vector of non-negative lower bounds. If empty or omitted,
%              then the lower bounds are set to zero.
%         vub: n vector of upper bounds. May be omitted or empty.
%   autoscale: Autoscale flag. Off when 0 or omitted.
%        keep: Flag for keeping the lp problem after it's been solved.
%              If omitted, the lp will be deleted when solved.
%
%  OUTPUT: A nonempty output is returned if a solution is found:
%
%         obj: Optimal value of the objective function.
%           x: Optimal value of the decision variables.
%       duals: solution of the dual problem.
%
%  Copyright (c) 1995 by Jeffrey C. Kantor. All rights reserved.
%
%  Email: jeff@control.cheg.nd.edu
%         cchen@darwin.cc.nd.edu

function [obj,x,duals] = lp_solve(f,a,b,e,vlb,vub,xint,autoscale,keep)

[m,n] = size(a);
lp = lpmex('make_lp',m,n);
lpmex('set_mat', lp, a);
lpmex('set_rh_vec', lp, b);
lpmex('set_obj_fn', lp, f);
lpmex('set_maxim', lp); % default is solving minimum lp.

for i = 1:length(e)
  lpmex('set_constr_type', lp, i,e(i)+1);
end

if nargin > 4
for i = 1:length(vlb)
  lpmex('set_lowbo', lp,i,vlb(i));
end
end

if nargin > 5
for i = 1:length(vub)
  lpmex('set_upbo', lp,i,vub(i));
end
end

if nargin > 6
for i = 1:length(xint)
  lpmex('set_int', lp,xint(i),1);
end
end

if nargin > 7
if autoscale ~= 0 
  lpmex('auto_scale', lp);
else
  lpmex('unscale', lp);
end
end

lpmex('solve',lp);

[obj,x,duals] = lpmex('get_solution',lp);

if nargin < 9
lpmex('delete_lp',lp);
end
