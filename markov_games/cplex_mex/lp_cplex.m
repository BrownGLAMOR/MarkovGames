% LP_CPLEX - Solves a linear program (LP) using the CPLEX solver.
%
% LP_CPLEX solves the linear programming problem:
%
%       min  c'*x
%       s.t  A*x ? b
%            l <= x <= u
%
% where ? can be =, <= , or >=.
%
% Syntax:
% [obj,x,lambda,status,colstat,it] = lp_cplex(c,A,b,l,u,le,ge,maxIter)
%
% c, A, and b are required arguments.
% If l and u are omitted, x is assumed non-negative.
% le and ge are indices corresponding to constraints with <= and >=,
%   respectively.
% maxiter is 10000 by default.
%
% Copyright 2000 David R. Musicant
% Designed for CPLEX 6.5. Version 1.0
% Please report bugs to musicant@cs.wisc.edu.

function [obj,x,lambda,status,colstat,it] = lp_cplex(c,A,b,l,u,le,ge,maxIter)

  % Initial error checking
  [m,n]=size(A);
    
%  c = ColumnVector(c);
%  mc = length(c);
%  if (mc ~= n)
%    error('A and c are of incompatible sizes.');
%  end;
  
%  b = ColumnVector(b);
%  mb = length(b);
%  if (mb ~= m)
%    error('A and b are of incompatible sizes.');
%  end;
  
  % Assign default values if not provided
%  if ~exist('l','var')
%    l = zeros(mc,1);
%  else
%    l = ColumnVector(l);
%  end;

%  if ~exist('u','var')
%    u = inf*ones(mc,1);
%  else
%    u = ColumnVector(u);
%  end;

%  if ~exist('le','var')
%    le = [];
%  else
%    le = ColumnVector(le);
%  end;
  
%  if ~exist('ge','var')
%    ge = [];
%  else
%    ge = ColumnVector(ge);
%  end;
    
%  if ~exist('maxIter','var')
%    maxIter = 10000;
%  end;

  % More error checking
%  if length(l) ~= n,
%    error('A and l are of incompatible sizes');
%  end;

%  if length(u) ~= n,
%    error('A and u are of incompatible sizes');
%  end;

%  if max(le) > m | length(le) > m,
%    error('A and le are incompatible');
%  end;

%  if max(ge) > m | length(ge) > m,
%    error('A and ge are incompatible');
%  end;

  % Make the CPLEX call
  [obj,x,lambda,status,colstat,it] = lp_cplex_mex(c,A,b,l,u,le,ge,maxIter);

  % Output based on status
  switch(status)
   case 1,
    % disp(sprintf('Optimal solution found.'));
   case 2,
    disp(sprintf('Problem infeasible'));
   case 3,
    disp(sprintf('Problem unbounded.'));
   case 4,
    disp(sprintf('Objective limit exceeded in Phase II.'));
   case 5,
    disp(sprintf('Iteration limit exceeded in Phase II.'));
   case 6,
    disp(sprintf('Iteration limit exceeded in Phase I.'));
   case 7,
    disp(sprintf('Time limit exceeded in Phase II.'));
   case 8,
    disp(sprintf('Time limit exceeded in Phase I.'));
   case 9,
    disp(sprintf('Problem non-optimal, singularities in Phase II.'));
   case 10,
    disp(sprintf('Problem non-optimal, singularities in Phase I.'));
   case 11,
    disp(sprintf('Optimal solution found, unscaled infeasibilities.'));
   case 12,
    disp(sprintf('Aborted in Phase II.'));
   case 13,
    disp(sprintf('Aborted in Phase I.'));
   case 19,
    disp(sprintf('Infeasible or unbounded.'));
  end;


function [vec] = ColumnVector(oldVec)
  vec = oldVec;
  [m,n] = size(vec);
  if n > 1
    vec = vec';
    [m,n] = size(vec);
  end;
  if n > 1
    error('One of the input vectors is of the wrong size.');
  end;
  return;
