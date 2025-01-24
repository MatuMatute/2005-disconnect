extends Node2D

@onready var area_despawn = $Base/Area_despawn
@onready var cooldown = $Aro_cooldown

# Consigue la escena del aro
var aro = ResourceLoader.load("res://Escenarios principales/Computadora/WH/Aro/aro.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_despawn_body_entered(body: Node2D) -> void:
	if body is Aro:
		await get_tree().create_timer(3).timeout
		body.queue_free()

func _on_aro_cooldown_timeout() -> void:
	var aro_actual = aro.instantiate()
	aro_actual.anillo = calculo_de_color()
	aro_actual.position = Vector2(505, 75)
	add_child(aro_actual)

func calculo_de_color():
	randomize()
	var color: String
	var probabilidad = randi_range(0, 100)
	
	if probabilidad >= 0 and probabilidad < 50:
		color = "Blanco"
	if probabilidad >= 50 and probabilidad < 80:
		color = "Azul"
	if probabilidad >= 80 and probabilidad < 95:
		color = "Verde"
	if probabilidad >= 95 and probabilidad <= 100:
		color = "Rojo"
	
	return color
