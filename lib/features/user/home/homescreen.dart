import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_card.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/presentation/view/pet_screen.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/pet_card.dart';
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';
import 'package:pet_connect/widgets/custom_navbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load pets
    ref.read(petViewModelProvider.notifier).loadAllPets();

    // Load all businesses
    ref.read(businessViewModelProvider.notifier).getAllBusinesses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _getCurrentScreen(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeContentScreen();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const CompatibilityScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeContentScreen();
    }
  }
}

// Home Content Screen (Main Tab)
class HomeContentScreen extends ConsumerWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petState = ref.watch(petViewModelProvider);
    final businessState = ref.watch(businessViewModelProvider);

    // Show error message if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (businessState.message != null && businessState.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(businessState.message!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(businessViewModelProvider.notifier).clearMessage();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(petViewModelProvider.notifier).loadAllPets();
          await ref.read(businessViewModelProvider.notifier).getAllBusinesses();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryOrange.withOpacity(0.1),
                      AppColors.primaryOrange.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Pet Connect!',
                      style: AppStyles.headline3.copyWith(
                        fontSize: 20,
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find your perfect pet companion from trusted businesses',
                      style: AppStyles.body.copyWith(
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Pets Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Pets',
                      style: AppStyles.headline3.copyWith(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all pets screen
                      },
                      child: Text(
                        'See All',
                        style: AppStyles.body.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Pets Horizontal List
            if (petState.pets.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: petState.pets.length > 3
                        ? 3
                        : petState.pets.length,
                    itemBuilder: (context, index) {
                      final pet = petState.pets[index];
                      return Container(
                        width: 200,
                        margin: EdgeInsets.only(
                          right:
                              index ==
                                  (petState.pets.length > 3
                                      ? 2
                                      : petState.pets.length - 1)
                              ? 0
                              : 12,
                        ),
                        child: _buildFeaturedPetCard(pet, context),
                      );
                    },
                  ),
                ),
              )
            else if (petState.isLoading)
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textLightGrey.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 40,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No pets available',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // All Businesses Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Business Partners',
                      style: AppStyles.headline3.copyWith(fontSize: 18),
                    ),
                    if (businessState.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // All Businesses Grid
            if (businessState.isLoading && businessState.businesses.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              )
            else if (businessState.businesses.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final business = businessState.businesses[index];
                    return BusinessCard(
                      business: business,
                      onTap: () {
                        print('Tapped business: ${business.businessName}');
                      },
                    );
                  }, childCount: businessState.businesses.length),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textLightGrey.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business,
                        size: 40,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No businesses found',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // All Pets Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Pets',
                      style: AppStyles.headline3.copyWith(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all pets screen
                      },
                      child: Text(
                        'See All',
                        style: AppStyles.body.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // All Pets Grid
            petState.isLoading && petState.pets.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : petState.pets.isNotEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pet = petState.pets[index];
                        return UserPetCard(
                          pet: pet,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserPetDetailScreen(petId: pet.id),
                              ),
                            );
                          },
                        );
                      }, childCount: petState.pets.length),
                    ),
                  )
                : const SliverToBoxAdapter(child: SizedBox()),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPetCard(UserPetEntity pet, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPetDetailScreen(petId: pet.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                color: AppColors.textLightGrey,
                child: pet.photos.isNotEmpty
                    ? Image.network(
                        pet.photos[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(Icons.pets, size: 60, color: Colors.white),
                      ),
              ),
            ),

            // Pet Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: AppStyles.headline3.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet.breed,
                    style: AppStyles.body.copyWith(
                      color: AppColors.textLightGrey,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.cake,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pet.age} ${pet.age == 1 ? 'month' : 'months'}',
                        style: AppStyles.small.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        pet.gender.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        size: 12,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.gender,
                        style: AppStyles.small.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Other screens (Placeholders)
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Favorites',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.textLightGrey,
            ),
            SizedBox(height: 16),
            Text('No favorites yet', style: AppStyles.headline3),
          ],
        ),
      ),
    );
  }
}

class CompatibilityScreen extends StatelessWidget {
  const CompatibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Compatibility',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: AppColors.textLightGrey,
            ),
            SizedBox(height: 16),
            Text('Coming Soon', style: AppStyles.headline3),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: AppColors.textLightGrey),
            SizedBox(height: 16),
            Text('Profile Screen', style: AppStyles.headline3),
          ],
        ),
      ),
    );
  }
}
