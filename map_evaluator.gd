extends Node

# Imports
const utils = preload("utils.gd")

# Returns the fitness for a given map.
func get_fitness(map):
    var fitness = 0
    fitness += elements_sum(map)
    fitness += room_overlap(map)
    ##fitness += adjacent_rooms(map)
    fitness += overlapping_corridors(map)
    fitness += corridor_endings(map)
    fitness += map_reachability(map)
    return fitness

# Evaluation steps.

func elements_sum(map):
    # Parameters:
    var room_point = 10
    var corridor_point = 4
    # Calculate score of map elements.
    var sum = 0
    sum += len(map.room_list) * room_point 
    sum += len(map.corridor_list) * corridor_point 
    return sum

func room_overlap(map):
    # Parameters:
    var cell_overlap = -1
    # Create int map.
    var matrix=[]
    for x in range(map.SIZE.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(map.SIZE.y):
            matrix[x].append([])
            matrix[x][y]=0
    # Add cell for each room ocurrence.
    for room in map.room_list:
        var room_width = Vector2(room.init_pos.x, room.init_pos.x + room.size.x)
        var room_height = Vector2(room.init_pos.y, room.init_pos.y + room.size.y)
        for x in range(room_width.x, room_width.y):
            for y in range(room_height.x, room_height.y):
                matrix[y][x] += 1
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
            sum += cell_overlap * matrix[x][y]
    return sum

func adjacent_rooms(map):
    return 0

func overlapping_corridors(map):
    # Parameters:
    var cell_overlap = -1
    # Create int map.
    var matrix=[]
    for x in range(map.SIZE.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(map.SIZE.y):
            matrix[x].append([])
            matrix[x][y]=0
    # Add cell for each room ocurrence.
    var x
    var y
    var mi
    var ma
    for corridor in map.corridor_list:
        for k in range(corridor.points.size()-1):
            var cur_point = corridor.points[k]
            var next_point = corridor.points[k+1]
            if cur_point.x == next_point.x:
                x = cur_point.x
                mi = min(cur_point.y, next_point.y)
                ma = max(cur_point.y, next_point.y)+1
                for y in range(mi, ma):
                    matrix[y][x] += 1
            elif cur_point.y == next_point.y:
                y = cur_point.y
                mi = min(cur_point.x, next_point.x)
                ma = max(cur_point.x, next_point.x)+1
                for x in range(mi, ma):
                    matrix[y][x] += 1
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
            sum += cell_overlap * matrix[x][y]
    return sum

func corridor_endings(map):
    # Parameters
    var corridor_end_penalty = 5
    # Create int map.
    var matrix=[]
    for x in range(map.SIZE.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(map.SIZE.y):
            matrix[x].append([])
            matrix[x][y]=0
    # Create map of rooms and corridors.
    for room in map.room_list:
        var room_width = Vector2(room.init_pos.x, room.init_pos.x + room.size.x)
        var room_height = Vector2(room.init_pos.y, room.init_pos.y + room.size.y)
        for x in range(room_width.x, room_width.y):
            for y in range(room_height.x, room_height.y):
                matrix[y][x] = 1
    # foreach corridor, get both ends and check if it and its adjacencies are inside a room.
    var penalty = 0
    for corridor in map.corridor_list:
        penalty += check_corridor_end(matrix, corridor_end_penalty, corridor.points[0])
        penalty += check_corridor_end(matrix, corridor_end_penalty, corridor.points[len(corridor.points)-1])
    print(-penalty)
    return -penalty

func map_reachability(map):
    # Parameters:
    var penalty_per_cell = 1
    # Create int map.
    var matrix=[]
    for x in range(map.SIZE.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(map.SIZE.y):
            matrix[x].append([])
            matrix[x][y]=0
    # Create map of rooms and corridors.
    for room in map.room_list:
        var room_width = Vector2(room.init_pos.x, room.init_pos.x + room.size.x)
        var room_height = Vector2(room.init_pos.y, room.init_pos.y + room.size.y)
        for x in range(room_width.x, room_width.y):
            for y in range(room_height.x, room_height.y):
                matrix[y][x] = 1
                matrix[y][x] = 1
    for corridor in map.corridor_list:
        for k in range(corridor.points.size()-1):
            var cur_point = corridor.points[k]
            var next_point = corridor.points[k+1]
            if cur_point.x == next_point.x:
                var x = cur_point.x
                var mi = min(cur_point.y, next_point.y)
                var ma = max(cur_point.y, next_point.y)+1
                for y in range(mi, ma):
                    matrix[y][x] = 1
            elif cur_point.y == next_point.y:
                var y = cur_point.y
                var mi = min(cur_point.x, next_point.x)
                var ma = max(cur_point.x, next_point.x)+1
                for x in range(mi, ma):
                    matrix[y][x] = 1
            matrix[next_point.y][next_point.x] = 1
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
    if num_reachable < num_spaces:
        return -map.SIZE.x*map.SIZE.y*penalty_per_cell
    return 0
    
# Assisting methods

func check_adj_reachable(matrix, bounds, queue, cell):
    if utils.between(0, cell.x, bounds.x-1) and utils.between(0, cell.y, bounds.y-1) and matrix[cell.x][cell.y] == 1:
        queue.push_back(cell)
        matrix[cell.x][cell.y] = 2

func check_corridor_end(matrix, penalty, cell):
    var end_connected = false
    end_connected = end_connected || check_adj_corridor(matrix, Vector2(cell.x, cell.y))
    end_connected = end_connected || check_adj_corridor(matrix, Vector2(cell.x, cell.y-1))
    end_connected = end_connected || check_adj_corridor(matrix, Vector2(cell.x, cell.y+1))
    end_connected = end_connected || check_adj_corridor(matrix, Vector2(cell.x-1, cell.y))
    end_connected = end_connected || check_adj_corridor(matrix, Vector2(cell.x+1, cell.y))
    if not end_connected:
        return penalty
    return 0

func check_adj_corridor(matrix, cell):
    if matrix[cell.y][cell.x] == 1:
        return true
    return false

#    for x in range(map.SIZE.x):
#        var text = ""
#        for y in range(map.SIZE.y):
#            text += ", "+str(matrix[x][y])
#        print(text)