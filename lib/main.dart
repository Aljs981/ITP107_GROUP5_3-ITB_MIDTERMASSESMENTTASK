import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(), // 👈 add this line
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2E9DD),
        fontFamily: 'Georgia',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mutable so the catalog section can sync new bookmarks into it.
  List<Book> _bookmarkedBooks = [];

  void _addBookmark(Book book) {
    if (_bookmarkedBooks.contains(book)) return;
    setState(() => _bookmarkedBooks.add(book));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} has been added to your bookmarks!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _removeBookmark(Book book) {
    setState(() => _bookmarkedBooks.remove(book));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} was removed from your bookmarks.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openBookmarksModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.35,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2E9DD),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Bookmarks',
                              style: TextStyle(
                                fontFamily: 'AncizarSerif',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF4A2E1B),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                'assets/images/cancel.png',
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0x334A2E1B)),
                      Expanded(
                        child: _bookmarkedBooks.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'No bookmarks yet.\nDouble-tap a book in the catalog to save it here.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.brown.shade300,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  20,
                                ),
                                itemCount: _bookmarkedBooks.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final book = _bookmarkedBooks[index];
                                  return BookmarkTile(
                                    book: book,
                                    onRemove: () {
                                      _removeBookmark(book);
                                      // Refresh the modal's own view immediately,
                                      // in addition to the parent's setState above.
                                      setModalState(() {});
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C4033),
        elevation: 0,
        titleSpacing: 16,
        title: Image.asset(
          'assets/images/home-logo.png',
          height: 34,
          fit: BoxFit.contain,
        ),
        actions: [
          GestureDetector(
            onLongPress: _openBookmarksModal,
            child: TextButton.icon(
              onPressed: () {
                // Tap shows a hint; long-press opens the saved list.
              },
              icon: Image.asset(
                'assets/images/bookmark.png',
                width: 20,
                height: 20,
              ),
              label: const Text(
                'BOOKMARKS',
                style: TextStyle(
                  color: Color(0xFFF2E9DD),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const SwipeablePromoBanner(),
            const SizedBox(height: 24),
            const FeaturedCollections(),
            const SizedBox(height: 24),
            BookCatalogSection(
              onBookmarksUpdated: (updatedList) {
                setState(() => _bookmarkedBooks = updatedList);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkTile extends StatelessWidget {
  final Book book;
  final VoidCallback onRemove;

  const BookmarkTile({super.key, required this.book, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              book.imageUrl,
              width: 52,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 52,
                height: 72,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF4A2E1B),
                  ),
                ),
                Text(
                  book.author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < book.rating ? Icons.star : Icons.star_border,
                      size: 13,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                ), // 👈 adjust this value to align with title
                child: Text(
                  '₱${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF4A2E1B),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final double price;
  final double rating;
  final String imageUrl;

  const Book({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}

class PromoBanner {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.buttonText = 'Shop now',
  });
}

final List<PromoBanner> promoBanners = [
  const PromoBanner(
    title: 'COZY READS\n& BREWS',
    subtitle: 'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame2.png',
    buttonText: 'Shop now',
  ),
  const PromoBanner(
    title: 'RAINY DAY\nREADS',
    subtitle: 'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame1.png',
    buttonText: 'Shop now',
  ),
  const PromoBanner(
    title: 'CLASSIC\nCOLLECTION',
    subtitle: 'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame3.png',
    buttonText: 'Shop now',
  ),
];

/// A featured collection card. Each collection holds up to three
/// book cover images that get fanned out inside the card.
class BookCollection {
  final String title;
  final List<String> imageUrls; // exactly 3 placeholder book covers

  const BookCollection({required this.title, required this.imageUrls});
}

// 👇 Placeholder asset paths — rename these to your real image files.
final List<BookCollection> featuredCollections = [
  const BookCollection(
    title: 'Coffee Shop Classics',
    imageUrls: [
      'assets/images/war-and-peace.png',
      'assets/images/1984.png',
      'assets/images/jane-eyre.png',
    ],
  ),
  const BookCollection(
    title: 'Rainy Day Reads',
    imageUrls: [
      'assets/images/anne-of-gables.png',
      'assets/images/cerulean-sea.png',
      'assets/images/little-paris.png',
    ],
  ),
  const BookCollection(
    title: 'Mystery Lit',
    imageUrls: [
      'assets/images/the-vegetarian.png',
      'assets/images/underground.png',
      'assets/images/magical-think.png',
    ],
  ),
];

final List<Book> books = [
  Book(
    title: '1984',
    author: 'George Orwell',
    price: 850.00,
    rating: 4,
    imageUrl: 'assets/images/1984.png',
  ),
  Book(
    title: 'War And Peace',
    author: 'Leo Tolstoy',
    price: 850.00,
    rating: 4,
    imageUrl: 'assets/images/war-and-peace.png',
  ),
  Book(
    title: 'Jane Eyre',
    author: 'Charlotte Brontë',
    price: 850.00,
    rating: 4,
    imageUrl: 'assets/images/jane-eyre.png',
  ),
  Book(
    title: 'The House In The Cerulean Sea',
    author: 'TJ Klune',
    price: 450.00,
    rating: 4,
    imageUrl: 'assets/images/cerulean-sea.png',
  ),
  Book(
    title: 'Anne Of Green Gables',
    author: 'L. M. Montgomery',
    price: 450.00,
    rating: 4,
    imageUrl: 'assets/images/anne-of-gables.png',
  ),
  Book(
    title: 'The Little Paris Bookshop',
    author: 'Nina George',
    price: 450.00,
    rating: 3,
    imageUrl: 'assets/images/little-paris.png',
  ),
  Book(
    title: 'The Underground Railroad',
    author: 'Colson Whitehead',
    price: 650.00,
    rating: 4,
    imageUrl: 'assets/images/underground.png',
  ),
  Book(
    title: 'The Vegetarian',
    author: 'Han Kang',
    price: 650.00,
    rating: 4,
    imageUrl: 'assets/images/the-vegetarian.png',
  ),
  Book(
    title: 'The Year Of Magical Thinking',
    author: 'Joan Didion',
    price: 650.00,
    rating: 4,
    imageUrl: 'assets/images/magical-think.png',
  ),
];

class BookCatalogSection extends StatefulWidget {
  final ValueChanged<List<Book>>? onBookmarksUpdated;

  const BookCatalogSection({super.key, this.onBookmarksUpdated});

  @override
  State<BookCatalogSection> createState() => _BookCatalogSectionState();
}

class _BookCatalogSectionState extends State<BookCatalogSection> {
  final List<Book> _bookmarks = [];

  void _handleBookmark(Book book) {
    setState(() {
      if (!_bookmarks.contains(book)) {
        _bookmarks.add(book);
      }
    });
    // Notify HomePage with a fresh copy of the current bookmark list.
    widget.onBookmarksUpdated?.call(List<Book>.from(_bookmarks));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} has been added to your bookmarks!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'BOOK CATALOG',
            style: TextStyle(
              fontFamily: 'AncizarSerif',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onDoubleTapBookmark: () => _handleBookmark(book),
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.black26, thickness: 1),
          const SizedBox(height: 8),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Single Tap - CHECKOUT  button | Double Tap - Catalog Book | Long Press - Bookmark Icon',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onDoubleTapBookmark;

  const BookCard({
    super.key,
    required this.book,
    required this.onDoubleTapBookmark,
  });

  void _openCheckoutForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const SizedBox(
        height: 200,
        child: Center(child: Text('Checkout form goes here')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTapBookmark,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  book.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              book.author,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '₱${book.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < book.rating ? Icons.star : Icons.star_border,
                  size: 14,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openCheckoutForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2E1B),
                ),
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeablePromoBanner extends StatefulWidget {
  const SwipeablePromoBanner({super.key});

  @override
  State<SwipeablePromoBanner> createState() => _SwipeablePromoBannerState();
}

class _SwipeablePromoBannerState extends State<SwipeablePromoBanner> {
  final PageController _pageController = PageController(
    viewportFraction: 0.92,
    initialPage: 1,
  );

  int _currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: promoBanners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final banner = promoBanners[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                    value = (1 - (value * 0.15)).clamp(0.85, 1.0);
                  }
                  return Transform.scale(scale: value, child: child);
                },
                child: _buildBannerCard(banner),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promoBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF4A2E1B)
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(PromoBanner banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(
                banner.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF5C4033),
                  child: const Icon(
                    Icons.image,
                    color: Colors.white54,
                    size: 50,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF5C4033),
                padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      banner.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4A484),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        banner.buttonText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedCollections extends StatefulWidget {
  const FeaturedCollections({super.key});

  @override
  State<FeaturedCollections> createState() => _FeaturedCollectionsState();
}

class _FeaturedCollectionsState extends State<FeaturedCollections> {
  static const int _loopMultiplier = 1000;

  late double _viewportFraction = 0.42;
  late PageController _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage:
        _loopMultiplier ~/ 2 - (_loopMultiplier ~/ 2) % _collectionsLength,
  );

  int get _collectionsLength => featuredCollections.length;
  late int _currentPage = _controller.initialPage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- Responsive breakpoints (this is your "media query") ---
    final screenWidth = MediaQuery.of(context).size.width;

    late final double viewportFraction;
    late final double cardHeight;
    late final double fontSize;

    if (screenWidth < 400) {
      // Small phones
      viewportFraction = 0.55;
      cardHeight = 160;
      fontSize = 13;
    } else if (screenWidth < 600) {
      // Regular phones
      viewportFraction = 0.42;
      cardHeight = 190;
      fontSize = 15;
    } else if (screenWidth < 900) {
      // Tablets / small windows
      viewportFraction = 0.30;
      cardHeight = 220;
      fontSize = 17;
    } else {
      // Desktop / web wide screens
      viewportFraction = 0.20;
      cardHeight = 260;
      fontSize = 19;
    }
    if (_viewportFraction != viewportFraction) {
      final oldPage = _controller.hasClients
          ? (_controller.page ?? _currentPage.toDouble())
          : _currentPage.toDouble();
      _viewportFraction = viewportFraction;
      _controller.dispose();
      _controller = PageController(
        viewportFraction: viewportFraction,
        initialPage: oldPage.round(),
      );
      _currentPage = oldPage.round();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'FEATURED COLLECTIONS',
            style: TextStyle(
              fontFamily: 'AncizarSerif',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
              color: Color(0xFF4A2E1B), // dark espresso brown
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _controller,
            padEnds: true,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _loopMultiplier,
            itemBuilder: (context, index) {
              final collection =
                  featuredCollections[index % _collectionsLength];
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double scale = 0.65;
                  if (_controller.position.haveDimensions) {
                    final page = _controller.page ?? _currentPage.toDouble();
                    final delta = (page - index).abs();
                    scale = (1.0 - (delta * 0.35)).clamp(0.65, 1.0);
                  }
                  return Center(
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: _CollectionCard(
                  collection: collection,
                  fontSize: fontSize,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _collectionsLength,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage % _collectionsLength == index ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage % _collectionsLength == index
                    ? const Color(0xFF4A2E1B) // active dot — espresso brown
                    : const Color(0xFFD9CFC4), // inactive dot — soft tan
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final BookCollection collection;
  final double fontSize;

  const _CollectionCard({required this.collection, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: const Color(0xFF5C4033), // fallback coffee brown backdrop
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 👇 This is the "container inside the container" that
              // holds the three fanned book cover images for this
              // collection. Swap the placeholder paths in
              // `featuredCollections` above to use your real assets.
              Align(
                alignment: Alignment.topCenter,
                child: _BookImageStack(imageUrls: collection.imageUrls),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  collection.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fans three book cover images inside a card, like a mini display
/// of the books included in that collection.
class _BookImageStack extends StatelessWidget {
  final List<String> imageUrls;

  const _BookImageStack({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    // Always reserve 3 slots, even if fewer images were provided.
    final images = List<String?>.generate(
      3,
      (i) => i < imageUrls.length ? imageUrls[i] : null,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _fannedCover(images[0], angle: -0.0, dx: -50, widthFactor: 0.4),
          _fannedCover(images[2], angle: 0.0, dx: 50, widthFactor: 0.4),
          _fannedCover(images[1], angle: 0.0, dx: 0, widthFactor: 0.46),
        ],
      ),
    );
  }

  Widget _fannedCover(
    String? imageUrl, {
    required double angle,
    required double dx,
    required double widthFactor,
  }) {
    return Transform.translate(
      offset: Offset(dx, 0),
      child: Transform.rotate(
        angle: angle,
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: imageUrl == null
                    ? Container(color: const Color(0xFF8C5A3B))
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: const Color(0xFF8C5A3B)),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}