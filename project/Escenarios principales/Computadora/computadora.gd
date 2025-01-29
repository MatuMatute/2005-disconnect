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

# Señal que indica que la computadora se ha apagado
signal apagada

# Al presionar el icono de "Fish it!"
func _on_lgf_pressed() -> void:
	click.play()
	programa = ResourceLoader.load("res://Escenarios principales/Computadora/LGF/Ventana/lgf_ventana.tscn")
	programa = programa.instantiate()
	$Margen_pantalla/Orden_iconos.add_sibling(programa)
	programa_abierto = true
	deshabilitar_programas()
	programa.cerrado.connect(programa_cerrado)

# Al presionar el icono de "Water Hoops"
func _on_wrt_pressed() -> void:
	click.play()
	programa = ResourceLoader.load("res://Escenarios principales/Computadora/WH/Ventana/wh_ventana.tscn")
	programa = programa.instantiate()
	$Margen_pantalla/Orden_iconos.add_sibling(programa)
	programa_abierto = true
	deshabilitar_programas()
	programa.cerrado.connect(programa_cerrado)

# Funcióm para deshabilitar los iconos de los programas y así no se abren cuando no queremos que se abran
func deshabilitar_programas() -> void:
	LGF.disabled = true
	WRT.disabled = true
	MSN.disabled = true

# Habilito los programas para que puedas clickear en ellos
func habilitar_programas() -> void:
	LGF.disabled = false
	WRT.disabled = false
	MSN.disabled = false

# Al cerrarse un programa
func programa_cerrado() -> void:
	click.play()
	programa_abierto = false
	habilitar_programas()
	programa.cerrado.disconnect(programa_cerrado)

# Al presionar el menu inicio
func _on_inicio_pressed() -> void:
	match menu_inicio.visible:
		true:
			click.play()
			menu_inicio.hide()
		false:
			click.play()
			menu_inicio.show()

# Al presional el botón "Apagar"
func _on_apagar_pressed() -> void:
	match programa_abierto:
		false:
			menu_inicio.hide()
			hide()
			apagada.emit()
