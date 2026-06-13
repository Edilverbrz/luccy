package com.asistente.contable.features.transactions.domain.model

/**
 * Value Object que representa el dinero.
 * En DDD, los Value Objects son inmutables y no tienen ID; se definen por sus atributos.
 */
data class Money(
    val amount: Double,
    val currency: String = "USD"
) {
    // Regla de negocio: No puedes sumar peras con manzanas (o USD con EUR) sin convertir
    operator fun plus(other: Money): Money {
        require(currency == other.currency) { 
            "Operación inválida: No se pueden sumar diferentes divisas ($currency y ${other.currency}) sin una tasa de conversión." 
        }
        return Money(this.amount + other.amount, this.currency)
    }

    operator fun minus(other: Money): Money {
        require(currency == other.currency) { 
            "Operación inválida: No se pueden restar diferentes divisas." 
        }
        return Money(this.amount - other.amount, this.currency)
    }
}