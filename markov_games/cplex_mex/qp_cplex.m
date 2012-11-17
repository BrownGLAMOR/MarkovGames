% QP_CPLEX: Solve quadratic programs using CPLEX.
%
%	QP(H,f,A,b) solves the quadratic programming problem:
%
%            min 0.5*x'Hx + f'x   subject to:  Ax <= b 
%             x    
%
%       [OBJ,X,LAMBDA]=QP(H,f,A,b) returns the objective value, the
%       solution S, and the set of Lagrangian multipliers.
%
%       QP(H,f,A,b,VLB,VUB) defines a set of lower and upper
%       bounds on the design variables, X, so that the solution  
%       is always in the range VLB < X < VUB.
%
%       QP(H,f,A,b,VLB,VUB,X0) sets the initial starting point to X0.
%       Optionally can use X0=[] to indicate no initial starting point.
%
%       QP(H,f,A,b,VLB,VUB,X0,N) indicates that the first N constraints 
%       defined by A and b are equality constraints.
%
%       Copyright 2000 David R. Musicant
%       Designed for CPLEX 6.5. Version 1.0
%       Please report bugs to musicant@cs.wisc.edu.

function [obj, x, lambda] = qp_cplex(H,f,A,b,l,u,x0,numeq)
  
  % Initial error checking
  [m,n] = size(A);
  
  f = ColumnVector(f);
  mf = length(f);
  if (mf ~= n)
    error('A and f are of incompatible sizes.');
  end;

  b = ColumnVector(b);
  mb = length(b);
  if (mb ~= m)
    error('A and b are of incompatible sizes.');
  end;

  [mH,nH] = size(H);
  if (mH ~= n | nH ~= n)
    error('H and A are of incompatible sizes');
  end;
  
  % CPLEX requires that H be symmetric. The solution of the problem does
  % not change if H is replaced by (H+H')/2 which is symmetric.
  H = sparse((H+H')/2);
  
  % Do error checking if terms are present
  if exist('l','var')
    l = ColumnVector(l);
    if length(l) ~= n,
      error('A and l are of incompatible sizes');
    end;
  end;
  
  if exist('u','var')
    u = ColumnVector(u);
    if length(u) ~= n,
      error('A and u are of incompatible sizes');
    end;
  end;

  if exist('x0','var')
    x0 = ColumnVector(x0);
    if length(x0) ~= n,
      error('A and x0 are of incompatible sizes');
    end;
  end;
  
  if exist('numeq','var')
    if numeq > m,
      error('N is too large');
    end;
  end;

  % Call the mex file with the proper number of arguments.
  if nargin < 4
    error('Not enough input arguments.');
    
  elseif (nargin == 4)
    [obj , x, lambda, status, it] = qp_cplex_mex(H,f,A,b);
    			     
  elseif (nargin == 5)	     
    [obj , x, lambda, status, it] = qp_cplex_mex(H,f,A,b,l);
    			     
  elseif (nargin == 6)	     
    [obj , x, lambda, status, it] = qp_cplex_mex(H,f,A,b,l,u);
    			     
  elseif (nargin == 7)	     
    [obj , x, lambda, status, it] = qp_cplex_mex(H,f,A,b,l,u,x0);
    			     
  elseif (nargin == 8)	     
    [obj , x, lambda, status, it] = qp_cplex_mex(H,f,A,b,l,u,x0,numeq);
    
  else
    error('Too many input arguments.');

  end;

  % Report based on status
  switch(status)
   case 1,
    disp(sprintf('Optimal solution found.'));
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
   case 14,      
    disp(sprintf('Aborted in barrier, dual infeasible.'));
   case 15,      
    disp(sprintf('Aborted in barrier, primal infeasible.'));
   case 16,      
    disp(sprintf('Aborted in barrier, primal and dual infeasible.'));
   case 17,      
    disp(sprintf('Aborted in barrier, primal and dual feasible.'));
   case 18,      
    disp(sprintf('Aborted in crossover.'));
   case 19,      
    disp(sprintf('Infeasible or unbounded.'));
   case 32,      
    disp(sprintf('Converged, dual feasible, primal infeasible.'));
   case 33,      
    disp(sprintf('Converged, primal feasible, dual infeasible.'));
   case 34,      
    disp(sprintf('Converged, primal and dual infeasible.'));
   case 35,      
    disp(sprintf('Primal objective limit reached.'));
   case 36,      
    disp(sprintf('Dual objective limit reached.'));
   case 37,      
    disp(sprintf('Primal has unbounded optimal face.'));
   case 38,      
    disp(sprintf('Non-optimal solution found, primal-dual feasible.'));
   case 39,      
    disp(sprintf('Non-optimal solution found, primal infeasible.'));
   case 40,      
    disp(sprintf('Non-optimal solution found, dual infeasible.'));
   case 41,      
    disp(sprintf('Non-optimal solution found, primal-dual infeasible.'));
   case 42,      
    disp(sprintf('Non-optimal solution found, numerical difficulties.'));
   case 43,      
    disp(sprintf('Barrier found inconsistent constraints.'));
   otherwise,    
    disp(sprintf('CPLEX status %d.',status));
  end;


function [vec] = ColumnVector(oldVec)
  vec = oldVec;
  [m,n] = size(vec);
  if n~=1
    vec = vec';
    [m,n] = size(vec);
  end;
  if n~=1
    error('One of the input vectors is of the wrong size.');
  end;
  return;