# USAGE: python cocogames.py <GRIDFILE> <NUM_ITERATIONS> <TARGET_FILE_FOR_CONVERGENCE_DATA>
# The first argument is required, but <NUM_ITERATIONS> will default to 10 and if TARGET_FILE_FOR_CONVERGENCE_DATA is not specified the data will not be outputted


import grid
import gridstate
import gridsquare
import bimatrix
import cocosolver
import sys

ITERATIONS=10 # default
def main():
	if len(sys.argv)>=3:
		ITERATIONS=int(sys.argv[2])
	print "loading grid"
	testgrid = grid.Grid(sys.argv[1])
	print "grid loaded"
	print "creating solver"
	solver = cocosolver.CocoSolver(testgrid, 0.8)
	print "solver created"
	print "performing cocovalue iteration "+str(ITERATIONS)+" times"
	conv_data = solver.iterateV(ITERATIONS)
	print "done iterating"
	print "printing trajectory to 50 steps or until it terminates (to change this number, see pygrid/cocogames.py)"
	solver.printP(50)
	if len(sys.argv)>=4:
		f = open(sys.argv[3],"w")
		f.write("iteration\tmax_difference\n")
		for i in range(0,len(conv_data)):
			f.write(str(i)+"\t"+str(conv_data[i])+"\n")
		f.close()
	

if __name__ == "__main__":
	main()
