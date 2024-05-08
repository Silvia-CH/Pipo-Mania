extends CanvasLayer
# Called when the node enters the scene tree for the first time.
@onready var salir = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer/Salir

signal salir_menu_opciones

func _ready():
	set_process(false)

func _on_salir_pressed():
	salir_menu_opciones.emit()
	set_process(false)
