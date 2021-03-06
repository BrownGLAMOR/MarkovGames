import numpy
import bimatrix
import gridsquare
import gridstate
class Grid:
	def __init__(self,filepath):
		print("loading from "+filepath)
		self.load(filepath)
		
	# load (filepath: string) -> void
	# takes a filepath to a grid configuration file and loads this grid with the information from it
	def load(self, filepath):
		f = open(filepath,'r')
		_width=0
		_height=0
		references={}
		for line in f:
			if(line=="END\n"): break
			_height+=1
			_width=len(line.rstrip())
		self.height = _height
		self.width = _width
		self.squares = [[gridsquare.GridSquare(i,j) for j in range(0,_height)] for i in range(0,_width)]
		squareInfo=False
		currLine=0
		f.close()
		f = open(filepath, 'r')
		for line in f:
			line = line.rstrip()
			if(squareInfo==True):
				ident=line.split(":")[0]
				info=line.split(":")[1]
				if ident=="stepcost":
					self.stepcost = 0#float(info)
				else:
					settings=[s.split("=")[0] for s in info.split(";")]
					if "start_a" in settings: self.start_a = references[ident]
					elif "start_b" in settings: self.start_b = references[ident]
					references[ident].setInfo(info)
			elif(squareInfo==False):
				if(line=="END"):
					squareInfo=True
					continue
				else:
					for i in range(0, len(line)):
						if(line[i]=="X"): self.squares[i][currLine].reachable=False
						elif(line[i]!="N"): references[line[i]]=self.squares[i][currLine]
						self.squares[i][currLine].pos = (i,currLine)
			currLine += 1
	#
	# getSquare (int,int) -> GridSquare
	# returns the GridSquare at the given coordinates
	# returns None if coordinates are out of bounds
	def getSquare(self, pos):
		if pos[0] < self.width and pos[0] >= 0 and pos[1] < self.height and pos[1] >= 0:
			return self.squares[pos[0]][pos[1]]
		else: return None
	#
	# isSquare (int,int) -> bool
	# returns whether there is a reachable square at the given coordinates
	def isSquare(self, pos):
		if pos[0] < self.width and pos[0] >= 0 and pos[1] < self.height and pos[1] >= 0:
			return self.getSquare(pos).reachable
		else: return False
	#
	# reachableSquares () -> list of GridSquare
	# returns a list of all the reachable squares in the grid i.e. squares that were not given as 'X'
	# helper for allStates
	def reachableSquares(self):
		ret = []
		for x in range(0, self.width):
			for y in range(0, self.height):
				if(self.squares[x][y].reachable == True): ret.append(self.squares[x][y])
		return ret
	#
	# allStates () -> list of GridState
	# returns all possible states i.e. all possible configurations of 2 agents in the grid
	def allStates(self):
		states = []
		squares = self.reachableSquares()
		for square1 in squares:
			for square2 in squares:
				if not numpy.array_equal(square1.pos, square2.pos): 
					states.append(gridstate.GridState(square1.pos,square2.pos,self))
		return states
	#
	

	
					
					
		
		
