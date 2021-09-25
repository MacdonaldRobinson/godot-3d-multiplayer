extends Node

class_name PeerData

var peer_name = "Name"
var energy:int = 100
var health:int = 100
var global_transform:Transform
var equip_holder_transform:Transform
var equip_holder_rotation:Vector3
var animations:Dictionary = {}
var camera_pivot_rotation:Vector3
var currently_equipped_item_tscn:String
var remote_method_call:String
var mesh_spray_global_transform:Transform
var world_state:Dictionary = {}
var messages:Array = []
