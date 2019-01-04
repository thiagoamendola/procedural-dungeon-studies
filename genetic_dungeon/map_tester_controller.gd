extends Node

onready var tilemap = get_node("tilemap")
onready var player = get_node("player")

var map_matrix

func _ready():
    spawn_map()
    positionate_player()
    pass

func spawn_map():
    map_matrix = map_tester.map_to_test
    #map_matrix = [[0, 0, 0, 0, 0], [0, 2, 1, 1, 0], [0, 1, 1, 1, 0], [0, 1, 1, 1, 0], [0, 0, 0, 0, 0]]
    print("pirulipu "+str(len(map_matrix))+" , "+str(len(map_matrix[0])))
    for i in range(len(map_matrix)):
        for j in range(len(map_matrix[i])):
            tilemap.set_cellv(Vector2(i,j), map_matrix[i][j])

func positionate_player():
    # Find spawn position in matrix
    var player_pos = null
    for i in range(len(map_matrix)):
        for j in range(len(map_matrix[i])):
            if(map_matrix[i][j] == 2):
                player_pos = Vector2(i, j)
    if player_pos == null:
        print("ERROR: No spawn point in map matrix.")
        return
    # Positionate player
    player.position = Vector2(32 + player_pos.x*64, 32 + player_pos.y*64)