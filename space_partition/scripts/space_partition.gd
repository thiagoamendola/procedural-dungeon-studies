extends Node

# Partition Parameters

const MIN_ROOM = Vector2(2,2)

# Classes

const utils = preload("utils.gd")
const MapData = preload("map_data.gd")
const TreeNode = preload("tree_node.gd")

# Variables

var tree_node

func generate_map(map):
    tree_node = TreeNode.new()
    tree_node.init_root(map)
    # Partitionate the area
    partitionate_map(map, tree_node)
    # Create rooms
    create_rooms(map,tree_node)
    # Connect rooms
    create_corridors(map,tree_node)
    pass

func partitionate_map(map, node):
    var cur_size = node.get_size()
    if cur_size.x < map.MIN_SIZE.x or cur_size.y < map.MIN_SIZE.y:
        return
    # Partitionate and recurse.
    if rand_range(0.0, 1.0) > 0.5:
        node.orientation = utils.Orientation.VERTICAL
        var partition_point = int(rand_range(node.origin.x+1, node.ending.x))
        var child0 = TreeNode.new()
        child0.map_data = map
        child0.origin = Vector2 (node.origin.x, node.origin.y)
        child0.ending = Vector2 (partition_point, node.ending.y)
        child0.childs = []
        node.childs.append(child0)
        var child1 = TreeNode.new()
        child1.map_data = map
        child1.origin = Vector2 (partition_point, node.origin.y)
        child1.ending = Vector2 (node.ending.x, node.ending.y)
        child1.childs = []
        node.childs.append(child1)
    else:
        node.orientation = utils.Orientation.HORIZONTAL
        var partition_point = int(rand_range(node.origin.y+1, node.ending.y))
        var child0 = TreeNode.new()
        child0.map_data = map
        child0.origin = Vector2 (node.origin.x, node.origin.y)
        child0.ending = Vector2 (node.ending.x, partition_point)
        child0.childs = []
        node.childs.append(child0)
        var child1 = TreeNode.new()
        child1.map_data = map
        child1.origin = Vector2 (node.origin.x, partition_point)
        child1.ending = Vector2 (node.ending.x, node.ending.y)
        child1.childs = []
        node.childs.append(child1)
    partitionate_map(map,node.childs[0])
    partitionate_map(map,node.childs[1])

func create_rooms(map,node):
    if node.childs == null or len(node.childs) < 2:
        var partition_size = node.get_size()
        var true_min_size = Vector2(min(MIN_ROOM.x,partition_size.x),min(MIN_ROOM.y,partition_size.y))
        var room_size = Vector2(int(rand_range(true_min_size.x,partition_size.x)),int(rand_range(true_min_size.y,partition_size.y)))
        var room_pos = Vector2(int(rand_range(node.origin.x,node.ending.x-room_size.x)),int(rand_range(node.origin.y,node.ending.y-room_size.y)))
        node.room_pos = room_pos
        node.room_size = room_size
        for i in range(room_pos.x,room_pos.x+room_size.x):
            for j in range(room_pos.y,room_pos.y+room_size.y):
                map.matrix[i][j]=1
        #node.print()
        #print("Room-> origin("+str(room_pos.x)+","+str(room_pos.y)+") ; size("+str(room_size.x)+","+str(room_size.y)+")")
        return
    create_rooms(map,node.childs[0])
    create_rooms(map,node.childs[1])

# Corridor connections.

