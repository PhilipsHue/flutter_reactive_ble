package com.signify.hue.flutterreactiveble.debugutils

fun ByteArray.toHexString() = joinToString("") { String.format("%02x", it) }
