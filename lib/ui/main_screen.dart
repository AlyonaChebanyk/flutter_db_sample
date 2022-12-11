import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  var users = <User>[];

  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BlocConsumer
    return BlocConsumer<UsersBloc, UsersState>(
        listener: (BuildContext context, state) {
      if (state is UsersLoadedState) {
        users = state.users;
        print(state.users);
      }
    }, builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Age'),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                  onPressed: () => {
                        if (nameController.text.isEmpty ||
                            ageController.text.isEmpty)
                          {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Fields are empty"),
                            ))
                          }
                        else
                          {
                            _addUser(
                                userName: nameController.text,
                                userAge: int.parse(ageController.text)),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("User added"),
                            ))
                          }
                      },
                  child: const Text('Add user'))),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton(
                  onPressed: _printUsers, child: Text('Show users'))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Name: ${users[index].name}, age: ${users[index].age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )))
        ],
      );
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       ElevatedButton(
      //         onPressed: _addTestValues,
      //         child: const Text('Add test users'),
      //       ),
      //       ElevatedButton(
      //         onPressed: _printUsers,
      //         child: const Text('Print users'),
      //       ),
      //     ],
      //   ),
      // ),
    });
  }

  void _addUser({required String userName, required int userAge}) {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(AddUserEvent(User(name: userName, age: userAge)));
    // bloc.add(
    //   AddUserEvent(
    //     User(
    //       name: 'Alex',
    //       age: 22,
    //     ),
    //   ),
    // );
    // bloc.add(
    //   AddUserEvent(
    //     User(
    //       name: 'Ben',
    //       age: 33,
    //     ),
    //   ),
    // );
    // bloc.add(
    //   AddUserEvent(
    //     User(
    //       name: 'Carl',
    //       age: 44,
    //     ),
    //   ),
    // );
  }

  void _printUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
