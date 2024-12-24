import 'package:flutter/material.dart';
import 'package:orders/api/services/search_service.dart';
import 'package:orders/widgets/home/search_list.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final searchService = SearchService();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: searchService.fetchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching results"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No results found"),
          );
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                title: Text(item.name), // Use appropriate field
                onTap: () {
                  close(context, item['name']); // Return selected item
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("Start typing to search"),
      );
    }
    return FutureBuilder<List<dynamic>>(
      future: searchService.fetchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching suggestions"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No suggestions available"),
          );
        } else {
          // final suggestions = snapshot.data![0]['products'];
          return SearchList(
              click: (context,item){
                    query = item['name']; // Set the query
                    showResults(context); // Show results
                  },
              stores: snapshot.data![0]['stores'],
              products: snapshot.data![0]['products']);
        }
      },
    );
  }
}
