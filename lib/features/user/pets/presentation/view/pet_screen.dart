import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/user_pet_detail_content.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/user_pet_detail_error.dart';
import 'package:pet_connect/features/user/pets/presentation/view/widgets/user_pet_detail_loading.dart';
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';

class UserPetDetailScreen extends ConsumerStatefulWidget {
  final String petId;

  const UserPetDetailScreen({super.key, required this.petId});

  @override
  ConsumerState<UserPetDetailScreen> createState() =>
      _UserPetDetailScreenState();
}

class _UserPetDetailScreenState extends ConsumerState<UserPetDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petViewModelProvider.notifier).getPetById(widget.petId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(petViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.selectedPet != null && state.selectedPet!.id == widget.petId
          ? UserPetDetailContent(
              pet: state.selectedPet!,
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            )
          : state.isLoading
          ? const UserPetDetailLoading()
          : const UserPetDetailError(),
    );
  }
}
