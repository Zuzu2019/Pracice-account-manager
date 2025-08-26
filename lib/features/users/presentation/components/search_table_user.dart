import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/provider/user_paging_provider.dart';
import 'package:practice_acount_manager/features/users/provider/user_provider.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_update_user.dart';

class SearchTableUser extends ConsumerStatefulWidget {
  const SearchTableUser({super.key});

  @override
  ConsumerState<SearchTableUser> createState() => _SearchTableUserState();
}

class _SearchTableUserState extends ConsumerState<SearchTableUser> {
  @override
  void initState() {
    super.initState();
    // Cargar la primera página automáticamente
    Future.microtask(() => ref.read(usersPagingProvider).fetchNextPage());
  }

  void _onDelete(User user, BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: loc.delete,
      desc:
          '${user.login} '
          ' ${loc.delete_confirmation}',
      btnCancelText: loc.cancel,
      btnCancelOnPress: () {},
      btnOkText: loc.confirm,
      btnOkOnPress: () async {
        final success = await ref
            .read(userProvider.notifier)
            .deleteUser(user.id);
        if (success) {
          final manager = ref.read(usersPagingProvider);
          manager.reset();
          await manager.fetchNextPage();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '"${user.login}${loc.deleted}"' : 'Error'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final manager = ref.watch<UsersPagingManager>(usersPagingProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBarExample(
            onQueryChanged: (query) {
              ref.read(usersPagingProvider.notifier).setSearchQuery(query);
              //ref.read(userProvider.notifier).setSearchQuery(query),
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PagedListView<int, User>(
            state: manager.state,
            fetchNextPage: () => manager.fetchNextPage(),
            builderDelegate: PagedChildBuilderDelegate<User>(
              itemBuilder: (context, user, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                                    ),
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    loc.label_login,
                                    style: const TextStyle(
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
                                  Text(
                                    loc.email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: const TextStyle(fontSize: 13),
                                  ),
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
                                  Text(
                                    loc.label_id,
                                    style: const TextStyle(
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
                                  Text(
                                    loc.label_group,
                                    style: const TextStyle(
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
                                  Text(
                                    loc.label_quota,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    (user.quota).toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateUserForm(user: user),
                              ),
                            );
                            //manager.reset(query: manager.currentQuery);
                          } else if (value == 'delete') {
                            _onDelete(user, context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(loc.edit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(loc.delete),
                              ],
                            ),
                          ),
                        ],
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
    );
  }
}
