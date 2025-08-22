import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_acount_manager/features/users/provider/user_paging_provider.dart';
import 'package:practice_acount_manager/features/users/provider/user_provider.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_update_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';

class SearchTableUser extends ConsumerStatefulWidget {
  const SearchTableUser({super.key});

  @override
  ConsumerState<SearchTableUser> createState() => _SearchTableUserState();
}

class _SearchTableUserState extends ConsumerState<SearchTableUser> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onDelete(
    User user,
    BuildContext context,
    UsersPagingManager manager,
  ) async {
    final loc = AppLocalizations.of(context)!;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: loc.delete,
      desc: '${user.login} ${loc.delete_confirmation}',
      btnCancelText: loc.cancel,
      btnCancelOnPress: () {},
      btnOkText: loc.confirm,
      btnOkOnPress: () async {
        final success = await ref
            .read(userProvider.notifier)
            .deleteUser(user.id);
        if (success) {
          manager.reset();
          await manager.fetchNextPage(_searchCtrl.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '"${user.login} ${loc.deleted}"' : 'Error'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final manager = ref.watch(usersPagingProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBarExample(
            //controller: _searchCtrl,
            onQueryChanged: (query) async {
              manager.reset();
              await manager.fetchNextPage(query);
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: manager.state.pages!.isEmpty && manager.state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : PagedListView<int, User>(
                  state: manager.state,
                  fetchNextPage: () async =>
                      await manager.fetchNextPage(_searchCtrl.text),
                  builderDelegate: PagedChildBuilderDelegate<User>(
                    itemBuilder: (context, user, index) => Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                          ),
                        ),
                        title: Text(user.login),
                        subtitle: Text(user.email),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateUserForm(user: user),
                                ),
                              );
                              manager.reset();
                            } else if (value == 'delete') {
                              await _onDelete(user, context, manager);
                            }
                          },
                          itemBuilder: (_) => [
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
                    noItemsFoundIndicatorBuilder: (_) =>
                        Center(child: Text(loc.error_title)),
                  ),
                ),
        ),
      ],
    );
  }
}
