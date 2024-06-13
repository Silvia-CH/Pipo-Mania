extends CanvasLayer

signal pause
signal unpause
signal salir_menu_opciones
signal volver_menu_principal
var is_paused = false

## Funcion a la espera de inputs
## Activa la vista de opciones al presionar ESC
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and not is_paused:
			pause.emit()
			is_paused = true
			$"../PuaseUi".visible = true
		elif event.keycode == KEY_ESCAPE and is_paused:
			unpause.emit()
			is_paused = false
			$"../PuaseUi".visible = false

## Vuelve al menu principal al presionar el boton
func _on_volver_al_menu_pressed():
	unpause.emit()
	volver_menu_principal.emit()
