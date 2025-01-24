extends RigidBody2D
class_name Aro

var anillo: String

var estadisticas: Dictionary = {
	"masa": 0.0,
	"velocidad" : 0,
	"color": Color(1.0, 1.0, 1.0, 1.0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match anillo:
		"Blanco":
			estadisticas["masa"] = 0.04
			estadisticas["velocidad"] = 6
			estadisticas["color"] = Color(1.0, 1.0, 1.0, 1.0)
		"Azul":
			estadisticas["masa"] = 0.06
			estadisticas["velocidad"] = 7
			estadisticas["color"] = Color(0.0, 0.0, 1.0, 1.0)
		"Verde":
			estadisticas["masa"] = 0.08
			estadisticas["velocidad"] = 8
			estadisticas["color"] = Color(0.0, 1.0, 0.0, 1.0)
		"Rojo":
			estadisticas["masa"] = 0.1
			estadisticas["velocidad"] = 10
			estadisticas["color"] = Color(1.0, 0.0, 0.0, 1.0)
	
	mass = estadisticas["masa"]
	$Sprite.self_modulate = estadisticas["color"]

func _integrate_forces(state):
	if Input.is_action_pressed("ui_left"):
		state.apply_force(Vector2(-estadisticas["velocidad"], 0))
	if Input.is_action_pressed("ui_right"):
		state.apply_force(Vector2(estadisticas["velocidad"], 0))
