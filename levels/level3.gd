extends Node

func _on_visible_on_screen_notifier_2d_2_screen_exited():
	$DeathDialog.show()
	$Player.can_move = false


func _on_confirmation_dialog_confirmed():
	$DeathDialog.hide()
	$Player.can_move = true
	$Player.set_position($StartPosition.position)


func _on_confirmation_dialog_canceled():
	get_tree().quit()


func _on_canvas_layer_pause():
	
	$Player.can_move = false
	$Player/AnimatedSprite2D.stop()
	
func _on_canvas_layer_unpause():
	$Player.can_move = true
	$Player/AnimatedSprite2D.play()


func _on_door_body_entered(_body):
	get_tree().change_scene_to_file("res://levels/level3.tscn")
