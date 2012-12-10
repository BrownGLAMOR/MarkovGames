import numpy
class GridSquare:
	def __init__(self, x, y):
		self.pos=numpy.array([x,y])
		self.attr={}
		self.attr["wall_up"]=1.0
		self.attr["wall_down"]=1.0
		self.attr["wall_left"]=1.0
		self.attr["wall_right"]=1.0
		self.attr["goal_a"]=1.0
		self.attr["goal_b"]=1.0
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
			if name=="start_a" or name=="start_b": value = bool(value)
			else: value = float(value)
			self.attr[name]=value
	#
				
