extends RigidBody2D
class_name Aro

#var anillo: String = "Blanco"  

var estadisticas: Dictionary = {
	"masa": 0.0,
	"velocidad" : 0,
	"color": Color(1.0, 1.0, 1.0, 1.0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	estadisticas["masa"] = 0.04
	estadisticas["velocidad"] = 15
	
	var color = randi_range(0, 3) 
	match color:
		0: estadisticas["color"] = Color(1.0, 1.0, 1.0, 1.0)
		1: estadisticas["color"] = Color(1.0, 0.0, 0.0, 1.0)
		2: estadisticas["color"] = Color(0.0, 1.0, 0.0, 1.0)
		3: estadisticas["color"] = Color(0.0, 0.0, 1.0, 1.0)
	
	mass = estadisticas["masa"]
	$Sprite.self_modulate = estadisticas["color"]

func _integrate_forces(state):
	if Input.is_action_pressed("ui_left"):
		state.apply_force(Vector2(-estadisticas["velocidad"], 0))
	if Input.is_action_pressed("ui_right"):
		state.apply_force(Vector2(estadisticas["velocidad"], 0))
	if Input.is_action_pressed("ui_up"):
		state.apply_force(Vector2(0, -estadisticas["velocidad"]))
	if Input.is_action_pressed("ui_down"):
		state.apply_force(Vector2(0, estadisticas["velocidad"]))
