import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/aliases/data/mock_aliases.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/frm_add_aliase.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';

class SearchTableAliases extends StatefulWidget {
  const SearchTableAliases({super.key});

  @override
  State<SearchTableAliases> createState() => _SearchTableAliasesState();
}

class _SearchTableAliasesState extends State<SearchTableAliases> {
  late final AliasesDataSource _dataSource;

  final TextEditingController _searchCtrl = TextEditingController();
  //int _rowsPerPage = 9;
  @override
  void initState() {
    super.initState();

    _dataSource = AliasesDataSource(
      alias: alias,
      onEdit: _onEdit,
      onDelete: _onDelete,
    );
  }

  void _onEdit(Aliases u) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAliasForm(alias: u, isEditing: true),
      ),
    );
  }

  void _onDelete(Aliases alias) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Eliminar',
      desc: '¿Estás seguro de eliminar a ${alias.local}?',
      btnCancelText: 'Cancelar',
      btnCancelOnPress: () {},
      btnOkText: 'Confirmar',
      btnOkOnPress: () {
        setState(() {
          _dataSource.delete(alias);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario "${alias.local}" eliminado correctamente'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            elevation: 5,
          ),
        );
      },
    ).show();
  }

  // void _onDelete(Aliases alias) async {
  //   final confirm = await showDialog(
  //     context: context,
  //     builder: (context) => ConfirmAlertDialog(text: alias.local),
  //   );

  //   if (confirm == true) {
  //     setState(() {
  //       _dataSource.delete(alias);
  //     });

  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Alias "${alias.local}" eliminado correctamente'),
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.green,
  //         elevation: 5,
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
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
              final alias = _dataSource.getVisibleAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(
                    'Local: ${alias.local}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    'Remoto: ${alias.remoto}',
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _onEdit(alias);
                      } else if (value == 'delete') {
                        _onDelete(alias);
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

class AliasesDataSource extends DataTableSource {
  final void Function(Aliases) onEdit;
  final void Function(Aliases) onDelete;

  final List<Aliases> _all;
  List<Aliases> _visible;

  int get visibleCount => _visible.length;
  Aliases getVisibleAt(int index) => _visible[index];

  AliasesDataSource({
    required List<Aliases> alias,
    required this.onEdit,
    required this.onDelete,
  }) : _all = List<Aliases>.from(alias),
       _visible = List<Aliases>.from(alias);

  void filter(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      _visible = List<Aliases>.from(_all);
    } else {
      _visible = _all.where((u) {
        return u.remoto.toLowerCase().contains(q) ||
            u.remoto.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }

  void delete(Aliases u) {
    _all.removeWhere((x) => x.local == u.local);
    _visible.removeWhere((x) => x.local == u.local);
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
        DataCell(Text(u.local)),
        DataCell(Text(u.remoto)),
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
