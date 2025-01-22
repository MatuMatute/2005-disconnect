extends Control

#Declaro las variables de los nodos de la interfaz
@onready var animacion = $Animaciones
@onready var fade = $Fade
@onready var logo = $logo_container/oddgames
@onready var presenta = $logo_container/presenta
@onready var menu_container = $menu_container
@onready var opciones_container = $opciones_container
@onready var creditos_container = $creditos_container
@onready var aplicar = $opciones_container/volver_container/Aplicar
@onready var nos_vemos = $menu_container/Nos_vemos

# Asigno las resoluciones de pantalla posibles como valores en un array para simplificar el cambio de resolucion de pantalla
var resoluciones: Array = [
	Vector2i(640, 360), 
	Vector2i(854, 480), 
	Vector2i(1280, 720), 
	Vector2i(1366, 768), 
	Vector2i(1920, 1080), 
	Vector2i(2560, 1440)]

var modo_ventana: Array = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
]

var vsync: Array = [
	DisplayServer.VSYNC_ENABLED,
	DisplayServer.VSYNC_DISABLED
]

var valores_index = {
	"Resolución": 2,
	"Modo de ventana": 2,
	"Sincronización vertical": 0
}

# Esta función se llama la primera vez que se llama al nodo.
func _ready() -> void:
	animacion.play("odd-games")

# Esta funcion es llamada cada fotograma.
func _process(delta: float) -> void:
	pass

# Al presionar el botón "Jugar" esta función se activa
func _on_jugar_pressed() -> void:
	var nivel = ResourceLoader.load("res://Escenarios/letsgofishing.tscn")
	menu_container.hide()
	fade.hide()
	$"/root".add_child(nivel.instantiate())

func _on_opciones_pressed() -> void:
	menu_container.hide()
	opciones_container.show()

func _on_resolucion_item_selected(index: int) -> void:
	valores_index["Resolución"] = index
	match aplicar.visible:
		false: aplicar.show()
	#get_window().set_size(resoluciones[index])

# Al modificar el tipo de ventana se activa esta función
func _on_tipo_ventana_selected(index: int) -> void:
	valores_index["Modo de ventana"] = index
	match aplicar.visible:
		false: aplicar.show()
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

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


func _on_creditos_pressed() -> void:
	menu_container.hide()
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
	if opciones_container.visible:
		menu_container.show()
		opciones_container.hide()
	if creditos_container.visible:
		menu_container.show()
		creditos_container.hide()
