import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

//Data class to hold each books info

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List<Book> _bookmarkedBooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Appbar Tester.)'),
        backgroundColor: const Color(0xFFF2E9DD),
        foregroundColor: Colors.black,
        elevation: 0,
        //bookmark logic
      ),
      body: SingleChildScrollView(
        child: BookCatalogSection(
          onBookmarksUpdated: (updatedList) {
            setState(() => _bookmarkedBooks = updatedList);
          },
        ),
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

//All Books Inside the app
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
];

//Book Catalog----
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
    widget.onBookmarksUpdated?.call(_bookmarks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} have been added to your bookmarks!'),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

//Double Tap Logic
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onDoubleTapBookmark;

  const BookCard({
    super.key,
    required this.book,
    required this.onDoubleTapBookmark,
  });

  //Pa edit nalang ng section na to if may Checkout form Ty

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
              // Single tap lives HERE now, on the button itself.
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
