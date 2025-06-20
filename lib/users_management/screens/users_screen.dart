import 'package:ams/users_management/screens/widgets/user_form_dialog.dart';
import 'package:ams/users_management/screens/widgets/user_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ams/users_management/bloc/user_bloc.dart';
import 'package:ams/users_management/bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _searchController = TextEditingController();
  UserRole? _selectedRole;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUserFormDialog({User? existingUser}) {
    final bloc = context.read<UserBloc>(); // ✅ Safe context

    showDialog(
      context: context,
      builder: (_) => UserFormDialog(
        existingUser: existingUser,
        onUserSubmitted: (user) {
          if (existingUser != null) {
            bloc.add(UpdateUser(user));
          } else {
            bloc.add(AddUser(user));
          }
        },
      ),
    );
  }


  void _showUserProfileDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => UserProfileDialog(user: user),
    );
  }

  void _showDeleteConfirmation(User user) {
    final bloc = context.read<UserBloc>(); // ✅ Safe here

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Are you sure you want to delete ${user.fullName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              bloc.add(DeleteUser(user.id!)); // ✅ Use captured bloc
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, email, or phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<UserBloc>().add(const SearchUsers(''));
                  },
                )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<UserBloc>().add(SearchUsers(query));
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<UserRole?>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Filter by Role',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<UserRole?>(
                  value: null,
                  child: Text('All Roles'),
                ),
                ...UserRole.values.map((role) => DropdownMenuItem<UserRole?>(
                  value: role,
                  child: Text(role.displayName),
                )),
              ],
              onChanged: (role) {
                setState(() {
                  _selectedRole = role;
                });
                context.read<UserBloc>().add(FilterUsersByRole(role));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No Users Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Create your first user to get started!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showUserFormDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Create User"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _getRoleColor(user.role),
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: user.profilePicture == null
                      ? Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.role.displayName,
                              style: TextStyle(
                                color: _getRoleColor(user.role),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            user.phone,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      if (user.createdAt != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Joined ${_formatDate(user.createdAt!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20, color: Colors.green),
                  onPressed: () => _showUserProfileDialog(user),
                  tooltip: 'View Profile',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () => _showUserFormDialog(existingUser: user),
                  tooltip: 'Edit User',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(user),
                  tooltip: 'Delete User',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.ADMIN:
        return Colors.purple;
      case UserRole.ASSET_MANAGER:
        return Colors.blue;
      case UserRole.EMPLOYEE:
        return Colors.green;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserBloc>().add(LoadUsers()),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UsersLoaded || state is UserOperationFailure) {
            return FloatingActionButton(
              onPressed: () => _showUserFormDialog(),
              child: const Icon(Icons.add),
              tooltip: 'Add User',
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is UserOperationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading users...'),
                      ],
                    ),
                  );
                }

                if (state is UserOperationInProgress) {
                  return Stack(
                    children: [
                      // Show existing content in background
                      if (state.currentUsers.isEmpty)
                        _buildEmptyState()
                      else
                        ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: state.currentUsers.length,
                          itemBuilder: (context, index) {
                            return _buildUserCard(state.currentUsers[index]);
                          },
                        ),
                      // Overlay loading indicator
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(state.operation),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is UsersLoaded) {
                  final usersToShow = state.filteredUsers.isEmpty &&
                      (state.searchQuery.isNotEmpty || state.selectedRole != null)
                      ? <User>[]
                      : state.filteredUsers.isEmpty
                      ? state.users
                      : state.filteredUsers;

                  if (usersToShow.isEmpty) {
                    if (state.users.isEmpty) {
                      return _buildEmptyState();
                    } else {
                      // No results for current filter/search
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No Users Found",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Try adjusting your search or filter criteria.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _selectedRole = null;
                                  });
                                  context.read<UserBloc>().add(const SearchUsers(''));
                                  context.read<UserBloc>().add(const FilterUsersByRole(null));
                                },
                                icon: const Icon(Icons.clear),
                                label: const Text("Clear Filters"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserBloc>().add(LoadUsers());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: usersToShow.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(usersToShow[index]);
                      },
                    ),
                  );
                }

                if (state is UserOperationFailure) {
                  if (state.currentUsers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 80,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Error Loading Users",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.read<UserBloc>().add(LoadUsers()),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Show existing users even if there was an error
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.currentUsers.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(state.currentUsers[index]);
                      },
                    );
                  }
                }

                // Fallback for any other state
                return const Center(
                  child: Text('Unknown state'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}