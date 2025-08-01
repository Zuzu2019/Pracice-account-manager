import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/users/data/mock_users.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_add_user.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_update_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';

class SearchTableUser extends StatefulWidget {
  const SearchTableUser({super.key});

  @override
  State<SearchTableUser> createState() => _SearchTableUserState();
}

class _SearchTableUserState extends State<SearchTableUser> {
  late final UserDataSource _dataSource;
  final TextEditingController _searchCtrl = TextEditingController();
  //int _rowsPerPage = 9;

  @override
  void initState() {
    super.initState();

    _dataSource = UserDataSource(
      users: users,
      onEdit: _onEdit,
      onDelete: _onDelete,
    );
  }

  void _onEdit(User u) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateUserForm(user: u)),
    );
  }

  void _onDelete(User user) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Eliminar',
      desc: '¿Estás seguro de eliminar el usuario ${user.login}?',
      btnCancelText: 'Cancelar',
      btnCancelOnPress: () {},
      btnOkText: 'Confirmar',
      btnOkOnPress: () {
        setState(() {
          _dataSource.delete(user);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario "${user.login}" eliminado correctamente'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            elevation: 5,
          ),
        );
      },
    ).show();
  }

  //void _onDelete(User user) {
  // final confirm = await showDialog<bool>(
  //   context: context,
  //   builder: (context) => ConfirmAlertDialog(text: user.login),
  // );

  // if (confirm == true) {
  //   setState(() {
  //     _dataSource.delete(user);
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Usuario "${user.login}" eliminado corretamente'),
  //       duration: Duration(seconds: 3),
  //       backgroundColor: Colors.green,
  //       elevation: 5,
  //     ),
  //   );
  // }
  //}

  // void _onDelete(User u) {
  //   users.remove(u);
  // }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SearchBarExample(
            onQueryChanged: (query) {
              _dataSource.filter(query);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _dataSource.visibleCount,
            itemBuilder: (context, index) {
              final user = _dataSource.getVisibleAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      // Info en dos columnas
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Imagen circular (avatar) con imagen local
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                                    ),
                                    backgroundColor: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.login,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Maildir',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.maildir,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const Text(
                                    'Identificación',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.identificacion,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Grupo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.grupo,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Quota',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.quota,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón de opciones
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _onEdit(user);
                          } else if (value == 'delete') {
                            _onDelete(user);
                            //_dataSource.delete(user);
                            //setState(() {});
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final void Function(User) onEdit;
  final void Function(User) onDelete;

  final List<User> _all;
  List<User> _visible;

  int get visibleCount => _visible.length;
  User getVisibleAt(int index) => _visible[index];

  UserDataSource({
    required List<User> users,
    required this.onEdit,
    required this.onDelete,
  }) : _all = List<User>.from(users),
       _visible = List<User>.from(users);

  void filter(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      _visible = List<User>.from(_all);
    } else {
      _visible = _all.where((u) {
        return u.email.toLowerCase().contains(q) ||
            u.maildir.toLowerCase().contains(q) ||
            u.identificacion.toLowerCase().contains(q) ||
            u.grupo.toLowerCase().contains(q) ||
            u.quota.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }

  void delete(User u) {
    _all.removeWhere((x) => x.login == u.login);
    _visible.removeWhere((x) => x.login == u.login);
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _visible.length) return null;
    final u = _visible[index];

    final rowColor = index % 2 == 0
        ? const Color(0xFFE3F2FD)
        : const Color(0xFFBBDEFB);

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.all(rowColor),
      cells: [
        DataCell(Text(u.login)),
        DataCell(Text(u.email)),
        DataCell(Text(u.maildir)),
        DataCell(Text(u.identificacion)),
        DataCell(Text(u.grupo)),
        DataCell(Text(u.quota)),
        DataCell(
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit(u);
              } else if (value == 'delete') {
                onDelete(u);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Color.fromARGB(255, 72, 115, 242)),
                    SizedBox(width: 8),
                    Text(
                      'Editar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 72, 115, 242),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Eliminar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _visible.length;

  @override
  int get selectedRowCount => 0;
}
