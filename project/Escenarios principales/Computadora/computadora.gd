extends Control

# Conseguir los nodos que usaremos en este código
@onready var LGF = $Margen_pantalla/Orden_iconos/LGF
@onready var WRT = $Margen_pantalla/Orden_iconos/WRT
@onready var MSN = $Margen_pantalla/Orden_iconos/MSN
@onready var menu_inicio = $Inicio/Menu_inicio
@onready var apagar = $Inicio/Menu_inicio/Apagar
@onready var click = $Audio/Sonidos/Click

# Variable para saber si hay programa abierto
var programa_abierto: bool = false
var programa

signal apagada

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	click.play()
	programa = ResourceLoader.load("res://Escenarios principales/Computadora/Ventana/lgf_ventana.tscn")
	programa = programa.instantiate()
	$Margen_pantalla/Orden_iconos.add_sibling(programa)
	programa_abierto = true
	programa.cerrado.connect(programa_cerrado)

func _on_wrt_pressed() -> void:
	click.play()
	programa = ResourceLoader.load("res://Escenarios principales/Computadora/WH/wh_ventana.tscn")
	programa = programa.instantiate()
	$Margen_pantalla/Orden_iconos.add_sibling(programa)
	programa_abierto = true
	programa.cerrado.connect(programa_cerrado)

func _on_inicio_pressed() -> void:
	match menu_inicio.visible:
		true:
			click.play()
			menu_inicio.hide()
		false:
			click.play()
			menu_inicio.show()

func _on_apagar_pressed() -> void:
	match programa_abierto:
		false:
			menu_inicio.hide()
			hide()
			apagada.emit()

func programa_cerrado() -> void:
	click.play()
	programa_abierto = false
	programa.cerrado.disconnect(programa_cerrado)
