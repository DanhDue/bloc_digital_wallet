/*
 * Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

package com.danhdue.{{name.snakeCase()}}.presentation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun {{name.pascalCase()}}Screen(
    viewModel: {{name.pascalCase()}}ViewModel,
    modifier: Modifier = Modifier
) {
    val state by viewModel.state.collectAsState()

    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = state.title,
            style = MaterialTheme.typography.titleLarge
        )

        if (state.isLoading) {
            CircularProgressIndicator(modifier = Modifier.padding(top = 16.dp))
        }

        Button(
            onClick = { viewModel.onAction({{name.pascalCase()}}Action.Initialize) },
            modifier = Modifier.padding(top = 16.dp)
        ) {
            Text("Refresh Native Data")
        }
    }
}
