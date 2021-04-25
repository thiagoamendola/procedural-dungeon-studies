extends Node2D

# Imports
const utils = preload("utils.gd")

# Returns a full matrix map.
static func get_map_matrix(map):
	# Create empty map
	var matrix = create_empty_matrix(map.SIZE)
	# Create map of rooms and corridors.
	matrix = create_rooms_matrix(map, matrix, false)
	matrix = create_corridors_matrix(map, matrix, false)
	matrix = create_entrance_exit_matrix(map, matrix)
	return matrix

# Returns a full matrix map.
static func get_map_matrix_border(map):
	var matrix = create_empty_matrix(Vector2(map.SIZE.x+2, map.SIZE.y+2))
	# Get a matrix representation of the map (I think I already have one)
	var raw_matrix = get_map_matrix(map)
	# Assign matrix to map view
	for i in range(map.SIZE.x+2):
		for j in range(map.SIZE.y+2):
			matrix[i][j] = utils.WALL_CELL
	# Fill empty spaces
	for i in range(map.SIZE.x):
		for j in range(map.SIZE.y):
			matrix[i+1][j+1] = raw_matrix[i][j]
	return matrix

# Creates an empty matrix given its proportions.
static func create_empty_matrix(size):
	# Create int map.
	var matrix=[]
	for x in range(size.x):
		matrix.append([])
		matrix[x]=[]
		for y in range(size.y):
			matrix[x].append([])
			matrix[x][y] = utils.WALL_CELL
	return matrix

#
static func create_rooms_matrix(map, matrix, additive=false):
	for room in map.room_list:
		var room_width = Vector2(room.init_pos.x, room.init_pos.x + room.size.x)
		var room_height = Vector2(room.init_pos.y, room.init_pos.y + room.size.y)
		for x in range(room_width.x, room_width.y):
			for y in range(room_height.x, room_height.y):
				if additive:
					matrix[x][y] += 1
				else:
					matrix[x][y] = utils.EMPTY_CELL
	return matrix

static func create_corridors_matrix(map, matrix, additive=false):
	var x_pos
	var y_pos
	var mi
	var ma
	for corridor in map.corridor_list:
		for k in range(corridor.points.size()-1):
			var cur_point = corridor.points[k]
			var next_point = corridor.points[k+1]
			if cur_point.x == next_point.x:
				x_pos = cur_point.x
				mi = min(cur_point.y, next_point.y)
				ma = max(cur_point.y, next_point.y)+1
				for y in range(mi, ma):
					y_pos = y
					if additive:
						matrix[x_pos][y_pos] += 1
					else:
						matrix[x_pos][y_pos] = utils.EMPTY_CELL
			elif cur_point.y == next_point.y:
				y_pos = cur_point.y
				mi = min(cur_point.x, next_point.x)
				ma = max(cur_point.x, next_point.x)+1
				for x in range(mi, ma):
					x_pos = x
					if additive:
						matrix[x_pos][y_pos] += 1
					else:
						matrix[x_pos][y_pos] = utils.EMPTY_CELL
	return matrix

#
static func create_entrance_exit_matrix(map, matrix):
	matrix[map.entrance.x][map.entrance.y] = utils.START_CELL
	matrix[map.exit.x][map.exit.y] = utils.END_CELL
	return matrix
