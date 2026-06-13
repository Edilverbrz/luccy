package com.asistente.contable.features.transactions.domain.repository

import com.asistente.contable.features.transactions.domain.model.Money
import kotlinx.coroutines.flow.Flow

/**
 * Representa los datos de configuración financiera del usuario.
 * Es un modelo simple de dominio para este propósito.
 */
data class UserFinancialProfile(
    val monthlyIncome: Money,
    val fixedExpenses: Money
) {
    /**
     * Regla de negocio: Calcula el "Dinero Libre" o presupuesto disponible
     * para gastos variables antes de entrar en riesgo.
     */
    fun calculateDisposableIncome(): Money {
        return monthlyIncome - fixedExpenses
    }
}

/**
 * Interfaz para gestionar el perfil financiero que alimenta las alertas de Lucy.
 */
interface UserProfileRepository {
    
    /**
     * Guarda o actualiza los ingresos mensuales y gastos fijos del usuario.
     */
    suspend fun saveProfile(profile: UserFinancialProfile)
    
    /**
     * Obtiene el perfil financiero actual en tiempo real.
     */
    fun getProfile(): Flow<UserFinancialProfile?>
}