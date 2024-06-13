extends CanvasLayer
signal pause
signal unpause
signal commands_changed(text)

signal saveTimer

@onready var countdown := $Timer

var is_paused = false
var dash = "sadh"
var jump = "pujm"
var fast = "clove"

var timer = 0.0

var config = ConfigFile.new()
	
func _ready():
	var data = config.load("res://config/timer.cfg")

	if data != OK:
		config.set_value("Timer", "timeFloat", 0.0)
		config.set_value("Timer", "time", "0.0")

		config.save("res://config/timer.cfg")
	else:
		for time in config.get_sections():
			timer = config.get_value(time, "timeFloat")
			countdown.text = config.get_value(time, "time")


func _process(delta : float):
	if not is_paused:
		timer += delta
		countdown.text = _format_seconds(timer)
	
func _on_save_timer():
		config.set_value("Timer", "time", countdown.text)
		config.set_value("Timer", "timeFloat", timer)

		config.save("res://config/timer.cfg")

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
	_findPowers($TextEdit.text)
	$TextEdit.hide()
	$ColorRect.hide()
	unpause.emit()
	is_paused = false
	
func _findPowers(text):
	var powers = text.split(" ")
	for item in powers:
		match item.to_lower():
			dash:
				$ItemList.set_item_disabled(0, false)
				$Exists/AnimationPlayer.current_animation = "fade"
				$Exists/AnimationPlayer.play()
			jump:
				$ItemList.set_item_disabled(1, false)
				$Exists/AnimationPlayer.current_animation = "fade"
				$Exists/AnimationPlayer.play()
			fast:
				$ItemList.set_item_disabled(2, false)
				$Exists/AnimationPlayer.current_animation = "fade"
				$Exists/AnimationPlayer.play()
			_:
				$NonExistant/AnimationPlayer.current_animation = "fade"
				$NonExistant/AnimationPlayer.play()


func _on_item_list_item_selected(index):
	match index:
		0:
			commands_changed.emit(dash)
		1:
			commands_changed.emit(jump)
		2:
			commands_changed.emit(fast)

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
