extends Node2D

@onready var tiempo = $Tiempo
@onready var circulo_grande = $Circulo_lago/Sprite_circulogrande
@onready var circulo_chico = $Circulo_lago/Sprite_circulochico

# Declaro nodos importantes de la interfaz
signal cambiar_nivel
signal cambiar_puntuacion

# Variables que controlan el gameplay
var nivel = 0
var puntuacion = 0

# Variables reguladoras de la dificultad ()
var vel_rueda_grande = 0.04
var vel_rueda_chica = 0.08

# Carga de los peces del minijuego
var pez_azul = ResourceLoader.load("res://Assets/Pez_azul/pez_azul.tscn")

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	rodar()

func actualizar_puntuacion(cantidad: int) -> void:
	puntuacion += cantidad
	cambiar_puntuacion.emit(puntuacion)

func siguiente_nivel() -> void:
	nivel += 1
	vel_rueda_grande *= 1.25
	vel_rueda_chica *= 1.25
	cambiar_nivel.emit(nivel)

func _on_comenzar_nivel() -> void:
	actualizar_puntuacion(0)
	siguiente_nivel()
	tiempo.paused = false
	tiempo.start()

func rodar() -> void:
	# Para girar se suman o restan los grados de rotación
	circulo_grande.rotation_degrees += vel_rueda_grande
	circulo_chico.rotation_degrees -= vel_rueda_chica
