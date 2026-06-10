import 'package:flutter/material.dart';
import '../models/homestay.dart';
import '../services/api_service.dart';
import 'homestay_detail_screen.dart';

class HomestayScreen extends StatefulWidget {
  const HomestayScreen({super.key});

  @override
  State<HomestayScreen> createState() => _HomestayScreenState();
}

class _HomestayScreenState extends State<HomestayScreen> {
  final ApiService apiService = ApiService();

  List<Homestay> homestays = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController districtController = TextEditingController();

  bool isLoading = false;
  String message = '';

  String selectedState = 'All';

  List<String> states = [
    'All',
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perak',
    'Perlis',
    'Pulau Pinang',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
  ];

  @override
  void initState() {
    super.initState();
    loadHomestays();
  }

  Future<void> loadHomestays() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      homestays = await apiService.loadHomestays(
        search: searchController.text.trim(),
        state: selectedState,
        district: districtController.text.trim(),
      );

      if (homestays.isEmpty) {
        message = 'No homestay found.';
      }
    } catch (e) {
      message = e.toString().replaceAll('Exception: ', '');
    }

    setState(() {
      isLoading = false;
    });
  }

  void clearAllFilters() {
    searchController.clear();
    districtController.clear();

    setState(() {
      selectedState = 'All';
    });

    loadHomestays();
  }

  @override
  void dispose() {
    searchController.dispose();
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homestay2U Malaysia'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 239, 187, 238),
        foregroundColor: Color.fromARGB(255, 138, 22, 111),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search: paddy field, beach, city',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => loadHomestays(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              initialValue: selectedState,
              decoration: InputDecoration(
                labelText: 'Filter by state',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
                loadHomestays();
              },
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: districtController,
              decoration: InputDecoration(
                hintText: 'Filter by district: Pontian, Shah Alam',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => loadHomestays(),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: loadHomestays,
                    icon: const Icon(Icons.filter_alt),
                    label: const Text('Apply Filter'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: clearAllFilters,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : message.isNotEmpty
                    ? Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: loadHomestays,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: homestays.length,
                          itemBuilder: (context, index) {
                            final h = homestays[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomestayDetailScreen(homestay: h),
                                    ),
                                  );
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                  h.imageUrl ?? '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                  Icons.home,
                                  size: 40,
                                  color: Color.fromARGB(255, 138, 22, 111),
                                  );
                                  },
                                  ),
                                ),
                                title: Text(
                                  h.name.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 138, 22, 111),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${h.district}, ${h.state}'),
                                    Text(
                                    h.price == 'Not stated'
                                    ? 'Price: Not available'
                                    : 'Price: RM ${h.price}',
                                    style: TextStyle(
                                      color: h.price == 'Not stated'
                                      ? Colors.grey
                                      : Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    Text(
                                      h.description.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}