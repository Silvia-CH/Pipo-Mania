extends CanvasLayer

signal salir_menu_opciones

func _ready():
	pass

	
func _on_salir_pressed():
	salir_menu_opciones.emit()
	set_process(false)
