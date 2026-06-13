package com.asistente.contable.features.transactions.domain.repository

import com.asistente.contable.features.transactions.domain.model.Transaction
import kotlinx.coroutines.flow.Flow

/**
 * Interfaz del Repositorio de Transacciones.
 * Dicta las operaciones que Lucy necesita realizar sobre los movimientos diarios.
 */
interface TransactionRepository {
    
    /**
     * Guarda un nuevo gasto o ingreso reportado por el usuario.
     */
    suspend fun saveTransaction(transaction: Transaction)
    
    /**
     * Elimina una transacción en caso de error en el registro.
     */
    suspend fun deleteTransaction(id: String)
    
    /**
     * Obtiene el flujo en tiempo real de todas las transacciones guardadas.
     */
    fun getAllTransactions(): Flow<List<Transaction>>
    
    /**
     * Obtiene las transacciones filtradas por un rango de tiempo (ej: el mes actual).
     * Crucial para que Lucy calcule los riesgos del periodo en curso.
     */
    fun getTransactionsByPeriod(startDate: Long, endDate: Long): Flow<List<Transaction>>
}