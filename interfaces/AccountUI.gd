extends Control

@onready var salir = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer/Salir
@onready var login = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/LoginUI
@onready var register = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisterUI
@onready var registered = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisteredUI
@onready var emailLOG = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/LoginUI/VBoxContainer/HBoxContainer2/Email
@onready var passwdLOG = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/LoginUI/VBoxContainer/HBoxContainer2/Passwd
@onready var emailRES = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Email
@onready var passwdRES = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Passwd
@onready var passwdRESREP = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisterUI/VBoxContainer/HBoxContainer2/Passwd2
@onready var mensajeAVISO = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/MensajeAviso
@onready var mensajeALT = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/Alternador/Label
@onready var botonALT = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/Alternador/Rotar
@onready var alternador = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/Alternador
@onready var apodoCH = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisteredUI/VBoxContainer/VBoxContainer/Apodo
@onready var apodoPRD = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/ContenedorUI/RegisteredUI/VBoxContainer/HBoxContainer/ApodoPRD
@onready var tiempoP1 = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/VBoxContainer/Clasificiacion/Personal/VBoxContainer/Label
@onready var refrescar = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/VBoxContainer/HBoxContainer/Refrescar
@onready var actualizar = $"ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/VBoxContainer/HBoxContainer/Actualizar Puntuacion"
@onready var clasi = $ContenedorPadre/MarginContainer/VBoxContainer/HBoxContainer2/Cuenta/HBoxContainer/VBoxContainer/Clasificiacion/Global/ItemList

@onready var rotacion = false;
@onready var userdata: FirestoreCollection = Firebase.Firestore.collection("info")

signal salir_menu_cuenta
signal block_login
signal unblock_login
signal load_data
signal update

## Esta funcion se ejecuta nada mas iniciar la escena
func _ready():
	set_process(false)
	Firebase.Auth.login_succeeded.connect(on_login_succeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	if Firebase.Auth.check_auth_file():
		block_login.emit()
	
## Funcion para volver al menú principal despues de presionar el botón
func _on_salir_pressed():
	salir_menu_cuenta.emit()
	set_process(false)
	
## Funcion de inicio de sesión
func _on_inicio_sesion_pressed():
	var email = emailLOG.text
	var passwd = passwdLOG.text
	if(es_email(email)):
		Firebase.Auth.login_with_email_and_password(emailLOG.text,passwdLOG.text)
	else:
		mensajeAVISO.text = "Error : Email Invalido"

	
## Funcion de registro
func _on_registro_pressed():
	var valnum = false
	var valchar = false
	var email = emailRES.text
	var pass1 = passwdRES.text
	var pass2 = passwdRESREP.text
	if(es_email(email)):
		if(pass1 == pass2):
			if(str(pass1).length() >9):
				valnum = tiene_numeros(pass1)
				if(valnum):
					valchar = tiene_letras(pass1)
					if(valchar):
						Firebase.Auth.signup_with_email_and_password(email,pass2)
					else:
						mensajeAVISO.text = "Error : Contraseña no tiene letras"
				else:
					mensajeAVISO.text = "Error : Contraseña no tiene números"
			else:
				mensajeAVISO.text = "Error : Contraseña inferior a 9 caracteres"
		else: 
			mensajeAVISO.text = "Error : Contraseñas no coinciden"
	else:
		mensajeAVISO.text = "Error : Email Invalido"

## Valida si la cadena proporcionada tiene al menos una letra
func tiene_letras(cadena) -> bool:
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(cadena)):
		return true
	else:
		return false

## Valida si la cadena proporcionada tiene al menos un numero
func tiene_numeros(cadena) -> bool:
	var regex = RegEx.new()
	regex.compile("\\d")
	if regex.search(str(cadena)):
		return true
	else:
		return false

## Valida si la cadena proporcionada es un email (texto@algo.almenos 2 caracteres)
func es_email(cadena) -> bool:
	var regex = RegEx.new()
	regex.compile("^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})$")
	if regex.search(str(cadena)):
		return true
	else:
		return false

## Funcion que guarda el token de sesion y cambia la ventana a la de usuario
func on_login_succeded(auth):
	Firebase.Auth.save_auth(auth)
	load_clasificar()
	refrescar.visible=true
	block_login.emit()

## Cambia el mensaje de aviso a uno personalizado
func on_signup_succeded(auth):
	mensajeAVISO.text = "Registro exitoso"
	stablish_datos(auth)

## Muestra un error en caso de fallo de inicio de sesion
func on_login_failed(error_code,message):
	print(error_code)
	print(message)
	mensajeAVISO.text = "Error : "+ message

## Muestra un error en caso de fallo de registro
func on_signup_failed(error_code,message):
	print(error_code)
	print(message)
	mensajeAVISO.text = "Error : "+ message

## Cambia entre vista de inicio de sesion y registro
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

