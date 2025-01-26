extends Area2D

## Estadisticas del pez
@export_category("🐟 Comportamiento")
## Mínimo de tiempo por el cuál abrira o cerrará la boca
@export var min_tiempo: float = 0.0
## Máximo de tiempo por el cuál abrira o cerrará la boca
@export var max_tiempo: float = 0.0
## Tipo de pez
@export var pez: String = ""
## Color del pez
@export var color_pez: Color
## Puntuación que otorga el pez
@export var puntos: int = 0

# Variable que ajusta sí el pez tiene la boca abierta o no
var abierta: bool = false


signal pescado(puntos_dados, pez, nodo)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$Sprite.self_modulate = color_pez
	rotate(randf_range(0.0, PI * 2))
	$Boca.start(randf_range(min_tiempo, max_tiempo))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match abierta:
		false: pass
		true: pass

func _on_boca_timeout() -> void:
	match abierta:
		false:
			randomize()
			$Sprite.play("Abrir")
			abierta = true
			$Boca.start(randf_range(min_tiempo, max_tiempo))
		true:
			randomize()
			$Sprite.play("Cerrar")
			abierta = false
			$Boca.start(randf_range(min_tiempo, max_tiempo))


func _on_body_entered(body: Node2D) -> void:
	if body is Anzuelo:
		match abierta:
			true:
				$Boca.paused = true
				$Sprite.play("Cerrar")
				body.hide()
				await get_tree().create_timer(0.5).timeout
				pescado.emit(puntos, pez, self)
				body.show()
				queue_free()
