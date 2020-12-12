import 'package:chopper/chopper.dart';
import 'package:go_squad/data/json_to_type_converter.dart';
import 'package:go_squad/models/create_post_response_model.dart';
import 'package:go_squad/models/post_comment_response.dart';
import 'package:go_squad/models/token_model1.dart';
import 'package:go_squad/models/tokens_model.dart';
import 'package:go_squad/models/post_model.dart';
import 'package:go_squad/models/users_create_profile_response_model.dart';
import 'package:go_squad/models/users_profile_model.dart';
part 'rest_api_service.chopper.dart';


@ChopperApi()
abstract class RestApiService extends ChopperService{

  @Get(path: 'posts/{id}', headers: {'abc': 'cba'})
  Future <Response> getPosts(@Path('id') int id,
      @Header('Authorization') String headerVal
      );

  @Post(path: '/login')
  Future<Response<TokenModel1>> logUserIn(@Body() Map<String, String> body);

  @Post(path: '/register')
  Future<Response<TokenModel1>> registerUser(@Body() Map<String, String> body);

  @Get(path: '/post')
  Future <Response<List<PostModel>>> loadPosts(@Header('x-auth-token') String token);

  @Get(path: '/post/{id}')
  Future<Response<PostModel>> loadPost(@Path('id') String id, @Header('x-auth-token') String token);

  @Get(path: '/users')
  Future<Response<List<UsersProfileModel>>> loadUsersProfile(@Header('x-auth-token') String token);

  @Get(path: '/users/{id}')
  Future<Response<UsersProfileModel>> loadSelectedUserProfile(@Header('x-auth-token') String token, @Path('id') String id);

  @Get(path: '/users/me')
  Future<Response<UsersProfileModel>> loadMyProfile(@Header('x-auth-token') String token);

  @Post(path: '/users')
  Future<Response<UsersCreateProfileResponseModel>> createProfile(@Header('x-auth-token') String token, @body Map<String, String> body);

  @Post(path: '/post')
  Future<Response<CreatePostResponseModel>> createPost(@Header('x-auth-token') String token, @body Map<String, String> body);

  @Post(path: '/post/comment/{id}')
  Future<Response<List<PostCommentResponse>>> createComment(@Header('x-auth-token') String token, @Path('id') String postId, @body Map<String, String> body);

  static RestApiService create() {
    final client = ChopperClient(baseUrl: 'https://gosquad-test.herokuapp.com/api',
    services: [
      _$RestApiService(),
    ],
    converter: JsonToTypeConverter( {
      TokensModel: (jsonData) => TokensModel.fromJson(jsonData),
      TokenModel1: (jsonData) => TokenModel1.fromJson(jsonData),
      PostModel: (jsonData) => PostModel.fromJson(jsonData),
      UsersProfileModel: (jsonData) => UsersProfileModel.fromJson(jsonData),
      UsersCreateProfileResponseModel: (jsonData) => UsersCreateProfileResponseModel.fromJson(jsonData),
      CreatePostResponseModel: (jsonData) => CreatePostResponseModel.fromJson(jsonData),
      PostCommentResponse: (jsonData) => PostCommentResponse.fromJson(jsonData),
    })
    );
    return _$RestApiService(client);
  }
}