import 'package:dio/dio.dart';
abstract class DataState<T> {
  final T? data;
  final DioException ?error;  
  const DataState({this.data,this.error});

  }

  // on Sucess State
   class DataSuccess<T> extends DataState<T> { 
    const DataSuccess(T data):super(data: data);
    }
  //  On error State
       class DataError<T> extends DataState<T> { 
    const DataError(DioException error):super(error: error);
    }