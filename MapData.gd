extends Node

const SIZE = Vector2(10,10)

class Room:
	var init_pos
	var size

class Corridor:
	var points


var roomList
var corridorList

func _init():
	roomList = []
	corridorList = []

func create_room(init_pos, size):
	var room = Room.new()
	room.init_pos = init_pos
	room.size = size
	roomList.append(room)

func create_corridor(points):
	var corridor = Corridor.new()
	corridor.points = points
	corridorList.append(corridor)

func print_map_data():
	pass
