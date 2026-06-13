package com.asistente.contable.features.transactions.domain.model

/**
 * Value Object que clasifica los movimientos financieros.
 */
data class Category(
    val name: String,
    val icon: String // Guardaremos un identificador o un Emoji (ej: "🍔", "🚗")
) {
    init {
        // Regla de negocio: Una categoría no puede ser un texto vacío
        require(name.isNotBlank()) { "El nombre de la categoría no puede estar vacío." }
    }
}