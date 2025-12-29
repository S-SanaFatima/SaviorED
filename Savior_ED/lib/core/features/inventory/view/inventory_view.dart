import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import '../../../widgets/gradient_background.dart';
import '../viewmodels/inventory_viewmodel.dart';
import '../models/inventory_item_model.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  String _selectedCategory = 'all';
  String _selectedRarity = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInventory();
    });
  }

  void _loadInventory() {
    final viewModel = Provider.of<InventoryViewModel>(context, listen: false);
    viewModel.getInventory().catchError((error) {
      print('❌ Failed to load inventory: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load inventory: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [Color(0xFFA5D6A7), Color(0xFFE3F2FD)],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'INVENTORY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<InventoryViewModel>(
          builder: (context, viewModel, child) {
            // Show loading only if actually loading and no error
            if (viewModel.isLoading && viewModel.errorMessage == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Loading inventory...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade300,
                        size: 48.sp,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Error Loading Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        viewModel.errorMessage ?? 'Unknown error',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          viewModel.getInventory();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Show empty state if no items
            if (viewModel.items.isEmpty && !viewModel.isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 64.sp,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Your Inventory is Empty',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Complete focus sessions to earn items!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          viewModel.getInventory();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Filter items
            List<InventoryItemModel> displayItems = viewModel.items;
            if (_selectedCategory != 'all') {
              displayItems = displayItems
                  .where((item) => item.category == _selectedCategory)
                  .toList();
            }
            if (_selectedRarity != 'all') {
              displayItems = displayItems
                  .where((item) => item.rarity == _selectedRarity)
                  .toList();
            }
            if (_searchController.text.isNotEmpty) {
              displayItems = viewModel.searchItems(_searchController.text);
            }

            return Column(
              children: [
                // Search bar
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),

                // Filters
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCategoryFilter(),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildRarityFilter(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Stats
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Total Items',
                          '${viewModel.inventory?.totalItems ?? 0}',
                          Icons.inventory_2,
                        ),
                        _buildStatItem(
                          'Unique Items',
                          '${viewModel.inventory?.uniqueItems ?? 0}',
                          Icons.category,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Items grid
                Expanded(
                  child: displayItems.isEmpty
                      ? Center(
                          child: Text(
                            'No items found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.all(4.w),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.w,
                            mainAxisSpacing: 2.h,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final item = displayItems[index];
                            return _buildItemCard(item, viewModel);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'all', child: Text('All Categories')),
          DropdownMenuItem(value: 'collectible', child: Text('Collectibles')),
          DropdownMenuItem(value: 'equipment', child: Text('Equipment')),
          DropdownMenuItem(value: 'consumable', child: Text('Consumables')),
          DropdownMenuItem(value: 'component', child: Text('Components')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedCategory = value ?? 'all';
          });
        },
      ),
    );
  }

  Widget _buildRarityFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: _selectedRarity,
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'all', child: Text('All Rarities')),
          DropdownMenuItem(value: 'common', child: Text('Common')),
          DropdownMenuItem(value: 'rare', child: Text('Rare')),
          DropdownMenuItem(value: 'epic', child: Text('Epic')),
          DropdownMenuItem(value: 'legendary', child: Text('Legendary')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedRarity = value ?? 'all';
          });
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B5E20), size: 24.sp),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(InventoryItemModel item, InventoryViewModel viewModel) {
    final color = Color(item.colorValue);
    
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to item detail
        _showItemDetail(item, viewModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                _getIconForName(item.iconName),
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B5E20),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.quantity > 1)
              Text(
                'x${item.quantity}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showItemDetail(InventoryItemModel item, InventoryViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: Color(item.colorValue).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(item.colorValue), width: 2),
                  ),
                  child: Icon(
                    _getIconForName(item.iconName),
                    color: Color(item.colorValue),
                    size: 30.sp,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text('Description: ${item.description}'),
              SizedBox(height: 1.h),
              Text('Category: ${item.category}'),
              Text('Rarity: ${item.rarity}'),
              Text('Quantity: ${item.quantity}'),
              if (item.obtainedAt != null)
                Text('Obtained: ${item.obtainedAt!.toString().split(' ')[0]}'),
            ],
          ),
        ),
        actions: [
          if (item.usable)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await viewModel.useItem(item.itemId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Item used!' : 'Failed to use item'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Use'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'focus':
        return Icons.access_time;
      case 'learner':
        return Icons.school;
      case 'castle':
        return Icons.castle;
      case 'fire':
      case 'streak':
        return Icons.local_fire_department;
      case 'shield':
        return Icons.shield;
      case 'star':
      case 'hero':
        return Icons.star;
      case 'trophy':
        return Icons.emoji_events;
      case 'medal':
        return Icons.military_tech;
      case 'ore':
        return Icons.diamond;
      default:
        return Icons.star;
    }
  }
}

