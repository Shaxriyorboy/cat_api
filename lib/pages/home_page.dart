import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_api/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/cat_model.dart';
import '../models/uploadModel/uploadImage.dart';

class HomePage extends StatefulWidget {
  static const String id = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UploadImage> uploadImage = [];
  List<Color> colors = [
    Colors.blueGrey.shade700,
    Colors.grey,
    Colors.grey.shade500,
    Colors.blueGrey,
    Colors.black12,
  ];
  bool isLoading = true;
  bool isLoadMore = false;
  List<Cat> catList = [];
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  getList() {
    setState(() {
      isLoading = true;
    });
    Network.GET(Network.API_LIST, Network.paramsAll(page)).then((value) => {
          _showResponse(value!),
        });
  }

  void _showResponse(String response) {
    List<Cat> list = Network.parsePostList(response);
    catList.clear();
    setState(() {
      isLoading = false;
      catList = list;
    });
  }

  void _fetchPosts() async {
    setState(() {
      page++;
    });
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsAll(page));
    List<Cat> newPosts = Network.parsePostList(response!);
    catList.addAll(newPosts);
    setState(() {
      isLoadMore = false;
    });
  }

  getUpload() {
    Network.GET_UPLOAD(Network.API_UPLOAD_GET, Network.getUpload())
        .then((value) => {
      _showUpload(value!),
    });
  }

  _showUpload(String response) {
    setState(() {
      uploadImage = Network.parseUpload(response);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
    getUpload();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 10,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "All",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "My Cat",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            !isLoading
                ? NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoadMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    isLoadMore = true;
                    _fetchPosts();
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoadMore?LinearProgressIndicator(color: Colors.red,minHeight: 4,):SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: MasonryGridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: catList.length,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        AspectRatio(
                                          aspectRatio: catList[index].width! /
                                              catList[index].height!,
                                          child: Container(
                                            color:
                                            colors[index % colors.length],
                                          ),
                                        ),
                                    imageUrl: catList[index].url!,
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  ),
                                ),
                                onTap: () {},
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ) : Center(
              child: CircularProgressIndicator(),
            ),
            !isLoading
                ? NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoadMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    isLoadMore = true;
                    _fetchPosts();
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoadMore?LinearProgressIndicator(color: Colors.red,minHeight: 4,):SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: MasonryGridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: uploadImage.length,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        AspectRatio(
                                          aspectRatio: uploadImage[index].width! /
                                              uploadImage[index].height!,
                                          child: Container(
                                            color:
                                            colors[index % colors.length],
                                          ),
                                        ),
                                    imageUrl: uploadImage[index].url!,
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  ),
                                ),
                                onTap: () {},
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ) : Center(
              child: CircularProgressIndicator(),
            ),
          ],
        )
      ),
    );
  }
}
