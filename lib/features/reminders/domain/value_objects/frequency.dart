enum Frequency {
  once,
  daily,
  weekly,
  custom,
}

extension FrequencyX on Frequency {
  /// Devuelve una descripción legible de la frecuencia.
  String get label {
    switch (this) {
      case Frequency.once:
        return 'Una vez';
      case Frequency.daily:
        return 'Diario';
      case Frequency.weekly:
        return 'Semanal';
      case Frequency.custom:
        return 'Personalizado';
    }
  }

  /// Convierte un entero en Frequency.
  static Frequency fromIndex(int index) {
    if (index < 0 || index >= Frequency.values.length) {
      return Frequency.once;
    }
    return Frequency.values[index];
  }
}