import numpy
from operator import add,neg
class Bimatrix:
	# a bimatrix looks like this:
	# 
	#	up	down	left	right   stay
	# up    ..	..	..	..	..
	# down  ..	..	..	..	..
	# left  ..	..	..	..	..
	# right .. 	..	..	..	..
	# stay  ..	..	..	..	..
	# 
	# where each entry is a tuple (float, float) representing the (expected) coco value
	#	of the state resulting from agent A taking the row action and agent B taking
	#	the column action.
	# any action pair that has a chance of the agents running into each other is given
	#	coco value (-inf, -inf) because we just never want that to happen.
	# it's stored in a dict accessible by action tuples
	def __init__(self, _entries):
		"""if(_entries == None):
			self.entries={}
			for a1 in ["up","down","left","right","stay"]:
				for a2 in ["up","down","left","right","stay"]:
					self.entries[(a1,a2)] = numpy.array([0.0,0.0])
		else:"""
		self.entries = _entries
	
	# coopVal() -> (float,float)
	# gives the cooperative (i.e. max-max of the cooperative matrix) value of the bimatrix
	def coopVal(self):
		coopMat = {}
		for key in self.entries:
			coopMat[key] = (self.entries[key][0] + self.entries[key][1])/2.0
		max_val = float("-inf")
		max_key = ""
		for key in coopMat:
			if(coopMat[key] > max_val):
				max_key = key
				max_val = coopMat[max_key]
		return numpy.array([max_val,max_val])
	#
	# coopAction() -> (string, string)
	# gives the (rowAction, colAction) string tuple which leads to the max-max
	def coopAction(self):
		coopMat = {}
		for key in self.entries:
			coopMat[key] = (self.entries[key][0] + self.entries[key][1])/2.0
		max_val = float("-inf")
		max_key = ""
		for key in coopMat:
			if(coopMat[key] > max_val):
				max_key = key
				max_val = coopMat[max_key]
		return max_key	
	#
	# compVal() -> (float,float)
	# gives the competitive (i.e. min-max of the competitive matrix) value of the bimatrix
	def compVal(self):
		
		compMat = {}
		for key in self.entries:
			tmp = (self.entries[key][0] - self.entries[key][1])/2.0
			compMat[key] = numpy.array([tmp,-tmp])
		actionA = ""
		rowRewards = {}
		for a in ["up","down","left","right","stay"]:
			rowval = float("-inf")
			for b in ["up","down","left","right","stay"]:
				rowval = max(rowval, compMat[(a,b)][1])
			rowRewards[a] = rowval
		minrowval = float("inf")
		for a in rowRewards:
			if(rowRewards[a] < minrowval):
				actionA = a
				minrowval = rowRewards[a]
		actionB = ""
		colRewards = {}
		for b in ["up","down","left","right","stay"]:
			colval = float("-inf")
			for a in ["up","down","left","right","stay"]:
				colval = max(colval, compMat[(a,b)][0])
			colRewards[b] = colval
		mincolval = float("inf")
		for b in colRewards:
			if(colRewards[b] < mincolval):
				actionB = b
				mincolval = colRewards[b]
		return compMat[(actionA, actionB)]
		
	#
	# cocoVal() -> (float, float)
	# gives the coco value of the bimatrix
	def cocoVal(self):
		return self.coopVal() + self.compVal()
		
	#
	# stringOfDecomposition() -> string
	# gives a string representing the bimatrix, the coco decomposition of the bimatrix, and the coco value
	def stringOfDecomposition(self):
		ret = "\t\tu\t\td\t\tl\t\tr\t\ts\n"
		ret += "\tu\t"+str(self.entries[("up","up")])+"\t"+str(self.entries[("up","down")])+"\t"+str(self.entries[("up","left")])+"\t"+str(self.entries[("up","right")])+"\t"+str(self.entries[("up","stay")])+"\n"
		ret += "\td\t"+str(self.entries[("down","up")])+"\t"+str(self.entries[("down","down")])+"\t"+str(self.entries[("down","left")])+"\t"+str(self.entries[("down","right")])+"\t"+str(self.entries[("down","stay")])+"\n"
		ret += "\tl\t"+str(self.entries[("left","up")])+"\t"+str(self.entries[("left","down")])+"\t"+str(self.entries[("left","left")])+"\t"+str(self.entries[("left","right")])+"\t"+str(self.entries[("left","stay")])+"\n"
		ret += "\tr\t"+str(self.entries[("right","up")])+"\t"+str(self.entries[("right","down")])+"\t"+str(self.entries[("right","left")])+"\t"+str(self.entries[("right","right")])+"\t"+str(self.entries[("right","stay")])+"\n"
		ret += "\ts\t"+str(self.entries[("stay","up")])+"\t"+str(self.entries[("stay","down")])+"\t"+str(self.entries[("stay","left")])+"\t"+str(self.entries[("stay","right")])+"\t"+str(self.entries[("stay","stay")])+"\n"
		ret += "\n\t\tCocoValue: "+str(self.cocoVal())+" = "+str(self.coopVal())+" + "+str(self.compVal())+"\n"
		return ret
