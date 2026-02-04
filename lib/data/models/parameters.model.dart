enum MSG_FUNCTION {
  BATTERY_LVL(3),
  GENERAL(1),
  LIGHT(10),
  LOCALISATION_GPS(9),
  RMASTER_BRD(2),
  UNKNOWN(0);

  final int byteValue;
  const MSG_FUNCTION(int byte) : byteValue = byte;

  static MSG_FUNCTION? fromByte(int byte) {
    return MSG_FUNCTION.values.firstWhere(
      (func) => func.byteValue == byte,
      orElse: () => MSG_FUNCTION.UNKNOWN,
    );
  }
}

enum MSG_TYPE {
  CMD(4),
  EVENT(5),
  GET(1),
  PARAM_VALUE(3),
  SET(2),
  UNKNOWN(0);

  final int byteValue;
  const MSG_TYPE(int byte) : byteValue = byte;

  static MSG_TYPE? fromByte(int byte) {
    return MSG_TYPE.values.firstWhere(
      (type) => type.byteValue == byte,
      orElse: () => MSG_TYPE.UNKNOWN,
    );
  }
}

enum OBJ {
  ONE(1),
  TWO(2),
  THREE(3),
  FOUR(4),
  FIVE(5),
  SIX(6);

  final int byteValue;
  const OBJ(int byte) : byteValue = byte;
}
