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
    pass

func partitionate_map(map, node):
    var cur_size = node.get_size()
    if cur_size.x < map.MIN_SIZE.x or cur_size.y < map.MIN_SIZE.y:
        #node.print()
        return
    # partitionate and recurse
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
        for i in range(room_pos.x,room_pos.x+room_size.x):
            for j in range(room_pos.y,room_pos.y+room_size.y):
                map.matrix[i][j]=1
        #node.print()
        #print("Room-> origin("+str(room_pos.x)+","+str(room_pos.y)+") ; size("+str(room_size.x)+","+str(room_size.y)+")")
        return
    create_rooms(map,node.childs[0])
    create_rooms(map,node.childs[1])