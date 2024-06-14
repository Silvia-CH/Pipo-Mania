extends Control

@export var partida_precargada = preload("res://interfaces/SkinPickerUI.tscn")
@export var menu_Opciones_precargada = preload("res://interfaces/PuaseUI.tscn")
@export var menu_Cuenta_precargada = preload("res://interfaces/AccountUI.tscn")

func _on_empezar_button_down():
	var config = ConfigFile.new()
	var data = config.load("res://config/timer.cfg")
	if data != OK:
		config.set_value("Timer", "timeFloat", 0.0)
		config.set_value("Timer", "time", "0.0")

		config.save("res://config/timer.cfg")
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
	$PuaseUiALT.set_process(true)
	$PuaseUiALT.visible=true

func _on_puase_ui_alt_salir_menu_opciones():
	$MarginContainer.visible=true
	$PuaseUiALT.visible=false

func _on_salir_button_down():
	get_tree().quit()


