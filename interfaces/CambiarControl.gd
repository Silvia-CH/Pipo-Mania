extends Control

@onready var texto = $HBoxContainer/Label
@onready var boton = $HBoxContainer/Button
@export var accion = ""


func _ready():
	set_process_unhandled_key_input(false)
	establecerTexto()
	cambiarTextoBoton()

func establecerTexto():
	match accion:
		"space":
			texto.text = "Saltar"
		"right":
			texto.text = "Derecha"
		"left":
			texto.text = "Izquierda"
		"dash":
			texto.text = "Aceleracion"

func cambiarTextoBoton():
	var todoEventos = InputMap.action_get_events(accion)
	var evento = todoEventos[0]
	var tecla = OS.get_keycode_string(evento.physical_keycode)
	boton.text = "%s" % tecla

## Funcion de cambio de tecla de accion
func _on_button_toggled(presionado):
	if presionado:
		boton.text = "Presione una tecla..."
		set_process_unhandled_key_input(presionado)
		for i in get_tree().get_nodes_in_group("cambioTeclaBotones"):
			if i.accion != self.accion:
				i.boton.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else: 
		for i in get_tree().get_nodes_in_group("cambioTeclaBotones"):
			if i.accion != self.accion:
				i.boton.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		cambiarTextoBoton()

## Esta funcion activa el boton despues de haber presionado una tecla
func _unhandled_key_input(event):
	cambioTecla(event)
	boton.button_pressed = false
	

## Comprueba que no haya una accion con esa tecla asignada y la cambia a la necesaria
func cambioTecla(evento):
	var duplicado=false
	var codigoAccion=OS.get_keycode_string(evento.physical_keycode)
	for i in get_tree().get_nodes_in_group("cambioTeclaBotones"):
			if i.accion!=self.accion:
				if i.boton.text=="%s" %codigoAccion:
					duplicado=true
					break
	if not duplicado:
		if "Tab" != codigoAccion and "Escape" != codigoAccion:
			InputMap.action_erase_events(accion)
			InputMap.action_add_event(accion,evento)
			set_process_unhandled_key_input(false)
			cambiarTextoBoton()
