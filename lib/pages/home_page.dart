import 'package:codigo6_movieapp/models/genre_model.dart';
import 'package:codigo6_movieapp/models/movie_model.dart';
import 'package:codigo6_movieapp/pages/detail_page.dart';
import 'package:codigo6_movieapp/services/api_service.dart';
import 'package:codigo6_movieapp/ui/general/colors.dart';
import 'package:codigo6_movieapp/widgets/item_filter_widget.dart';
import 'package:codigo6_movieapp/widgets/item_home_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieModel> moviesModel = [];
  List<MovieModel> moviesModelTemp = [];
  List<GenreModel> genres = [];
  int idFilter = 0;
  int counterPage = 1;
  ScrollController movieScrollController = ScrollController();

  int value = 1;

  @override
  void initState() {
    super.initState();
    getData();
    movieScrollController.addListener(() {
      if (movieScrollController.offset >=
          movieScrollController.position.maxScrollExtent) {
        getMovies();
      }
    });
  }

  getData() async {
    ApiService apiService = ApiService();
    await getMovies();
    genres = await apiService.getGenres();
    genres.insert(0, GenreModel(id: 0, name: "All"));
    setState(() {});
  }

  getMovies() async {
    ApiService apiService = ApiService();
    moviesModel = [
      ...moviesModelTemp,
      ...await apiService.getMovies(counterPage)
    ];
    moviesModelTemp = moviesModel;
    filterMovie(idFilter);
    setState(() {});
    counterPage++;
  }

  filterMovie(int id) {
    moviesModel = moviesModelTemp;
    if (id != 0) {
      moviesModel = moviesModel
          .where((element) => element.genreIds.contains(id))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    movieScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandPrimaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "TotalCinema",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: genres
                          .map(
                            (e) => ItemFilterWidget(
                              text: e.name,
                              isSelected: e.id == idFilter,
                              onTap: () {
                                idFilter = e.id;
                                // setState(() {});
                                filterMovie(idFilter);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    color: Colors.white,
                    child: DropdownButton(
                      isExpanded: true,
                      value: idFilter,
                      items: genres
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (int? mandarina) {
                        idFilter = mandarina!;
                        filterMovie(idFilter);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: movieScrollController,
                shrinkWrap: true,
                // physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(14.0),
                itemCount: moviesModel.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ItemHomeWidget(
                    model: moviesModel[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            idMovie: moviesModel[index].id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
