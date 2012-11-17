/*********************************************************************
 * qp_cplex_mex.c - Mexfile for connexting MATLAB with CPLEX QP      *
 &                  solver                                           *
 * Copyright 2000 David R. Musicant                                  *
 * Designed for CPLEX 6.5. Version 1.0                               *
 * Please report bugs to musicant@cs.wisc.edu.                       *
 * This software is free for academic and research use only.         *
 * For commercial use, contact musicant@cs.wisc.edu.                 *
 *********************************************************************
 * Notes:                                                            *
 * H and Q are identical. (qp calls it H, CPLEX calls it Q)          *
 * CPLEX does not properly return the number of iterations.          *
 *********************************************************************/

#include "cplex.h"
#include <stdlib.h>
#include <string.h>
#include "mex.h"

#define MINIMIZE 1

/* Input arguments */
#define H_IN    prhs[0]
#define F_IN    prhs[1]
#define A_IN    prhs[2]
#define B_IN    prhs[3]
#define L_IN    prhs[4]
#define U_IN    prhs[5]
#define X0_IN   prhs[6]
#define N_IN    prhs[7]
#define ITER_IN prhs[8]

/* Output arguments */
#define OBJ_OUT    0
#define X_OUT      1
#define PI_OUT     2
#define STAT_OUT   3
#define ITER_OUT   4

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Local pointers for MATLAB rhs parameters */
  double *H,*f,*A,*b,*x0,*iterptr;
  int N, advStart;
  
  /* Mex function return arguments */
  int qpstat;
  double *obj,*x,*pi,*itcnt;

  /* Other declarations */
  int      cols, rows,*matbeg,*matcnt,*matind,*qmatbeg,*qmatcnt,*qmatind;
  int      maxIter,nA,status,i,j,m,n,*istat; 
  double   *b_ptr,*matval,*qmatval,*l_ptr,*u_ptr,*matqpstat;
  char     *sense,errorMsg[255];
  CPXENVptr env;
  CPXLPptr lp = NULL;

  /* Assign pointers to MATLAB memory stuctures */
  if (nrhs < 4)
    mexErrMsgTxt("qp_cplex_mex: Too few number of input arguments.");
  
  H = (double *)mxGetPr(H_IN);
  f = (double *)mxGetPr(F_IN);
  A = (double *)mxGetPr(A_IN);
  b = (double *)mxGetPr(B_IN);
  nA = mxGetN(A_IN);
  cols  = mxGetM(F_IN);
  rows  = mxGetM(B_IN);
  b_ptr = mxGetPr(B_IN);

  /* Set lower bounds to -inf if unspecified */
  if (nrhs >= 5)
    l_ptr = (double *)mxGetPr(L_IN);
  else {
    l_ptr = (double *)mxMalloc(nA*sizeof(double));
    for (i=0; i < nA; i++)
      l_ptr[i] = -(CPX_INFBOUND+1);
  }
    
  /* Set upper bounds to inf if unspecified */
  if (nrhs >= 6)
    u_ptr = (double *)mxGetPr(U_IN);
  else {
    u_ptr = (double *)mxMalloc(nA*sizeof(double));
    for (i=0; i < nA; i++)
      u_ptr[i] = CPX_INFBOUND+1;
  }

  /* Obtain and set up advanced start, if available */
  advStart = 0;
  if (nrhs >= 7) {
    x0 = (double *)mxGetPr(X0_IN);
    if (mxGetM(X0_IN)>0)
      advStart = 1;
  }

  /* Obtain number of initial equality constraints, if available */
  if (nrhs >= 8)
    N = (int)mxGetScalar(N_IN);
  else
    N = 0;
    
  /* Set up maximum number of iterations */
  if (nrhs >= 9) {
    maxIter = (int)mxGetScalar(ITER_IN);
  } else
    maxIter = 10000;

  /* Build the matrix of constraint coefficients, taking sparsity into
     account. */

  if (mxIsSparse(A_IN)) {
    /* Sparse */
    matbeg = mxGetJc(A_IN);  /* beginnings of each column */
    matcnt = (int*)mxCalloc(cols,sizeof(int));  /* # of entries in each col */
    for(i = 0; i < cols; i++)
      matcnt[i] = matbeg[i + 1] - matbeg[i];
    matind = mxGetIr(A_IN);   /* row locations */
    matval = mxGetPr(A_IN);   /* actual coefficients */

  } else {
    /* Dense */
    m = mxGetM(A_IN);
    n = mxGetN(A_IN);
    matbeg = (int *) mxCalloc(n,sizeof(int));
    matcnt = (int *) mxCalloc(n,sizeof(int));
    matind = (int *) mxCalloc(m*n,sizeof(int));
    matval = mxGetPr(A_IN);
    for(j = 0; j < n; j++) {
      matbeg[j] = j*m;
      for(i = 0; i < m; i++)
	matind[j*m + i] = i; 
      matcnt[j] = m;
    }
  }

  /* Quadaratic coefficient Matrix. Since CPLEX bombs if any of the
     terms are nonzero anyway, only works if input matrix is stored as
     sparse. */

  if(mxIsSparse(H_IN)){
    qmatbeg = mxGetJc(H_IN);
    qmatcnt = (int *) mxCalloc(cols,sizeof(int));
    for(i = 0; i < cols; i++)
      qmatcnt[i] = qmatbeg[i + 1] - qmatbeg[i];
    qmatind = mxGetIr(H_IN);
    qmatval = mxGetPr(H_IN);
  }
  else
    mexErrMsgTxt("\nMex error: Input matrix for H must be sparse.");

  /* Set up first N constraints has equality constraints, and the remainder
     as "<=" constraints. */
  sense = (char *) mxCalloc(rows,sizeof(char));
  for (i=0; (i < rows && i < N); i++)
    sense[i] = 'E';
  for (i=N; i < rows; i++)
    sense[i] = 'L';

  /* Output to MATLAB */
  /************  Output arguments *******************/
  
  plhs[OBJ_OUT]  = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[X_OUT]    = mxCreateDoubleMatrix(cols,1,mxREAL);
  plhs[PI_OUT]   = mxCreateDoubleMatrix(rows,1,mxREAL);
  plhs[STAT_OUT] = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[ITER_OUT] = mxCreateDoubleMatrix(1,1,mxREAL);

  obj   = mxGetPr(plhs[OBJ_OUT]);
  x     = mxGetPr(plhs[X_OUT]);
  pi    = mxGetPr(plhs[PI_OUT]);
  matqpstat = mxGetPr(plhs[STAT_OUT]);
  itcnt = mxGetPr(plhs[ITER_OUT]);

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
		
  /* Copy LP portion into CPLEX environment */
  status = CPXcopylp(env, lp, cols, rows, MINIMIZE, f, b_ptr, sense,
		     matbeg, matcnt, matind, matval, l_ptr, u_ptr, NULL);
  
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not copy CPLEX problem.");
  }

  /* Now copy in QP information */
  status = CPXcopyquad(env, lp, qmatbeg, qmatcnt, qmatind, qmatval);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not copy in quadratic data.");
  }

  /*  Set up advanced start */
  if (advStart) {
    double *rprim = (double *)mxMalloc(rows*sizeof(double));
    for (i=0; i < rows; i++)
      rprim[i] = 0;
    status = CPXcopystart(env,lp,NULL,NULL,x0,rprim,NULL,NULL);
    if (status) {
      printf(CPXgeterrorstring(env,status,errorMsg));
      CPXfreeprob(env,&lp); 
      CPXcloseCPLEX(&env);
      mexErrMsgTxt("\nCould not set starting point.");
    }
    mxFree(rprim);
  }  
  
  /* Set iteration limit. */
  status = CPXsetintparam(env, CPX_PARAM_ITLIM, maxIter);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not set number of iterations.");
  }

  /* Set convergence tolerance to 1e-5 */
  status = CPXsetdblparam(env, CPX_PARAM_BAREPCOMP, 1e-5);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not set convergence tolerance.");
  }

  /* Send output to the screen, since iteration count fails */
  status = CPXsetintparam(env, CPX_PARAM_SCRIND, 1);
  if (status) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nCould not send output to the screen.");
  }

  /* Perform optimization */
  status = CPXbaropt(env,lp);
  if ( status ) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nOptimization error.");
  }

  /* Obtain solution */
  status = CPXsolution(env, lp, &qpstat, obj, x, pi, NULL, NULL);
  *matqpstat =  qpstat;
  if ( status ) {
    printf(CPXgeterrorstring(env,status,errorMsg));
    CPXfreeprob(env,&lp); 
    CPXcloseCPLEX(&env);
    mexErrMsgTxt("\nFailure when retrieving solution.");
  }

  /* Get iteration count (this currently fails) */
  *itcnt = (double)CPXgetitc(env,lp);
  
  /* Clean up problem  */
  CPXfreeprob(env,&lp); 
  CPXcloseCPLEX(&env);

}

