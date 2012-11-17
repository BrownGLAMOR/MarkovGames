/* lpmex.c

  Mex file interface to the lp_solve 2.3 toolkit. Please see
  README_MEX for more information.

  This file and the matlab interface code is Copyright (c) 1995,
  Jeffrey C. Kantor. All Rights Reserved.
  
  Email: jeff@control.cheg.nd.edu
         cchen@darwin.helios.nd.edu

*/


#include <string.h>
#include "mex.h"

/* mex.h defines REAL as 0 to use as a flag, and the lp toolkit
   defines REAL as a double. Therefore we need to undef REAL */

/*#undef REAL*/
#include "lpkit.h"

/* Declare a global lp record */

#define LPMAX 100

lprec	*lp[LPMAX];
int	lp_last,lp_nr;
int	result;

/* Some working storage */

short	initialized=FALSE;
char	*cmd; /* command */
char	*errmsg; /* error message */


/* An exit function to clean up the lp structure.
   Registered with matlab and called by matlab on exit */

void ExitFcn()
{
	int	i;

	for (i=0; i<=lp_last; i++) {
	  if (lp[i] != NULL)
	          delete_lp(lp[i]);
	}
	free(cmd);
	free(errmsg);
}


/* Function to get a real scalar with error checking */

REAL GetRealScalar(
	const mxArray	*pm)
{
	if ((mxGetM(pm) == 1) && (mxGetN(pm)==1)
	  && (mxIsNumeric(pm)) && (!mxIsComplex(pm)) ) {
		return(mxGetScalar(pm));
	} else {
		mexErrMsgTxt("Expecting a scalar argument.");
	}
}


/* Function to get len elements from a matlab vector. Matrix
   can be either full or sparse. Elements are stored in indices
   1..n  Errors out if the matlab vector is not length len */

void GetRealVector(
	const mxArray	*pm,
	REAL	*vec,
	int	len)
{
	int	j,k,m,n;
	int	*ir, *jc;
	double	*pr;

	m = mxGetM(pm);
	n = mxGetN(pm);

	if (   ((m == 1) && (len != n)) || ((n == 1) && (len != m))
	  || !mxIsNumeric(pm) || mxIsComplex(pm)) {
		mexErrMsgTxt("invalid vector function.");
	}

	pr = mxGetPr(pm);

	if (!mxIsSparse(pm)) {
		for (k=0; k<len; k++) {
			vec[k+1] = pr[k];
		}
	} else if (mxIsSparse(pm)) {
		jc = mxGetJc(pm);
		ir = mxGetIr(pm);
		for (j=0; j<n; j++) {
			for (k=jc[j]; k<jc[j+1]; k++) {
				vec[1+ir[k]+j*m] = pr[k];
			}
		}
	} else {
		mexErrMsgTxt("Can't figure out this matrix.");
	}
}

/* lp_handle validation test */

int handle_valid(
        int handle)
{
        if (lp[handle] == NULL || handle < 0 || handle > lp_last)
	   return(0);
        else
           return(1);
}

/* mexFunction is the Matlab Interface */

