extends Control

@onready var button_1 = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
@onready var button_2 = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button2
@onready var button_3 = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button3
@export var partida_precargada = preload("res://main.tscn")
@export var menu_Opciones_precargada = preload("res://interfaces/PuaseUI.tscn")

func _on_button_button_down():
	get_tree().change_scene_to_packed(partida_precargada)

func _on_button_2_button_down():
	$MarginContainer.visible=false
	$PuaseUi.set_process(true)
	$PuaseUi.visible=true

func _on_button_3_button_down():
	get_tree().quit()

func _on_puase_ui_salir_menu_opciones():
	$MarginContainer.visible=true
	$PuaseUi.visible=false
