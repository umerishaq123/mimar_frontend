import 'package:flutter/material.dart';
import 'package:mimar/widgets/shimmer_widget.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

class UsersTableWidget extends StatelessWidget {
  final List<UserModel> users;
  final bool isLoading;
  final VoidCallback onRefresh;

  const UsersTableWidget({
    Key? key,
    required this.users,
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
                  'Users',
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
            const SizedBox(height: 16),
            
            if (isLoading)
               SizedBox(
                          height: height * 0.2,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ShimmerWidget.rectangular(
                                  width: width * 0.8,
                                  height: height * 0.05,
                                ),
                              );
                            },
                          ),
                        )
            else if (users.isEmpty)
              const Center(
                child: Text('No users found'),
              )
            else
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Created At')),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.id)),
                          DataCell(Text(user.name)),
                          DataCell(Text(user.email)),
                          DataCell(  Text(formatDate(user.createdAt.toString() ?? ''))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  String formatDate(String apiDate) {
  final dateTime = DateTime.parse(apiDate);
  return DateFormat('yyyy-MM-dd').format(dateTime); // e.g., 2025-05-22
}
}