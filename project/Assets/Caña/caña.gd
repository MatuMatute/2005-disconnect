extends CharacterBody2D

# Declaro los nodos de la caña
@onready var Cuerda = $Cuerda
@onready var Anzuelo = $Anzuelo
@onready var Sombra = $Sombra

# Declaro constantes y variables importantes
const velocidad = 200
var pescando: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Ajustar la posición del anzuelo al de la cuerda
	Anzuelo.position = Cuerda.get_point_position(0)
	# Función de movimiento
	match pescando:
		false: 
			movimiento()
			if Input.is_action_just_pressed("ui_select"): pescando = true
		true:
			velocity.x = 0 
			pescar()
	
	move_and_slide()

func movimiento() -> void:
	var direccion_entrada = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion_entrada * velocidad

func pescar() -> void:
	if Cuerda.get_point_position(0).y < 128:
		Cuerda.set_point_position(0, Vector2(Cuerda.get_point_position(0).x, Cuerda.get_point_position(0).y+2))
	elif Cuerda.get_point_position(0).y == 128:
		Sombra.hide()

func retroceder() -> void:
	Sombra.show()
	
