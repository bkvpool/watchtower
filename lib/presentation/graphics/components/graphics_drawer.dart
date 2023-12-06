import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prometheus_analytics/presentation/graphics/bloc/graphics_store.dart';

class GraphicsDrawer extends StatefulWidget {
  final GraphicsStore store;

  const GraphicsDrawer({required this.store, super.key});

  @override
  State<GraphicsDrawer> createState() => _GraphicsDrawerState();
}

class _GraphicsDrawerState extends State<GraphicsDrawer> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController baseUrlController;

  GraphicsStore get store => widget.store;

  bool get isParamsChanged => baseUrlController.text.trim().toLowerCase() != store.baseUrl.trim().toLowerCase();

  @override
  void initState() {
    baseUrlController = TextEditingController(text: store.baseUrl);
    super.initState();
  }

  @override
  void dispose() {
    baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  const SizedBox(height: 70.0),
                  SizedBox(
                    height: 80.0,
                    child: TextFormField(
                      controller: baseUrlController,
                      decoration: const InputDecoration(
                        label: Text('URL'),
                        hintText: 'URL',
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) return 'Field required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ListenableBuilder(
                    listenable: baseUrlController,
                    builder: (_, __) => ElevatedButton(
                      onPressed: isParamsChanged
                          ? () {
                              if (formKey.currentState?.validate() ?? false) {
                                store
                                  ..baseUrl = baseUrlController.text.trim()
                                  ..updateData();
                                setState(() {});
                              }
                            }
                          : null,
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
