import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/frm_add_aliase.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_paging_provider.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_provider.dart';
import 'package:practice_acount_manager/features/core/navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class SearchTableAliases extends ConsumerStatefulWidget {
  const SearchTableAliases({super.key});

  @override
  ConsumerState<SearchTableAliases> createState() => _SearchTableAliasesState();
}

class _SearchTableAliasesState extends ConsumerState<SearchTableAliases> {
  final TextEditingController _searchCtrl = TextEditingController();
  final _isLoading = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(aliasPagingProvider).fetchNextPage());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onDelete(Aliases alias) {
    final BuildContext? scaffoldContext = navigatorKey.currentContext;
    final loc = AppLocalizations.of(scaffoldContext!)!;
    ref.read(_isLoading.notifier).state = true;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      dismissOnTouchOutside: false,
      animType: AnimType.bottomSlide,
      title: loc.delete,
      desc: '${alias.local} ${loc.delete_confirmation}?',
      btnCancelText: loc.cancel,
      btnCancelOnPress: () {
        ref.read(_isLoading.notifier).state = false;
      },
      btnOkText: loc.confirm,
      btnOkOnPress: () async {
        try {
          final success = await ref
              .read(aliasProvider.notifier)
              .deleteAlias(alias.id);

          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(
                success ? '"${alias.local} ${loc.deleted}"' : 'Error',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        } finally {
          ref.read(_isLoading.notifier).state = false;
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final manager = ref.watch<AliasPagingManager>(aliasPagingProvider);
    final isLoading = ref.watch(_isLoading);
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SearchBarExample(
                  onQueryChanged: (query) {
                    ref
                        .read(aliasPagingProvider.notifier)
                        .setSearchQuery(query);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PagedListView<int, Aliases>(
                  state: manager.state,
                  fetchNextPage: () => manager.fetchNextPage(),
                  builderDelegate: PagedChildBuilderDelegate<Aliases>(
                    itemBuilder: (context, alias, index) => Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(
                          '${loc.local_label}: ${alias.local}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          '${loc.remote_label}: ${alias.remoto}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAliasForm(
                                    alias: alias,
                                    isEditing: true,
                                  ),
                                ),
                              );
                            } else if (value == 'delete') {
                              _onDelete(alias);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const Icon(Icons.edit, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(loc.edit),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text(loc.delete),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    firstPageProgressIndicatorBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    newPageProgressIndicatorBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    noItemsFoundIndicatorBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
