extends Control

#Declaro las variables de los nodos de la interfaz
@onready var animacion = $Animaciones
@onready var fade = $Fade
@onready var logo = $logo_container/oddgames
@onready var presenta = $logo_container/presenta
@onready var nos_vemos = $menu_container/Nos_vemos

# Esta función se llama la primera vez que se llama al nodo.
func _ready() -> void:
	animacion.play("odd-games")
	#fade.self_modulate = Color(1.0, 1.0, 1.0, 0.7)

# Esta funcion es llamada cada fotograma.
func _process(delta: float) -> void:
	pass

# El botón "Salir" hace que el juego se cierre.
func _on_salir_pressed() -> void:
	get_tree().quit()

# Pequeño mensaje aparece al colocar el mouse sobre el boton "Salir".
func _on_salir_mouse_entered() -> void:
	nos_vemos.show()

# El mensaje desaparece
func _on_salir_mouse_exited() -> void:
	nos_vemos.hide()
