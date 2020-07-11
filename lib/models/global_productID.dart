class GlobalProductId{
  final Map<dynamic,dynamic> id = <dynamic,dynamic>{};

  static GlobalProductId instance = GlobalProductId();

  set(dynamic value) => id['id']= value ;
  get()=> id['id'];
}