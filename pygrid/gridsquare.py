import numpy
class GridSquare:
	def __init__(self, x, y):
		self.pos=numpy.array([x,y])
		self.attr={}
		self.attr["wall_up"]=1.0
		self.attr["wall_down"]=1.0
		self.attr["wall_left"]=1.0
		self.attr["wall_right"]=1.0
		self.attr["goal_a"]=0.0
		self.attr["goal_b"]=0.0
		self.attr["start_a"]=False
		self.attr["start_b"]=False
		self.reachable=True
	
	# setInfo (config_str: String) -> void
	# takes a configuration string (as from a config file) and uses it to configure this square
	def setInfo(self, config_str):
		settings=[elt.split("=") for elt in config_str.split(";")]
		for s in settings:
			name=s[0]
			value=s[1]
			if name=="start_a" or name=="start_b":
				value = bool(value)
			else: value = float(value)
			self.attr[name]=value
	#
	# isNormal() -> bool
	# tells if there's anything abnormal about it
	def isNormal(self):
		return self.attr["wall_up"] == 1.0 and self.attr["wall_down"] == 1.0 and self.attr["wall_left"] == 1.0 and self.attr["wall_right"] == 1.0 and self.attr["goal_a"] == 0.0 and self.attr["goal_b"] == 0.0 and self.attr["start_a"] == False and self.attr["start_b"] == False
	#
	# abnormalAttrs() -> String
	# prints a string representation of everything "abnormal" about this state
	def abnormalAttrs(self):
		ret = ""
		if self.attr["wall_up"]!=1.0: ret += "wall_up = "+str(self.attr["wall_up"])+"; "
		if self.attr["wall_down"]!=1.0: ret += "wall_down = "+str(self.attr["wall_down"])+"; "
		if self.attr["wall_left"]!=1.0: ret += "wall_left = "+str(self.attr["wall_left"])+"; "
		if self.attr["wall_right"]!=1.0: ret += "wall_right = "+str(self.attr["wall_right"])+"; "
		if self.attr["goal_a"]!=0.0: ret += "goal_a = "+str(self.attr["goal_a"])+"; "
		if self.attr["goal_b"]!=0.0: ret += "goal_b = "+str(self.attr["goal_b"])+"; "
		if self.attr["start_a"]!=False: ret += "start_a = "+str(self.attr["start_a"])+"; "
		if self.attr["start_b"]!=False: ret += "start_b = "+str(self.attr["start_b"])+"; "
		return ret
				
