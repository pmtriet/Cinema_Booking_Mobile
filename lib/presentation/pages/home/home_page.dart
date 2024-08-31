import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';
import 'package:cinemabooking/datalayer/repo/auth_repo.dart';
import 'package:cinemabooking/datalayer/repo/movie_repo.dart';
import 'package:cinemabooking/domain/repo_interface/auth_repo_interface.dart';
import 'package:cinemabooking/presentation/cubit/home/home_cubit.dart';
import 'package:cinemabooking/presentation/pages/home/movie_card.dart';
import 'package:cinemabooking/presentation/states/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final movieRepository = MovieRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(movieRepository: movieRepository),
      child: const MaterialApp(
        home: HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<HomeCubit>().loadMoreMovies(_searchController.text);
    }
  }

  void _refreshMovie() {
    context.read<HomeCubit>().getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    IAuthRepository authRepository = AuthRepository();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(backgroundColor),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  children: [
                    Image.asset('assets/icons/logo.png'),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        final result = await authRepository.logout();
                        if (result && context.mounted) {
                          context.go(RouteName.welcome);
                        }
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(color: Color(appColor), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    if (!_isSearching)
                      const Expanded(
                        child: Text(
                          'Now in cinemas',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    if (_isSearching)
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Color(0xff637394)),
                            suffixIcon: Icon(Icons.search),
                            suffixIconColor: Color(0xff637394),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (text) {
                            context.read<HomeCubit>().onSearchTextChanged(text);
                          },
                        ),
                      ),
                    IconButton(
                      icon: Icon(_isSearching ? Icons.close : Icons.search),
                      color: const Color(0xff637394),
                      onPressed: () {
                        setState(() {
                          if (_isSearching) {
                            _searchController.clear();
                            context.read<HomeCubit>().searchMovie('');
                          }
                          _isSearching = !_isSearching;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is HomeInitialState) {
                      context.read<HomeCubit>().getAllMovies();
                    }
                  },
                  builder: (context, state) {
                    switch (state){
                      case HomeLoadingState():
                        context.read<HomeCubit>().getAllMovies();
                        return const Center(child: CircularProgressIndicator());
                      case HomeMoviesState():
                        return _homeMovieWidget(state.movies, state.isLoadingMore);
                      case HomeEmptyMovieState():
                        return _emtyMovieView(null);  
                      case HomeSearchErrorState():
                        return _emtyMovieView(state.errorMessage);
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeMovieWidget(List<MovieResponse> movies, bool isLoadingMore) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        _refreshMovie();
      },
      color: const Color(appColor),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.6,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movieId: movies[index].movieId,
                  movieName: movies[index].movieName,
                  movieCategory: movies[index].movieCategory,
                  movieImgUrl: movies[index].imgUrl,
                );
              },
            ),
          ),
          if (isLoadingMore)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _emtyMovieView(String? searchErrorMessage) {
    return Center(
      child: searchErrorMessage == null
          ? const Text(
              'Nothing to show',
              style: TextStyle(color: Colors.white),
            )
          : Text(searchErrorMessage),
    );
  }
}
