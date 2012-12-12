import numpy
from Tkinter import *
class GridSquare:
	def __init__(self, x=0, y=0):
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
		self.size=90
	
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
		return self.attr["wall_up"] == 1.0 and self.attr["wall_down"] == 1.0 and self.attr["wall_left"] == 1.0 and self.attr["wall_right"] == 1.0 and self.attr["goal_a"] == 0.0 and self.attr["goal_b"] == 0.0 and self.attr["start_a"] == False and self.attr["start_b"] == False and self.reachable == True
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
	# renderSelf (Canvas) (Tk) -> void
	# takes a reference to the tk canvas and draws self in it
	def renderSelf(self, canvas):
		if self.reachable == False: canvas.create_rectangle(self.size*self.pos[0], self.size*self.pos[1], self.size*(self.pos[0]+1), self.size*(self.pos[1]+1), fill="gray")
		else:
			if self.attr["goal_a"] != 0 or self.attr["goal_b"] != 0:
				canvas.create_rectangle(self.size*self.pos[0], self.size*self.pos[1], self.size*(self.pos[0]+1), self.size*(self.pos[1]+1), fill="yellow")
				goal_text = ""
				if self.attr["goal_a"] != 0: goal_text += "A: "+str(self.attr["goal_a"])+"\n"
				if self.attr["goal_b"] != 0: goal_text += "B: "+str(self.attr["goal_b"])
				canvas.create_text(self.size*(self.pos[0] + 0.5), self.size*(self.pos[1] + 0.5), text=goal_text, fill="black", font=("Helvetica","15"))
			else:
				canvas.create_rectangle(self.size*self.pos[0], self.size*self.pos[1], self.size*(self.pos[0]+1), self.size*(self.pos[1]+1), fill="white")
			if self.attr["wall_up"]!=1.0: canvas.create_line(self.size*self.pos[0], self.size*self.pos[1], self.size*(self.pos[0]+1), self.size*self.pos[1], fill="turquoise", width=4, dash=(int(5*(1-self.attr["wall_up"])), int(5*self.attr["wall_up"])))
			if self.attr["wall_down"]!=1.0: canvas.create_line(self.size*self.pos[0], self.size*(self.pos[1]+1), self.size*(self.pos[0]+1), self.size*(self.pos[1]+1), fill="turquoise", width=4, dash=(int(5*(1-self.attr["wall_down"])), int(5*self.attr["wall_down"])))
			if self.attr["wall_left"]!=1.0: canvas.create_line(self.size*self.pos[0], self.size*self.pos[1], self.size*self.pos[0], self.size*(self.pos[1]+1), fill="turquoise", width=4, dash=(int(5*(1-self.attr["wall_left"])), int(5*self.attr["wall_left"])))
			if self.attr["wall_right"]!=1.0: canvas.create_line(self.size*(self.pos[0]+1), self.size*self.pos[1], self.size*(self.pos[0]+1), self.size*(self.pos[1]+1), fill="turquoise", width=4, dash=(int(5*(1-self.attr["wall_right"])), int(5*self.attr["wall_right"])))
		
	
				
