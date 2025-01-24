extends Node2D

@onready var jugador_visible = $Jugador/Salida_transicion
@onready var camara = $Camara

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jugador_visible.screen_exited.connect(_jugador_fuera_pantalla)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _jugador_fuera_pantalla() -> void:
	if camara.position.x == 0:
		camara.position.x = 1920
	elif camara.position.x == 1920:
		camara.position.x = 0

func _on_area_pc_body_entered(body: Node2D) -> void:
	match Global.pausa:
		false:
			if body is Protagonista: 
				$Jugador/Mouse.show()
				if Input.is_action_pressed("ui_select"):
					$Animacion.play("zoom_camara")
					print("hola")

func _on_area_pc_body_exited(body: Node2D) -> void:
	match Global.pausa:
		false:
			if body is Protagonista: 
				$Jugador/Mouse.hide()