func create_corridors(map, node):
    # Solve recursion and base case.
    if node.childs == null or len(node.childs) < 2:
        return
    create_corridors(map,node.childs[0])
    create_corridors(map,node.childs[1])
    # Let's see if parent node was partitionated horizontally or vertically.
    if node.orientation == utils.Orientation.HORIZONTAL:
        # Now find if they are already connected by searching in both sides of the partition line for adjacent floor cells
        # Firstly, find get a list for the upper half
        print(node.childs[0].origin)
        print(node.childs[0].ending)
        print(node.childs[1].origin)
        print(node.childs[1].ending)
        var y_partition = node.childs[0].ending.y
        for xval in range(node.childs[0].origin.x, node.childs[0].ending.x):
            if map.matrix[xval][y_partition-1] == 1 and map.matrix[xval][y_partition] == 1:
                # Rooms already connected. Exit.
                print("Already connected.")
                return
        var x_corridor = int(rand_range(node.childs[0].origin.x, node.childs[0].ending.x))
        print("x_corridor: "+str(x_corridor))
        # For the upper and lower partitions
        # Upper partition
        var connected = false
        for i in range(y_partition-1, node.childs[0].origin.y, sign(node.childs[0].origin.y-y_partition-1)):
            if map.matrix[x_corridor][i] > 0:
                i+=1
                while i <= y_partition-1:
                    map.matrix[x_corridor][i] = 1
                    i+=1
                connected = true
                break
        if not connected:
            create_side_corridor(map, utils.Orientation.HORIZONTAL, Vector2(x_corridor, y_partition-1), node.childs[0].origin.y-1, node.childs[0].origin.x-1, node.childs[0].ending.x)
        # Lower partition
        connected = false
        for i in range(y_partition, node.childs[1].ending.y, sign(node.childs[1].ending.y-y_partition)):
            if map.matrix[x_corridor][i] > 0:
                i-=1
                while i >= y_partition:
                    map.matrix[x_corridor][i] = 1
                    i-=1
                connected = true
                break
        if not connected:
            create_side_corridor(map, utils.Orientation.HORIZONTAL, Vector2(x_corridor, y_partition), node.childs[1].ending.y, node.childs[1].origin.x-1, node.childs[1].ending.x)
    else:
        var x_partition = node.childs[0].ending.x
        for yval in range(node.childs[0].origin.y, node.childs[0].ending.y):
            if map.matrix[x_partition-1][yval] == 1 and map.matrix[x_partition][yval] == 1:
                # Rooms already connected. Exit.
                print("Already connected.")
                return
        var y_corridor = int(rand_range(node.childs[0].origin.y, node.childs[0].ending.y))
        print("y_corridor: "+str(y_corridor))
        # Left partition
        var connected = false
        for i in range(x_partition-1, node.childs[0].origin.x, sign(node.childs[0].origin.x-x_partition-1)):
            if map.matrix[i][y_corridor] > 0:
                i+=1
                while i <= x_partition-1:
                    map.matrix[i][y_corridor] = 1
                    i+=1
                connected = true
                break
        if not connected:
            create_side_corridor(map, utils.Orientation.VERTICAL, Vector2(x_partition-1, y_corridor), node.childs[0].origin.x-1, node.childs[0].origin.y-1, node.childs[0].ending.y)
        # Right partition
        connected = false
        for i in range(x_partition, node.childs[1].ending.y, sign(node.childs[1].ending.y-x_partition)):
            if map.matrix[i][y_corridor] > 0:
                i-=1
                while i >= x_partition:
                    map.matrix[i][y_corridor] = 1
                    i-=1
                connected = true
                break
        if not connected:
            create_side_corridor(map, utils.Orientation.VERTICAL, Vector2(x_partition, y_corridor), node.childs[1].ending.x, node.childs[1].origin.y-1, node.childs[1].ending.y)

func create_side_corridor(map, orientation, corridor_start, partition_end, side_origin, side_ending):
    var possible_conn_points = []
    if orientation == utils.Orientation.HORIZONTAL:
        # Find connection points in both sides.
        for i in range(corridor_start.y, partition_end, sign(partition_end-corridor_start.y)):
            #print("Inner 1: "+str(corridor_start.x)+" and "+str(side_ending))
            for j in range(corridor_start.x, side_ending, sign(side_ending-corridor_start.x)):
                if map.matrix[j][i] > 0:
                    possible_conn_points.append(Vector2(j,i))
                    break
            #print("Inner 2: "+str(corridor_start.x)+" and "+str(side_origin))
            for j in range(corridor_start.x, side_origin, sign(side_origin-corridor_start.x)):
                if map.matrix[j][i] > 0:
                    possible_conn_points.append(Vector2(j,i))
                    break
        # Sort a connection point.
        var sorted_val = int(rand_range(0,possible_conn_points.size()))
        var conn_point = possible_conn_points[sorted_val]
        # Connect to sorted point
        for i in range(corridor_start.y, conn_point.y, sign(conn_point.y-corridor_start.y)):
            map.matrix[corridor_start.x][i] = 1
        for j in range(corridor_start.x, conn_point.x, sign(conn_point.x-corridor_start.x)):
            map.matrix[j][conn_point.y] = 1
    else:
        # Find connection points in both sides.
        for i in range(corridor_start.x, partition_end, sign(partition_end-corridor_start.x)):
            for j in range(corridor_start.y, side_ending, sign(side_ending-corridor_start.y)):
                if map.matrix[i][j] > 0:
                    possible_conn_points.append(Vector2(i,j))
                    break
            for j in range(corridor_start.y, side_origin, sign(side_origin-corridor_start.y)):
                if map.matrix[i][j] > 0:
                    possible_conn_points.append(Vector2(i,j))
                    break
        # Sort a connection point.
        var sorted_val = int(rand_range(0,possible_conn_points.size()))
        var conn_point = possible_conn_points[sorted_val]
        # Connect to sorted point
        for i in range(corridor_start.x, conn_point.x, sign(conn_point.x-corridor_start.x)):
            map.matrix[i][corridor_start.y] = 1
        for j in range(corridor_start.y, conn_point.y, sign(conn_point.y-corridor_start.y)):
            map.matrix[conn_point.x][j] = 1