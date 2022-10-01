import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Logout',
        ),
        IconButton(
          onPressed: () => SessionDataProvider().setSessionId(null),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
