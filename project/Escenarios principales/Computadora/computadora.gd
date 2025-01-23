extends Control

# Conseguir los nodos que usaremos en este código
@onready var LGF = $Margen_pantalla/Orden_iconos/LGF
@onready var WRT = $Margen_pantalla/Orden_iconos/WRT
@onready var MSN = $Margen_pantalla/Orden_iconos/MSN

# Variable para saber si hay programa abierto
var programa_abierto: bool = false
var programa

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match programa_abierto:
		false:
			LGF.disabled = false
			WRT.disabled = false
			MSN.disabled = false
		true:
			LGF.disabled = true
			WRT.disabled = true
			MSN.disabled = true

# Al presionar el icono de "Let's go fishing"
func _on_lgf_pressed() -> void:
	programa = ResourceLoader.load("res://Escenarios principales/Computadora/Ventana/lgf_ventana.tscn")
	programa = programa.instantiate()
	$Margen_pantalla/Orden_iconos.add_sibling(programa)
	programa_abierto = true
	programa.cerrado.connect(programa_cerrado)

func programa_cerrado() -> void:
	programa_abierto = false
