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
  int _rowsPerPage = 9;
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

  void _onDelete(Aliases u) {}

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarExample(
          onQueryChanged: (query) {
            _dataSource.filter(query);
            setState(() {}); // <- Redibuja la tabla con los resultados
          },
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.9,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: PaginatedDataTable(
              //header: const Text('Aliases'),
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
                        'Local',
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
                        Icons.cloud,
                        size: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Remoto',
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
              availableRowsPerPage: const [9, 20, 50],
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

class AliasesDataSource extends DataTableSource {
  final void Function(Aliases) onEdit;
  final void Function(Aliases) onDelete;

  final List<Aliases> _all;
  List<Aliases> _visible;

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
