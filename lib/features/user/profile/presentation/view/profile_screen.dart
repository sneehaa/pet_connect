import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/user/profile/presentation/state/profile_state.dart';
import 'package:pet_connect/features/user/profile/presentation/view/edit_profile_screen.dart';
import 'package:pet_connect/features/user/profile/presentation/view/widgets/change_password_dialog.dart';
import 'package:pet_connect/features/user/profile/presentation/view/widgets/delete_account_dialog.dart';
import 'package:pet_connect/features/user/profile/presentation/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileViewModelProvider.notifier).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileViewModelProvider);

    // Handle snackbar messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.message != null && state.message!.isNotEmpty) {
        showSnackBar(
          context: context,
          message: state.message!,
          isSuccess: state.profileStatus != ProfileStatus.error,
        );
        ref.read(userProfileViewModelProvider.notifier).clearMessages();
      }

      // Handle password change success
      if (state.passwordStatus == PasswordStatus.success &&
          state.passwordMessage != null) {
        showSnackBar(
          context: context,
          message: state.passwordMessage!,
          isSuccess: true,
        );
        ref.read(userProfileViewModelProvider.notifier).clearPasswordStatus();
      }

      // Handle account deletion success
      if (state.deleteStatus == DeleteStatus.success &&
          state.deleteMessage != null) {
        showSnackBar(
          context: context,
          message: state.deleteMessage!,
          isSuccess: true,
        );
        // Navigate to login after successful deletion
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        });
        ref.read(userProfileViewModelProvider.notifier).clearDeleteStatus();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (state.userProfile != null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryOrange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(profile: state.userProfile!),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildContent(state),
    );
  }

  Widget _buildContent(UserProfileState state) {
    if (state.profileStatus == ProfileStatus.loading) {
      return _buildLoading();
    }

    if (state.profileStatus == ProfileStatus.error &&
        state.userProfile == null) {
      return _buildError(state);
    }

    return _buildProfile(state);
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading profile...',
            style: AppStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(UserProfileState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load profile',
              style: AppStyles.headline3.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.message ?? 'Please try again later',
              textAlign: TextAlign.center,
              style: AppStyles.small.copyWith(
                fontSize: 14,
                color: AppColors.textLightGrey,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(userProfileViewModelProvider.notifier)
                      .loadUserProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Retry',
                  style: AppStyles.button.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(UserProfileState state) {
    final profile = state.userProfile!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryOrange,
                  child: Text(
                    profile.fullName.substring(0, 1).toUpperCase(),
                    style: AppStyles.headline1.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        style: AppStyles.headline2.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${profile.username}',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: profile.isAdmin
                              ? Colors.purple.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.role,
                          style: AppStyles.small.copyWith(
                            color: profile.isAdmin
                                ? Colors.purple
                                : Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account Information
          Text(
            'Account Information',
            style: AppStyles.headline3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoItem(
                  icon: Icons.email,
                  title: 'Email',
                  value: profile.email,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: profile.phoneNumber,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.location_on,
                  title: 'Location',
                  value: profile.location ?? 'Not set',
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.person,
                  title: 'Username',
                  value: profile.username,
                ),
                _buildDivider(),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  value: profile.createdAt != null
                      ? _formatDate(profile.createdAt!)
                      : 'N/A',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Account Actions
          Text(
            'Account Actions',
            style: AppStyles.headline3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActionItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  color: Colors.blue,
                  onTap: () {
                    _showChangePasswordDialog(context);
                  },
                  isLoading: state.isChangingPassword,
                ),
                _buildDivider(),
                _buildActionItem(
                  icon: Icons.delete,
                  title: 'Delete Account',
                  color: Colors.red,
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                  isLoading: state.isDeleting,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Statistics (optional - can be expanded)
          Text(
            'Account Statistics',
            style: AppStyles.headline3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  label: 'Adoptions',
                  value: '0',
                  icon: Icons.pets,
                  color: AppColors.primaryOrange,
                ),
                _buildStatItem(
                  label: 'Payments',
                  value: '0',
                  icon: Icons.payment,
                  color: Colors.green,
                ),
                _buildStatItem(
                  label: 'Reviews',
                  value: '0',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textLightGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.small.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppStyles.headline2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppColors.textLightGrey),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangePasswordDialog(
          onChangePassword: (currentPassword, newPassword) {
            ref
                .read(userProfileViewModelProvider.notifier)
                .changePassword(
                  currentPassword: currentPassword,
                  newPassword: newPassword,
                );
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAccountDialog(
          onDeleteAccount: () {
            ref.read(userProfileViewModelProvider.notifier).deleteAccount();
          },
        );
      },
    );
  }
}
