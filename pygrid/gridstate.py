import numpy
import grid
import gridsquare
import bimatrix
import random
class GridState:
	def __init__(self, _posA, _posB, _grid):
		self.posA=_posA
		self.posB=_posB
		self.grid=_grid
	
	# rawNextState (actionA:string, actionB:string) -> GridState
	# returns the state arising from taking those two actions, assuming they both succeed
	# allows for pretty much anything going wrong, for example, going off the board, agents running into each other
	def rawNextState(self, actionA, actionB):
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
	# nextState (actionA:string, actionB:string) -> GridState
	# returns the state arising from taking those two actions
	# does the real stuff, i.e. supports semiwalls and if they run into eachother then nothing happens
	def nextState(self, actionA, actionB):		
		changeA = numpy.array([0,0])
		changeB = numpy.array([0,0])
		randA = random.random()
		randB = random.random()
		if actionA == "left": 
			if(randA < self.grid.getSquare(self.getPosA()).attr["wall_left"]): changeA = numpy.array([-1,0])
		elif actionA == "right":
			if(randA < self.grid.getSquare(self.getPosA()).attr["wall_right"]): changeA = numpy.array([1,0])
		elif actionA == "up": 
			if(randA < self.grid.getSquare(self.getPosA()).attr["wall_up"]): changeA = numpy.array([0,-1])
		elif actionA == "down": 
			if(randA < self.grid.getSquare(self.getPosA()).attr["wall_down"]): changeA = numpy.array([0,1])
		if actionB == "left": 
			if(randB < self.grid.getSquare(self.getPosB()).attr["wall_left"]): changeB = numpy.array([-1,0])
		elif actionB == "right":
			if(randB < self.grid.getSquare(self.getPosB()).attr["wall_right"]): changeB = numpy.array([1,0])
		elif actionB == "up": 
			if(randB < self.grid.getSquare(self.getPosB()).attr["wall_up"]): changeB = numpy.array([0,-1])
		elif actionB == "down": 
			if(randB < self.grid.getSquare(self.getPosB()).attr["wall_down"]): changeB = numpy.array([0,1])
		newA = self.posA + changeA
		newB = self.posB + changeB
		if newA[0] < 0 or newA[0] >= self.grid.width or newA[1] < 0 or newA[1] >= self.grid.height: newA = self.posA	
		if newB[0] < 0 or newB[0] >= self.grid.width or newB[1] < 0 or newB[1] >= self.grid.height: newB = self.posB
		if numpy.array_equal(self.posA, self.posB):
			newA = self.posA
			newB = self.posB
		return GridState(newA,newB,self.grid)
	#			
	# getReward() -> numpy.array([float,float])
	# returns the immediate reward arising from this state
	def getReward(self):
		if numpy.array_equal(self.posA, self.posB): return numpy.array([-1,-1])
		else: return numpy.array([self.grid.getSquare(self.posA).attr["goal_a"], self.grid.getSquare(self.posB).attr["goal_b"]])
	#
	# possibleResultantStates(string tuple) -> list of (GridState, float in [0,1])
	# returns a list of tuples of resultant states and their associated probabilities given that agents take the two given actions
	#
	def possibleResultantStates(self, actions):
		a = [actions[0], actions[1]]
		if actions[0] == "left" and not self.grid.isSquare(self.posA + numpy.array([-1,0])):
			a[0] = "stay"
		if actions[0] == "right" and not self.grid.isSquare(self.posA + numpy.array([1,0])):
			a[0] = "stay"
		if actions[0] == "up" and not self.grid.isSquare(self.posA + numpy.array([0,-1])):
			a[0] = "stay"
		if actions[0] == "down" and not self.grid.isSquare(self.posA + numpy.array([0,1])):
			a[0] = "stay"
		if actions[1] == "left" and not self.grid.isSquare(self.posB + numpy.array([-1,0])):
			a[1] = "stay"
		if actions[1] == "right" and not self.grid.isSquare(self.posB + numpy.array([1,0])):
			a[1] = "stay"
		if actions[1] == "up" and not self.grid.isSquare(self.posB + numpy.array([0,-1])):
			a[1] = "stay"
		if actions[1] == "down" and not self.grid.isSquare(self.posB + numpy.array([0,1])):
			a[1] = "stay"
	
		if a == ["stay","stay"]:
			return [(self, 1.0)]
		else:
			probA=1.0
			probB=1.0
			if a[0] != "stay": probA=self.grid.getSquare(self.posA).attr["wall_"+a[0]]
			if a[1] != "stay": probB=self.grid.getSquare(self.posB).attr["wall_"+a[1]]
			ret = []
			# case 1: they both fail
			ret.append((self,(1.0-probA)*(1.0-probB)))
			# case 2: they both succeed
			ret.append((self.rawNextState(a[0],a[1]), probA*probB))
			# case 3: A succeeds, B fails
			ret.append((self.rawNextState(a[0],"stay"), probA*(1.0-probB)))
			# case 4: A fails, B succeeds
			ret.append((self.rawNextState("stay",a[1]), (1.0-probA)*probB))
		return ret
	#
	# expectedCocoValue(string tuple, (V: dict from (numpy.array([int,int]), numpy.array([int,int])) to numpy.array([float,float])) -> (float,float)
	# returns the expected coco value from taking the two given actions using the state value "guesses" given in V
	def expectedCocoValue(self, actions, V):
		possibleStates = self.possibleResultantStates(actions)
		val = numpy.array([0,0])
		for i in possibleStates:
			if numpy.array_equal(i[0].posA, i[0].posB): val += i[1]*self.bimatrix(V).cocoVal()
			else: val += i[1]*i[0].bimatrix(V).cocoVal()
		return val
	# expectedValue(string tuple, (V: dict from (numpy.array([int,int]), numpy.array([int,int])) to numpy.array([float,float])) -> (float,float)
	# returns the expected value from taking the two given actions using the state value "guesses" given in V
	def expectedValue(self, actions, V):
		possibleStates = self.possibleResultantStates(actions)
		val = numpy.array([0,0])
		for i in possibleStates:
			if numpy.array_equal(i[0].posA, i[0].posB): val += i[1]*V[(self.getPosA(), self.getPosB())]
			else: val += V[(i[0].getPosA(), i[0].getPosB())]*i[1]
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
		return bimatrix.Bimatrix(mat)
	#
	# toString () -> String
	# returns an ascii representation
	def toString(self):
		ret = ""
		sq_id = 0
		refs = {}
		for y in range(0, self.grid.height):
			for x in range(0, self.grid.width):
				currSquare = self.grid.getSquare((x,y))
				if numpy.array_equal(self.posA, numpy.array([x,y])):
					ret += "A"
				elif numpy.array_equal(self.posB, numpy.array([x,y])):
					ret += "B"
				elif currSquare.isNormal():ret += "N"
				else: 
					ret+=str(sq_id)
					refs[sq_id] = currSquare
					sq_id += 1
			ret += "\n"
		for key in refs:
			ret += str(key)+": "+refs[key].abnormalAttrs()+"\n"
		return ret
	#
	# getters
	def getPosA(self):
		return (self.posA[0], self.posA[1])
	def getPosB(self):
		return (self.posB[0], self.posB[1])
