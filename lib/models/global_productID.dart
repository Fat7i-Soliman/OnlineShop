class GlobalProductId{
  final Map<dynamic,dynamic> id = <dynamic,dynamic>{};

  static GlobalProductId instance = GlobalProductId();

  set(dynamic value) => id['id']= value ;
  get()=> id['id'];
}

class GlobalCategory{
  final Map<dynamic,dynamic> id = <dynamic,dynamic>{};

  static GlobalCategory instance = GlobalCategory();

  setCat(dynamic value) => id['cat']= value ;
  setTitle(dynamic value) => id['title']= value ;

  getCat()=> id['cat'];
  getTitle()=> id['title'];
}