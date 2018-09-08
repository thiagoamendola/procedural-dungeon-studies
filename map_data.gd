extends Node

# Imports

const utils = preload("utils.gd")

# Constants

const SIZE = Vector2(10,10)
const MEAN = 3
const DEVIATION = 1

# Structs

class Room:
	var init_pos
	var size

class Corridor:
	var points


var room_list
var corridor_list

func _init():
	room_list = []
	corridor_list = []

# Creation

func create_room(init_pos, size):
	var room = Room.new()
	room.init_pos = init_pos
	room.size = size
	room_list.append(room)

func create_corridor(points):
	var corridor = Corridor.new()
	corridor.points = points
	corridor_list.append(corridor)

# Random creation

func create_random_room():
    var room_size = Vector2(utils.normal_limits(MEAN, DEVIATION, 2, SIZE.x), utils.normal_limits(MEAN, DEVIATION, 2, SIZE.y))
    var room_pos = Vector2(rand_range(1, SIZE.x-room_size.x-1), rand_range(1, SIZE.y-room_size.y-1))
    create_room(room_pos, room_size)

func create_random_corridor():
	var num_points = utils.normal_limits(3, 1, 2, 6)
	var points = []
	var axis = int(rand_range(0,2))
	var point
	for i in range(num_points):
		if i==0 :
			point = Vector2(int(rand_range(1, SIZE.x-1)), int(rand_range(1, SIZE.y-1)))
			points.append(point)
		else:
			point = Vector2()
			if axis==0:
				point.x=points[len(points)-1].x
				point.y=int(rand_range(1, SIZE.y-1))
			else:
				point.x=int(rand_range(1, SIZE.x-1))
				point.y=points[len(points)-1].y
			axis=int(axis+1)%2
			points.append(point)
	create_corridor(points)


func print_map_data():
	for corridor in corridor_list:
		var text = "corridor: {"
		for point in corridor.points:
			text+="("+str(point.x)+", "+str(point.y)+")"
		text+="}"
		print(text)
	pass
