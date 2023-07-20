import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start/Todo/views/details.dart';

import '../utils/colors.dart';
import '../widgets/delete_task_dialog.dart';
import '../widgets/update_task_dialog.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tasks to display');
          } else {
            final List<Widget> taskWidgets = [];

            for (DocumentSnapshot document in snapshot.data!.docs) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              bool taskState = data['State'];
              var taskTag = data['taskTag'];
              if (taskState == true && taskTag == 'Demande') {
                Color taskColor = AppColors.blueShadeColor;
                var taskTag = data['taskTag'];
                taskColor = AppColors.salmonColor;

                Widget taskWidget = Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 5.0,
                        offset: Offset(0, 5), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      String taskId = (data['id']);
                      String taskName = (data['taskName']);
                      String CurrencyFrom = (data['CurrencyFrom']);
                      String taskTag = (data['taskTag']);
                      String CurrencyTo = (data['CurrencyTo']);
                      double amount = (data['amount']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(
                                taskId: taskId,
                                taskName: taskName,
                                taskTag: taskTag,
                                amount: amount,
                                CurrencyFrom: CurrencyFrom,
                                CurrencyTo: CurrencyTo),
                          ));
                    },
                    leading: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: taskColor,
                      ),
                    ),
                    title: Text(data['taskName']),
                    isThreeLine: true,
                    subtitle: Text(data['CurrencyFrom']),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              String CurrencyFrom = (data['CurrencyFrom']);
                              String taskTag = (data['taskTag']);
                              String CurrencyTo = (data['CurrencyTo']);
                              double amount = (data['amount']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => UpdateTaskAlertDialog(
                                    taskId: taskId,
                                    taskName: taskName,
                                    taskTag: taskTag,
                                    amount: amount,
                                    CurrencyFrom: CurrencyFrom,
                                    CurrencyTo: CurrencyTo,
                                  ),
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              bool taskState = (data['State']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => DeleteTaskDialog(
                                      taskId: taskId, taskName: taskName),
                                ),
                              );
                            },
                          ),
                        ];
                      },
                    ),
                    dense: true,
                  ),
                );
                taskWidgets.add(taskWidget);
              }
            }
            if (taskWidgets.isEmpty) {
              return const Text('No tasks With state ');
            } else {
              return ListView(
                children: taskWidgets,
              );
            }
          }
        },
      ),
    );
  }
}
