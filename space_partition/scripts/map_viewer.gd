extends Node2D

const MapData = preload("map_data.gd")

const TILE_SIZE = Vector2(64,64)
const MAP_OFFSET = 32

onready var tile_map = preload("res://tile_map.tscn")

onready var partitions_visible = false
var map_view

func create_map_view():
    # Define maps size in tiles.
    var map_size = MapData.SIZE
    # Create tile map.
    map_view = tile_map.instance()
    map_view.position = Vector2(0,0)
    map_view.z_index = -1
    add_child(map_view)

func render_map(map):
    # Get a matrix representation of the map (I think I already have one)
    var matrix = map.matrix
    # Assign matrix to map view
    for i in range(map.SIZE.x+2):
        for j in range(map.SIZE.y+2):
            map_view.set_cellv(Vector2(i,j), 0)
    # Fill empty spaces
    for i in range(map.SIZE.x):
        for j in range(map.SIZE.y):
            map_view.set_cellv(Vector2(i+1,j+1), matrix[i][j])
    pass

var tree_node

func render_partition_limits(node):
    tree_node = node
    self.update()

func _draw():
    if partitions_visible:
        var curnode
        var cell_unit = Vector2(TILE_SIZE.x*global_scale.x,TILE_SIZE.y*global_scale.y)*0.835
        var nodeset=[]
        nodeset.append(tree_node)
        while(len(nodeset)>0):
            curnode = nodeset.pop_back()
            if curnode.childs != null and len(curnode.childs) == 2:
                nodeset.append(curnode.childs[0])
                nodeset.append(curnode.childs[1])
            draw_rect(Rect2(cell_unit+Vector2(curnode.origin.x*cell_unit.x,curnode.origin.y*cell_unit.y),Vector2((curnode.ending.x-curnode.origin.x)*cell_unit.x,(curnode.ending.y-curnode.origin.y)*cell_unit.y)),Color(0,0,255), false)