## Bloquea todas las funciones de inicio de sesion y registro
## Esto se ejecuta al autenticarse el usuario
func _on_block_login():
	login.visible=false
	register.visible=false
	alternador.visible=false
	mensajeAVISO.visible=false
	mensajeALT.visible=false
	registered.visible=true
	load_data.emit()

## Desbloquea todas las funciones de inicio de sesion y registro
## Esto se ejecuta al cerrar sesion
func _on_unblock_login():
	registered.visible=false
	login.visible=true
	alternador.visible=true
	mensajeAVISO.text=""
	mensajeAVISO.visible=true
	mensajeALT.visible=true

## Cierra sesion y borra el token de sesion
func _on_logout_pressed():
	Firebase.Auth.logout()
	refrescar.visible=false
	unblock_login.emit()

## Llama a la funcion para subir el nuevo nombre a la base de datos
## Actualiza el nombre mostrado en la vista
func _on_rename_pressed():
	load_data.emit()
	var apodo = apodoCH.text
	update.emit(apodo)
	apodoCH.text=""
	load_data.emit()

## Agarra la informacion que coincida con el usuario autenticado de la base de datos
## Si es la primera vez que inicia sesion, se genera un nombre aleatorio
func _on_load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		## Utiliza la variable "userdata" que contiene la coleccion "info"
		## y el ID del auth para acceder a sus datos de usuario 
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

## Actualiza el nombre de usuario con los datos proporcionados
func _on_update(datos):
	var val = true
	var auth = Firebase.Auth.auth
	var documento = await get_clasificacion()
	var tarea: FirestoreTask = userdata.get_doc(auth.localid)
	var tareaFIN: FirestoreTask = await tarea.task_finished
	var documento2 = tareaFIN.document
	for i in documento.doc_fields.keys().size():
		if(documento.doc_fields.keys()[i] == datos):
			val = false
	if auth.localid && val:
		var data: Dictionary = {
			"username": datos
		}
		var tarea2: FirestoreTask = userdata.update(auth.localid,data)
		load_data.emit()

## Establece datos genericos para usuarios nuevos
func stablish_datos(auth):
	var tiempos = "00:00:00"
	var rng = RandomNumberGenerator.new()
	var usuario = "usuario" + str(rng.randi_range(0, 100))
	apodoPRD.text = usuario
	if auth.localid:
		var data: Dictionary = {
			"username": usuario,
			"tiempo1" : tiempos,
			"float1" : 9999,
		}
		var tarea: FirestoreTask = userdata.update(auth.localid,data)

## Carga las 2 tablas de clasificacion
func load_clasificar():
	var auth2 = Firebase.Auth.auth
	if auth2.localid:
		## Refresca la clasificacion del Usuario
		var tarea: FirestoreTask = userdata.get_doc(auth2.localid)
		var tareaFIN: FirestoreTask = await tarea.task_finished
		var documento = tareaFIN.document
		if documento && documento.doc_fields:
			tiempoP1.text = "%s" %documento.doc_fields.tiempo1
		## Refresca la clasificacion Global
		var documento2 = await get_clasificacion()
		var texto
		if(clasi.get_item_count()>0):
			clasi.clear()
		if documento2 && documento2.doc_fields:
			for i in documento2.doc_fields.keys().size():
				texto = str(documento2.doc_fields.keys()[i]) +" : "+ str(documento2.doc_fields.values()[i])
				clasi.add_item(texto,null,true)

## Llama al metodo de refrescar las tablas de clasificacion
func _on_refrescar_pressed():	
	load_clasificar()

func _on_actualizar_puntuacion_pressed():
	subir_tiempos()

func get_clasificacion() -> FirestoreDocument:
	var auth = Firebase.Auth.auth
	var tarea= userdata.get_doc("clasificacion")
	var tareaFIN= await tarea.task_finished
	var documento = tareaFIN.document
	return documento

func subir_tiempos():
	var config = ConfigFile.new()
	var data = config.load("res://config/timer.cfg")
	var float1 
	var tiempo1 
	if data == OK:
		for time in config.get_sections():
				float1 = config.get_value(time, "timeFloat")
				tiempo1 = config.get_value(time, "time")
	else:
		print("kakota")
	if(float1>0):
		var auth = Firebase.Auth.auth
		if auth.localid:
			var tarea: FirestoreTask = userdata.get_doc(auth.localid)
			var tareaFIN: FirestoreTask = await tarea.task_finished
			var documento = tareaFIN.document
			if(documento.doc_fields.float1 > float1):
				print("pipo")
				var datto: Dictionary = {
					"tiempo1" : tiempo1,
					"float1" : float1
				}
				var tarea2: FirestoreTask = userdata.update(auth.localid,datto)
				var documento2 = await get_clasificacion()
				var datto2: Dictionary = {
						 documento.doc_fields.username: tiempo1,
					}
				var tarea3= userdata.update("clasificacion",datto2)
	load_clasificar()


