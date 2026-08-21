import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/core/constants/image_path.dart';
import 'package:miiincare/features/auth/account/controller/auth_controller.dart';
import 'package:miiincare/features/cart/controller/cart_controller.dart';
import 'package:miiincare/features/cart/model/cart_model.dart';
import 'package:miiincare/features/catalog/controller/catalog_controller.dart';
import 'package:miiincare/features/home/controller/home_controller.dart';
import 'package:miiincare/features/home/widgets/app_bottom_navigation_bar.dart';
import 'package:miiincare/features/home/widgets/product_card.dart';
import 'package:miiincare/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController(), permanent: true);
  final CatalogController catalog = Get.isRegistered<CatalogController>()
      ? Get.find<CatalogController>()
      : Get.put(CatalogController(), permanent: true);
  final CartController cart = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);
  final AuthController auth = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) => Obx(
    () => Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: [
          _HomeTab(
            catalog: catalog,
            controller: controller,
            cart: cart,
            onShop: () => controller.changeTab(1),
            onSearch: () {
              controller.changeTab(1);
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => catalog.searchFocusNode.requestFocus(),
              );
            },
            onBag: () => controller.changeTab(3),
          ),
          _ShopTab(catalog: catalog),
          _CategoriesTab(
            catalog: catalog,
            openShop: () => controller.changeTab(1),
          ),
          _CartTab(controller: cart),
          _AccountTab(
            controller: auth,
            openShop: () => controller.changeTab(1),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: controller.currentIndex.value,
        onDestinationSelected: controller.changeTab,
      ),
    ),
  );
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.catalog,
    required this.controller,
    required this.cart,
    required this.onShop,
    required this.onSearch,
    required this.onBag,
  });
  final CatalogController catalog;
  final HomeController controller;
  final CartController cart;
  final VoidCallback onShop;
  final VoidCallback onSearch;
  final VoidCallback onBag;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: RefreshIndicator(
      onRefresh: catalog.load,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 58,
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ClipRect(
                        child: Transform.scale(
                          scale: 2,
                          alignment: Alignment.center,
                          child: Image.asset(
                            ImagePath.wordmark,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onSearch,
                      icon: const Icon(Icons.search, size: 23),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 38,
                        height: 38,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox.square(
                      dimension: 38,
                      child: Center(
                        child: Obx(
                          () => IconButton(
                            onPressed: onBag,
                            padding: EdgeInsets.zero,
                            icon: Badge(
                              isLabelVisible: cart.cart.value.itemCount > 0,
                              label: Text('${cart.cart.value.itemCount}'),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _HeroCarousel(controller: controller, onShop: onShop),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Best sellers',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.bestSellers),
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (catalog.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (catalog.error.isNotEmpty) {
              return SliverToBoxAdapter(
                child: _ErrorMessage(
                  message: catalog.error.value,
                  retry: catalog.load,
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                AppBottomNavigationBar.contentClearance,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: .62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(product: catalog.products[i]),
                  childCount: catalog.products.length > 6
                      ? 6
                      : catalog.products.length,
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({required this.controller, required this.onShop});

  final HomeController controller;
  final VoidCallback onShop;

  static const _slides = [
    (
      ImagePath.hero,
      'AUTHENTIC BEAUTY',
      'Skincare you can trust, shopping you’ll enjoy.',
    ),
    (
      ImagePath.heroTwo,
      'SAFE & GENTLE',
      'Tested for safety and suitable for all skin.',
    ),
    (
      ImagePath.heroThree,
      'VISIBLE RESULTS',
      'High performance formulas for visible results.',
    ),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 210,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: PageView.builder(
            controller: controller.heroPageController,
            onPageChanged: controller.changeHero,
            itemCount: _slides.length,
            itemBuilder: (_, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(slide.$1, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColor.softLavender.withValues(alpha: .96),
                          AppColor.softLavender.withValues(alpha: .72),
                          Colors.transparent,
                        ],
                        stops: const [0, .52, 1],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: SizedBox(
                      width: 235,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slide.$2,
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 235,
                            child: Text(
                              slide.$3,
                              style: const TextStyle(
                                fontSize: 25,
                                height: 1.12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: onShop,
                            child: const Text('Shop now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          right: 14,
          bottom: 12,
          child: Obx(
            () => Row(
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: controller.heroIndex.value == index ? 20 : 7,
                  height: 7,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: controller.heroIndex.value == index
                        ? AppColor.primary
                        : Colors.white.withValues(alpha: .8),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ShopTab extends StatelessWidget {
  const _ShopTab({required this.catalog});
  final CatalogController catalog;
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Shop',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: TextField(
            controller: catalog.searchController,
            focusNode: catalog.searchFocusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: catalog.search,
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: catalog.clearSearch,
                icon: const Icon(Icons.close),
              ),
              filled: true,
              fillColor: AppColor.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColor.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColor.border),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: Obx(
            () => ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: catalog.selectedCategorySlug.isEmpty,
                  onSelected: (_) => catalog.filterBy(null),
                ),
                ...catalog.categories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(c.name),
                      selected: catalog.selectedCategorySlug.value == c.slug,
                      onSelected: (_) => catalog.filterBy(c),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(
            () => catalog.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      AppBottomNavigationBar.contentClearance,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: .62,
                        ),
                    itemCount: catalog.visibleProducts.length,
                    itemBuilder: (_, i) =>
                        ProductCard(product: catalog.visibleProducts[i]),
                  ),
          ),
        ),
      ],
    ),
  );
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.catalog, required this.openShop});
  final CatalogController catalog;
  final VoidCallback openShop;
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Find the right care for every routine.',
            style: TextStyle(color: AppColor.muted),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: const EdgeInsets.only(
                  bottom: AppBottomNavigationBar.contentClearance,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.84,
                ),
                itemCount: catalog.categories.length,
                itemBuilder: (_, i) {
                  final category = catalog.categories[i];
                  return InkWell(
                    onTap: () {
                      catalog.filterBy(category);
                      openShop();
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: DecorationImage(
                          image: AssetImage(
                            ImagePath.categoryImage(
                              category.slug,
                              category.name,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColor.ink.withValues(alpha: 0.08),
                              AppColor.ink.withValues(alpha: 0.78),
                            ],
                            stops: const [0.36, 0.58, 1],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              category.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${category.productCount} ${category.productCount == 1 ? 'product' : 'products'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CartTab extends StatelessWidget {
  const _CartTab({required this.controller});
  final CartController controller;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Obx(() {
      final cart = controller.cart.value;
      if (controller.isLoading.value && cart.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (cart.items.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.only(
              bottom: AppBottomNavigationBar.contentClearance,
            ),
            children: const [
              SizedBox(height: 180),
              Icon(
                Icons.shopping_bag_outlined,
                size: 54,
                color: AppColor.lavender,
              ),
              SizedBox(height: 16),
              Text(
                'Your bag is empty',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Text(
                'Products you add will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.muted),
              ),
            ],
          ),
        );
      }
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your bag',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: cart.items.length,
                separatorBuilder: (_, _) =>
                    const Divider(color: AppColor.border),
                itemBuilder: (_, index) =>
                    _CartItem(item: cart.items[index], controller: controller),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              AppBottomNavigationBar.contentClearance,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColor.border)),
            ),
            child: Column(
              children: [
                _TotalRow(label: 'Subtotal', value: cart.subtotal),
                if (cart.discount > 0)
                  _TotalRow(label: 'Discount', value: -cart.discount),
                _TotalRow(label: 'Shipping', value: cart.shipping),
                const SizedBox(height: 8),
                _TotalRow(label: 'Total', value: cart.total, bold: true),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => Get.toNamed(AppRoutes.checkout),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('Proceed to checkout'),
                ),
              ],
            ),
          ),
        ],
      );
    }),
  );
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.item, required this.controller});
  final CartItemModel item;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final updating = controller.updatingIds.contains(item.id);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 82,
              height: 82,
              color: AppColor.softLavender,
              child: item.image.isEmpty
                  ? const Icon(Icons.spa_outlined)
                  : Image.network(item.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'BDT ${item.lineTotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: updating || item.quantity <= 1
                          ? null
                          : () => controller.changeQuantity(
                              item,
                              item.quantity - 1,
                            ),
                      icon: const Icon(Icons.remove, size: 18),
                      constraints: const BoxConstraints.tightFor(
                        width: 34,
                        height: 34,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: updating || item.quantity >= item.stock
                          ? null
                          : () => controller.changeQuantity(
                              item,
                              item.quantity + 1,
                            ),
                      icon: const Icon(Icons.add, size: 18),
                      constraints: const BoxConstraints.tightFor(
                        width: 34,
                        height: 34,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: updating
                          ? null
                          : () => controller.remove(item),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final double value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          '${value < 0 ? '-' : ''}BDT ${value.abs().toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _AccountTab extends StatelessWidget {
  const _AccountTab({required this.controller, required this.openShop});
  final AuthController controller;
  final VoidCallback openShop;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final user = controller.user.value;
      if (user == null) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            AppBottomNavigationBar.contentClearance,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePath.splashIcon, width: 72, height: 72),
              const SizedBox(height: 18),
              const Text(
                'Welcome to Miiincare',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to see your orders and saved addresses.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.muted),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('SIGN IN'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text('Create an account'),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            AppBottomNavigationBar.contentClearance,
          ),
          children: [
            Text(
              'Hi, ${user.name.toUpperCase()}',
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(user.email, style: const TextStyle(color: AppColor.muted)),
            const SizedBox(height: 32),
            const Divider(color: AppColor.border),
            const SizedBox(height: 22),
            const Text(
              'ORDER HISTORY',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            if (controller.orders.isEmpty) ...[
              const SizedBox(height: 44),
              const Icon(
                Icons.shopping_bag_outlined,
                size: 44,
                color: AppColor.lavender,
              ),
              const SizedBox(height: 14),
              const Text(
                'No orders yet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'When you place an order it will show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.muted),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: openShop,
                child: const Text('START SHOPPING'),
              ),
              const SizedBox(height: 52),
            ] else
              ...controller.orders.map(
                (order) => Card(
                  child: ListTile(
                    onTap: () =>
                        Get.toNamed(AppRoutes.orderDetailsFor(order.id)),
                    title: Text(
                      order.id,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${order.itemCount} items · ${order.status}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'BDT ${order.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'View',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            OutlinedButton(
              onPressed: controller.logout,
              child: const Text('SIGN OUT'),
            ),
          ],
        ),
      );
    }),
  );
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.retry});
  final String message;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: retry, child: const Text('Try again')),
      ],
    ),
  );
}
