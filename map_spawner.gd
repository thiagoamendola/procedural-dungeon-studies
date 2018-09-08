extends Node2D

const MAP_SIZE = Vector2(10,10)

onready var tilemap = get_node("TileMap")

func spawn_map(mapData):
	var i
	var j
	var mi
	var ma
	# Fill map with walls.
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			tilemap.set_cellv(Vector2(i,j), 0)
	# Create rooms.
	for room in mapData.room_list:
		var room_width = Vector2(room.init_pos.x, room.init_pos.x + room.size.x)
		var room_height = Vector2(room.init_pos.y, room.init_pos.y + room.size.y)
		for i in range(room_width.x, room_width.y):
			for j in range(room_height.x, room_height.y):
				tilemap.set_cellv(Vector2(i,j), 1)
	# Create corridors.
	for corridor in mapData.corridor_list:
		for k in range(corridor.points.size()-1):
			var cur_point = corridor.points[k]
			var next_point = corridor.points[k+1]
			if cur_point.x == next_point.x:
				i = cur_point.x
				mi = min(cur_point.y, next_point.y)
				ma = max(cur_point.y, next_point.y)+1
				for j in range(mi, ma):
					tilemap.set_cellv(Vector2(i,j), 1)
			elif cur_point.y == next_point.y:
				j = cur_point.y
				mi = min(cur_point.x, next_point.x)
				ma = max(cur_point.x, next_point.x)+1
				for i in range(mi, ma):
					tilemap.set_cellv(Vector2(i,j), 1)
			tilemap.set_cellv(next_point, 1)
	pass
