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

    // Use ref.listen to handle snackbars, similar to the login view
    ref.listen<UserProfileState>(userProfileViewModelProvider, (
      previous,
      next,
    ) {
      // Handle general profile message
      if (next.message != null &&
          (previous?.message != next.message ||
              previous?.profileStatus != next.profileStatus)) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: next.profileStatus != ProfileStatus.error,
        );
        ref.read(userProfileViewModelProvider.notifier).clearMessages();
      }

      // Handle password change message
      if (next.passwordStatus == PasswordStatus.success &&
          next.passwordMessage != null &&
          previous?.passwordMessage != next.passwordMessage) {
        showSnackBar(
          context: context,
          message: next.passwordMessage!,
          isSuccess: true,
        );
        ref.read(userProfileViewModelProvider.notifier).clearPasswordStatus();
      }

      // Handle delete account message and navigation
      if (next.deleteStatus == DeleteStatus.success &&
          next.deleteMessage != null &&
          previous?.deleteMessage != next.deleteMessage) {
        showSnackBar(
          context: context,
          message: next.deleteMessage!,
          isSuccess: true,
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        });
        ref.read(userProfileViewModelProvider.notifier).clearDeleteStatus();
      }
    });

    return Container(color: AppColors.background, child: _buildContent(state));
  }

  Widget _buildContent(UserProfileState state) {
    if (state.profileStatus == ProfileStatus.loading &&
        state.userProfile == null) {
      return _buildLoading();
    }

    if (state.profileStatus == ProfileStatus.error &&
        state.userProfile == null) {
      return _buildError(state);
    }

    if (state.userProfile == null) {
      return _buildLoading();
    }

    return _buildProfile(state);
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
            const Icon(
              Icons.error_outline,
              color: AppColors.errorRed,
              size: 60,
            ),
            const SizedBox(height: 24),
            Text('Failed to load profile', style: AppStyles.headline3),
            const SizedBox(height: 12),
            Text(
              state.message ?? 'Please try again later',
              textAlign: TextAlign.center,
              style: AppStyles.small,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => ref
                    .read(userProfileViewModelProvider.notifier)
                    .loadUserProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text('Retry', style: AppStyles.button),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Account Details', style: AppStyles.headline3),
              IconButton(
                icon: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.primaryOrange,
                  size: 28,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(profile: profile),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primaryOrange,
                  child: Text(
                    profile.fullName[0].toUpperCase(),
                    style: AppStyles.headline1.copyWith(
                      color: Colors.white,
                      fontSize: 28,
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
                        style: AppStyles.headline3.copyWith(fontSize: 20),
                      ),
                      Text('@${profile.username}', style: AppStyles.small),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          profile.role.toUpperCase(),
                          style: AppStyles.small.copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
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
          _buildSectionTitle('Information'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildInfoItem(Icons.email_outlined, 'Email', profile.email),
                _buildDivider(),
                _buildInfoItem(
                  Icons.phone_outlined,
                  'Phone',
                  profile.phoneNumber,
                ),
                _buildDivider(),
                _buildInfoItem(
                  Icons.location_on_outlined,
                  'Location',
                  profile.location ?? 'Not set',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Settings'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildActionItem(
                  Icons.lock_reset_rounded,
                  'Change Password',
                  Colors.blue,
                  () => _showChangePasswordDialog(context),
                  state.isChangingPassword,
                ),
                _buildDivider(),
                _buildActionItem(
                  Icons.delete_forever_rounded,
                  'Delete Account',
                  AppColors.errorRed,
                  () => _showDeleteAccountDialog(context),
                  state.isDeleting,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Adoptions',
                  '0',
                  Icons.pets,
                  AppColors.primaryOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  'Reviews',
                  '0',
                  Icons.star_rounded,
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppStyles.headline3.copyWith(fontSize: 18));
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryOrange, size: 22),
      title: Text(label, style: AppStyles.small),
      subtitle: Text(
        value,
        style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
    bool loading,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: AppStyles.body.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: AppStyles.headline3),
          Text(label, style: AppStyles.small),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 50, endIndent: 16);

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordDialog(
        onChangePassword: (current, next) => ref
            .read(userProfileViewModelProvider.notifier)
            .changePassword(currentPassword: current, newPassword: next),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        onDeleteAccount: () =>
            ref.read(userProfileViewModelProvider.notifier).deleteAccount(),
      ),
    );
  }
}
