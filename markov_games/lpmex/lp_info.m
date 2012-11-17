%LP_INFO  Returnes information of mixed integer linear programming problems.
%
%  SYNOPSIS: [valid_handle,obj,x,duals,basis] = lp_info(lp_handle,solution,basis,lp,scale)
%
%  ARGUMENTS: 
%
%   lp_handle: integer handle pointing to LP problem.
%    solution: flag for returning the solution of the LP problem.
%          lp: flag for printing the LP problem.
%       basis: flag for returning the basis of the LP problem.
%       scale: flag for printing the scales of the LP problem.
%
%  OUTPUT: 
%
% valid_handle: array of integer handle to the lp created.
%          obj: Optimal value of the objective function.
%            x: Optimal value of the decision variables.
%        duals: solution of the dual problem.
%        basis: basis of the lp problem.
%
%  Copyright (c) 1995 by Jeffrey C. Kantor. All rights reserved.
%
%  Email: jeff@control.cheg.nd.edu
%         cchen@darwin.cc.nd.edu

function [valid_handle,obj,x,duals,basis] = lp_info(lp_handle,solution,basis,lp,scale)

[valid_handle] = lpmex('print_handle');

if nargin > 1
  [obj,x,duals] = lpmex('get_solution', lp_handle);
end

if nargin > 2
  [basis] = lpmex('get_basis', lp_handle);
end

if nargin > 3
  lpmex('print_lp', lp_handle);
end

if nargin > 4
  lpmex('print_scales', lp_handle);
end
