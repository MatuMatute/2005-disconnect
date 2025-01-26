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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Ya sé que esto se ve como un papelón, pero hay que pasar por varias cosas para activar esto.
func _input(event: InputEvent) -> void:
	match Global.pausa:
		false: 
			match ocupada:
				false:
					match interaccion: 
						"Computadora":
							if event.is_action_pressed("ui_select"): 
								ocupada = true
								get_parent().get_node("Animacion").play("zoom_camara")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match Global.pausa:
		true: velocity = Vector2(0, 0)
		false:
			match ocupada:
				false: movimiento()
				true: velocity = Vector2(0, 0)
	
	move_and_slide()

func movimiento() -> void:
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad
