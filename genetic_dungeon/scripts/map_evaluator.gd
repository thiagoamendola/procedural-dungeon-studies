extends Node

# Fitness Parameters

var POINTS_PER_ROOM = 10
var POINTS_PER_CORRIDOR = 2
var ROOM_OVERLAP_PENALTY = -1
var CORRIDOR_OVERLAP_PENALTY = -1
var CORRIDOR_END_PENALTY = -20
var UNREACHABLE_CELL_PENALTY = -3
var DISTANCE_MULTIPLIER = 5
var UNREACHABLE_PATH_PENALTY = -500

# Imports
const utils = preload("utils.gd")
const map_spawner = preload("map_spawner.gd")

# Returns the fitness for a given map.
func get_fitness(map):
	var fitness = 0
	fitness += elements_sum(map)
	fitness += room_overlap(map)
	##fitness += adjacent_rooms(map)
	fitness += overlapping_corridors(map)
	fitness += corridor_endings(map)
	fitness += map_reachability(map)
	fitness += entrance_exit_distance(map)
	return fitness

# Evaluation steps.

# Sums points for each component
func elements_sum(map):
	# Calculate score of map elements.
	var sum = 0
	sum += len(map.room_list) * POINTS_PER_ROOM 
	sum += len(map.corridor_list) * POINTS_PER_CORRIDOR 
	#print("elements_sum: "+str(sum))
	return sum

func room_overlap(map):
	# Create int map.
	var matrix = map_spawner.create_empty_matrix(map.SIZE)
	# Add cell for each room ocurrence.
	matrix = map_spawner.create_rooms_matrix(map, matrix, true)
	# Remove none and single ocurrences.
	for x in range(map.SIZE.x):
		for y in range(map.SIZE.y):
			matrix[x][y] -= 1
			if matrix[x][y] < 0:
				matrix[x][y] = 0
	# Sum overlapping cells.
	var sum = 0
	for x in range(map.SIZE.x):
		for y in range(map.SIZE.y):
			sum += ROOM_OVERLAP_PENALTY * matrix[x][y]
	#print("room_overlap: "+str(sum))
	return sum

func adjacent_rooms(map):
	return 0

func overlapping_corridors(map):
	# Create int map.
	var matrix = map_spawner.create_empty_matrix(map.SIZE)
	# Add cell for each corridor ocurrence.
	matrix = map_spawner.create_corridors_matrix(map, matrix, true)
	# Remove none and single ocurrences.
	for x in range(map.SIZE.x):
		for y in range(map.SIZE.y):
			matrix[x][y] -= 1
			if matrix[x][y] < 0:
				matrix[x][y] = 0
	# Sum overlapping cells.
	var sum = 0
	for x in range(map.SIZE.x):
		for y in range(map.SIZE.y):
			sum += CORRIDOR_OVERLAP_PENALTY * matrix[x][y]
	#print("overlapping_corridors: "+str(sum))
	return sum

func corridor_endings(map):
	# Create int map.
	var matrix = map_spawner.create_empty_matrix(map.SIZE)
	# Create map of rooms.
	matrix = map_spawner.create_rooms_matrix(map, matrix, false)
	# foreach corridor, get both ends and check if it and its adjacencies are inside a room.
	var penalty = 0
	for corridor in map.corridor_list:
		penalty += check_corridor_end(matrix, map.SIZE, CORRIDOR_END_PENALTY, corridor.points[0])
		penalty += check_corridor_end(matrix, map.SIZE, CORRIDOR_END_PENALTY, corridor.points[len(corridor.points)-1])
	#print("corridor_endings: "+str(penalty))
	return penalty

func map_reachability(map):
	# Create int map.
	var matrix = map_spawner.create_empty_matrix(map.SIZE)
	# Create map of rooms and corridors.
	matrix = map_spawner.create_rooms_matrix(map, matrix, false)
	matrix = map_spawner.create_corridors_matrix(map, matrix, false)
	# Get number of spaces and detect first empty space and add to queue. 
	var num_spaces = 0
	var first_space = Vector2(-1,0)
	var queue = []
	for x in range(map.SIZE.x):
		for y in range(map.SIZE.y):
			if matrix[x][y] == 1:
				num_spaces += 1
				if first_space.x == -1:
					first_space.x = x
					first_space.y = y
					queue.push_back(first_space)
	# Pop cell from queue, add adjacencies to queue and paint it.
	var num_reachable = 0
	while queue.size() > 0:
		var cell = queue.pop_front()
		check_adj_reachable(matrix, map.SIZE, queue, Vector2(cell.x, cell.y-1))
		check_adj_reachable(matrix, map.SIZE, queue, Vector2(cell.x, cell.y+1))
		check_adj_reachable(matrix, map.SIZE, queue, Vector2(cell.x-1, cell.y))
		check_adj_reachable(matrix, map.SIZE, queue, Vector2(cell.x+1, cell.y))
		matrix[cell.x][cell.y] = 2
		num_reachable += 1
	# Compare the number of painted cells and spaces in the map.
	var penalty = 0
	if num_reachable < num_spaces:
		penalty = map.SIZE.x*map.SIZE.y*UNREACHABLE_CELL_PENALTY
	#print("map_reachability: "+str(penalty))
	return penalty

	
func entrance_exit_distance(map):

	# Create int map.
	var matrix = map_spawner.create_empty_matrix(map.SIZE)

	# Create map of rooms and corridors.
	matrix = map_spawner.create_rooms_matrix(map, matrix, false)
	matrix = map_spawner.create_corridors_matrix(map, matrix, false)
	matrix = map_spawner.create_entrance_exit_matrix(map, matrix)

	# Start recursion in start
	var current_level = []
	var next_level = []
	var level = 0
	var found = false
	
	current_level.append(map.entrance)

	while not current_level.empty():
		var cell = current_level.pop_front()
		
		if matrix[cell.x][cell.y] == utils.END_CELL:
			found = true
			break
		
		matrix[cell.x][cell.y] = utils.WALL_CELL
		
		if cell.x-1 >= 0 and matrix[cell.x-1][cell.y] >= utils.EMPTY_CELL:
			if matrix[cell.x-1][cell.y] == utils.EMPTY_CELL:
				matrix[cell.x-1][cell.y] = utils.WALL_CELL
			next_level.append(Vector2(cell.x-1,cell.y))
		if cell.x+1 < map.SIZE.x and matrix[cell.x+1][cell.y] >= utils.EMPTY_CELL:
			if matrix[cell.x+1][cell.y] == utils.EMPTY_CELL:
				matrix[cell.x+1][cell.y] = utils.WALL_CELL
			next_level.append(Vector2(cell.x+1,cell.y))
		if cell.y-1 >= 0 and matrix[cell.x][cell.y-1] >= utils.EMPTY_CELL:
			if matrix[cell.x][cell.y-1] == utils.EMPTY_CELL:
				matrix[cell.x][cell.y-1] = utils.WALL_CELL
			next_level.append(Vector2(cell.x, cell.y-1))
		if cell.y+1 < map.SIZE.y and matrix[cell.x][cell.y+1] >= utils.EMPTY_CELL:
			if matrix[cell.x][cell.y+1] == utils.EMPTY_CELL:
				matrix[cell.x][cell.y+1] = utils.WALL_CELL
			next_level.append(Vector2(cell.x, cell.y+1))
		
		if current_level.empty():
			current_level = next_level
			next_level = []
			level+=1
	
	if not found:
		return UNREACHABLE_PATH_PENALTY
	return level * DISTANCE_MULTIPLIER;

# Assisting methods

func check_adj_reachable(matrix, bounds, queue, cell):
	if utils.between(0, cell.x, bounds.x-1) and utils.between(0, cell.y, bounds.y-1) and matrix[cell.x][cell.y] == 1:
		queue.push_back(cell)
		matrix[cell.x][cell.y] = 2

func check_corridor_end(matrix, bounds, penalty, cell):
	var end_connected = false
	end_connected = end_connected || check_adj_corridor(matrix, bounds, Vector2(cell.x, cell.y))
	end_connected = end_connected || check_adj_corridor(matrix, bounds, Vector2(cell.x, cell.y-1))
	end_connected = end_connected || check_adj_corridor(matrix, bounds, Vector2(cell.x, cell.y+1))
	end_connected = end_connected || check_adj_corridor(matrix, bounds, Vector2(cell.x-1, cell.y))
	end_connected = end_connected || check_adj_corridor(matrix, bounds, Vector2(cell.x+1, cell.y))
	if not end_connected:
		return penalty
	return 0

func check_adj_corridor(matrix, bounds, cell):
	if utils.between(0, cell.x, bounds.x-1) && utils.between(0, cell.y, bounds.y-1) && matrix[cell.x][cell.y] == 1:
		return true
	return false

func print_map(matrix, size):
	for y in range(size.y):
		var text = ""
		for x in range(size.x):
			text += ", "+str(matrix[x][y])
		print(text)
