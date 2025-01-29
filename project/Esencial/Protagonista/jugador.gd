extends CharacterBody2D
class_name Protagonista

## Menú de Ajustes
@export_category("⚙ Ajustes")
## La velocidad a la que se mueve el personaje del jugador
@export var velocidad = 200

# Variable que determina si la protagonista está ocupada y no puede moverse ni interactuar
var ocupada = false
# ¿Con qué cosa está interactuando nuestra protagonista?
var interaccion = ""

# Chequear sí el juego no está pausado y la protagonista no está ocupada
func _process(_delta: float) -> void:
	if not Global.pausa and not ocupada:
		movimiento()
		
		# Sí interactuamos con algo, pasa algo
		if Input.is_action_pressed("ui_select"):
			match interaccion: 
				"Computadora":
					ocupada = true
					get_parent().get_node("Animacion").play("zoom_camara")
				"MP3":
					print("Pronto")
		
		move_and_slide()

# Función para movimiento
func movimiento() -> void:
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad
