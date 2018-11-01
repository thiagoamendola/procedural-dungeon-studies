extends Node

# Imports

const utils = preload("utils.gd")

# Constants

const SIZE = Vector2(20,20)
const MIN_SIZE = Vector2(3,3)

# Structs

var matrix

func _init():
	matrix = utils.create_empty_matrix(self)

# Others

func print_map_data():
	pass
