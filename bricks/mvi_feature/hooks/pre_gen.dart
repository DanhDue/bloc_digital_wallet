import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Automatically set the year to the current year if not provided
  if (!context.vars.containsKey('year') || context.vars['year'] == null) {
    context.vars['year'] = DateTime.now().year;
  }
}
