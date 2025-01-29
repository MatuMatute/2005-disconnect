extends Node2D

@onready var animacion = $Animacion
@onready var jugador_visible = $Jugador/Salida_transicion
@onready var camara = $Camara
@onready var jugador = $Jugador
@onready var mouse = $Jugador/Mouse

# Detectar sí el/la jugador/a está fuera de la pantalla para cambiar la camara
func _jugador_fuera_pantalla() -> void:
	if camara.position.x == 0:
		camara.position.x = 1920
	elif camara.position.x == 1920:
		camara.position.x = 0

# Sí el/la jugador/a entra en area por el cual se puede interactuar con la PC
func _on_area_pc_body_entered(body: Node2D) -> void:
	if not Global.pausa and body is Protagonista:
		mouse.show()
		mouse.play("default")
		body.interaccion = "Computadora"

# Sí el/la jugador/a sale del area por el cual se puede interactuar con la PC
func _on_area_pc_body_exited(body: Node2D) -> void:
	if not Global.pausa and body is Protagonista: 
		mouse.hide()
		body.interaccion = ""

# Se activa al terminar la animación de zoom a la PC
func _on_animacion_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zoom_camara":
		animacion.play("RESET")
		await animacion.animation_finished
		camara.position.x = 0
		hide()
