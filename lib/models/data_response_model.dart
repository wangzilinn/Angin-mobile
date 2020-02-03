class DataResponseModel<T>{
  T data;
  bool error;
  String errorMessage;

  DataResponseModel({this.data, this.error = false, this.errorMessage});
}