import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/artist_helper.dart';
import 'package:eventtracking/helper/followers_helper.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/view_artist_profile.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);
  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  TextEditingController queryController = TextEditingController();
  List<Artist> allArtists = [];
  List<Artist> allUsers = [];
  List<Follow> follows = [];
  bool isLoading = false;
  String? currentUser;

  _fetchAllUsers() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    currentUser = userAuthProvider.authState.id;
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allUsers}?querytype=all",
          'get');
      var resFollows = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.followers}?querytype=all",
          'get');
      var followerRes = json.decode(resFollows);
      FollowList fllws = FollowHelper.filterEventsByType(followerRes);
      follows = fllws.followList;
      var body = json.decode(res);
      // print(body);
      ArtistList filteredEvents = ArtistHelper.filterEventsByType(body);
      print(filteredEvents);
      // print("BongoFleva Events:");
      allUsers = filteredEvents.userList;
      allArtists = filteredEvents.artistList;
      print(allArtists);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error: Failing to get artists check your internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isArtistFollowed(String? artistId) {
    bool value = false;
    dynamic artInFollower;
    for (var foll in follows) {
      if (foll.artist['id'] == artistId) {
        artInFollower = foll;
      }
    }

    if (artInFollower?.follower['id'] == currentUser) {
      value = true;
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artists"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: queryController,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {},
                      onChanged: (_) {},
                      leading: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: allArtists.length,
                  itemBuilder: (context, index) {
                    Artist artist = allArtists[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewArtistProfile(
                                        artistId: artist.id,
                                      )),
                            ),
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.textColor1),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${AppConstants.mediaBaseUrl}/${artist.profile}"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: '${artist.email}',
                                        size: 16,
                                      ),
                                      AppSmallText(text: '${artist.username}')
                                    ],
                                  )
                                ],
                              ),
                              _isArtistFollowed(artist.id)
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 2,
                                        backgroundColor: AppColors.addsOn,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(
                                        //       10), // Set border radius here
                                        // ),
                                      ),
                                      onPressed: () {
                                        // Navigator.pushReplacement(context,
                                        //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                                      },
                                      child: const Text(
                                        "Unfollow",
                                        style: TextStyle(
                                            color: AppColors.textColor1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 2,
                                        backgroundColor: AppColors.addsOn,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(
                                        //       10), // Set border radius here
                                        // ),
                                      ),
                                      onPressed: () {
                                        // Navigator.pushReplacement(context,
                                        //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                                      },
                                      child: const Text(
                                        "Follow",
                                        style: TextStyle(
                                            color: AppColors.textColor1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                    //   ListTile(
                    //   title: Text(comments[index]['text']),
                    //   // Add more comment details as needed
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
