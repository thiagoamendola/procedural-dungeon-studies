extends Node

# Imports

const utils = preload("utils.gd")

# Parameters

var map_data
var origin
var ending
var childs
var orientation

func init_root(map):
    map_data = map
    origin = Vector2(0,0)
    ending = Vector2(map.SIZE.x, map.SIZE.y)
    childs = []

func get_dim():
    return Vector2(ending.x-origin.x, ending.y-origin.y)