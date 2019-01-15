extends Node

var player_platform = preload("platform/player.tscn")
var player_topdown = preload("topdown/player.tscn")

onready var tilemap = get_node("tilemap")
onready var gameplay_menu = get_node("gameplay_menu")

var map_matrix
var player

func _ready():
    gameplay_menu.popup_centered()
    pass

func initiate_map():
    gameplay_menu.hide()
    spawn_map()
    positionate_player()

func spawn_map():
    map_matrix = map_tester.map_to_test
    #map_matrix = [[0, 0, 0, 0, 0], [0, 2, 1, 1, 0], [0, 1, 1, 1, 0], [0, 1, 1, 1, 0], [0, 0, 0, 0, 0]]
    for i in range(len(map_matrix)):
        for j in range(len(map_matrix[i])):
            tilemap.set_cellv(Vector2(i,j), map_matrix[i][j])

func positionate_player():
    tilemap.get_parent().add_child(player)
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


# Button callbacks

func _on_platform_btn_pressed():
    player = player_platform.instance()
    initiate_map()

func _on_topdown_btn_pressed():
    player = player_topdown.instance()
    initiate_map()
