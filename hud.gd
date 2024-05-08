extends CanvasLayer
signal pause
signal unpause
signal commands_changed(text)

var is_paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E and is_paused:
			$TextEdit.hide()
			$ColorRect.hide()
			unpause.emit()
			is_paused = false
		elif event.keycode == KEY_E and not is_paused:
			$TextEdit.show()
			$ColorRect.show()
			pause.emit()
			is_paused = true
		elif event.keycode == KEY_ESCAPE and not is_paused:
			pause.emit()
			is_paused = true
			$"../PuaseUi".visible = true
		elif event.keycode == KEY_ESCAPE and is_paused:
			unpause.emit()
			is_paused = false
			$"../PuaseUi".visible = false
			
func _on_enter_pressed():
	$Show.text = $TextEdit.text
	commands_changed.emit($TextEdit.text)


func _on_clear_pressed():
	$Show.text = "" 
	$TextEdit.text = ""
	
