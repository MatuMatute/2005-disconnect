extends Node2D

# Declaro los nodos del lago
@onready var circulo_grande = $Sprite_circulogrande
@onready var circulo_chico = $Sprite_circulochico

# Variable importante: La velocidad de giro de cada rueda
var rueda_grande = 0.05
var rueda_chica = 0.1
# Carga de los peces del minijuego
var pez_azul = ResourceLoader.load("res://Assets/Pez_azul/pez_azul.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rodar()

func rodar() -> void:
	# Para girar se suman o restan los grados de rotación
	circulo_grande.rotation_degrees += rueda_grande
	circulo_chico.rotation_degrees -= rueda_chica
