import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/frm_add_aliase.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_provider.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class SearchTableAliases extends ConsumerStatefulWidget {
  const SearchTableAliases({super.key});

  @override
  ConsumerState<SearchTableAliases> createState() => _SearchTableAliasesState();
}

class _SearchTableAliasesState extends ConsumerState<SearchTableAliases> {
  final TextEditingController _searchCtrl = TextEditingController();
  late final accessToken = ref.read(authProvider).accessToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Future<void> _loadAndInit() async {
  //   final resp = await getAlias(accessToken); // Trae la lista desde backend
  //   final loc = AppLocalizations.of(context)!;

  //   setState(() {
  //     _aliases = resp;
  //     _dataSource = AliasesDataSource(
  //       alias: _aliases,
  //       onEdit: _onEdit,
  //       onDelete: (alias) => _onDelete(alias, context),
  //       loc: loc,
  //     );
  //   });
  // }

  // Future<void> _onEdit(Aliases u) async {
  //   final edited = await Navigator.push<Aliases>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddAliasForm(alias: u, isEditing: true),
  //     ),
  //   );

  //   if (edited != null) {
  //     _loadAndInit();
  //   }
  // }

  void _onDelete(Aliases alias, BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: loc.delete,
      desc: '${alias.local} ${loc.delete_confirmation}?',
      btnCancelText: loc.cancel,
      btnCancelOnPress: () {},
      btnOkText: loc.confirm,
      btnOkOnPress: () async {
        //final resp = await deleteAlias(alias.id, accessToken);

        // if (resp.statusCode == 200) {
        //   //_loadAndInit();

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('"${alias.local}" ${loc.deleted}'),
        //       duration: Duration(seconds: 3),
        //       backgroundColor: Colors.green,
        //       elevation: 5,
        //     ),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Error al eliminar"${resp.body}"'),
        //       duration: Duration(seconds: 3),
        //       backgroundColor: Colors.red,
        //       elevation: 5,
        //     ),
        //   );
        // }
      },
    ).show();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final aliasAsync = ref.watch(aliasProvider); //Consumimos aliasProvider

    return aliasAsync.when(
      data: (aliases) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SearchBarExample(
                onQueryChanged: (query) {
                  ref.read(aliasProvider.notifier).setSearchQuery(query);
                },
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: aliases.length,
                itemBuilder: (context, index) {
                  final alias = aliases[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 1,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        '${loc.local_label}: ${alias?.local}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        '${loc.remote_label}: ${alias?.remoto}',
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddAliasForm(alias: alias),
                              ),
                            );
                          } else if (value == 'delete') {
                            _onDelete(alias!, context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(loc.edit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(loc.delete),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
