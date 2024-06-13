extends Node

@export var btnGroup: ButtonGroup
@export var nivel = preload("res://levels/level1.tscn")
@export var menu = preload("res://interfaces/MainUI.tscn")
var skin: String

func _ready():
	for i in btnGroup.get_buttons():
		i.pressed.connect(_on_button_pressed.bind(i))


func _on_button_pressed(button):
	skin = button.name
	for sprite in get_tree().get_nodes_in_group("sprites"):
		sprite.animation = "idle"
		
	get_node("HBoxContainer/{color}/{str}Sprite".format({"color": skin, "str": skin})).animation = "jump"
	
func _on_confirmation_dialog_confirmed():
	var config = ConfigFile.new()

	config.set_value("Player", "player_skin", skin)

	config.save("res://config/player.cfg")
	get_tree().change_scene_to_packed(nivel)


func _on_guardar_pressed():
	if skin.is_empty():
		$WarningDialog.show()
	else:
		$SaveDialog.dialog_text = "Has elegido %s" % skin
		$SaveDialog.show()


func _on_salir_pressed():
	get_tree().change_scene_to_packed(menu)
