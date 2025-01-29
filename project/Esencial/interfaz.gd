extends Control

#Declaro las variables de los nodos de la interfaz
@onready var musica_menu = $Audio/Musica/Main_menu
@onready var ambiente = $Audio/Musica/Ambiente
@onready var click = $Audio/Sonidos/Click
@onready var animacion = $Principal/Animaciones
@onready var fade = $Principal/Fade
@onready var logo = $Principal/logo_container/oddgames
@onready var presenta = $Principal/logo_container/presenta
@onready var menu_container = $Principal/Menu
@onready var logo_juego = $Principal/Menu/Logo
@onready var menu_botones = $Principal/Menu/menu_botones
@onready var opciones_container = $Principal/Menu/opciones_container
@onready var creditos_container = $Principal/Menu/creditos_container
@onready var pausa_container = $Principal/pausa_container
@onready var computadora = $Principal/Computadora
@onready var aplicar = $Principal/Menu/opciones_container/volver_container/Aplicar
@onready var nos_vemos = $Principal/Menu/menu_botones/Nos_vemos

# Asigno las resoluciones de pantalla posibles como valores en un array para simplificar el cambio de resolucion de pantalla
const resoluciones: Array = [
	Vector2i(640, 360), 
	Vector2i(854, 480), 
	Vector2i(1280, 720), 
	Vector2i(1366, 768), 
	Vector2i(1920, 1080), 
	Vector2i(2560, 1440)]

# Asigno los modos de ventana disponibles para el videojuego
const modo_ventana: Array = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
]

# Opciones de sincronización vertical
const vsync: Array = [
	DisplayServer.VSYNC_ENABLED,
	DisplayServer.VSYNC_DISABLED
]

# Administrador de los valores cambiados en el menú de opciones
var valores_index = {
	"Resolución": 4,
	"Modo de ventana": 2,
	"Sincronización vertical": 0
}

# Variables adicionales importantes más adelante
var habitacion = ResourceLoader.load("res://Escenarios principales/Habitación/habitacion.tscn")

# Esta función se llama la primera vez que se llama al nodo.
func _ready() -> void:
	musica_menu.play()
	Global.pausa = true
	#$"/root".add_child.call_deferred(habitacion.instantiate())
	animacion.play("odd-games")

# Esta funcion se llama cada frame que pasa en el juego
func _process(_delta: float) -> void:
	if not Global.pausa:
		if Input.is_action_just_pressed("ui_cancel"):
			pausar()

# Al presionar el botón "Jugar" esta función se activa
func _on_jugar_pressed() -> void:
	habitacion = habitacion.instantiate()
	click.play()
	musica_menu.stop()
	menu_container.hide()
	fade.hide()
	Global.pausa = false
	ambiente.play()
	$"/root".add_child(habitacion)
	$"/root/Habitacion/Animacion".animation_finished.connect(_on_animation_finished)

# Cuando termina la animación de acercamiento a la PC se muestra el escritorio de la PC
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zoom_camara":
		ambiente.stream_paused = true
		computadora.show()

# Cuando se apaga la computadora se muestra la habitación de vuelta
func _on_computadora_apagada() -> void:
	ambiente.stream_paused = false
	$"/root/Habitacion".show()
	$"/root/Habitacion/Jugador".ocupada = false

# Mostrar el menú de opciones
func _on_opciones_pressed() -> void:
	click.play()
	menu_botones.hide()
	opciones_container.show()

# Modificar resolución
func _on_resolucion_item_selected(index: int) -> void:
	valores_index["Resolución"] = index
	match aplicar.visible:
		false: aplicar.show()

# Al modificar el tipo de ventana se activa esta función
func _on_tipo_ventana_selected(index: int) -> void:
	valores_index["Modo de ventana"] = index
	match aplicar.visible:
		false: aplicar.show()

# Al cambiar el modo de sincronizado vertical se activa esta función
func _on_vsync_toggled(toggled_on: bool) -> void:
	click.play()
	match toggled_on:
		true: valores_index["Sincronización vertical"] = 0
		false: valores_index["Sincronización vertical"] = 1
	match aplicar.visible:
		false: aplicar.show()

# Función para centrar pantalla sí cambias a modo ventana
func centrar_pantalla() -> void:
	var centro_pantalla = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var tamaño_ventana = get_window().get_size_with_decorations()
	get_window().set_position(centro_pantalla - tamaño_ventana / 2)

# Se aplica la configuración
func _on_aplicar_configuracion_pressed() -> void:
	DisplayServer.window_set_mode(modo_ventana[valores_index["Modo de ventana"]])
	DisplayServer.window_set_vsync_mode(vsync[valores_index["Sincronización vertical"]])
	get_window().set_size(resoluciones[valores_index["Resolución"]])
	centrar_pantalla()
	aplicar.hide()

# Se activa al presionar el botón de "Créditos"
func _on_creditos_pressed() -> void:
	click.play()
	menu_botones.hide()
	logo_juego.hide()
	creditos_container.show()

# El botón "Salir" hace que el juego se cierre.
func _on_salir_pressed() -> void:
	click.play()
	get_tree().quit()

# Pequeño mensaje aparece al colocar el mouse sobre el boton "Salir".
func _on_salir_mouse_entered() -> void:
	nos_vemos.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

# El mensaje desaparece
func _on_salir_mouse_exited() -> void:
	nos_vemos.self_modulate = Color(1.0, 1.0, 1.0, 0.0)

# Cuando se presiona el botón para volver al menú
func _on_volver_menu_pressed() -> void:
	if opciones_container.visible:
		menu_botones.show()
		opciones_container.hide()
	if creditos_container.visible:
		menu_botones.show()
		logo_juego.show()
		creditos_container.hide()

# Pausa el juego
func pausar() -> void:
	fade.self_modulate = Color(0.0, 0.0, 0.0, 0.5)
	fade.show()
	pausa_container.show()
	Global.pausa = true
	Global.pausado.emit()

# Resume el juego, cerrando el menú de pausa
func resumir() -> void:
	pausa_container.hide()
	fade.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
	fade.hide()
	Global.pausa = false
	Global.resumido.emit()

# Este botón hace un soft-reboot del juego
func _on_regresar_menu_pressed() -> void:
	ambiente.stop()
	musica_menu.play()
	cerrar_escenarios()
	$"/root".add_child(habitacion, true)
	fade.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
	fade.hide()
	pausa_container.hide()
	menu_container.show()

# Esta función cierra los escenarios, está algo viejo y tengo que renovarlo
func cerrar_escenarios() -> void:
	var escenarios = get_tree().get_nodes_in_group("Escenarios")
	computadora.hide()
	for i in escenarios.size():
		escenarios[i].queue_free()
