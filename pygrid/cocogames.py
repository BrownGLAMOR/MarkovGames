# USAGE: python cocogames.py <GRIDFILE> <NUM_ITERATIONS> <TARGET_FILE_FOR_CONVERGENCE_DATA>
# The first argument is required, but <NUM_ITERATIONS> will default to 10 and if TARGET_FILE_FOR_CONVERGENCE_DATA is not specified the data will not be outputted


import grid
import gridstate
import gridsquare
import bimatrix
import cocosolver
import sys
from Tkinter import *

ITERATIONS=10 # default
root = Tk()
canvas = None
simulation = []
simulation_spot = 0
tkinter_ovals = []
solver = None
def main():
	global root
	global simulation_spot
	global canvas
	global simulation
	global tkinter_ovals
	global solver
	if len(sys.argv)>=3:
		ITERATIONS=int(sys.argv[2])
	print "loading grid"
	testgrid = grid.Grid(sys.argv[1])
	print "grid loaded"
	print "creating solver"
	solver = cocosolver.CocoSolver(testgrid, 0.999)
	print "solver created"
	print "performing cocovalue iteration "+str(ITERATIONS)+" times"
	conv_data = solver.iterateV(ITERATIONS)
	print "done iterating"
	if len(sys.argv)>=4:
		f = open(sys.argv[3],"w")
		f.write("iteration\tmax_difference\n")
		for i in range(0,len(conv_data)):
			f.write(str(i)+"\t"+str(conv_data[i])+"\n")
		f.close()
	print "simulating"
	simulation = solver.simulate()
	simulation_spot = 0
	tkinter_ovals = []	
	canvas = simulation[0].gridstate.renderSelf(root)
	displayState()
	nextbutton = Button(root, text = "Next", command = displayNextState)
	nextbutton.pack()
	prevbutton = Button(root, text = "Prev", command = displayPrevState)
	prevbutton.pack()
	canvas.pack(fill=BOTH)
	root.mainloop()

def displayNextState():
	global root
	global simulation_spot
	global canvas
	global simulation
	global tkinter_ovals
	if simulation_spot < len(simulation) - 1:
		simulation_spot += 1
		displayState()

def displayPrevState():
	global root
	global simulation_spot
	global canvas
	global simulation
	global tkinter_ovals
	if simulation_spot >=1:	
		simulation_spot -= 1
		displayState()

def displayState():
	global canvas
	global root
	global simulation_spot
	global simulation
	global tkinter_ovals
	global solver
	for oval_id in tkinter_ovals: canvas.delete(oval_id)
	tkinter_ovals.append(canvas.create_oval(gridsquare.GridSquare().size*simulation[simulation_spot].gridstate.getPosA()[0], gridsquare.GridSquare().size*simulation[simulation_spot].gridstate.getPosA()[1], gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.getPosA()[0]+1), gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.getPosA()[1]+1), fill="green"))
	tkinter_ovals.append(canvas.create_oval(gridsquare.GridSquare().size*simulation[simulation_spot].gridstate.getPosB()[0], gridsquare.GridSquare().size*simulation[simulation_spot].gridstate.getPosB()[1], gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.getPosB()[0]+1), gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.getPosB()[1]+1), fill="red"))
	tkinter_ovals.append(canvas.create_text(gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.posA[0]+0.5),gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.posA[1]+0.5), text="A",fill="black",font=("Helvetica","30"))) 
	tkinter_ovals.append(canvas.create_text(gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.posB[0]+0.5),gridsquare.GridSquare().size*(simulation[simulation_spot].gridstate.posB[1]+0.5), text="B",fill="black",font=("Helvetica","30")))
	status_string = simulation[simulation_spot].getStatus(solver)
	tkinter_ovals.append(canvas.create_text(250, gridsquare.GridSquare().size*simulation[simulation_spot].gridstate.grid.height + 150, text=status_string, fill="black",font=("Helvetica","10")))
	
	canvas.pack(fill=BOTH)	

if __name__ == "__main__":
	main()
