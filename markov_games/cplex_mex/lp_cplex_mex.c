/*********************************************************************
 * Program: lp_cplex_mex.c                                           *
 * Copyright 2000 David R. Musicant                                  *
 * Designed for CPLEX 6.5. Version 1.0                               *
 * Please report bugs to musicant@cs.wisc.edu.                       *
 * This software is free for academic and research use only.         *
 * For commercial use, contact musicant@cs.wisc.edu.                 *
 *********************************************************************/

#include "cplex.h"
#include <stdlib.h>
#include <string.h>
#include "mex.h"

#define MINIMIZE 1
#define MANDATORY_ARGS 5
#define MAX_ITER_DEFAULT 10000

/* Input arguments */
#define C_IN   0
#define A_IN   1
#define B_IN   2
#define L_IN   3
#define U_IN   4
#define LE_IN  5
#define GE_IN  6
#define MI_IN  7

/* Output arguments */
#define OBJ_OUT    0
#define X_OUT      1
#define PI_OUT     2
#define STAT_OUT   3
#define CSTAT_OUT  4
#define ITER_OUT   5

static int initialized = 0;
static CPXENVptr env = NULL;
static CPXLPptr lp = NULL;

void cleanup(void) 
{
    mexPrintf("MEX-file (lp_cplex_MEX.c) is terminating, clearing memory\n");
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    initialized = 0;
}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* MATLAB memory structures */
  const mxArray *c,*A,*b,*l,*u,*le,*ge,*maxIterPtr;

  /* Return arguments */
  double   *matlpstat,*objval,*x,*pi,*cstat,*itcnt;

  /* Other declarations */
  char *sense,errorMsg[255];
  int rows,cols,maxIter,*matbeg,*matcnt,*matind;
  double *c_ptr,*b_ptr,*matval,*l_ptr,*u_ptr,*slack,*dj;
  int matrixSize,status,i,j,le_size,ge_size,m,n;
  double *le_ptr = NULL,*ge_ptr = NULL;
  int *istat,lpstat;
  //CPXENVptr env;
  //CPXLPptr lp = NULL;

  /* Assign pointers to MATLAB memory stuctures */
  c = prhs[C_IN];
  A = prhs[A_IN];
  b = prhs[B_IN];
  l = prhs[L_IN];
  u = prhs[U_IN];

  c_ptr = mxGetPr(c); 
  b_ptr = mxGetPr(b); 
  l_ptr = mxGetPr(l);
  u_ptr = mxGetPr(u);
  rows  = mxGetM(b);  
  cols  = mxGetM(c);  

  /* Build the matrix of coefficients, taking sparsity into account. */
  if (mxIsSparse(A)){
    /* Sparse */
    matbeg = mxGetJc(A);   /* beginnings of each column */
    matcnt = (int*)mxCalloc(cols,sizeof(int)); /* # of entries in each col */
    for (i = 0; i < cols; i++)
      matcnt[i] = matbeg[i+1] - matbeg[i];
    matind = mxGetIr(A);   /* row locations */
    matval = mxGetPr(A);   /* actual coefficients */

  } else {
    /* Dense */
    m = mxGetM(A);
    n = mxGetN(A);
    matbeg = (int*)mxCalloc(n,sizeof(int));
    matcnt = (int*)mxCalloc(n,sizeof(int));
    matind = (int*)mxCalloc(m*n,sizeof(int));
    matval = mxGetPr(A);
    for (j = 0; j < n; j++) {
      matbeg[j] = j*m;
      for (i = 0; i < m; i++)
	matind[j*m + i] = i; 
      matcnt[j] = m;
    }
  }

  /* Initialize all constraints to be equality constraints (default). */
  sense = (char*)mxCalloc(rows,sizeof(char));
  for(i = 0; i < rows; i++)
    sense[i] = 'E';

  /* If "<=" constraints given, set them up. */
  if(nrhs > MANDATORY_ARGS){
    le = prhs[LE_IN];
    le_ptr = mxGetPr(le);
    le_size = mxGetM(le);
    for(i = 0; i < le_size; i++)
      sense[(int)(le_ptr[i]-1)] = 'L';
  }

  /* If ">=" constraints given, set them up. */
  if(nrhs > MANDATORY_ARGS + 1){
    ge = prhs[GE_IN];
    ge_ptr = mxGetPr(ge);
    ge_size = mxGetM(ge);
    for(i = 0; i < ge_size; i++)
      sense[(int)(ge_ptr[i]-1)] = 'G';
  }

  /* Set up maximum number of iterations */
  if (nrhs > MANDATORY_ARGS + 2) {
    maxIterPtr = prhs[MI_IN];
    maxIter = (int)mxGetScalar(maxIterPtr);
  } else
    maxIter = MAX_ITER_DEFAULT;

  /* Output to MATLAB */
  plhs[OBJ_OUT]    = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[X_OUT]      = mxCreateDoubleMatrix(cols,1,mxREAL);
  plhs[PI_OUT]     = mxCreateDoubleMatrix(rows,1,mxREAL);
  plhs[STAT_OUT]   = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[CSTAT_OUT]  = mxCreateDoubleMatrix(cols,1,mxREAL);
  plhs[ITER_OUT]   = mxCreateDoubleMatrix(1,1,mxREAL);

  objval    = mxGetPr(plhs[OBJ_OUT]);
  x         = mxGetPr(plhs[X_OUT]);
  pi        = mxGetPr(plhs[PI_OUT]);
  matlpstat = mxGetPr(plhs[STAT_OUT]);
  cstat     = mxGetPr(plhs[CSTAT_OUT]);
  istat     = (int*)mxCalloc(cols,sizeof(int));
  itcnt     = mxGetPr(plhs[ITER_OUT]);
  
  if (!initialized)
  {
      mexPrintf("MEX-file: lp_cplex_mex opening cplex environment\n");
      /* Open CPLEX environment */
      env = CPXopenCPLEXdevelop(&status);
      if (!env) {
        printf(CPXgeterrorstring(env,status,errorMsg));
        mexErrMsgTxt("\nCould not open CPLEX environment.");
      }
      /* Create CPLEX problem space */
      lp = CPXcreateprob(env, &status, "matlab");
      if (!lp) {
        printf(CPXgeterrorstring(env,status,errorMsg));
        CPXcloseCPLEX(&env);
        mexErrMsgTxt("\nCould not create CPLEX problem.");
      }
      mexAtExit(cleanup);
      initialized = 1;
  }
  
	
  /* Copy LP into CPLEX environment */
  status = CPXcopylp(env, lp, cols, rows, MINIMIZE, c_ptr, b_ptr, sense,
		     matbeg, matcnt, matind, matval, l_ptr, u_ptr, NULL);
  
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    //CPXfreeprob(env,&lp); 
    //CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not copy CPLEX problem.");
  }
  
  /* Set iteration limit. */
  status = CPXsetintparam(env, CPX_PARAM_ITLIM, maxIter);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    //CPXfreeprob(env,&lp); 
    //CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not set number of iterations.");
  }
  
  /* Perform optimization */
  status = CPXprimopt(env,lp);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    //CPXfreeprob(env,&lp); 
    //CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nOptimization error.");
  }
  
  /* Obtain solution */
  status = CPXsolution(env, lp, &lpstat, objval, x, pi, NULL, NULL);
  *matlpstat = lpstat;
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    //CPXfreeprob(env,&lp); 
    //CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nFailure when retrieving solution.");
  }
  
  /* Get status of columns */
  status = CPXgetbase(env, lp, istat, NULL);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    //CPXfreeprob(env,&lp); 
    //CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nUnable to get basis status.");
  }
 
  /* Copy int column values to double column values */
  for (i=0; i < cols; i++)
    cstat[i] = istat[i];
  
  /* Get iteration count */
  *itcnt = (double)CPXgetitcnt(env,lp);
  
  /* Clean up problem  */
  //CPXfreeprob(env,&lp); 
  //CPXcloseCPLEX(&env);
  
}

