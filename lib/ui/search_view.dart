import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../shared/colors.dart';
import '../shared/dimens.dart';
import '../shared/strings.dart';
import 'search_viewmodel.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              AppStrings.titleSearch,
              style: TextStyle(
                  fontSize: Dimens.fontSize28, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.paddingHorizontal,
              Dimens.paddingVertical,
              Dimens.paddingHorizontal,
              Dimens.mediumSpacing,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: AppStrings.hintSearch,
                      hintStyle: const TextStyle(color: AppColors.hintText),
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.hintText),
                      filled: true,
                      fillColor: AppColors.fillColor,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimens.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => model.search(value),
                    style: const TextStyle(color: AppColors.hintText),
                  ),
                  const SizedBox(height: Dimens.mediumSpacing),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text(AppStrings.albumsLabel),
                        selected:
                            model.selectedType == AppStrings.selectedTypeAlbum,
                        onSelected: (_) =>
                            model.setSelectedType(AppStrings.selectedTypeAlbum),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.chipBorderRadius),
                        ),
                        selectedColor: AppColors.selectedChip,
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color:
                              model.selectedType == AppStrings.selectedTypeAlbum
                                  ? Colors.white
                                  : Colors.white,
                        ),
                        side: const BorderSide(
                            color: AppColors.chipBorder,
                            width: Dimens.borderSideWidth),
                        showCheckmark: false,
                      ),
                      const SizedBox(width: Dimens.smallSpacing),
                      ChoiceChip(
                        label: const Text(AppStrings.artistsLabel),
                        selected:
                            model.selectedType == AppStrings.selectedTypeArtist,
                        onSelected: (_) => model
                            .setSelectedType(AppStrings.selectedTypeArtist),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.chipBorderRadius),
                        ),
                        selectedColor: AppColors.selectedChip,
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: model.selectedType ==
                                  AppStrings.selectedTypeArtist
                              ? Colors.white
                              : Colors.white,
                        ),
                        side: const BorderSide(
                            color: Colors.white, width: Dimens.borderSideWidth),
                        showCheckmark: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.mediumSpacing),
                  if (model.isBusy)
                    const Center(child: CircularProgressIndicator())
                  else if (model.results.isEmpty)
                    const Center(
                      child: Text(
                        AppStrings.noResults,
                        style: TextStyle(
                            fontSize: Dimens.fontSize18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  else if (model.selectedType == AppStrings.selectedTypeAlbum)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  height: Dimens.imageHeight,
                                  fit: BoxFit.cover,
                                ),
                              const SizedBox(height: Dimens.smallSpacing),
                              Text(
                                album.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: Dimens.maxLineTwo,
                              ),
                              if (album.artist != null)
                                Text(
                                  album.artist!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: Dimens.maxLineOne,
                                ),
                              if (album.year != null) Text(album.year!),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.results.length,
                      itemBuilder: (context, index) {
                        final artist = model.results[index];
                        return ListTile(
                          leading: artist.imageUrl != null
                              ? Image.network(artist.imageUrl!,
                                  width: Dimens.artistImageWidthUrl,
                                  height: Dimens.artistImageHeightUrl)
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
