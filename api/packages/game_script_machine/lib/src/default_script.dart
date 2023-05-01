/// The default script, used when none is found in the firebase.
const defaultGameLogic = '''
external fun rollDoubleValue

fun rollCardRarity() -> bool {
  var chance = rollDoubleValue();
  return chance > 0.9;
}


fun rollCardPower(isRare: bool) -> int {
  const maxValue = 99;
  const minValue = 10;
  const gap = maxValue - minValue;
  
  var base = rollDoubleValue();
  var value = (base * gap + minValue).toInt();
  value = if (isRare) 100 else value;

  return value;
}

fun compareCards(valueA: int, valueB: int, suitA: str, suitB: str) -> int {
  var evaluation = compareSuits(suitA, suitB);

  var aModifier = if (evaluation == -1) 0.9 else 1;
  var bModifier = if (evaluation == 1) 0.9 else 1;

  var a = valueA * aModifier;
  var b = valueB * bModifier;

  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}

fun compareSuits(suitA: str, suitB: str) -> int {
  when (suitA) {
    'fire' -> {
      when (suitB) {
        'air', 'metal' -> return 1;
        'water', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'air' -> {
      when (suitB) {
        'water', 'earth' -> return 1;
        'fire', 'metal' -> return -1;
        else -> return 0;
      }
    }
    'metal' -> {
      when (suitB) {
        'water', 'air' -> return 1;
        'fire', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'earth' -> {
      when (suitB) {
        'fire', 'metal' -> return 1;
        'water', 'air' -> return -1;
        else -> return 0;
      }
    }
    'water' -> {
      when (suitB) {
        'fire', 'earth' -> return 1;
        'metal', 'air' -> return -1;
        else -> return 0;
      }
    }
    else -> return 0;
  }
}
''';
