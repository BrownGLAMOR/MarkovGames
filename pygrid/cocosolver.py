import numpy
import grid
import gridstate
import bimatrix
import gridsquare
class CocoSolver:
	def __init__(self, _grid, _gamma):
		self.grid = _grid
		self.gamma = _gamma
		self.V = {}
		self.P = {}
		for st in _grid.allStates():
			self.V[(st.getPosA(), st.getPosB())] = numpy.array([0.0,0.0])
			self.P[(st.getPosA(), st.getPosB())] = ("stay", "stay")
	
	# iterateV (n: int) -> void
	# iteratively computes V to "solve" the game
	def iterateV(self, n):
		for i in range(0,n):
			print("iteration "+str(i))
			newV = {}
			allStates = self.grid.allStates()
			for st in allStates:
				argmaxmaxA = st.bimatrix(self.V).coopAction()
				newV[(st.getPosA(),st.getPosB())] = numpy.array([self.grid.stepcost,self.grid.stepcost]) + st.expectedReward(argmaxmaxA) + self.gamma*st.expectedCocoValue(argmaxmaxA, self.V)
				self.P[(st.getPosA(), st.getPosB())] = argmaxmaxA
			self.V = newV
	#
	# printP(n:int) -> void
	# visualizes the learned policy to n steps
	def printP(self, n):
		currState = gridstate.GridState(self.grid.start_a.pos, self.grid.start_b.pos, self.grid)
		for i in range(0,n):
			print currState.toString()
			policy = self.P[(currState.getPosA(), currState.getPosB())]
			currState = currState.nextState(policy[0],policy[1])
			print "I think the value of the current state is "+str(self.V[(currState.getPosA(), currState.getPosB())])
			
			
	
				
