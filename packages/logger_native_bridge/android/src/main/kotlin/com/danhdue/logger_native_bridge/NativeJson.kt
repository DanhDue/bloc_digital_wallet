// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

/**
 * A minimal, dependency-free JSON encoder/decoder used by [NativeLogQueue]
 * and [NativeAppenderToggleStore].
 *
 * Deliberately hand-rolled instead of depending on `org.json` or
 * `kotlinx.serialization`: `android.jar`'s `org.json.*` classes are
 * compile-only stubs (every method throws `RuntimeException("Stub!")` at
 * runtime outside an actual Android device/emulator/Robolectric), which
 * would make this native core untestable in a plain JVM unit test — the
 * exact environment this package's core is required to be testable in.
 * `kotlinx.serialization` would add a new pub-equivalent dependency for a
 * handful of flat, simple shapes (`Map<String, Boolean>` and a list of
 * flat log-entry records). A small hand-rolled codec avoids both problems
 * and is easy to keep correct for the restricted shapes this file actually
 * needs to represent.
 *
 * Supports the full JSON value grammar (objects, arrays, strings, numbers,
 * booleans, null) so callers can decode/encode nested `Map`/`List`
 * structures generically, with proper string escaping (quote, backslash,
 * and control characters).
 */
internal object NativeJson {
    /** Encodes [value] (nested `Map`/`List`/`String`/`Number`/`Boolean`/`null`) to JSON. */
    fun encode(value: Any?): String {
        val sb = StringBuilder()
        writeValue(sb, value)
        return sb.toString()
    }

    /** Decodes a JSON document. Throws [NativeJsonException] on malformed input. */
    fun decode(json: String): Any? {
        val parser = Parser(json)
        val value = parser.parseValue()
        parser.skipWhitespace()
        if (!parser.isAtEnd()) {
            throw NativeJsonException("Unexpected trailing content at index ${parser.pos}")
        }
        return value
    }

    private fun writeValue(sb: StringBuilder, value: Any?) {
        when (value) {
            null -> sb.append("null")
            is Boolean -> sb.append(if (value) "true" else "false")
            is Int -> sb.append(value)
            is Long -> sb.append(value)
            is Double -> sb.append(value)
            is String -> writeString(sb, value)
            is Map<*, *> -> {
                sb.append('{')
                var first = true
                for ((k, v) in value) {
                    if (!first) sb.append(',')
                    first = false
                    writeString(sb, k.toString())
                    sb.append(':')
                    writeValue(sb, v)
                }
                sb.append('}')
            }
            is List<*> -> {
                sb.append('[')
                var first = true
                for (item in value) {
                    if (!first) sb.append(',')
                    first = false
                    writeValue(sb, item)
                }
                sb.append(']')
            }
            else -> throw NativeJsonException("Unsupported JSON value type: ${value::class}")
        }
    }

    private fun writeString(sb: StringBuilder, s: String) {
        sb.append('"')
        for (c in s) {
            when (c) {
                '"' -> sb.append("\\\"")
                '\\' -> sb.append("\\\\")
                '\n' -> sb.append("\\n")
                '\r' -> sb.append("\\r")
                '\t' -> sb.append("\\t")
                else -> {
                    if (c.code < 0x20) {
                        sb.append("\\u")
                        sb.append(c.code.toString(16).padStart(4, '0'))
                    } else {
                        sb.append(c)
                    }
                }
            }
        }
        sb.append('"')
    }

    private class Parser(private val src: String) {
        var pos: Int = 0

        fun isAtEnd(): Boolean = pos >= src.length

        fun skipWhitespace() {
            while (pos < src.length && src[pos].isWhitespace()) pos++
        }

        fun parseValue(): Any? {
            skipWhitespace()
            if (isAtEnd()) throw NativeJsonException("Unexpected end of input at index $pos")
            return when (src[pos]) {
                '{' -> parseObject()
                '[' -> parseArray()
                '"' -> parseString()
                't', 'f' -> parseBoolean()
                'n' -> parseNull()
                else -> parseNumber()
            }
        }

        private fun parseObject(): Map<String, Any?> {
            expect('{')
            val result = LinkedHashMap<String, Any?>()
            skipWhitespace()
            if (peek() == '}') {
                pos++
                return result
            }
            while (true) {
                skipWhitespace()
                val key = parseString()
                skipWhitespace()
                expect(':')
                val value = parseValue()
                result[key] = value
                skipWhitespace()
                when (peek()) {
                    ',' -> {
                        pos++
                        continue
                    }
                    '}' -> {
                        pos++
                        break
                    }
                    else -> throw NativeJsonException("Expected ',' or '}' at index $pos")
                }
            }
            return result
        }

        private fun parseArray(): List<Any?> {
            expect('[')
            val result = ArrayList<Any?>()
            skipWhitespace()
            if (peek() == ']') {
                pos++
                return result
            }
            while (true) {
                result.add(parseValue())
                skipWhitespace()
                when (peek()) {
                    ',' -> {
                        pos++
                        continue
                    }
                    ']' -> {
                        pos++
                        break
                    }
                    else -> throw NativeJsonException("Expected ',' or ']' at index $pos")
                }
            }
            return result
        }

