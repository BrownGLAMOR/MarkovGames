import numpy
import grid
import gridsquare
class GridState:
	def __init__(self, _posA, _posB, _grid):
		self.posA=_posA
		self.posB=_posB
		self.grid=_grid
	
	# nextState (actionA:string, actionB:string) -> GridState
	# returns the state arising from taking those two actions, assuming they both succeed
	# allows for pretty much anything going wrong, for example, going off the board, agents running into each other
	def nextState(self, actionA, actionB):
		changeA = numpy.array([0,0])
		changeB = numpy.array([0,0])
		if actionA == "left": changeA = numpy.array([-1,0])
		elif actionA == "right": changeA = numpy.array([1,0])
		elif actionA == "up": changeA = numpy.array([0,-1])
		elif actionA == "down": changeA = numpy.array([0,1])
		if actionB == "left": changeB = numpy.array([-1,0])
		elif actionB == "right": changeB = numpy.array([1,0])
		elif actionB == "up": changeB = numpy.array([0,-1])
		elif actionB == "down": changeB = numpy.array([0,1])			
		return GridState(self.posA + changeA, self.posB + changeB, self.grid)
	#	
	# getReward() -> numpy.array([float,float])
	# returns the immediate reward arising from this state
	def getReward(self):
		if numpy.array_equal(self.posA, self.posB): return numpy.array([-1,-1])
		else: return numpy.array([self.grid.getSquare(self.posA).goal_a, self.grid.getSquare(self.posB).goal_b])
	#
	# possibleResultantStates(string tuple) -> list of (GridState, float in [0,1])
	# returns a list of tuples of resultant states and their associated probabilities given that agents take the two given actions
	#
	def possibleResultantStates(self, actions):
		if actions[0] == "left" and not self.grid.isSquare(self.posA + numpy.array([-1,0])):
			actions[0] = "stay"
		if actions[0] == "right" and not self.grid.isSquare(self.posA + numpy.array([1,0])):
			actions[0] = "stay"
		if actions[0] == "up" and not self.grid.isSquare(self.posA + numpy.array([0,-1])):
			actions[0] = "stay"
		if actions[0] == "down" and not self.grid.isSquare(self.posA + numpy.array([0,1])):
			actions[0] = "stay"
		if actions[1] == "left" and not self.grid.isSquare(self.posB + numpy.array([-1,0])):
			actions[1] = "stay"
		if actions[1] == "right" and not self.grid.isSquare(self.posB + numpy.array([1,0])):
			actions[1] = "stay"
		if actions[1] == "up" and not self.grid.isSquare(self.posB + numpy.array([0,-1])):
			actions[1] = "stay"
		if actions[1] == "down" and not self.grid.isSquare(self.posB + numpy.array([0,1])):
				actions[1] = "stay"
	
		if actions == ("stay","stay"):
			return [(self, 1.0)]
		else:
			probA=1.0
			probB=1.0
			if actions[0] != "stay": probA=self.grid.getSquare(posA).attr["wall_"+actions[0]]
			if actions[1] != "stay": probB=self.grid.getSquare(posB).attr["wall_"+actions[1]]
			ret = []
			# case 1: they both fail
			ret.append((self,(1.0-probA)*(1.0-probB)))
			# case 2: they both succeed
			ret.append((self.nextState(actions[0],actions[1]), probA*probB))
			# case 3: A succeeds, B fails
			ret.append((self.nextState(actions[0],"stay"), probA*(1.0-probB)))
			# case 4: A fails, B succeeds
			ret.append((self.nextState("stay",actions[1]), (1.0-probA)*probB))
		return ret
	#
	# expectedValue(string tuple, (V: dict from (numpy.array([int,int]), numpy.array([int,int])) to numpy.array([float,float])) -> (float,float)
	# returns the expected value from taking the two given actions using the state value "guesses" given in V
	def expectedValue(self, actions, V):
		possibleStates = self.possibleResultantStates(actions)
		val = numpy.array([0,0])
		for i in possibleStates:
			if numpy.array_equal(i[0].posA. i[0].posB): val += i[1]*V[(self.posA, self.posB)]
			else: val += V[(i[0].posA, i[0].posB)]*i[1]
		return val	
	
	# expectedReward(string tuple) -> (float, float)
	# returns the expected reward from taking the two given actions
	def expectedReward(self, actions):
		possibleStates = self.possibleResultantStates(actions)
		rew = numpy.array([0,0])
		for i in possibleStates:
			rew += i[0].getReward()*i[1]
		return rew
			
	# bimatrix (V: dict from (posA, posB) to numpy.array([float,float])) -> Bimatrix
	# returns the bimatrix of values associated with this state
	# each entry is the expected cocovalue of the resulting state, using values from V and transition probabilities given by the grid
	# if an action pair could possibly result in the agents running into each other, the entry is (-inf, -inf)
	def bimatrix(self, V):
		mat = {}
		for action1 in ["up","down","left","right","stay"]:
			for action2 in ["up","down","left","right","stay"]:
				mat[(action1,action2)] = self.expectedValue((action1,action2), V)
		return Bimatrix(mat)
