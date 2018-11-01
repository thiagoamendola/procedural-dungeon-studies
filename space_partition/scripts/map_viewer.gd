extends Node2D

const MapData = preload("map_data.gd")

const TILE_SIZE = Vector2(64,64)
const MAP_OFFSET = 32

onready var tile_map = preload("res://tile_map.tscn")

var map_view

func create_map_view():
    # Define maps size in tiles.
    var map_size = MapData.SIZE
    # Create tile map.
    map_view = tile_map.instance()
    map_view.position = Vector2(0,0)
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

