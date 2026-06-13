package com.asistente.contable.features.transactions.domain.model

/**
 * Entidad principal del dominio de finanzas.
 * Representa cualquier movimiento de dinero realizado por el usuario.
 */
data class Transaction(
    val id: String,          // Identificador único (UUID generado en el sistema)
    val title: String,       // Concepto (ej: "Compra de víveres")
    val money: Money,        // Objeto de valor Dinero
    val type: TransactionType,
    val date: Long,          // Timestamp de la operación
    val category: Category   // Objeto de valor Categoría
) {
    init {
        // Reglas de validación del Dominio
        require(title.isNotBlank()) { "El título de la transacción no puede estar vacío." }
        require(title.length <= 50) { "El título es demasiado largo (máximo 50 caracteres)." }
        require(money.amount > 0) { "El monto de la transacción debe ser mayor a cero." }
    }
    
    /**
     * Devuelve el monto formateado con un signo según su tipo.
     * Útil para la lógica de negocio de los balances.
     */
    fun getSignedAmount(): Double {
        return if (type == TransactionType.EXPENSE) -money.amount else money.amount
    }
}