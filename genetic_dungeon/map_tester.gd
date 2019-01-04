extends Node

var map_to_test

func test_map(map):
    map_to_test = map
    get_tree().change_scene("res://map_tester.tscn")