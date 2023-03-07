import 'package:codigo6_movieapp/models/character_model.dart';
import 'package:codigo6_movieapp/models/image_model.dart';
import 'package:codigo6_movieapp/models/movie_detail_model.dart';
import 'package:codigo6_movieapp/models/review_model.dart';
import 'package:codigo6_movieapp/services/api_service.dart';
import 'package:codigo6_movieapp/ui/general/colors.dart';
import 'package:codigo6_movieapp/utils/constants.dart';
import 'package:codigo6_movieapp/widgets/item_cast_widget.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int idMovie;

  const DetailPage({
    super.key,
    required this.idMovie,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MovieDetailModel? movie;
  List<CharacterModel> characteres = [];
  List<ImageModel> images = [];
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    ApiService apiService = ApiService();
    movie = await apiService.getMovieDetails(widget.idMovie);
    characteres = await apiService.getCharacteres(widget.idMovie);
    images = await apiService.getImages(widget.idMovie);
    reviews = await apiService.getReviews(widget.idMovie);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBrandPrimaryColor,
      body: movie != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.33,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${movie!.backdropPath}",
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                kBrandPrimaryColor,
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18.0,
                                ),
                                const SizedBox(
                                  width: 3.0,
                                ),
                                Text(
                                  movie!.voteAverage.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  " | ${movie!.voteCount}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    String message =
                                        "Hola espero que estén bien, por favor me envian lo que falta";
                                    message = message.replaceAll(" ", "%20");
                                    Uri url = Uri.parse(
                                        "https://wa.me/51969461067?text=Hola");
                                    launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  },
                                  icon: const Icon(
                                    Icons.whatsapp_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    //Esta película me parecio intesante
                                    Share.share(
                                        "Película: ${movie!.originalTitle} | Resumen: ${movie!.overview} | Web: ${movie!.homepage}");
                                  },
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          movie!.originalTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${movie!.runtime} min",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              movie!.releaseDate.year.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          spacing: 6,
                          runSpacing: -4,
                          children: [
                            // ...movie!.genres
                            //     .map(
                            //       (e) => Chip(
                            //         label: Text(
                            //           e.name,
                            //         ),
                            //       ),
                            //     )
                            //     .toList(),

                            ...List.generate(
                              movie!.genres.length,
                              (index) => Chip(
                                label: Text(
                                  movie!.genres[index].name,
                                ),
                              ),
                            ),

                            // Chip(
                            //   label: Text(
                            //     "Science Fiction",
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          movie!.overview,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        InkWell(
                          onTap: () {
                            Uri url = Uri.parse(movie!.homepage);
                            launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              gradient: LinearGradient(
                                colors: [
                                  kBrandSecondaryColor,
                                  const Color(0xff973FEF),
                                ],
                              ),
                            ),
                            child: const Text(
                              "Homepage",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        const Text(
                          "Top Cast",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: characteres
                                .map((e) => ItemCastWidget(
                                      model: e,
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        const Text(
                          "Images",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          color: Colors.amber,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                              // padding: EdgeInsets.zero,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.35,
                              ),
                              itemCount: images.length ~/ 2,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  // apiImageUrl + images[index].filePath,
                                  "$apiImageUrl${images[index].filePath}",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        const Text(
                          "Reviews",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        ...reviews
                            .map(
                              (e) => ExpansionTile(
                                iconColor: kBrandSecondaryColor,
                                collapsedIconColor: Colors.white,
                                childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 6.0,
                                ),
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white10,
                                      child: Text(
                                        e.authorDetails.rating.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.author,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          e.createdAt
                                              .toString()
                                              .substring(0, 10),
                                          style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                children: [
                                  Text(
                                    e.content,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        const SizedBox(
                          height: 60.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
