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


# Creates an empty matrix given its proportions.
static func create_empty_matrix(size):
    # Create int map.
    var matrix=[]
    for x in range(size.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(size.y):
            matrix[x].append([])
            matrix[x][y]=0
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
                    matrix[x][y] = 1
    return matrix

static func create_corridors_matrix(map, matrix, additive=false):
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
                    if additive:
                        matrix[x][y] += 1
                    else:
                        matrix[x][y] = 1
            elif cur_point.y == next_point.y:
                y = cur_point.y
                mi = min(cur_point.x, next_point.x)
                ma = max(cur_point.x, next_point.x)+1
                for x in range(mi, ma):
                    if additive:
                        matrix[x][y] += 1
                    else:
                        matrix[x][y] = 1
    return matrix

#
static func create_entrance_exit_matrix(map, matrix):
    matrix[map.entrance.x][map.entrance.y] = 2
    matrix[map.exit.x][map.exit.y] = 3
    return matrix