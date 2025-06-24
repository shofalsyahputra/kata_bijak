## 🚀 Implementasi Fungsi Navigasi

Aplikasi ini menggunakan **navigasi bottom bar** untuk berpindah antar halaman utama. Navigasi dilakukan menggunakan kombinasi `BottomNavigationBar`, `Navigator.pushNamed`, dan deklarasi `routes` di `main.dart`.

###

jika aplikasi muncul terjadi kesalahan, coba berulang kali dengan reload. karna penyebab utamanya adalah menggunakan API public yang server kadang kadang down.

### ✅ Struktur Navigasi:

| Tab         | Fungsi                              | Navigasi ke                    |
| ----------- | ----------------------------------- | ------------------------------ |
| 🏠 Beranda  | Menampilkan kutipan acak            | `QuoteView` (dalam `HomePage`) |
| 📚 Kategori | Menampilkan banyak kutipan dari API | `CategoryPage`                 |
| ❤️ Favorit  | Menampilkan kutipan yang disimpan   | `FavoritesPage`                |

---

### 📁 Contoh Implementasi Navigasi

#### 🔸 1. Konfigurasi Routing di `main.dart`:

```dart
MaterialApp(
  title: 'Kata Bijak',
  theme: ThemeData(
    primarySwatch: Colors.yellow,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.yellow[700],
      foregroundColor: Colors.black,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => HomePage(),
    '/kategori': (context) => CategoryPage(),
    '/favorit': (context) => FavoritesPage(),
  },
);
```

---

#### 🔸 2. Bottom Navigation di `home_page.dart`

```dart
BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.yellow,
  backgroundColor: Colors.black,
  unselectedItemColor: Colors.white,
  onTap: _onItemTapped,
);
```

---

#### 🔸 3. Fungsi Navigasi:

```dart
void _onItemTapped(int index) {
  if (index == 0) {
    setState(() => _selectedIndex = index); // Tampilkan halaman QuoteView
  } else if (index == 1) {
    Navigator.pushNamed(context, '/kategori');
  } else if (index == 2) {
    Navigator.pushNamed(context, '/favorit');
  }
}
```

---

Dengan cara ini, pengguna dapat berpindah halaman dari **beranda**, ke **kategori**, hingga ke **halaman favorit** secara dinamis, konsisten, dan efisien menggunakan **Bottom Navigation Bar**.
