extends Node2D

# Variable que chequea cuantos aros tenés embocados
var aros_embocados = 0

# Señal que verifica sí ganaste
signal ganaste

# Actualizar la cantidad de aros, añadiendo uno y chequeando sí ya embocaste todos
func sumar_aros() -> void:
	aros_embocados += 1
	
	# Sí son diez los aros embocados esperamos un poquito y le damos la victoria
	if aros_embocados == 10:
		await get_tree().create_timer(1).timeout
		var nodos_a_eliminar = get_tree().get_nodes_in_group("Waterhoops")
		
		# Eliminamos todos los nodos que ya no necesitamos
		for i in nodos_a_eliminar.size():
			nodos_a_eliminar[i].queue_free()
		
		ganaste.emit()
