import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
    final usersAsync = ref.watch(userProvider); // Consumimos userProvider

    return usersAsync.when(
      data: (users) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBarExample(
                onQueryChanged: (query) =>
                    ref.read(userProvider.notifier).setSearchQuery(query),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 1,
                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
