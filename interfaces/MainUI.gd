extends Control

@export var partida_precargada = preload("res://main.tscn")
@export var menu_Opciones_precargada = preload("res://interfaces/PuaseUI.tscn")
@export var menu_Cuenta_precargada = preload("res://interfaces/AccountUI.tscn")

func _on_empezar_button_down():
	get_tree().change_scene_to_packed(partida_precargada)

func _on_cuenta_button_down():
	$MarginContainer.visible=false
	$AccountUi.set_process(true)
	$AccountUi.visible=true
	
func _on_account_ui_salir_menu_cuenta():
	$MarginContainer.visible=true
	$AccountUi.visible=false

func _on_opciones_button_down():
	$MarginContainer.visible=false
	$PuaseUi.set_process(true)
	$PuaseUi.visible=true

func _on_puase_ui_salir_menu_opciones():
	$MarginContainer.visible=true
	$PuaseUi.visible=false

func _on_salir_button_down():
	get_tree().quit()


