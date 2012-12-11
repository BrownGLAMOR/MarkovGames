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
	
	# iterateV (n: int) -> float list
	# iteratively computes V to "solve" the game
	# returns a list of iteration differences (i.e. convergence metric) where the ith entry is (iteration i) - (iteration i-1), where iteration 0 is the initial state
	def iterateV(self, n):
		max_diff = []
		for i in range(0,n):
			max_diff.append(0)
		for i in range(0,n):
			print("iteration "+str(i))
			newV = {}
			allStates = self.grid.allStates()
			for st in allStates:
				argmaxmaxA = st.bimatrix(self.V, self.gamma).coopAction()
				newV[(st.getPosA(),st.getPosB())] = st.bimatrix(self.V, self.gamma).cocoVal()
				self.P[(st.getPosA(), st.getPosB())] = argmaxmaxA
			max_d = 0
			for key in newV:
				max_d = max(max_d, abs(newV[key][0] - self.V[key][0]), abs(newV[key][1] - self.V[key][1]))
			max_diff[i] = max_d
			self.V = newV
		return max_diff
	#
	# printP(n:int) -> void
	# visualizes the learned policy to n steps (or until it naturally terminates)
	def printP(self, n):
		currState = gridstate.GridState(self.grid.start_a.pos, self.grid.start_b.pos, self.grid)
		for i in range(0,n):
			print currState.toString()
			policy = self.P[(currState.getPosA(), currState.getPosB())]
			print "I think the value of the current state is "+str(self.V[(currState.getPosA(), currState.getPosB())])
			a_at_goal = False
			b_at_goal = False
			if self.grid.getSquare(currState.getPosA()).attr["goal_a"]!=0.0:a_at_goal = True
			if self.grid.getSquare(currState.getPosB()).attr["goal_b"]!=0.0: b_at_goal = True
			if a_at_goal: print "A reached a goal with reward amount "+str(self.grid.getSquare(currState.getPosA()).attr["goal_a"])
			if b_at_goal: print "B reached a goal with reward amount "+str(self.grid.getSquare(currState.getPosB()).attr["goal_b"])
			if a_at_goal or b_at_goal:
				print "Game has ended!"
				break
			currState = currState.nextState(policy[0],policy[1])
				
	
				
