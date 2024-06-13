extends Node

var isPaused = false

func _on_visible_on_screen_notifier_2d_2_screen_exited():
	$AcceptDialog.show()
	$Player.can_move = false
	$Commands.is_paused = true

func _on_canvas_layer_pause():
	if !isPaused:
		get_tree().paused = true
		$Player.can_move = false
		$PuaseUi.set_process_mode(PROCESS_MODE_DISABLED)
	
func _on_canvas_layer_unpause():
	if !isPaused:
		get_tree().paused = false
		$Player.can_move = true
		$PuaseUi.set_process_mode(PROCESS_MODE_ALWAYS)

func _on_puase_ui_volver_menu_principal():
	get_tree().change_scene_to_file("res://interfaces/MainUI.tscn")

func _on_puase_ui_pause():
		get_tree().paused = true
		$Commands.set_process_mode(PROCESS_MODE_DISABLED)

func _on_puase_ui_unpause():
		get_tree().paused = false
		$Commands.set_process_mode(PROCESS_MODE_ALWAYS)


func _on_area_2d_body_entered(_body):
	$Commands.is_paused = true
	$Player.can_move = false
	$Player.cutscene = true
	$Player/Camera2D2.zoom = Vector2(0.9, 0.9)
	$Player/Camera2D2.offset = Vector2(0, -300)


func _on_accept_dialog_confirmed():
	get_tree().change_scene_to_file("res://interfaces/MainUI.tscn")
