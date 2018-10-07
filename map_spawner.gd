extends Node2D

# Imports
const utils = preload("utils.gd")

onready var tilemap = get_node("TileMap")

func spawn_map(map):
    # Create empty map
    var matrix = utils.create_empty_matrix(map)
    # Create map of rooms and corridors.
    matrix = utils.create_rooms_matrix(map, matrix, false)
    matrix = utils.create_corridors_matrix(map, matrix, false)
    # Fill map with walls.
    for i in range(map.SIZE.x+2):
        for j in range(map.SIZE.y+2):
            tilemap.set_cellv(Vector2(i,j), 0)
    # Fill empty spaces
    for i in range(map.SIZE.x):
        for j in range(map.SIZE.y):
            tilemap.set_cellv(Vector2(i+1,j+1), matrix[i][j])