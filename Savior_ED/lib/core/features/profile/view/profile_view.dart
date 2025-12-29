import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import '../../../widgets/gradient_background.dart';
import '../../../routes/app_routes.dart';
import '../../authentication/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _pushNotifications = false;
  bool _emailNotifications = false;
  bool _lightMode = false;
  String _selectedLanguage = 'GMT+1';
  String _selectedColorScheme = 'blue';

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile data when view opens
    _loadProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when view becomes visible (after navigating back)
    _loadProfileData();
  }

  void _loadProfileData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      profileViewModel.loadProfile().then((_) {
        // Update name controller with loaded data
        if (profileViewModel.name != null && mounted) {
          _nameController.text = profileViewModel.name!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [Color(0xFFA5D6A7), Color(0xFFE3F2FD)],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Consumer<ProfileViewModel>(
            builder: (context, profileViewModel, child) {
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () async {
                            await profileViewModel.refresh();
                            if (mounted && profileViewModel.name != null) {
                              _nameController.text = profileViewModel.name!;
                            }
                          },
                          tooltip: 'Refresh Profile',
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Profile Header Section
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: _buildProfileHeader(profileViewModel),
                          ),

                          // Stats Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: _buildStatsSection(profileViewModel),
                          ),

                          SizedBox(height: 2.h),

                          // Level & XP Progress Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: _buildLevelProgressSection(profileViewModel),
                          ),

                          SizedBox(height: 2.h),

                          // Profile Edit Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: _buildProfileEditSection(profileViewModel),
                          ),

                          SizedBox(height: 2.h),

                          // Settings Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: _buildSettingsSection(),
                          ),

                          SizedBox(height: 3.h),

                          // LOGOUT BUTTON
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Material(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(100),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  final authViewModel =
                                      Provider.of<AuthViewModel>(context, listen: false);
                                  await authViewModel.logout();
                                  if (mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.welcome,
                                      (route) => false,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build profile header with avatar, name, email
  Widget _buildProfileHeader(ProfileViewModel profileViewModel) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.sp,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: profileViewModel.avatar != null
                ? NetworkImage(profileViewModel.avatar!)
                : null,
            child: profileViewModel.avatar == null
                ? Icon(
                    Icons.person,
                    size: 35.sp,
                    color: Colors.blue.shade700,
                  )
                : null,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileViewModel.name ?? 'User',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  profileViewModel.email ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build stats section (Focus Hours, Sessions, Coins)
  Widget _buildStatsSection(ProfileViewModel profileViewModel) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: const Color(0xFF1B5E20), size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.access_time,
                  'Focus Time',
                  _formatFocusTime(profileViewModel.totalFocusHours),
                  Colors.blue,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatItem(
                  Icons.check_circle,
                  'Sessions',
                  '${profileViewModel.completedSessions}/${profileViewModel.totalSessions}',
                  Colors.green,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatItem(
                  Icons.monetization_on,
                  'Coins',
                  '${profileViewModel.totalCoins}',
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 1.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build level progress section with XP bar
  Widget _buildLevelProgressSection(ProfileViewModel profileViewModel) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: const Color(0xFF1B5E20), size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                'Level & Progress',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${profileViewModel.level}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${profileViewModel.experiencePoints} XP',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Next: Level ${profileViewModel.level + 1}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${profileViewModel.xpNeededForNextLevel} XP needed',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // XP Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: profileViewModel.levelProgress,
                  minHeight: 20.sp,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.lightBlue.shade300,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '${profileViewModel.levelProgressPercent} to Level ${profileViewModel.level + 1}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build profile edit section
  Widget _buildProfileEditSection(ProfileViewModel profileViewModel) {
    return _buildSettingsCard(
      title: 'Edit Profile',
      icon: Icons.edit,
      child: Column(
        children: [
          _buildRoundedTextField(
            controller: _nameController,
            hintText: 'Name',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final success = await profileViewModel.updateProfile(
                  name: _nameController.text.trim().isNotEmpty
                      ? _nameController.text.trim()
                      : null,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Profile updated successfully'
                            : profileViewModel.errorMessage ?? 'Failed to update profile',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build settings section
  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingsCard(
          title: 'Notification Settings',
          icon: Icons.notifications,
          child: Column(
            children: [
              _buildToggleItem(
                'Push Notifications',
                _pushNotifications,
                (val) => setState(() => _pushNotifications = val),
              ),
              SizedBox(height: 1.h),
              _buildToggleItem(
                'Email Notifications',
                _emailNotifications,
                (val) => setState(() => _emailNotifications = val),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        _buildSettingsCard(
          title: 'Language & Region Settings',
          icon: Icons.language,
          child: Column(
            children: [
              _buildLanguageItem(
                Icons.language,
                'Language',
                _selectedLanguage,
                () {},
              ),
              SizedBox(height: 1.h),
              _buildToggleItem(
                'Light Mode',
                _lightMode,
                (val) => setState(() => _lightMode = val),
                icon: Icons.light_mode,
              ),
              SizedBox(height: 1.h),
              _buildColorSchemeItem(),
            ],
          ),
        ),
      ],
    );
  }

  // TEXT FIELD UI
  Widget _buildRoundedTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool isPassword = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Color(0xFF1B5E20)),
        filled: true,
        fillColor: Colors.white, // Same as container background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

  // SETTINGS CARD
  Widget _buildSettingsCard({
    required String title,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, color: const Color(0xFF1B5E20), size: 20.sp),
              if (icon != null) SizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }

  // SWITCH ITEM
  Widget _buildToggleItem(
    String label,
    bool value,
    ValueChanged<bool> onChanged, {
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: Colors.grey.shade700, size: 20.sp),
        if (icon != null) SizedBox(width: 3.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  // LANGUAGE ITEM
  Widget _buildLanguageItem(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 20.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          SizedBox(width: 2.w),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  // COLOR SCHEME
  Widget _buildColorSchemeItem() {
    return Row(
      children: [
        Icon(Icons.dark_mode, color: Colors.grey.shade700, size: 20.sp),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            'Color Scheme',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ),
        Row(
          children: [
            _buildColorSwatch(
              const Color(0xFF2196F3),
              _selectedColorScheme == 'blue',
              () => setState(() => _selectedColorScheme = 'blue'),
            ),
            SizedBox(width: 2.w),
            _buildColorSwatch(
              const Color(0xFF81C784),
              _selectedColorScheme == 'green',
              () => setState(() => _selectedColorScheme = 'green'),
            ),
            SizedBox(width: 2.w),
            _buildColorSwatch(
              Colors.purple,
              _selectedColorScheme == 'purple',
              () => setState(() => _selectedColorScheme = 'purple'),
            ),
          ],
        ),
      ],
    );
  }

  // COLOR SWATCH
  Widget _buildColorSwatch(
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24.sp,
        height: 24.sp,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Format focus time from hours to readable format (e.g., "2h 30m" or "150m")
  String _formatFocusTime(double hours) {
    if (hours < 0.1) {
      // Less than 6 minutes, show in minutes
      final minutes = (hours * 60).round();
      return '${minutes}m';
    } else if (hours < 1.0) {
      // Less than 1 hour, show in minutes
      final minutes = (hours * 60).round();
      return '${minutes}m';
    } else {
      // 1 hour or more, show hours and minutes
      final totalHours = hours.floor();
      final minutes = ((hours - totalHours) * 60).round();
      if (minutes == 0) {
        return '${totalHours}h';
      } else {
        return '${totalHours}h ${minutes}m';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
