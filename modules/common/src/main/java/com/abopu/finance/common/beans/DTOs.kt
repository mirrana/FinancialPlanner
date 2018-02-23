package com.abopu.finance.common.beans

import java.io.Serializable
import java.util.*

data class User(
        val id: Long? = null,
        var username: String? = null,
        var hashedPassword: String? = null,
        var lastLogin: Date? = null
) : Serializable

data class Transaction(val id: Long? = null) : Serializable