void mexFunction(
        int	nlhs,
        mxArray	*plhs[],
        int	nrhs,
        const mxArray	*prhs[])
{
	int	h,i,j,k,l,n,m;
	int	row,col;
	short	type;
	REAL	value;
	REAL	*yout;
	REAL	*vec;
	int	*ir, *jc;
	double	*pr;
	FILE    *fp;
	nstring filename;
	char    *str, *str1;

	if (!initialized) {
		/* Register the Exit Function */

		if (0 != mexAtExit(ExitFcn)) {
			mexErrMsgTxt("Failed to register exit function.\n");
		}
        	initialized = TRUE;

		/* Allocate a string array to store command */

		cmd = calloc(NAMELEN,sizeof(char));

		/* Allocate a string array to store error message */

		errmsg = calloc(200,sizeof(char));

		/* Initialize the lp array, and pointer to the last lp */

		for (i = 0; i < LPMAX; i++) 
			lp[i] = NULL;

		lp_last = -1;
	}

	/* Get the first argument as a string matrix */

	if (nrhs < 1) {
		mexErrMsgTxt("At least one command is required.");
	}
	mxGetString(prhs[0], cmd, mxGetN(prhs[0])+1);

	/* Now call the required part of the lp toolkit */

/* functions without using lp_handle */

	/* [lp_handle] = lpmex('make_lp', rows, cols) */

	if (strcmp("make_lp",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("make_lp requires 2 arguments.");
		}
		row = GetRealScalar(prhs[1]);
		col = GetRealScalar(prhs[2]);
		for (i=0; i<=lp_last; i++) {
		  if (lp[i] == NULL)
		      break;
		}
		if (i <= lp_last) {
		  lp[i] = make_lp(row,col);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = i;
		}
		else if (lp_last+1 >= LPMAX ) {
			mexErrMsgTxt("Cannot allocate any more lps.");
		}
		else {
		  lp_last++;
		  lp[lp_last] = make_lp(row,col);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = lp_last;
		}
	}

	/* [lp_handle] = lpmex('read_lp_file', filename, verbose, lp_name) */
	/* Make lp from a LP fromat file */

	else if (strcmp("read_lp_file",cmd)==0) {
		if (nrhs < 2) {
			mexErrMsgTxt("read_lp_file requires at least 1 argument.");
		}
		mxGetString(prhs[1], filename, NAMELEN);
		if ((fp = fopen(filename, "r")) == NULL) {
		   mexErrMsgTxt("read_lp_file can't read file.");
		}
		type = (nrhs == 3) ? 1 : 0;
		if (nrhs < 4) {
		   strcpy(filename, "unnamed");
		} 
		else {
		   mxGetString(prhs[3], filename, NAMELEN);
		}
		for (i=0; i<=lp_last; i++) {
		  if (lp[i] == NULL)
		      break;
		}
		if (i <= lp_last) {
		  lp[i] = read_lp_file(fp, type, filename);

		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = i;
		}
		else if (lp_last+1 >= LPMAX ) {
			mexErrMsgTxt("Cannot allocate any more lps.");
		}
		else {
		  lp_last++;
		  lp[lp_last] = read_lp_file(fp, type, filename);

		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = lp_last;
		}
		fclose(fp);
	}	

	/* [lp_handle] = lpmex('read_mps', filename, verbose) */
	/* Make lp from a MPS fromat file */

	else if (strcmp("read_mps",cmd)==0) {
		if (nrhs < 2) {
			mexErrMsgTxt("read_mps requires 1 or 2 arguments.");
		}
		mxGetString(prhs[1], filename, NAMELEN);
		if ((fp = fopen(filename, "r")) == NULL) {
		   mexErrMsgTxt("read_mps can't read file.");
		}
		type = (nrhs == 3) ? 1 : 0;
		for (i=0; i<=lp_last; i++) {
		  if (lp[i] == NULL)
		      break;
		}
		if (i <= lp_last) {
		  lp[i] = read_mps(fp, type);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = i;
		}
		else if (lp_last+1 >= LPMAX ) {
			mexErrMsgTxt("Cannot allocate any more lps.");
		}
		else {
		  lp_last++;
		  lp[lp_last] = read_mps(fp, type);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = lp_last;
		}
		fclose(fp);
	}

	/* [handle_vec] = lpmex('print_handle') */

	else if (strcmp("print_handle",cmd)==0) {
		j=0;
	        for (i=0; i <= lp_last; i++) {
		  if (lp[i] != NULL) {
		     j++;
		  }
                }
		if (j > 0) {
		  plhs[0] = mxCreateDoubleMatrix(j,1,0);
		  pr = mxGetPr(plhs[0]);
		  k=0;
		  for (i=0; i<= lp_last; i++) {
		    if (lp[i] != NULL) {
                     pr[k] = i;
		     k++;
		    }
		  }
		}
		else {
		 mexErrMsgTxt("Cannot find existing lp_handle."); 
		}
	} 

	/* lpmex('demo') */

/* This demo is not a necessary part of the program
	else if (strcmp("demo",cmd)==0) {
		lp_last++;
		lp[lp_last] = make_lp(0,4);
		str_add_constraint(lp[lp_last],"3 2 2 1",LE,4);
		str_add_constraint(lp[lp_last],"0 4 3 1",GE,3);
		str_set_obj_fn(lp[lp_last],"2 3 -2 3");

		print_lp(lp[lp_last]);
		solve(lp[lp_last]);
		print_solution(lp[lp_last]);

		plhs[0] = mxCreateDoubleMatrix(1,1,0);
		pr = mxGetPr(plhs[0]);
		pr[0] = lp_last;

	} 
*/

/* functions with at least one argument */

	else if (nrhs < 2 ) {
                strcpy(errmsg,cmd);
                strncat(errmsg,": Unimplemented or requires at least 1 argument.",180);
                mexErrMsgTxt(errmsg);
	} 

	/* getting lp_handle */

	else if (  !( (h=GetRealScalar(prhs[1])) + 1 )   ) 
    {
        strcpy(errmsg,cmd);
        strncat(errmsg,": lp handle can not be -1.",180);	        
		mexErrMsgTxt(errmsg);
	} 

	/* lp_handle validation */

	else if ( !handle_valid(h) ) 
    {
        strcpy(errmsg,cmd);
        strncat(errmsg,": Invalid lp handle.",180);	        
		mexErrMsgTxt(errmsg);
	} 

	/* lpmex('auto_scale', lp_handle) */

	else if (strcmp("auto_scale",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("auto_scale requires 1 argument.");
		auto_scale(lp[h]);
	}

	/* [lp_handle] = lpmex('copy_lp', lp_handle) */
	
	else if (strcmp("copy_lp", cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("copy_lp requires 1 argument.");
		if (lp_last+1 >= LPMAX ) {
			mexErrMsgTxt("Cannot allocate any more lps.");
		}
		for (i=0; i<=lp_last; i++) {
		  if (lp[i] == NULL)
		      break;
		}
		if (i <= lp_last) {
		  lp[i] = copy_lp(lp[h]);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = i;
		}
		else if (lp_last+1 >= LPMAX ) {
			mexErrMsgTxt("Cannot allocate any more lps.");
		}
		else {
		  lp_last++;
		  lp[lp_last] = copy_lp(lp[h]);
		  plhs[0] = mxCreateDoubleMatrix(1,1,0);
		  pr = mxGetPr(plhs[0]);
		  pr[0] = lp_last;
		}
	}

	/* lpmex('delete_lp', lp_handle) */

	else if (strcmp("delete_lp", cmd)==0) {
		if (nrhs != 2) {
			mexErrMsgTxt("delete_lp requires 1 argument.");
		}
		delete_lp(lp[h]);
                lp[h] = NULL;
	}

	/* [basis] = lpmex('get_basis', lp_handle) */

	else if (strcmp("get_basis",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("get_basis requires 1 argument.");
		if (lp[h]->basis_valid) {
			plhs[0] = mxCreateDoubleMatrix(lp[h]->columns,1,0);
			pr = mxGetPr(plhs[0]);
			for (i=0; i<lp[h]->columns; i++) {
				pr[i] = lp[h]->basis[i+1];
			}
		}
	}

	/* [cost_vec]=lpmex('get_reduced_costs',lp_handle) */ 

	else if (strcmp("get_reduced_costs",cmd)==0) {
	      if (nrhs != 2) {
		 mexErrMsgTxt("get_reduced_costs needs 1 argument1.");
	      }
	      plhs[0] = mxCreateDoubleMatrix(lp[h]->sum,1,0);
	      pr = mxGetPr(plhs[0]);
	      get_reduced_costs(lp[h], pr);
	}

	/* [obj,x,duals] = lpmex('get_solution', lp_handle) */

	else if (strcmp("get_solution",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("get_solution requires 1 argument.");
		if (result == 0) {
			plhs[0] = mxCreateDoubleMatrix(1,1,0);
			pr = mxGetPr(plhs[0]);
			pr[0] = lp[h]->best_solution[0];

			if (nlhs > 1) {
				plhs[1] = mxCreateDoubleMatrix(lp[h]->columns,1,0);
				pr = mxGetPr(plhs[1]);
				for (i=0; i<lp[h]->columns; i++) {
					pr[i] = lp[h]->best_solution[lp[h]->rows+i+1];
				}
			}

			if (nlhs > 2) {
				plhs[2] = mxCreateDoubleMatrix(lp[h]->rows,1,0);
				pr = mxGetPr(plhs[2]);
				for (i=0; i<lp[h]->rows; i++) {
					pr[i] = lp[h]->duals[i+1];
				}
			}
		}
        else
        {
		    /*printf("non-zero result, returning junk\n");*/
			plhs[0] = mxCreateDoubleMatrix(1,1,0);
			pr[0] = 0;
			if (nlhs > 1) 
            {
				plhs[1] = mxCreateDoubleMatrix(lp[h]->columns,1,0);
				pr = mxGetPr(plhs[1]);
				/*
                for (i=0; i<lp[h]->columns; i++) {
			        pr[i] = lp[h]->best_solution[lp[h]->rows+i+1];
			    }
                */
			}

			if (nlhs > 2) {
				plhs[2] = mxCreateDoubleMatrix(lp[h]->rows,1,0);
				pr = mxGetPr(plhs[2]);
				/*
                for (i=0; i<lp[h]->rows; i++) {
			        pr[i] = lp[h]->duals[i+1];
			    }
                */
			}
        }
	}

	/* lpmex('print_duals', lp_handle) */

	else if (strcmp("print_duals",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("print_duals requires 1 argument.");
		print_duals(lp[h]);
	}

	/* lpmex('print_lp', lp_handle) */

	else if (strcmp("print_lp",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("print_lp requires 1 argument.");
		print_lp(lp[h]);
	}

	/* lpmex('print_scales', lp_handle) */

	else if (strcmp("print_scales",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("print_scales requires 1 argument.");
		print_scales(lp[h]);
	}

	/* lpmex('print_solution', lp_handle) */

	else if (strcmp("print_solution",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("print_solution requires 1 argument.");
		print_solution(lp[h]);
	}

	/* lpmex('reset_basis', lp_handle) */

	else if (strcmp("reset_basis",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("reset_basis requires 1 argument.");
		reset_basis(lp[h]);
	}

	/* lpmex('set_maxim', lp_handle) */

	else if (strcmp("set_maxim",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("set_maxim requires 1 argument.");
		set_maxim(lp[h]);
	}

	/* lpmex('set_minim', lp_handle) */

	else if (strcmp("set_minim",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("set_minim requires 1 argument.");
		set_minim(lp[h]);
	}

	/* [result] = lpmex('solve', lp_handle) */

	else if (strcmp("solve",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("solve requires 1 argument.");
		result = solve(lp[h]);
		plhs[0] = mxCreateDoubleMatrix(1,1,0);
		pr = mxGetPr(plhs[0]);
		pr[0] = result;
		if (result == OPTIMAL) {
		  if (lp[h]->verbose == TRUE) {
		    print_solution(lp[h]);
		    printf("Branch & Bound depth: %d\n",lp[h]->max_level);
		    printf("Nodes processed: %d\n",lp[h]->total_nodes);
		    printf("Simplex pivots: %d\n",lp[h]->total_iter);
          }
		}
		if (result == INFEASIBLE)
        {
		  /*printf("This problem is infeasible\n");*/
        }
		if (result == UNBOUNDED)
		  printf("This problem is unbounded\n");
		if (result == FAILURE)
		  printf("lp_solve failed\n");
	}

	/* lpmex('unscale', lp_handle) */

	else if (strcmp("unscale",cmd)==0) {
		if (nrhs != 2)
			mexErrMsgTxt("unscale requires 1 argument.");
		unscale(lp[h]);
	}

/* functions with at least two arguments */

	else if (nrhs < 3 ) {
                strcpy(errmsg,cmd);
                strncat(errmsg,": Unimplemented or requires at least 2 arguments.",180);
                mexErrMsgTxt(errmsg);
	} 

	/* lpmex('add_column', lp_handle, col_vec) */

	else if (strcmp("add_column",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("add_column requires 2 arguments.");
		}
		vec = mxCalloc(1+lp[h]->rows,sizeof(REAL));
		/* GetRealVector can handle both full and sparse matrix */
		GetRealVector(prhs[2],vec,lp[h]->rows);
		add_column(lp[h],vec);
		mxFree(vec);
	}

	/* [ans]=lpmex('column_in_lp', lp_handle, col_vec) */ 
	/* returns TRUE if col_vec is already present as a column in lp. */
	/*(Does not look at bounds and types, only looks at matrix values) */

	else if (strcmp("column_in_lp",cmd)==0) {
	      if (nrhs != 3) {
		 mexErrMsgTxt("column_in_lp needs 2 arguments.");
	      }
	      vec = mxCalloc(2+lp[h]->rows,sizeof(REAL));
	      /* GetRealVector can handle both full and sparse matrix */
	      GetRealVector(prhs[2],vec,1+lp[h]->rows);
	      plhs[0] = mxCreateDoubleMatrix(1,1,0);
	      pr = mxGetPr(plhs[0]);
	      pr[0] = column_in_lp(lp[h],vec+1);
	      mxFree(vec);
	}

	/* lpmex('del_column', lp_handle, col) */

	else if (strcmp("del_column",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("del_column requires 2 arguments.");
		}
		col = GetRealScalar(prhs[2]);
		if ((col >= 1) && (col <= lp[h]->columns)) {
			del_column(lp[h],col);
		} else {
			mexErrMsgTxt("column number out of bounds.");
		}
	}

	/* lpmex('del_constraint', lp_handle, row) */

	else if (strcmp("del_constraint",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("del_constraint requires 2 arguments.");
		}
		row = GetRealScalar(prhs[2]);
		if ((row >= 1) && (row <= lp[h]->rows)) {
			del_constraint(lp[h],row);
		} else {
			mexErrMsgTxt("constraint number out of bounds.");
		}
	}

	/* [col_vec] = lpmex('get_column', lp_handle, col) */

	else if (strcmp("get_column",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("get_column requires 2 arguments.");
		}
		col = GetRealScalar(prhs[2]);
		if ((col < 1) || (col > lp[h]->columns)) {
			mexErrMsgTxt("column out of range.");
		}
		vec = mxCalloc(1+lp[h]->rows,sizeof(REAL));
 		get_column(lp[h],col,vec);
		plhs[0] = mxCreateDoubleMatrix(lp[h]->rows,1,0);
		pr = mxGetPr(plhs[0]);
		for (i=0; i<lp[h]->rows; i++) {
			pr[i] = vec[i+1];
		}
		mxFree(vec);
	}

	/* [row_vec] = lpmex('get_row', lp_handle, row) */

	else if (strcmp("get_row",cmd)==0) {
		if (nrhs != 3)
			mexErrMsgTxt("get_row requires 2 arguments.");
		row = GetRealScalar(prhs[2]);
		if ((row < 1) || (row > lp[h]->rows)) {
			mexErrMsgTxt("row out of range.");
		}
		vec = mxCalloc(1+lp[h]->columns,sizeof(REAL));
 		get_row(lp[h],row,vec);
		plhs[0] = mxCreateDoubleMatrix(1,lp[h]->columns,0);
		pr = mxGetPr(plhs[0]);
		for (i=0; i<lp[h]->columns; i++) {
			pr[i] = vec[i+1];
		}
		mxFree(vec);
	}

	/* [ans]=lpmex('is_feasible', lp_handle, sol_vec) */ 
	/* returns TRUE if the vector in values is a feasible solution to the lp */

	else if (strcmp("is_feasible",cmd)==0) {
	      if (nrhs != 3) {
		 mexErrMsgTxt("is_feasible needs 2 arguments.");
	      }
	      vec = mxCalloc(1+lp[h]->rows,sizeof(REAL));
	      /* GetRealVector can handle both full and sparse matrix */
	      GetRealVector(prhs[2],vec,lp[h]->rows);
	      plhs[0] = mxCreateDoubleMatrix(1,1,0);
	      pr = mxGetPr(plhs[0]);
	      pr[0] = is_feasible(lp[h],vec);
	      mxFree(vec);
	}

	/* lpmex('lp_options', lp_handle, opt_str) */ 
	/* Set options for the lp. See README_MEX for details*/

	else if (strcmp("lp_options",cmd)==0) {
	      if (nrhs != 3) {
		 mexErrMsgTxt("lp_options needs 2 arguments.");
	      }
	      str = mxCalloc(73,sizeof(char));
	      mxGetString(prhs[2], str, 73);
	      lp[h]->verbose         = (strstr(str,"-v")) ? TRUE:FALSE;
	      lp[h]->debug           = (strstr(str,"-d")) ? TRUE:FALSE;
	      lp[h]->print_duals     = (strstr(str,"-p")) ? TRUE:FALSE;
	      lp[h]->print_sol       = (strstr(str,"-i")) ? TRUE:FALSE;
	      lp[h]->floor_first     = (strstr(str,"-c")) ? FALSE:TRUE;
	      lp[h]->print_at_invert = (strstr(str,"-I")) ? TRUE:FALSE;
	      lp[h]->trace           = (strstr(str,"-t")) ? TRUE:FALSE;
	      lp[h]->anti_degen      = (strstr(str,"-degen")) ? TRUE:FALSE;
	      if (strstr(str,"-s"))
		auto_scale(lp[h]);
	      else
		unscale(lp[h]);
	      if (str1=strstr(str,"-b"))
		lp[h]->obj_bound = atof(str1 + 3);
              else
		lp[h]->obj_bound = (REAL)DEF_INFINITE;
	      if (str1=strstr(str,"-e"))
		lp[h]->epsilon = atof(str1 + 3);
              else
		lp[h]->epsilon = (REAL)DEF_EPSILON;
	      mxFree(str);
	}

 	/* lpmex('set_mat', lp_handle, a)  Full matrix argument */
	/* lpmex('set_mat', lp_handle, a)  Sparse matrix argument */
	/* lpmex('set_mat', lp_handle, row, col, value) */

	else if (strcmp("set_mat",cmd)==0) {
		if ( (nrhs!=3) && (nrhs!=5) )
			mexErrMsgTxt("incorrect number of arguments.");
		if (nrhs == 5) {
			row = GetRealScalar(prhs[2]);
			if ((lp[h]->rows < row)||(row < 0)) {
				mexErrMsgTxt("set_mat invalid row.");
			}
			col = GetRealScalar(prhs[3]);
			if ((lp[h]->columns < col)||(col < 0)) {
				mexErrMsgTxt("set_mat invalid column.");
			}
			value = GetRealScalar(prhs[4]);
			set_mat(lp[h],row,col,value);
		} else if (nrhs == 3) {
			/* Called with a matrix argument */
			m = mxGetM(prhs[2]);
			n = mxGetN(prhs[2]);
			if ((lp[h]->rows != m) || (lp[h]->columns != n) 
			   || !mxIsNumeric(prhs[2]) || mxIsComplex(prhs[2])) {
				mexErrMsgTxt("invalid argument.");
			}
			pr = mxGetPr(prhs[2]);
			if (!mxIsSparse(prhs[2])) {
				for (j=0; j<n; j++) {
					for (l=0; l<m; l++) {
						set_mat(lp[h],l+1,j+1,pr[l+j*m]);
					}
				}
			}
			if (mxIsSparse(prhs[2])) {
				jc = mxGetJc(prhs[2]);
				ir = mxGetIr(prhs[2]);
				for (j=0; j<n; j++) {
					for (k = jc[j]; k<jc[j+1]; k++) {
						i = ir[k];
						set_mat(lp[h],i+1,j+1,pr[k]);
					}
				}
			}
		}
	}
	
	/* lpmex('set_obj_fn', lp_handle, vec)  Sparse or Full arguments */

	else if (strcmp("set_obj_fn",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("set_obj_fn requires 2 arguments.");
		}
		vec = mxCalloc(1+lp[h]->columns,sizeof(REAL));
		/* GetRealVector can handle both full and sparse matrix */
	        GetRealVector(prhs[2],vec,lp[h]->columns);
	        set_obj_fn(lp[h],vec);
	        mxFree(vec);
	}

	/* lpmex('set_rh', lp_handle, row, value) */

	else if (strcmp("set_rh",cmd)==0) {
		if (nrhs != 4) {
			mexErrMsgTxt("set_rh requires 3 arguments.");
		}
		row = GetRealScalar(prhs[2]);
		value = GetRealScalar(prhs[3]);
		set_rh(lp[h],row,value);
	}

	/* lpmex('set_rh_vec', lp_handle, vec)  Sparse of Full arguments */

	else if (strcmp("set_rh_vec",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("set_rh_vec requires 2 arguments.");
		}
		vec = mxCalloc(1+lp[h]->rows,sizeof(REAL));
		/* GetRealVector can handle both full and sparse matrix */
	        GetRealVector(prhs[2],vec,lp[h]->rows);
	        set_rh_vec(lp[h],vec);
	        mxFree(vec);
	}

	/* lpmex('write_LP', lp_handle, filename) */
	/* Write lp to a LP file */

	else if (strcmp("write_LP",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("write_LP requires 2 arguments.");
		}
		mxGetString(prhs[2], filename, NAMELEN);
		if ((fp = fopen(filename, "w")) == NULL) {
		   mexErrMsgTxt("write_LP can't write to the file.");
		}
		
		write_LP(lp[h], fp);
		fclose(fp);
	}
     
	/* lpmex('write_MPS', lp_handle, filename) */
	/* Write lp to a MPS file */

	else if (strcmp("write_MPS",cmd)==0) {
		if (nrhs != 3) {
			mexErrMsgTxt("write_MPS requires 2 arguments.");
		}
		mxGetString(prhs[2], filename, NAMELEN);
		if ((fp = fopen(filename, "w")) == NULL) {
		   mexErrMsgTxt("write_MPS can't write to the file.");
		}
		write_MPS(lp[h], fp);
		fclose(fp);
	}

/* functions with at least three arguments */

	else if (nrhs < 4 ) {
                strcpy(errmsg,cmd);
                strncat(errmsg,": Unimplemented or requires at least 3 arguments.",180);
                mexErrMsgTxt(errmsg);
	} 

	/* [value] = lpmex('mat_elm',lp_handle,row,col)  get a single element 
           from the matrix.*/

	else if (strcmp("mat_elm",cmd)==0) {
	      if (nrhs != 4) {
		 mexErrMsgTxt("mat_elm needs 3 arguments.");
	      }
	      row = GetRealScalar(prhs[2]);
	      if ((row < 1) || (row > lp[h]->rows)) {
		 mexErrMsgTxt("row number out of bounds.");
	      }
	      col = GetRealScalar(prhs[3]);
	      if ((col < 1) && (col > lp[h]->columns)) {
	         mexErrMsgTxt("column number out of bounds.");
	      }
	      plhs[0] = mxCreateDoubleMatrix(1,1,0);
	      pr = mxGetPr(plhs[0]);
	      pr[0] = mat_elm(lp[h],row,col);
	}

	/* lpmex('set_constr_type', lp_handle, row, type) */

	else if (strcmp("set_constr_type",cmd)==0) {
		if (nrhs != 4) {
			mexErrMsgTxt("set_constr_type needs 3 arguments.");
		}
		row = GetRealScalar(prhs[2]);
		if ((row < 1) || (row > lp[h]->rows)) {
			mexErrMsgTxt("row number out of bounds.");
		}
		type = GetRealScalar(prhs[3]);
		if ((type!=EQ) && (type!=LE) && (type!=GE)) {
			mexErrMsgTxt("invalid constraint type.");
		}
		set_constr_type(lp[h],row,type);
	}

	/* lpmex('set_int', lp_handle, col, type) */

	else if (strcmp("set_int",cmd)==0) {
		if (nrhs != 4) {
			mexErrMsgTxt("set_int requires 3 arguments.");
		}
		col = GetRealScalar(prhs[2]);
		type = GetRealScalar(prhs[3]);
		if (type == 0)
			set_int(lp[h],col,FALSE);
		else
			set_int(lp[h],col,TRUE);
	}

	/* lpmex('set_lowbo', lp_handle, col,value) */

	else if (strcmp("set_lowbo",cmd)==0) {
		if (nrhs != 4) {
			mexErrMsgTxt("set_lowbo requires 3 arguments.");
		}
		col = GetRealScalar(prhs[2]);
		value = GetRealScalar(prhs[3]);
		set_lowbo(lp[h],col,value);
	}

	/* lpmex('set_upbo', lp_handle, col, value) */

	else if (strcmp("set_upbo",cmd)==0) {
		if (nrhs != 4) {
			mexErrMsgTxt("set_upbo requires 3 arguments.");
		}
		col = GetRealScalar(prhs[2]);
		value = GetRealScalar(prhs[3]);
		set_upbo(lp[h],col,value);
	}

/* functions with more than three arguments */

	else if (nrhs < 5 ) {
                strcpy(errmsg,cmd);
                strncat(errmsg,": Unimplemented or requires at least 4 arguments.",180);
                mexErrMsgTxt(errmsg);
	} 

	/* lpmex('add_constraint', lp_handle, vec, type, rh) Sparse or Full arguments */

	else if (strcmp("add_constraint", cmd)==0) {
		if (nrhs != 5) {
			mexErrMsgTxt("add_constraint requires 4 arguments.");
		}
		type = GetRealScalar(prhs[3]);
		if ((type!=LE) && (type!=EQ) && (type!=GE)) {
			mexErrMsgTxt("invalid constraint type.");
		}
		value = GetRealScalar(prhs[4]);
		vec = mxCalloc(1+lp[h]->columns,sizeof(REAL));
		/* GetRealVector can handle both full and sparse matrix */
		GetRealVector(prhs[2],vec,lp[h]->columns);
		add_constraint(lp[h],vec,type,value);
		mxFree(vec);
	}

    else {
        strcpy(errmsg,cmd);
        strncat(errmsg,": Unimplemented.",180);
        mexErrMsgTxt(errmsg);
	}
}
