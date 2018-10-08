extends Node2D

# Imports
const utils = preload("utils.gd")

static func get_map_matrix(map):
    # Create empty map
    var matrix = utils.create_empty_matrix(map)
    # Create map of rooms and corridors.
    matrix = utils.create_rooms_matrix(map, matrix, false)
    matrix = utils.create_corridors_matrix(map, matrix, false)
    return matrix