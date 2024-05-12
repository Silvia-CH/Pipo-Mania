extends CanvasLayer
# Called when the node enters the scene tree for the first time.
@onready var salir = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer/Salir
@onready var login = $"ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Inicio de sesion/LoginUI"
@onready var visibilidad = false;
signal salir_menu_opciones

func _ready():
	set_process(false)

func _on_salir_pressed():
	salir_menu_opciones.emit()
	set_process(false)


func _on_ventanas_tab_clicked(tab):
	if(tab==1 && !visibilidad):
		login.visible=true
		visibilidad=true
	else: 
		login.visible=false
		visibilidad=false
