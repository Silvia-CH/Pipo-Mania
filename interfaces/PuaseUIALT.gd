extends CanvasLayer

signal pause
signal unpause
signal salir_menu_opciones
signal volver_menu_principal
var is_paused = false

## Vuelve al menu principal
func _on_salir_pressed():
	salir_menu_opciones.emit()
	set_process(false)