        private fun parseString(): String {
            expect('"')
            val sb = StringBuilder()
            while (true) {
                if (isAtEnd()) throw NativeJsonException("Unterminated string at index $pos")
                val c = src[pos]
                pos++
                when (c) {
                    '"' -> return sb.toString()
                    '\\' -> {
                        if (isAtEnd()) throw NativeJsonException("Unterminated escape at index $pos")
                        val esc = src[pos]
                        pos++
                        when (esc) {
                            '"' -> sb.append('"')
                            '\\' -> sb.append('\\')
                            '/' -> sb.append('/')
                            'n' -> sb.append('\n')
                            'r' -> sb.append('\r')
                            't' -> sb.append('\t')
                            'b' -> sb.append('\b')
                            'f' -> sb.append('\u000C')
                            'u' -> {
                                if (pos + 4 > src.length) {
                                    throw NativeJsonException("Invalid unicode escape at index $pos")
                                }
                                val hex = src.substring(pos, pos + 4)
                                pos += 4
                                val codePoint =
                                    try {
                                        hex.toInt(16)
                                    } catch (e: NumberFormatException) {
                                        // Malformed \u escape (e.g. non-hex
                                        // digits) must fail open via
                                        // NativeJsonException, not leak a
                                        // raw NumberFormatException past
                                        // this decoder -- see
                                        // NativeAppenderToggleStore/
                                        // NativeLogQueue's "fail open"
                                        // contract.
                                        throw NativeJsonException(
                                            "Invalid unicode escape '\\u$hex' at index $pos",
                                        )
                                    }
                                sb.append(codePoint.toChar())
                            }
                            else -> throw NativeJsonException("Invalid escape '\\$esc' at index $pos")
                        }
                    }
                    else -> sb.append(c)
                }
            }
        }

        private fun parseBoolean(): Boolean {
            return if (src.startsWith("true", pos)) {
                pos += 4
                true
            } else if (src.startsWith("false", pos)) {
                pos += 5
                false
            } else {
                throw NativeJsonException("Invalid literal at index $pos")
            }
        }

        private fun parseNull(): Any? {
            if (src.startsWith("null", pos)) {
                pos += 4
                return null
            }
            throw NativeJsonException("Invalid literal at index $pos")
        }

        private fun parseNumber(): Any {
            val start = pos
            if (!isAtEnd() && src[pos] == '-') pos++

            // At least one integer digit is required -- a lone '-', or a
            // '-'/nothing followed immediately by a non-digit, is not a
            // valid JSON number. Without this check, malformed input like
            // "-" alone would slip through to text.toDouble() below and
            // throw a raw NumberFormatException instead of failing open.
            val digitsStart = pos
            while (!isAtEnd() && src[pos].isDigit()) pos++
            if (pos == digitsStart) throw NativeJsonException("Invalid number at index $pos")

            var isDouble = false
            if (!isAtEnd() && src[pos] == '.') {
                isDouble = true
                pos++
                val fracStart = pos
                while (!isAtEnd() && src[pos].isDigit()) pos++
                if (pos == fracStart) throw NativeJsonException("Invalid number at index $pos")
            }
            if (!isAtEnd() && (src[pos] == 'e' || src[pos] == 'E')) {
                isDouble = true
                pos++
                if (!isAtEnd() && (src[pos] == '+' || src[pos] == '-')) pos++
                // Same requirement as the integer part: at least one
                // exponent digit. Without this, malformed input like "1e"
                // would reach text.toDouble() below and throw a raw
                // NumberFormatException instead of failing open.
                val expStart = pos
                while (!isAtEnd() && src[pos].isDigit()) pos++
                if (pos == expStart) throw NativeJsonException("Invalid number at index $pos")
            }

            val text = src.substring(start, pos)
            return try {
                if (isDouble) text.toDouble() else (text.toLongOrNull() ?: text.toDouble())
            } catch (e: NumberFormatException) {
                // Defense in depth: the grammar checks above should already
                // rule out every case that reaches here, but this decoder's
                // whole contract is "never leak an unchecked exception past
                // NativeJson.decode" -- see NativeAppenderToggleStore/
                // NativeLogQueue's "fail open" callers.
                throw NativeJsonException("Invalid number literal '$text' at index $start")
            }
        }

        private fun peek(): Char {
            if (isAtEnd()) throw NativeJsonException("Unexpected end of input at index $pos")
            return src[pos]
        }

        private fun expect(c: Char) {
            if (isAtEnd() || src[pos] != c) {
                throw NativeJsonException("Expected '$c' at index $pos")
            }
            pos++
        }
    }
}

/** Thrown when [NativeJson.decode] encounters malformed input. */
internal class NativeJsonException(message: String) : Exception(message)
