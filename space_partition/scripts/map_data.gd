extends Node

# Imports

const utils = preload("utils.gd")

# Constants

const SIZE = Vector2(20,20)
#const ROOM_SIZE_MEAN = 3
#const ROOM_SIZE_DEVIATION = 1

# Structs

var matrix

func _init():
	matrix = utils.create_empty_matrix(this)

# Others

func print_map_data():
	for corridor in corridor_list:
		var text = "corridor: {"
		for point in corridor.points:
			text+="("+str(point.x)+", "+str(point.y)+")"
		text+="}"
		print(text)
	pass
