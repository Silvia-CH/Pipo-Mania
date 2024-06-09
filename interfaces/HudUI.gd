extends CanvasLayer
signal pause
signal unpause
signal commands_changed(text)

var is_paused = false
var dash = "sadh"
var jump = "pujm"
var fast = "clove"

func _input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("enter") and is_paused:
			submitText()
		elif (Input.is_action_just_pressed("pause") and is_paused):
			$TextEdit.hide()
			$ColorRect.hide()
			unpause.emit()
			is_paused = false
		elif Input.is_action_just_pressed("pause") and not is_paused:
			$TextEdit.show()
			$ColorRect.show()
			$TextEdit.grab_focus()
			pause.emit()
			is_paused = true
			$TextEdit.text = ""

func _on_enter_pressed():
	submitText()

func submitText():
	findPowers($TextEdit.text)
	$TextEdit.hide()
	$ColorRect.hide()
	unpause.emit()
	is_paused = false
	
func findPowers(text):
	var powers = text.split(" ")
	for item in powers:
		match item.to_lower():
			dash:
				$ItemList.set_item_disabled(0, false)
			jump:
				$ItemList.set_item_disabled(1, false)
			fast:
				$ItemList.set_item_disabled(2, false)


func _on_item_list_item_selected(index):
	match index:
		0:
			commands_changed.emit(dash)
		1:
			commands_changed.emit(jump)
		2:
			commands_changed.emit(fast)
