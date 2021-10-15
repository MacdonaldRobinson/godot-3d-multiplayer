extends Resource
class_name ItemCollector
func get_class(): return "ItemCollector"

var item_name:String = "Ammo Name"
var item:Interactable
var item_icon_texture:Texture
var current_amount:int = -1
var max_capacity:int = -1
var call_back_method:FuncRef
var is_skill:bool = false
