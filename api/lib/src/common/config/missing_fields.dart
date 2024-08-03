/// Missing fields class that detects parameters that are nullable and return
/// associated message for their missing
class MissingFields {
  /// {@macro missing_fields}
  const MissingFields(this._fields);

  final Map<String, dynamic> _fields;

  /// Method for detecting missing fields
  ///
  /// Loop over each field. If the value is null add this field
  /// to the missing fields variable
  String get missing {
    final missingFields = <String>[];
    for (final fieldName in _fields.keys) {
      final fieldValue = _fields[fieldName];
      if (fieldValue == null) {
        missingFields.add(fieldName);
      }
    }
    return 'Missing ${missingFields.map(_capitalize).join(', ')}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
