extends CharacterBody2D

## Menú de Ajustes
@export_category("⚙ Ajustes")
## La velocidad a la que se mueve el personaje del jugador
@export var velocidad = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match Global.pausa:
		true:
			pass
		false:
			movimiento()
	
	move_and_slide()

func movimiento() -> void:
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad
