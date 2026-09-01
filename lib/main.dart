import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

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
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2E9DD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C4033),
        ),
        textTheme: GoogleFonts.loraTextTheme(),
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
  List<Book> _bookmarkedBooks = [];

  void _addBookmark(Book book) {
    if (_bookmarkedBooks.contains(book)) return;

    setState(() {
      _bookmarkedBooks.add(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} has been added to your bookmarks!'),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF5C4033),
      ),
    );
  }

  void _removeBookmark(Book book) {
    setState(() {
      _bookmarkedBooks.remove(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} was removed from your bookmarks.'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF5C4033),
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
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          14,
                          16,
                          8,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Bookmarks',
                              style: TextStyle(
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
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.close,
                                    color: Color(0xFF4A2E1B),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        color: Color(0x334A2E1B),
                      ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Long press BOOKMARKS to view your saved books.',
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xFF5C4033),
                  ),
                );
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
                setState(() {
                  _bookmarkedBooks = updatedList;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   BOOKMARK TILE
   ============================================================ */

class BookmarkTile extends StatelessWidget {
  final Book book;
  final VoidCallback onRemove;

  const BookmarkTile({
    super.key,
    required this.book,
    required this.onRemove,
  });

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
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 52,
                  height: 72,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                );
              },
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
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < book.rating
                          ? Icons.star
                          : Icons.star_border,
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
            children: [
              Text(
                '₱${book.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF4A2E1B),
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

/* ============================================================
   BOOK MODEL
   ============================================================ */

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

/* ============================================================
   PROMO MODEL
   ============================================================ */

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
    subtitle:
        'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame2.png',
  ),
  const PromoBanner(
    title: 'RAINY DAY\nREADS',
    subtitle:
        'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame1.png',
  ),
  const PromoBanner(
    title: 'CLASSIC\nCOLLECTION',
    subtitle:
        'Discover your next\nadventure in a relaxed\natmosphere',
    imageUrl: 'assets/images/cozy-frame3.png',
  ),
];

/* ============================================================
   COLLECTION MODEL
   ============================================================ */

class BookCollection {
  final String title;
  final List<String> imageUrls;

  const BookCollection({
    required this.title,
    required this.imageUrls,
  });
}

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

/* ============================================================
   BOOK DATA
   ============================================================ */

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

/* ============================================================
   BOOK CATALOG
   ============================================================ */

class BookCatalogSection extends StatefulWidget {
  final ValueChanged<List<Book>>? onBookmarksUpdated;

  const BookCatalogSection({
    super.key,
    this.onBookmarksUpdated,
  });

  @override
  State<BookCatalogSection> createState() =>
      _BookCatalogSectionState();
}

class _BookCatalogSectionState
    extends State<BookCatalogSection> {
  final List<Book> _bookmarks = [];

  void _handleBookmark(Book book) {
    if (_bookmarks.contains(book)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${book.title} is already bookmarked.'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF5C4033),
        ),
      );
      return;
    }

    setState(() {
      _bookmarks.add(book);
    });

    widget.onBookmarksUpdated?.call(
      List<Book>.from(_bookmarks),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${book.title} has been added to your bookmarks!',
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF5C4033),
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
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xFF4A2E1B),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
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
                onDoubleTapBookmark: () =>
                    _handleBookmark(book),
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.black26,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Single Tap - CHECKOUT button | Double Tap - Catalog Book | Long Press - Bookmark Icon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/* ============================================================
   BOOK CARD
   ============================================================ */

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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) {
        return CheckoutForm(book: book);
      },
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
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF4A2E1B),
              ),
            ),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₱${book.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2E1B),
              ),
            ),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < book.rating
                      ? Icons.star
                      : Icons.star_border,
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
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   CHECKOUT FORM
   ============================================================ */

class CheckoutForm extends StatefulWidget {
  final Book book;

  const CheckoutForm({
    super.key,
    required this.book,
  });

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _addressController =
      TextEditingController();

  final TextEditingController _quantityController =
      TextEditingController(text: '1');

  final TextEditingController _contactController =
      TextEditingController();

  int _quantity = 1;

  double get _totalPrice =>
      widget.book.price * _quantity;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /* ============================================================
     VALIDATION
     ============================================================ */

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }

    final nameParts = value.trim().split(RegExp(r'\s+'));

    if (nameParts.length < 2) {
      return 'Please enter your first and last name.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Shipping address is required.';
    }

    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters.';
    }

    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required.';
    }

    final quantity = int.tryParse(value.trim());

    if (quantity == null) {
      return 'Quantity must be a whole number.';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than 0.';
    }

    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required.';
    }

    final contact = value.trim();

    if (!RegExp(r'^\d{11}$').hasMatch(contact)) {
      return 'Contact number must be exactly 11 digits.';
    }

    return null;
  }

  void _updateQuantity(String value) {
    final quantity = int.tryParse(value);

    if (quantity != null && quantity > 0) {
      setState(() {
        _quantity = quantity;
      });
    }
  }

  /* ============================================================
     SUBMIT ORDER
     ============================================================ */

  void _submitOrder() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final contact = _contactController.text.trim();

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF2E9DD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xFF5C4033),
                size: 28,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    color: Color(0xFF4A2E1B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thank you for your order!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF4A2E1B),
                  ),
                ),
                const SizedBox(height: 14),
                _orderDetail('Customer', fullName),
                _orderDetail('Email', email),
                _orderDetail('Contact', contact),
                _orderDetail('Book', widget.book.title),
                _orderDetail('Quantity', '$_quantity'),
                _orderDetail(
                  'Shipping Address',
                  address,
                ),
                const Divider(
                  color: Color(0x554A2E1B),
                ),
                _orderDetail(
                  'Total',
                  '₱${_totalPrice.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'DONE',
                style: TextStyle(
                  color: Color(0xFF4A2E1B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _orderDetail(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isTotal
                    ? const Color(0xFF4A2E1B)
                    : Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 16 : 12,
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF4A2E1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ============================================================
     SCREENSHOT-STYLE INPUT
     ============================================================ */

  InputDecoration _inputDecoration({
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8D7B6D),
        fontSize: 12,
      ),
      filled: true,
      fillColor: const Color(0xFFF4E9DC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
        borderSide: const BorderSide(
          color: Color(0xFF6B5142),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
        borderSide: const BorderSide(
          color: Color(0xFF6B5142),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
        borderSide: const BorderSide(
          color: Color(0xFF4A2E1B),
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
        borderSide: const BorderSide(
          color: Color(0xFF9E4C3D),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
        borderSide: const BorderSide(
          color: Color(0xFF9E4C3D),
          width: 1.3,
        ),
      ),
      errorStyle: const TextStyle(
        fontSize: 9,
        height: 1.0,
      ),
    );
  }

  /* ============================================================
     CHECKOUT UI
     ============================================================ */

  @override
  Widget build(BuildContext context) {
    final keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 360,
            maxHeight:
                MediaQuery.of(context).size.height * 0.94,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE1D0BD),
            borderRadius: BorderRadius.circular(9),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: 35,
              right: 35,
              top: 13,
              bottom: keyboardHeight > 0
                  ? keyboardHeight + 15
                  : 28,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /* =================================================
                     CLOSE BUTTON
                     ================================================= */

                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF4A3428),
                            width: 1.7,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFF4A3428),
                        ),
                      ),
                    ),
                  ),

                  /* =================================================
                     LOGO
                     ================================================= */

                  const SizedBox(height: 2),

                  Image.asset(
                    'assets/images/checkout-logo.png',
                    width: 112,
                    height: 112,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return Column(
                        children: const [
                          Icon(
                            Icons.local_cafe,
                            size: 55,
                            color: Color(0xFF4A2E1B),
                          ),
                          Text(
                            'Granville\nBookstore',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 0.95,
                              color: Color(0xFF4A2E1B),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 3),

                  /* =================================================
                     TITLE
                     ================================================= */

                  const Text(
                    'Checkout Form',
                    style: TextStyle(
                      color: Color(0xFF9A806D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /* =================================================
                     FULL NAME
                     ================================================= */

                  SizedBox(
                    height: 47,
                    child: TextFormField(
                      controller: _fullNameController,
                      textCapitalization:
                          TextCapitalization.words,
                      decoration: _inputDecoration(
                        hint: 'Full Name',
                      ),
                      validator: _validateFullName,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /* =================================================
                     EMAIL
                     ================================================= */

                  SizedBox(
                    height: 47,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        hint: 'Email Address',
                      ),
                      validator: _validateEmail,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /* =================================================
                     SHIPPING ADDRESS
                     ================================================= */

                  SizedBox(
                    height: 47,
                    child: TextFormField(
                      controller: _addressController,
                      textCapitalization:
                          TextCapitalization.sentences,
                      decoration: _inputDecoration(
                        hint: 'Shipping Address',
                      ),
                      validator: _validateAddress,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /* =================================================
                     QUANTITY
                     ================================================= */

                  SizedBox(
                    height: 47,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType:
                          TextInputType.number,
                      decoration: _inputDecoration(
                        hint: 'Quantity',
                      ),
                      onChanged: _updateQuantity,
                      validator: _validateQuantity,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /* =================================================
                     CONTACT NUMBER
                     ================================================= */

                  SizedBox(
                    height: 47,
                    child: TextFormField(
                      controller: _contactController,
                      keyboardType:
                          TextInputType.phone,
                      maxLength: 11,
                      decoration: _inputDecoration(
                        hint: 'Contact Number',
                      ).copyWith(
                        counterText: '',
                      ),
                      validator: _validateContactNumber,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /* =================================================
                     PROCEED CHECKOUT BUTTON
                     ================================================= */

                  SizedBox(
                    width: double.infinity,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF624838),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor:
                            Colors.black.withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(17),
                        ),
                      ),
                      child: const Text(
                        'PROCEED CHECKOUT',
                        style: TextStyle(
                          color: Color(0xFFEFE3D7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  /* =================================================
                     SMALL BOOK INFO
                     ================================================= */

                  Text(
                    '${widget.book.title} • ₱${widget.book.price.toStringAsFixed(2)} × $_quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF806D5E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   PROMO BANNER
   ============================================================ */

class SwipeablePromoBanner extends StatefulWidget {
  const SwipeablePromoBanner({super.key});

  @override
  State<SwipeablePromoBanner> createState() =>
      _SwipeablePromoBannerState();
}

class _SwipeablePromoBannerState
    extends State<SwipeablePromoBanner> {
  final PageController _pageController =
      PageController(
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
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = promoBanners[index];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;

                  if (_pageController
                      .position
                      .haveDimensions) {
                    value =
                        (_pageController.page! - index)
                            .abs();

                    value = (1 - (value * 0.15))
                        .clamp(0.85, 1.0);
                  }

                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: _buildBannerCard(banner),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            promoBanners.length,
            (index) => AnimatedContainer(
              duration:
                  const Duration(milliseconds: 250),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4),
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
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF5C4033),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF5C4033),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  14,
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
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
                        color:
                            Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {},
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFC4A484),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30),
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

/* ============================================================
   FEATURED COLLECTIONS
   ============================================================ */

class FeaturedCollections extends StatefulWidget {
  const FeaturedCollections({super.key});

  @override
  State<FeaturedCollections> createState() =>
      _FeaturedCollectionsState();
}

class _FeaturedCollectionsState
    extends State<FeaturedCollections> {
  static const int _loopMultiplier = 1000;

  double _viewportFraction = 0.42;

  late PageController _controller =
      PageController(
    viewportFraction: _viewportFraction,
    initialPage:
        _loopMultiplier ~/ 2 -
            (_loopMultiplier ~/ 2) %
                featuredCollections.length,
  );

  int _currentPage = 500;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    late final double viewportFraction;
    late final double cardHeight;
    late final double fontSize;

    if (screenWidth < 400) {
      viewportFraction = 0.55;
      cardHeight = 160;
      fontSize = 13;
    } else if (screenWidth < 600) {
      viewportFraction = 0.42;
      cardHeight = 190;
      fontSize = 15;
    } else if (screenWidth < 900) {
      viewportFraction = 0.30;
      cardHeight = 220;
      fontSize = 17;
    } else {
      viewportFraction = 0.20;
      cardHeight = 260;
      fontSize = 19;
    }

    if (_viewportFraction != viewportFraction) {
      final oldPage = _controller.hasClients
          ? (_controller.page ??
              _currentPage.toDouble())
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
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'FEATURED COLLECTIONS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
              color: Color(0xFF4A2E1B),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _controller,
            padEnds: true,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _loopMultiplier,
            itemBuilder: (context, index) {
              final collection =
                  featuredCollections[
                      index %
                          featuredCollections.length];

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double scale = 0.65;

                  if (_controller
                      .position
                      .haveDimensions) {
                    final page =
                        _controller.page ??
                            _currentPage.toDouble();

                    final delta =
                        (page - index).abs();

                    scale = (1 -
                            (delta * 0.35))
                        .clamp(0.65, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
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
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            featuredCollections.length,
            (index) =>
                AnimatedContainer(
              duration:
                  const Duration(milliseconds: 200),
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              width:
                  _currentPage %
                              featuredCollections.length ==
                          index
                      ? 16
                      : 6,
              height: 6,
              decoration: BoxDecoration(
                color:
                    _currentPage %
                                featuredCollections.length ==
                            index
                        ? const Color(0xFF4A2E1B)
                        : const Color(0xFFD9CFC4),
                borderRadius:
                    BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================================================
   COLLECTION CARD
   ============================================================ */

class _CollectionCard extends StatelessWidget {
  final BookCollection collection;
  final double fontSize;

  const _CollectionCard({
    required this.collection,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: const Color(0xFF5C4033),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: _BookImageStack(
                  imageUrls:
                      collection.imageUrls,
                ),
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
                    stops: const [
                      0.4,
                      1.0,
                    ],
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

/* ============================================================
   BOOK IMAGE STACK
   ============================================================ */

class _BookImageStack extends StatelessWidget {
  final List<String> imageUrls;

  const _BookImageStack({
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    final images = List<String?>.generate(
      3,
      (i) => i < imageUrls.length
          ? imageUrls[i]
          : null,
    );

    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _fannedCover(
            images[0],
            angle: -0.0,
            dx: -50,
            widthFactor: 0.4,
          ),
          _fannedCover(
            images[2],
            angle: 0.0,
            dx: 50,
            widthFactor: 0.4,
          ),
          _fannedCover(
            images[1],
            angle: 0.0,
            dx: 0,
            widthFactor: 0.46,
          ),
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
              decoration:
                  const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(6),
                child: imageUrl == null
                    ? Container(
                        color:
                            const Color(0xFF8C5A3B),
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) {
                          return Container(
                            color:
                                const Color(0xFF8C5A3B),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}