import 'dart:convert';
import 'package:cat_api/models/cat_model.dart';
import 'package:cat_api/models/uploadModel/uploadImage.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.thecatapi.com";
  static String SERVER_PRODUCTION = "jsonplaceholder.typicode.com";

  /* Header */
  static Map<String, String> getHeader() {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    return header;
  }

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'x-api-key': 'c1666ee0-7ada-408d-9596-e397f4060da3'
    };
    return headers;
  }

  /* Test Server */
  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /*Http request*/
  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri,headers: getHeader());
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> MULTIPART(
      String api, String filePath, Map<String, String> body) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('file', filePath,contentType: MediaType("file", "jpeg")));
    request.fields.addAll(body);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  static Future<String?> GET_UPLOAD(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri,headers: getHeader());
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> GET_ONE(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri,headers: getHeader());
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await post(
      uri,
      body: jsonEncode(params),
        headers: getHeader()
    );
    // Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> UPLOAD(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api);
    var response =
        await put(uri, body: jsonEncode(params),headers: getHeader());
    // Log.d(response.body);

    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params);
    var response = await delete(uri,headers: getHeader());
    // Log.d(response.body);

    if (response.statusCode == 200) return response.body;
    return null;
  }

  /* Http apis */

  static String API_LIST = "/v1/images/search";
  static String API_UPLOAD_GET = "/v1/images/";
  static String API_UPLOAD = "/v1/images/upload";
  static String API_DELETE = "/v1/images/search/"; //{id}
  static String API_SEARCH_BREED = "/v1/breeds/search";
  static String API_GET_UPLOADS = "/v1/images/";

  /* Http Body */
  static Map<String, String> bodyUpload(String subId) {
    Map<String, String> body = {'sub_id': subId};
    return body;
  }

  /* Http params */
  static Map<String, String> upload(String file){
    Map<String,String> map = {};
    map.addAll({
      "file":file.toString()
    });
    return map;
  }

  static Map<String,String> getUpload(){
    Map<String,String> map = {
      "limit":"10"
    };
    return map;
  }

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  static Map<String , String> paramsUpload(int page){
    Map<String,String> param = {
      "limit":"15",
      "page":page.toString(),
    };
    return param;
  }

  static Map<String , String> paramsAll(int page){
    Map<String,String> param = {
      "limit":"15",
      "page":page.toString(),
      "order":"Asc"
    };
    return param;
  }

  static Map<String, String> paramsSearch(String search, int pageNumber) {
    Map<String, String> params = {};
    params.addAll(
        {'breed_ids': search, 'limit': '25', 'page': pageNumber.toString()});
    return params;
  }

  static Map<String, String> paramsBreedSearch(String search) {
    Map<String, String> params = {};
    params.addAll({'q': search});
    return params;
  }

  /* Http parsing */
  static List<Cat> parseResponse(String response) {
    List json = jsonDecode(response);
    List<Cat> photos = List<Cat>.from(json.map((x) => Cat.fromJson(x)));
    return photos;
  }

  static List<Breed> parseSearchBreed(String response) {
    List json = jsonDecode(response);
    List<Breed> categories = List<Breed>.from(json.map((x) => Breed.fromJson(x)));
    return categories;
  }

  /* Http parsing */
  static Cat parseEmpOne(String body){
    dynamic json = jsonDecode(body);
    var data = Cat.fromJson(json);
    return data;
  }

  static List<Cat> parsePostList(String body){
    List<Cat> cats = catFromJson(body);
    return cats;
  }

  static List<UploadImage> parseUpload(String body){
    List<UploadImage> image = uploadFromJson(body);
    return image;
  }
}
