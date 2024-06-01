extends CanvasLayer
# Called when the node enters the scene tree for the first time.
@onready var salir = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer/Salir
@onready var login = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/LoginUI
@onready var register = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisterUI
@onready var registered = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisteredUI
@onready var emailLOG = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/LoginUI/VBoxContainer/HBoxContainer2/Email
@onready var passwdLOG = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/LoginUI/VBoxContainer/HBoxContainer2/Passwd
@onready var emailRES = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Email
@onready var passwdRES = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Passwd
@onready var passwdRESREP = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Passwd2
@onready var mensajeAVISO = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/Mensaje
@onready var mensajeALT = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/Alternador/Label
@onready var botonALT = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/Alternador/Rotar
@onready var alternador = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/Alternador
@onready var apodoCH = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisteredUI/VBoxContainer/VBoxContainer/Apodo
@onready var apodoPRD = $ContenedorPadre/MarginContainer/VBoxContainer/Ventanas/Cuenta/ContenedorUI/RegisteredUI/VBoxContainer/HBoxContainer/ApodoPRD
@onready var rotacion = false;
@onready var userdata: FirestoreCollection = Firebase.Firestore.collection("info")

signal salir_menu_opciones
signal block_login
signal unblock_login
signal load_data
signal update

func _ready():
	set_process(false)
	Firebase.Auth.login_succeeded.connect(on_login_succeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	if Firebase.Auth.check_auth_file():
		block_login.emit()

	
func _on_salir_pressed():
	salir_menu_opciones.emit()
	set_process(false)

func _on_inicio_sesion_pressed():
	var email = emailLOG.text
	var passwd = passwdLOG.text
	Firebase.Auth.login_with_email_and_password(emailLOG.text,passwdLOG.text)
	
func _on_registro_pressed():
	var email = emailRES.text
	var pass1 = passwdRES.text
	var pass2 = passwdRESREP.text
	if(pass1 == pass2):
		Firebase.Auth.signup_with_email_and_password(email,pass2)

func on_login_succeded(auth):
	Firebase.Auth.save_auth(auth)
	block_login.emit()
	
func on_signup_succeded(auth):
	mensajeAVISO.text = "Registro exitoso"
	
func on_login_failed(error_code,message):
	print(error_code)
	print(message)
	mensajeAVISO.text = "Error : "+ message
	
func on_signup_failed(error_code,message):
	print(error_code)
	print(message)
	mensajeAVISO.text = "Error : "+ message
	
func _on_rotar_pressed():
	if(rotacion):
		register.visible=false
		mensajeALT.text = "¿No tienes Cuenta?"
		botonALT.text = "Registrate"
		login.visible=true
		rotacion=false
	else:
		login.visible=false
		mensajeALT.text = "¿Ya tienes cuenta? "
		botonALT.text = "Inicia Sesion"
		register.visible=true
		rotacion=true


func _on_block_login():
	login.visible=false
	register.visible=false
	alternador.visible=false
	mensajeAVISO.visible=false
	mensajeALT.visible=false
	registered.visible=true
	load_data.emit()
	
func _on_unblock_login():
	registered.visible=false
	login.visible=true
	alternador.visible=true
	mensajeAVISO.text=""
	mensajeAVISO.visible=true
	mensajeALT.visible=true


func _on_logout_pressed():
	Firebase.Auth.logout()
	unblock_login.emit()

func _on_rename_pressed():
	load_data.emit()
	var apodo = apodoCH.text
	update.emit(apodo)
	apodoCH.text=""
	load_data.emit()

func _on_load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var tarea: FirestoreTask = userdata.get_doc(auth.localid)
		var tareaFIN: FirestoreTask = await tarea.task_finished
		var documento = tareaFIN.document
		if documento && documento.doc_fields:
			apodoPRD.text = documento.doc_fields.username
		else:
			var rng = RandomNumberGenerator.new()
			var usuario = "usuario" + str(rng.randi_range(0, 100))
			update.emit(usuario)
			apodoPRD.text = usuario
			


func _on_update(datos):
	var auth = Firebase.Auth.auth
	if auth.localid:
		var data: Dictionary = {
			"username": datos
		}
		var tarea: FirestoreTask = userdata.update(auth.localid,data)
