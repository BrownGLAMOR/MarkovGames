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
			self.V[(st.posA, st.posB)] = numpy.array([0.0,0.0])
			self.P[(st.posA, st.posB)] = ("stay", "stay")
	
	# iterateV (n: int) -> void
	# iteratively computes V to "solve" the game
	def iterateV(n):
		for i in range(0,n):
			newV = {}
			for st in _grid.allStates():
				argmaxmaxA = st.bimatrix(self.V).coopAction()
				newV[(st.posA,st.posB)] = self.grid.stepcost + st.expectedReward(argmaxmaxA) + self.gamma*st.expectedValue(argmaxmaxA, self.V)
			self.V = newV
				
