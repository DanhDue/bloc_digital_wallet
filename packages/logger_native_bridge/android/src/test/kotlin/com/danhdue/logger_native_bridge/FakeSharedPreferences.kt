// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.logger_native_bridge

import android.content.SharedPreferences

/**
 * A minimal in-memory [SharedPreferences] test double.
 *
 * [SharedPreferences]/[SharedPreferences.Editor] are Android SDK
 * *interfaces* — their real Android implementations aren't available in a
 * plain JVM test (android.jar's own concrete classes are compile-only
 * stubs that throw at runtime), but since they're interfaces, a fake
 * implementation like this one is all a plain JVM unit test needs. This is
 * what makes [NativeAppenderToggleStore] and [NativeLogQueue] testable
 * with no Robolectric/Android instrumentation at all.
 *
 * Only the subset of the API [NativeAppenderToggleStore]/[NativeLogQueue]
 * actually use is implemented; everything else throws
 * [UnsupportedOperationException] so an accidental new usage fails loudly
 * in tests instead of silently doing nothing.
 */
class FakeSharedPreferences(initial: Map<String, String> = emptyMap()) : SharedPreferences {
    private val values = LinkedHashMap<String, String>(initial)

    override fun getString(key: String?, defValue: String?): String? {
        return if (key != null && values.containsKey(key)) values[key] else defValue
    }

    override fun edit(): SharedPreferences.Editor = FakeEditor()

    override fun getAll(): MutableMap<String, *> = values.toMutableMap()

    override fun getStringSet(key: String?, defValues: MutableSet<String>?): MutableSet<String>? =
        throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

    override fun getInt(key: String?, defValue: Int): Int =
        throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

    override fun getLong(key: String?, defValue: Long): Long =
        throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

    override fun getFloat(key: String?, defValue: Float): Float =
        throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

    override fun getBoolean(key: String?, defValue: Boolean): Boolean =
        throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

    override fun contains(key: String?): Boolean = key != null && values.containsKey(key)

    override fun registerOnSharedPreferenceChangeListener(
        listener: SharedPreferences.OnSharedPreferenceChangeListener?,
    ) = Unit

    override fun unregisterOnSharedPreferenceChangeListener(
        listener: SharedPreferences.OnSharedPreferenceChangeListener?,
    ) = Unit

    private inner class FakeEditor : SharedPreferences.Editor {
        private val pendingPuts = LinkedHashMap<String, String?>()
        private val pendingRemovals = LinkedHashSet<String>()
        private var pendingClear = false

        override fun putString(key: String?, value: String?): SharedPreferences.Editor {
            if (key != null) {
                pendingPuts[key] = value
                pendingRemovals.remove(key)
            }
            return this
        }

        override fun putStringSet(
            key: String?,
            values: MutableSet<String>?,
        ): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

        override fun putInt(key: String?, value: Int): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

        override fun putLong(key: String?, value: Long): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

        override fun putFloat(key: String?, value: Float): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

        override fun putBoolean(key: String?, value: Boolean): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by NativeAppenderToggleStore/NativeLogQueue")

        override fun remove(key: String?): SharedPreferences.Editor {
            if (key != null) {
                pendingRemovals.add(key)
                pendingPuts.remove(key)
            }
            return this
        }

        override fun clear(): SharedPreferences.Editor {
            pendingClear = true
            pendingPuts.clear()
            pendingRemovals.clear()
            return this
        }

        override fun commit(): Boolean {
            apply()
            return true
        }

        override fun apply() {
            if (pendingClear) {
                values.clear()
            }
            for (key in pendingRemovals) {
                values.remove(key)
            }
            for ((key, value) in pendingPuts) {
                if (value == null) {
                    values.remove(key)
                } else {
                    values[key] = value
                }
            }
        }
    }
}
