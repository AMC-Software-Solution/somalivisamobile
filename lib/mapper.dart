import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:somalivisamobile/shared/models/user.dart';
// jhipster-merlin-needle-mapper-import-add

void configMapper() {
// YOU HAVE TO DECLARE YOUR DTOs LIST HERE FOR CORRECT SERIALIZATION / DESERIALIZATION
  JsonMapper().useAdapter(JsonMapperAdapter(valueDecorators: {
         typeOf<List<User>>(): (value) => value.cast<User>(),
          // jhipster-merlin-needle-mapper-list-add
 } ,converters: {
// CODE HERE AS AN EXAMPLE YOU HAVE TO DECLARE YOUR ENUMS HERE FOR CORRECT SERIALIZATION / DESERIALIZATION
//  PackState: EnumConverter(PackState.values)
// jhipster-merlin-needle-mapper-enum-add
  }));
}

class EnumConverter implements ICustomConverter<dynamic> {
  List<dynamic> compareTO;

  EnumConverter(List<dynamic> compareTO) : super() {
    this.compareTO = compareTO;
  }

  @override
  dynamic fromJSON(jsonValue, [JsonProperty jsonProperty]) {
    String jsonValueString = jsonValue.toString().replaceAll('"', '');
    var result;
    if (jsonValueString.indexOf('.') != - 1) {
      result = compareTO.firstWhere((v) => jsonValueString == v.toString(), orElse: () => null);
    } else {
      result =  compareTO.firstWhere((v) => jsonValueString == v.toString().split('.').last, orElse: () => null);
    }
    return result;
  }

  @override
  String toJSON(dynamic object, [JsonProperty jsonProperty]) {
    if(object != null){
      return object.toString().split('.').last;
    } else {
      return '';
    }
  }
}
