extends Node

@export var siguiente = preload("res://levels/level2.tscn") 
@export var menu = preload("res://interfaces/MainUI.tscn") 
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
	get_tree().change_scene_to_packed(menu)

func _on_canvas_layer_pause():
	if !isPaused:
		get_tree().paused = true
		$Player.can_move = false
		$PuaseUi.set_process_mode(PROCESS_MODE_DISABLED)
		$Plataforma/AnimationPlayer.pause()
		$Plataforma2/AnimationPlayer.pause()
	
func _on_canvas_layer_unpause():
	if !isPaused:
		get_tree().paused = false
		$Player.can_move = true
		$PuaseUi.set_process_mode(PROCESS_MODE_ALWAYS)
		$Plataforma/AnimationPlayer.play()
		$Plataforma2/AnimationPlayer.play()

func _on_door_body_entered(_body):
	get_tree().change_scene_to_packed(siguiente)
	$Commands.saveTimer.emit()

func _on_puase_ui_volver_menu_principal():
	get_tree().change_scene_to_packed(menu)

func _on_puase_ui_pause():
		get_tree().paused = true
		$Commands.set_process_mode(PROCESS_MODE_DISABLED)
		$Plataforma/AnimationPlayer.pause()
		$Plataforma2/AnimationPlayer.pause()

func _on_puase_ui_unpause():
		get_tree().paused = false
		$Commands.set_process_mode(PROCESS_MODE_ALWAYS)
		$Plataforma/AnimationPlayer.play()
		$Plataforma2/AnimationPlayer.play()
