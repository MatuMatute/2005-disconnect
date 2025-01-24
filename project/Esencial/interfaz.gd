extends Control

#Declaro las variables de los nodos de la interfaz
@onready var animacion = $Principal/Animaciones
@onready var fade = $Principal/Fade
@onready var logo = $Principal/logo_container/oddgames
@onready var presenta = $Principal/logo_container/presenta
@onready var menu_container = $Principal/Menu
@onready var menu_botones = $Principal/Menu/menu_botones
@onready var opciones_container = $Principal/Menu/opciones_container
@onready var creditos_container = $Principal/Menu/creditos_container
@onready var pausa_container = $Principal/pausa_container
@onready var fishing_interface = $Principal/fishing_interface
#@onready var computadora = $Principal/Computadora
@onready var aplicar = $Principal/Menu/opciones_container/volver_container/Aplicar
@onready var nos_vemos = $Principal/Menu/menu_botones/Nos_vemos

# Asigno las resoluciones de pantalla posibles como valores en un array para simplificar el cambio de resolucion de pantalla
var resoluciones: Array = [
	Vector2i(640, 360), 
	Vector2i(854, 480), 
	Vector2i(1280, 720), 
	Vector2i(1366, 768), 
	Vector2i(1920, 1080), 
	Vector2i(2560, 1440)]

# Asigno los modos de ventana disponibles para el videojuego
var modo_ventana: Array = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
]

# Opciones de sincronización vertical
var vsync: Array = [
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
var habitacion: Resource
var camara: Resource

# Esta función se llama la primera vez que se llama al nodo.
func _ready() -> void:
	Global.pausa = true
	habitacion = ResourceLoader.load("res://Escenarios principales/Habitación/habitacion.tscn")
	$"/root".add_child.call_deferred(habitacion.instantiate())
	animacion.play("odd-games")

func _process(_delta: float) -> void:
	match Global.pausa:
		false:
			if Input.is_action_just_pressed("ui_cancel"):
				pausar()

# Al presionar el botón "Jugar" esta función se activa
func _on_jugar_pressed() -> void:
	menu_container.hide()
	fade.hide()
	Global.pausa = false
	$"/root/Habitacion/Animacion".animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	pass
	#computadora.show()

func _on_probar_computadora_pressed() -> void:
	menu_container.hide()
	fade.hide()
	Global.pausa = false
	cerrar_escenarios()
	$Principal/Computadora.show()

func _on_opciones_pressed() -> void:
	menu_botones.hide()
	opciones_container.show()

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
	match toggled_on:
		true: valores_index["Sincronización vertical"] = 0
		false: valores_index["Sincronización vertical"] = 1
	match aplicar.visible:
		false: aplicar.show()

func centrar_pantalla() -> void:
	var centro_pantalla = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var tamaño_ventana = get_window().get_size_with_decorations()
	get_window().set_position(centro_pantalla - tamaño_ventana / 2)

func _on_aplicar_configuracion_pressed() -> void:
	DisplayServer.window_set_mode(modo_ventana[valores_index["Modo de ventana"]])
	DisplayServer.window_set_vsync_mode(vsync[valores_index["Sincronización vertical"]])
	get_window().set_size(resoluciones[valores_index["Resolución"]])
	centrar_pantalla()
	aplicar.hide()

# Se activa al presionar el botón de "Créditos"
func _on_creditos_pressed() -> void:
	menu_botones.hide()
	creditos_container.show()

# El botón "Salir" hace que el juego se cierre.
func _on_salir_pressed() -> void:
	get_tree().quit()

# Pequeño mensaje aparece al colocar el mouse sobre el boton "Salir".
func _on_salir_mouse_entered() -> void:
	nos_vemos.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

# El mensaje desaparece
func _on_salir_mouse_exited() -> void:
	nos_vemos.self_modulate = Color(1.0, 1.0, 1.0, 0.0)

# Cuando se presiona el botón para volver al menú
func _on_volver_menu_pressed() -> void:
	match opciones_container.visible:
		true:
			menu_botones.show()
			opciones_container.hide()
	match creditos_container.visible:
		true:
			menu_botones.show()
			creditos_container.hide()

# Pausa el juego
func pausar() -> void:
	fade.show()
	pausa_container.show()
	Global.pausa = true
	Global.pausado.emit()

# Resume el juego, cerrando el menú de pausa
func resumir() -> void:
	pausa_container.hide()
	fade.hide()
	Global.pausa = false
	Global.resumido.emit()

# Este botón hace un soft-reboot del juego
func _on_regresar_menu_pressed() -> void:
	cerrar_escenarios()
	$"/root".add_child.call_deferred(habitacion.instantiate())
	pausa_container.hide()
	menu_container.show()

func cerrar_escenarios() -> void:
	var escenarios = get_tree().get_nodes_in_group("Escenarios")
	match escenarios.size():
		0: $"Principal/Computadora".queue_free()
	for i in escenarios.size():
		escenarios[i].queue_free()
