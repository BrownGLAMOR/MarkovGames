import numpy
import grid
import gridsquare
import gridstate
import bimatrix
import random
class SimState:
	def __init__(self, state, value_guess):
		self.a_winnings = state.grid.getSquare(state.getPosA()).attr["goal_a"]
		self.b_winnings = state.grid.getSquare(state.getPosB()).attr["goal_b"]
		self.gridstate = state
		self.value = value_guess
	
	def getStatus(self, solver):
		ret = ""
#		ret += "I think the value of this state is "+str(self.value)+"\n"
		ret += self.gridstate.bimatrix(solver.V, solver.gamma).stringOfDecomposition()
		if self.a_winnings != 0: ret+= "A has reached a goal worth "+str(self.a_winnings)+"\n"
		if self.b_winnings != 0: ret+= "B has reached a goal worth "+str(self.b_winnings)
		return ret
