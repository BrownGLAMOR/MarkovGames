import grid
import gridstate
import gridsquare
import bimatrix
import cocosolver

ITERATIONS=5
def main():
	print "loading grid"
	testgrid = grid.Grid("test.grid")
	print "grid loaded"
	print "creating solver"
	solver = cocosolver.CocoSolver(testgrid, 0.8)
	print "solver created"
	print "performing cocovalue iteration "+str(ITERATIONS)+" times"
	solver.iterateV(ITERATIONS)
	print "done iterating"
	print "printing trajectory"
	solver.printP(50)

if __name__ == "__main__":
	main()
