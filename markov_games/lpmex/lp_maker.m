%LP_MAKER  Makes mixed integer linear programming problems.
%
%  SYNOPSIS: [lp_handle] = lp_maker(f,a,b,e,vlb,vub,xint,autoscale,setminim)
%     make the MILP problem
%       max v = f'*x 
%         a*x <> b
%           x >= vlb >= 0
%           x <= vub
%           x(int) are integer 
%
%  ARGUMENTS: The first four arguments are required: 
%           f: n vector of coefficients for a linear objective function.
%           a: m by n sparse matrix representing linear constraints.
%           b: m vector of right sides for the inequality constraints.
%           e: m vector that determines the sense of the inequalities:
%                     e(i) < 0  ==> Less Than 
%                     e(i) = 0  ==> Equals
%                     e(i) > 0  ==> Greater Than 
%         vlb: n vector of non-negative lower bounds. If empty or omitted,
%              then the lower bounds are set to zero.
%         vub: n vector of upper bounds. May be omitted or empty.
%   autoscale: Autoscale flag. Off when 0 or omitted.
%   setminim: Set maximum lp when this flag equals 0 or omitted. 
%
%  OUTPUT: lp_handle is a integer handle to the lp created.
%
%  Copyright (c) 1995 by Jeffrey C. Kantor. All rights reserved.
%
%  Email: jeff@control.cheg.nd.edu
%         cchen@darwin.cc.nd.edu

function [lp_handle] = lp_maker(f,a,b,e,vlb,vub,xint,autoscale,setminim)

[m,n] = size(a);
lp_handle = lpmex('make_lp',m,n);
lpmex('set_mat', lp_handle, a);
lpmex('set_rh_vec', lp_handle, b);
lpmex('set_obj_fn', lp_handle, f);
lpmex('set_maxim', lp_handle); % default is solving minimum lp.

for i = 1:length(e)
  lpmex('set_constr_type', lp_handle, i,e(i)+1);
end

if nargin > 4
for i = 1:length(vlb)
  lpmex('set_lowbo', lp_handle,i,vlb(i));
end
end

if nargin > 5
for i = 1:length(vub)
  lpmex('set_upbo', lp_handle,i,vub(i));
end
end

if nargin > 6
for i = 1:length(xint)
  lpmex('set_int', lp_handle,xint(i),1);
end
end

if nargin > 7
if autoscale ~= 0 
  lpmex('auto_scale', lp_handle);
else
  lpmex('unscale', lp_handle);
end
end

if nargin > 8
if  setminim ~= 0 
  lpmex('set_minim', lp_handle);
else
  lpmex('set_maxim', lp_handle);
end
end
