extends Node2D

const MapData = preload("map_data.gd")
const MapSpawner = preload("map_spawner.gd")
const MapEvaluator = preload("map_evaluator.gd")

const TILE_SIZE = Vector2(64,64)
const MAP_OFFSET = 32

onready var tile_map = preload("res://tile_map.tscn")

var tile_map_list
var map_evaluator

func create_map_view(num_map):
    # Define maps size in tiles.
    var map_size = MapData.SIZE
    map_evaluator = MapEvaluator.new()
    # Define initial pos for map creation.
    var map_pos = Vector2(0,0)
    tile_map_list = []
    for i in range(num_map):
        # Create tile map.
        var map_view = tile_map.instance()
        map_view.position = map_pos
        add_child(map_view)
        tile_map_list.append(map_view)
        # Positionate Fitness display.
        var fitness_label = map_view.get_node("Fitness")
        fitness_label.rect_position.y = TILE_SIZE.y * (map_size.y+2)
        # Move initial pos by the offset.
        map_pos.x += (TILE_SIZE.x * (map_size.x+2)/2) + MAP_OFFSET

func build_map(map, view_index):
    # Get a matrix representation of the map (I think I already have one)
    var matrix = MapSpawner.get_map_matrix(map)
    # Assign matrix to map view
    for i in range(map.SIZE.x+2):
        for j in range(map.SIZE.y+2):
            tile_map_list[view_index].set_cellv(Vector2(i,j), 0)
    # Fill empty spaces
    for i in range(map.SIZE.x):
        for j in range(map.SIZE.y):
            tile_map_list[view_index].set_cellv(Vector2(i+1,j+1), matrix[i][j])
    # Show fitness
    var fitness_label = tile_map_list[view_index].get_node("Fitness")
    fitness_label.text = str(map_evaluator.get_fitness(map))
    pass
