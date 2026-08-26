// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

package com.danhdue.native_security

import android.content.SharedPreferences

/**
 * Minimal in-memory [SharedPreferences] test double for
 * [DatadogNativeAppenderHeadlessTest] — deliberately independent of
 * `logger_native_bridge`'s own test-source fake of the same name (they
 * live in different Gradle modules and neither exposes test sources to the
 * other). See `logger_native_bridge`'s
 * `android/src/test/kotlin/.../FakeSharedPreferences.kt` for the fuller
 * rationale: [SharedPreferences] is an Android SDK *interface*, so a fake
 * implementation is all a plain JVM test needs (no Robolectric).
 */
class FakeSharedPreferences(initial: Map<String, String> = emptyMap()) : SharedPreferences {
    private val values = LinkedHashMap<String, String>(initial)

    override fun getString(key: String?, defValue: String?): String? =
        if (key != null && values.containsKey(key)) values[key] else defValue

    override fun edit(): SharedPreferences.Editor = FakeEditor()

    override fun getAll(): MutableMap<String, *> = values.toMutableMap()

    override fun getStringSet(key: String?, defValues: MutableSet<String>?): MutableSet<String>? =
        throw UnsupportedOperationException("not used by this test fixture")

    override fun getInt(key: String?, defValue: Int): Int =
        throw UnsupportedOperationException("not used by this test fixture")

    override fun getLong(key: String?, defValue: Long): Long =
        throw UnsupportedOperationException("not used by this test fixture")

    override fun getFloat(key: String?, defValue: Float): Float =
        throw UnsupportedOperationException("not used by this test fixture")

    override fun getBoolean(key: String?, defValue: Boolean): Boolean =
        throw UnsupportedOperationException("not used by this test fixture")

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

        override fun putString(key: String?, value: String?): SharedPreferences.Editor {
            if (key != null) {
                pendingPuts[key] = value
                pendingRemovals.remove(key)
            }
            return this
        }

        override fun putStringSet(key: String?, values: MutableSet<String>?): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by this test fixture")

        override fun putInt(key: String?, value: Int): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by this test fixture")

        override fun putLong(key: String?, value: Long): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by this test fixture")

        override fun putFloat(key: String?, value: Float): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by this test fixture")

        override fun putBoolean(key: String?, value: Boolean): SharedPreferences.Editor =
            throw UnsupportedOperationException("not used by this test fixture")

        override fun remove(key: String?): SharedPreferences.Editor {
            if (key != null) {
                pendingRemovals.add(key)
                pendingPuts.remove(key)
            }
            return this
        }

        override fun clear(): SharedPreferences.Editor {
            pendingPuts.clear()
            pendingRemovals.clear()
            values.clear()
            return this
        }

        override fun commit(): Boolean {
            apply()
            return true
        }

        override fun apply() {
            for (key in pendingRemovals) values.remove(key)
            for ((key, value) in pendingPuts) {
                if (value == null) values.remove(key) else values[key] = value
            }
        }
    }
}
