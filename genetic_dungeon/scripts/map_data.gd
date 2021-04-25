extends Node

# Imports

const utils = preload("utils.gd")

# Constants

const SIZE = Vector2(10,10)
const ROOM_SIZE_MEAN = 3
const ROOM_SIZE_DEVIATION = 1

# Structs

class Room:
	var init_pos
	var size

class Corridor:
	var points


var room_list
var corridor_list
var entrance
var exit

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

func create_random_map():
	var num_rooms = rand_range(2, int(((SIZE.x+SIZE.y)/2)*0.75))
	var num_corridors = rand_range(num_rooms-1, 2*num_rooms)
	for i in range(num_rooms):
		create_random_room()
	for i in range(num_corridors):
		create_random_corridor()
	create_random_entrance_exit()

func create_random_room():
	var room_size = Vector2(utils.normal_limits(ROOM_SIZE_MEAN, ROOM_SIZE_DEVIATION, 2, SIZE.x), utils.normal_limits(ROOM_SIZE_MEAN, ROOM_SIZE_DEVIATION, 2, SIZE.y))
	var room_pos = Vector2(rand_range(0, SIZE.x-room_size.x), rand_range(0, SIZE.y-room_size.y))
	create_room(room_pos, room_size)

func create_random_corridor():
	var num_points = utils.normal_limits(3, 1, 2, 6)
	var points = []
	var axis = int(rand_range(0,2))
	var point
	for i in range(num_points):
		if i == 0 :
			point = Vector2(int(rand_range(0, SIZE.x)), int(rand_range(0, SIZE.y)))
			points.append(point)
		else:
			point = Vector2()
			if axis == 0:
				point.x = points[len(points)-1].x
				point.y = int(rand_range(0, SIZE.y))
			else:
				point.x = int(rand_range(0, SIZE.x))
				point.y = points[len(points)-1].y
			axis = int(axis+1)%2
			points.append(point)
	create_corridor(points)

func create_random_entrance_exit():
	entrance = create_random_position()
	exit = create_random_position()

func create_random_position():
	var room = room_list[rand_range(0, len(room_list))]
	var random_pos = Vector2(int(rand_range(room.init_pos.x, room.init_pos.x + room.size.x)), int(rand_range(room.init_pos.y, room.init_pos.y + room.size.y)))
	return random_pos


# Others

func print_map_data():
	for corridor in corridor_list:
		var text = "corridor: {"
		for point in corridor.points:
			text+="("+str(point.x)+", "+str(point.y)+")"
		text+="}"
		print(text)
	pass
