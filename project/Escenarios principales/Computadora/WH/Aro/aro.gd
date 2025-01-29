extends RigidBody2D
class_name Aro

var detenido: bool = false

var estadisticas: Dictionary = {
	"masa": 0.0,
	"velocidad" : 0,
	"color": Color(1.0, 1.0, 1.0, 1.0)
}

# Se llama a está función cuando aparece uno o varios aros
func _ready() -> void:
	# Crea una semilla aleatoria
	randomize()
	
	# Establece las características del aro, como su masa y velocidad
	estadisticas["masa"] = 0.04
	estadisticas["velocidad"] = 15
	
	# Calcula cual color queres que sea el aro
	var color = randi_range(0, 4) 
	match color:
		0: estadisticas["color"] = Color(1.0, 0.0, 0.0, 1.0)
		1: estadisticas["color"] = Color(0.0, 1.0, 0.0, 1.0)
		2: estadisticas["color"] = Color(0.0, 0.0, 1.0, 1.0)
		3: estadisticas["color"] = Color(0.0, 0.5, 0.5, 1.0)
		4: estadisticas["color"] = Color(0.5, 0.0, 0.5, 1.0)
	
	# Las características son aplicadas al aro
	mass = estadisticas["masa"]
	$Sprite.self_modulate = estadisticas["color"]

# Al presionar ciertos botones, el aro se mueve a cierta dirección
func _integrate_forces(state):
	if not detenido:
		# Izquierda
		if Input.is_action_pressed("ui_left"):
			state.apply_force(Vector2(-estadisticas["velocidad"], 0))
		
		# Derecha
		if Input.is_action_pressed("ui_right"):
			state.apply_force(Vector2(estadisticas["velocidad"], 0))
		
		# Arriba
		if Input.is_action_pressed("ui_up"):
			state.apply_force(Vector2(0, -estadisticas["velocidad"]))
		
		# Abajo
		if Input.is_action_pressed("ui_down"):
			state.apply_force(Vector2(0, estadisticas["velocidad"]))

# Sí logra embocarse en un cono, se activa lo que esta función especifica
func _on_emboco_area_entered(area: Area2D) -> void:
	if area is Cono:
		detenido = true
		mass = 0.5
		get_parent().sumar_aros()
		$Emboco.queue_free()
