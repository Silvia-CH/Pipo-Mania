extends Node

@export var siguiente = preload("res://levels/level3.tscn") 
var isPaused = false

func _on_visible_on_screen_notifier_2d_2_screen_exited():
	$DeathDialog.show()
	$Player.can_move = false
	$Commands.is_paused = true

func _on_confirmation_dialog_confirmed():
	$DeathDialog.hide()
	$Player.can_move = true
	$Player.set_position($StartPosition.position)
	$Commands.is_paused = false

func _on_confirmation_dialog_canceled():
	var config = ConfigFile.new()
	var data = config.load("res://config/timer.cfg")
	if data != OK:
		config.set_value("Timer", "timeFloat", 0.0)
		config.set_value("Timer", "time", "0.0")
		config.save("res://config/timer.cfg")
	get_tree().change_scene_to_file("res://interfaces/MainUI1.tscn")

func _on_canvas_layer_pause():
	if !isPaused:
		get_tree().paused = true
		$Player.can_move = false
		$PuaseUi.set_process_mode(PROCESS_MODE_DISABLED)
		$Plataforma/AnimationPlayer.pause()
	
func _on_canvas_layer_unpause():
	if !isPaused:
		get_tree().paused = false
		$Player.can_move = true
		$PuaseUi.set_process_mode(PROCESS_MODE_ALWAYS)
		$Plataforma/AnimationPlayer.play()

func _on_door_body_entered(_body):
	get_tree().change_scene_to_packed(siguiente)

func _on_puase_ui_volver_menu_principal():
	var config = ConfigFile.new()
	var data = config.load("res://config/timer.cfg")
	if data != OK:
		config.set_value("Timer", "timeFloat", 0.0)
		config.set_value("Timer", "time", "0.0")

		config.save("res://config/timer.cfg")
	get_tree().change_scene_to_file("res://interfaces/MainUI1.tscn")

func _on_puase_ui_pause():
		get_tree().paused = true
		$Commands.set_process_mode(PROCESS_MODE_DISABLED)
		$Plataforma/AnimationPlayer.pause()

func _on_puase_ui_unpause():
		get_tree().paused = false
		$Commands.set_process_mode(PROCESS_MODE_ALWAYS)
		$Plataforma/AnimationPlayer.play()
