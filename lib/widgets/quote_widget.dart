import 'package:flutter/material.dart';
import 'package:mimar/models/quotes_model.dart';
import 'package:mimar/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';


class QuoteWidget extends StatelessWidget {
  final QuoteData? quote;
  final bool isLoading;
  final VoidCallback onRefresh;

  const QuoteWidget({
    Key? key,
    required this.quote,
    required this.isLoading,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Motivation',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: onRefresh,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Quote content
                  Consumer(builder: (context,value,child){  
                    return  Text(
                    '"${quote?.quote?? ""}"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                  }),
                   
                  
                  const SizedBox(height: 8),
                  
                  // Quote author
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${quote?.author ?? ""}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}