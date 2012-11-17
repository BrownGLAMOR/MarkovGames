% LPMEX  Mex file interface to the lp_solve 2.2 toolkit. Please see
% README_MEX for more information.
%
% Copyright (c) 1995 by Jeffrey C. Kantor. All rights reserved.
%
%  Email: jeff@control.cheg.nd.edu
%         cchen@darwin.cc.nd.edu
%
% LPMEX is a low-level interface to the lp_solve toolkit. It may be called
% directly, or may be used to build higher level functions for solving
% various kinds of linear and mixed-integer linear programs. It uses a
% integer handle to point to a linear program.
%
% lpmex.c is a low-level interface to the lp_solve toolkit. It may be called
% directly, or may be used to build higher level functions for solving
% various kinds of linear and mixed-integer linear programs. It uses a
% integer handle to point to a linear program.
% 
%  Initialization and Management:
% 
%     [lp_handle]  = lpmex('make_lp', rows, cols)
%         Initializes and returns a handle to a new linear program with
%         m constaints and n variables.
% 
%     [lp_handle] = lpmex('copy_lp',lp_handle1)
%         Copy the linear program referred to by lp_handle1, and returns
%         a handle to the copy.
% 
%     lpmex('delete_lp',lp_handle)
%         Delete the linear program referred to by lp_handle.
% 
%     [result] = lpmex('solve', lp_handle)
%         Solve the linear program referred to by lp_handle. Returnnig
%         0-5 respectively for OPTIMA, MILP_FAIL, INFEASIBLE, UNBOUNDED,
%         FAILURE and RUNNING.
% 
%  Problem Setting and Modification:
%
%     lpmex('lp_options', lp_handle, opt_str)
%       opt_str is a string containing a list of options:
%       	-v  	verbose mode, gives flow through the program.
%  	-d  	debug mode, all intermediate results are printed,  
%	    	and the branch-and-bound decisions.
%  	-p  	print the values of the dual variables.
%  	-b <bound> 
%		specify a lower bound for the objective function to 
%            	the program. If close enough, may speed up the  calculations.
%  	-i  	print all intermediate valid solutions.  Can give you useful 
%            	solutions even if the total run time  is too long.
%  	-e <number> 
%		specifies the epsilon which is used to determine whether 
%            	a  floating point number is in fact an integer.  Should be < 0.5.
%  	-c  	during branch-and-bound, take the ceiling branch first
%  	-s  	use automatic problem scaling.  
%  	-I  	print info after reinverting.
%  	-t  	trace pivot selection.
%  	-degen  use perturbations to reduce degeneracy, but can increase 
%                numerical instability.
%       For example, lpmex('lp_options',0,'-v -b 1e5 -s') will set lp[0] to
%       verbose and autoscaling mode with lp[0]->obj_bound = 1e-5.
%       
%     lpmex('auto_scale', lp_handle)
% 
%     lpmex('unscale', lp_handle)
%          
%     lpmex('reset_basis', lp_handle)
% 
%     lpmex('set_maxim', lp_handle)
% 
%     lpmex('set_minim', lp_handle)
% 
%     lpmex('add_column', lp_handle, col_vec)
%         col_vec: Sparse or Full vector
% 
%     lpmex('del_column', lp_handle, col)
% 
%     lpmex('del_constraint', lp_handle, row)
% 
%     lpmex('add_constraint', lp_handle, row_vec, constr_type, rh_value)
%         row_vec: Sparse or Full arguments.
%         constr_type: 0 to 2 standing respectively for LE, EQ and GE.
% 
%     lpmex('set_mat', lp_handle, Mat)
%         Mat: a Full matrix or  Sparse matrix.
% 
%     lpmex('set_mat', lp_handle, row, col, value)
% 
%     lpmex('set_obj_fn', lp_handle, obj_vec)
%         obj_vec: Sparse or Full vector.
% 
%     lpmex('set_rh', lp_handle, row, rh_value)
% 
%     lpmex('set_rh_vec', lp_handle, rh_vec)
%         rh_vec: Sparse of Full vector.
% 
%     lpmex('set_constr_type', lp_handle, row, constr_type)
%         constr_type: 0 to 2 standing respectively for LE, EQ and GE.
% 
%     lpmex('set_int', lp_handle, col, int_type)
%         int_type: 0 for not an integer, otherwise an integer.
% 
%     lpmex('set_lowbo', lp_handle, col, value)
% 
%     lpmex('set_upbo', lp_handle, col, value)
% 
%  Functions that return Information:
% 
%     [valid_handle] = lpmex('print_handle')
% 
%     [basis] = lpmex('get_basis', lp_handle)
%
%     [cost_vec] = lpmex('get_reduced_costs',lp_handle)
% 
%     [obj,x,duals] = lpmex('get_solution', lp_handle)
%
%     [ans] = lpmex('is_feasible', lp_handle, sol_vec) 
%             Returns TRUE if the vector in values is a 
%             feasible solution to the lp
%
%     [ans] = lpmex('column_in_lp', lp_handle, col_vec)
%             Returns TRUE if col_vec is already present 
%             as a column in lp. (Does not look at bounds 
%             and types, only looks at matrix values)
% 
%     [value] = lpmex('mat_elm',lp_handle,row,col)  
%               Get a single element from the matrix.
%
%     [col_vec] = lpmex('get_column', lp_handle, col)
%          
%     [row_vec] = lpmex('get_row', lp_handle, row)
%
%     lpmex('print_duals', lp_handle)
% 
%     lpmex('print_lp', lp_handle)
% 
%     lpmex('print_scales', lp_handle)
% 
%     lpmex('print_solution', lp_handle)
% 
%  File Handling:
% 
%     [lp_handle] = lpmex('read_lp_file', filename, verbose, lp_name)
%                   Make lp by reading from the LP file "filename", assign 
%                   "lp_name" as the name of the problem (if lp_name omitted,
%                   "unnamed" is assigned). "verbose" is a diagnostic output flag.
%
%     lpmex('write_LP', lp_handle, filename)
%                   Save lp in the LP file "filename".
%                  
%     [lp_handle] = lpmex('read_mps', filename, verbose)
%                   Make lp by reading from the MPS file "filename". 
%                   "verbose" is a diagnostic output flag.
%                   
%     lpmex('write_MPS', lp_handle,  filename)
%                   Save lp in the MPS file "filename".
%
