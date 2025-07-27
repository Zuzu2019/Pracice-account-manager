import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

class SearchTableUser extends StatefulWidget {
  const SearchTableUser({super.key});

  @override
  State<SearchTableUser> createState() => _SearchTableUserState();
}

class _SearchTableUserState extends State<SearchTableUser> {
  late final UserDataSource _dataSource;
  final TextEditingController _searchCtrl = TextEditingController();
  int _rowsPerPage = 7;
  @override
  void initState() {
    super.initState();

    final users = [
      User(
        login: 'jsanchez',
        email: 'jsanchez@example.com',
        maildir: '/home/jsanchez/mail',
        identificacion: '123456789',
        grupo: 'admin',
        quota: '500MB',
      ),
      User(
        login: 'jsanchez',
        email: 'jsanchez@example.com',
        maildir: '/home/jsanchez/mail',
        identificacion: '123456789',
        grupo: 'admin',
        quota: '500MB',
      ),
    ];

    _dataSource = UserDataSource(
      users: users,
      onEdit: _onEdit,
      onDelete: _onDelete,
    );
  }

  void _onEdit(User u) {}

  void _onDelete(User u) {}

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.9,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: PaginatedDataTable(
              header: const Text('Dashboard Usuarios'),
              columns: const [
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 3, 208),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.file_copy,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Maildir',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),

                      Text(
                        'Identificación',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Grupo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),

                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.storage,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Quota',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Acciones   ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 3, 208),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              source: _dataSource,
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: const [7, 10, 20, 50],
              onRowsPerPageChanged: (v) {
                if (v != null) {
                  setState(() => _rowsPerPage = v);
                }
              },
              showFirstLastButtons: true,
            ),
          ),
        ),
      ],
    );
  }
}

class UserDataSource extends DataTableSource {
  final void Function(User) onEdit;
  final void Function(User) onDelete;

  final List<User> _all;
  List<User> _visible;

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
