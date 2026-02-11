// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:trends/trends_strings.dart';

/// Animated search bar with history dropdown for trends search.
class TrendsSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onChanged;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMicTap;
  final Function(String)? onHistoryTap;
  final List<String>? history;
  final Function(bool)? onFocusChanged;
  final Function(String)? onSubmitted;

  const TrendsSearchBar({
    super.key,
    this.onChanged,
    this.onSearchTap,
    this.onMicTap,
    this.onHistoryTap,
    this.history,
    this.onFocusChanged,
    this.onSubmitted,
  });

  @override
  State<TrendsSearchBar> createState() => _TrendsSearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(76);
}

class _TrendsSearchBarState extends State<TrendsSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() => setState(() {});

  void _onFocusChanged() {
    setState(() {});
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = _focusNode.hasFocus;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20, color: colorScheme.onSurface),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        onTap: widget.onSearchTap,
                        decoration: InputDecoration(
                          hintText: TrendsStrings.l10n.trendsSearchHint,
                          hintStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_controller.text.isNotEmpty)
                      InkWell(
                        onTap: () {
                          _controller.clear();
                          widget.onChanged?.call('');
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.clear,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: widget.onMicTap,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.mic_rounded, color: colorScheme.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 1,
                width: isExpanded ? MediaQuery.of(context).size.width : 0,
                color: colorScheme.primary,
              ),
              if (isExpanded) _buildHistoryDropdown(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: widget.history == null || widget.history!.isEmpty
            ? Container(
                height: 100,
                alignment: .center,
                child: Text(
                  TrendsStrings.l10n.trendsNoRecentSearches,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: .start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
                    child: Text(
                      TrendsStrings.l10n.trendsRecentSearches,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: .zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.history!.length,
                    itemBuilder: (context, index) {
                      final item = widget.history![index];
                      return ListTile(
                        leading: const Icon(Icons.history, size: 18),
                        title: Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        onTap: () {
                          _controller.text = item;
                          widget.onChanged?.call(item);
                          widget.onHistoryTap?.call(item);
                          _focusNode.unfocus();
                        },
                        dense: true,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
