
# Normal distribution implementation through Box-Muller polar transform.
static func normal(mean, deviation):
    var x1 = null
    var x2 = null
    var w = null
    while true:
        x1 = rand_range(0, 2) - 1
        x2 = rand_range(0, 2) - 1
        w = x1*x1 + x2*x2
        if 0 < w && w < 1:
            break
    w = sqrt(-2 * log(w)/w)
    return floor(mean + deviation * x1 * w)

# Normal distribution with stablished limits.
static func normal_limits(mean, deviation, lower_bound, upper_bound):
    return min(upper_bound, max(lower_bound, normal(mean, deviation)))

# Check if value is between upper and lower bounds.
static func between(lower, value, upper):
    if value >= lower and value <= upper:
        return true
    return false

#
static func create_empty_matrix(map):
    # Create int map.
    var matrix=[]
    for x in range(map.SIZE.x):
        matrix.append([])
        matrix[x]=[]
        for y in range(map.SIZE.y):
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
#            matrix[next_point.y][next_point.x] = 1
    return matrix

    # for x in range(map.SIZE.x):
    #    var text = ""
    #    for y in range(map.SIZE.y):
    #        text += ", "+str(matrix[x][y])
    #    print(text)

