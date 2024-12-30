import 'package:flutter/material.dart';
import 'package:spotify_search_app/utilities/Common.dart';
import 'package:stacked/stacked.dart';
import 'search_viewmodel.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search',style: TextStyle(fontSize:28, fontWeight: FontWeight.bold)),
            centerTitle: false, // Aligns the title to the left
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,16.0),
            child: SingleChildScrollView( // Makes content scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Artists, albums...',
                      hintStyle: TextStyle(
                        color: Common.hexToColor("#7F7F7F"), // Set your desired color for the hint text
                      ),
                      prefixIcon: Icon(Icons.search,color: Common.hexToColor("#7F7F7F")),
                      filled: true, // Enables the background color
                      fillColor: Common.hexToColor("#FFFFFF"), // Light grey background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
                        borderSide: BorderSide.none, // Remove the border line
                      ),
                    ),
                    onChanged: (value) => model.search(value),
                    style: TextStyle(color: Common.hexToColor("#7F7F7F")), // Text color
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Albums'),
                        selected: model.selectedType == 'album',
                        onSelected: (_) => model.setSelectedType('album'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        selectedColor: Colors.green[800],
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: model.selectedType == 'album' ? Colors.white : Colors.white,
                        ),
                        side: BorderSide(color: Common.hexToColor("#D3D3D3"), width: 0.5),
                        showCheckmark: false,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Artists'),
                        selected: model.selectedType == 'artist',
                        onSelected: (_) => model.setSelectedType('artist'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        selectedColor: Colors.green[800],
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: model.selectedType == 'artist' ? Colors.white : Colors.white,
                        ),
                        side: BorderSide(color: Colors.white, width: 0.5),
                        showCheckmark: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (model.isBusy)
                    const Center(child: CircularProgressIndicator())
                  else if (model.results.isEmpty)
                    const Center(
                      child: Text(
                        'No results',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  else if (model.selectedType == 'album')
                      GridView.builder(
                        shrinkWrap: true, // Prevents it from taking infinite height
                        physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: model.results.length,
                        itemBuilder: (context, index) {
                          final album = model.results[index];
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (album.imageUrl != null)
                                  Image.network(
                                    album.imageUrl!,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  album.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2, // Limit to one line
                                ),
                                if (album.artist != null) Text(album.artist! ,overflow: TextOverflow.ellipsis,
                                    maxLines: 1), // Limit to one line),
                                if (album.year != null) Text(album.year!),
                              ],
                            ),
                          );
                        },
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true, // Prevents it from taking infinite height
                        physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                        itemCount: model.results.length,
                        itemBuilder: (context, index) {
                          final artist = model.results[index];
                          return ListTile(
                            leading: artist.imageUrl != null
                                ? Image.network(artist.imageUrl!, width: 50, height: 50)
                                : const Icon(Icons.person),
                            title: Text(artist.name),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
