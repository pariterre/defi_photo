import 'package:defi_photo/common/models/enum.dart';
import 'package:defi_photo/common/providers/all_students.dart';
import 'package:enhanced_containers/enhanced_containers.dart';

class Question extends ItemSerializableWithCreationTime {
  // Constructors and (de)serializer
  Question(
    this.text, {
    required this.section,
    required this.defaultTarget,
    super.id,
    super.creationTimeStamp,
    this.canBeDeleted = true,
  });
  Question.fromSerialized(map)
      : text = map['text'],
        section = map['section'],
        defaultTarget = Target.values[map['defaultTarget']],
        canBeDeleted = map['canBeDeleted'] ?? false,
        super.fromSerialized(map);
  Question copyWith({
    String? text,
    int? section,
    Target? defaultTarget,
    String? id,
    int? creationTimeStamp,
  }) {
    text ??= this.text;
    section ??= this.section;
    defaultTarget ??= this.defaultTarget;
    id ??= this.id;
    creationTimeStamp ??= this.creationTimeStamp;
    return Question(
      text,
      section: section,
      defaultTarget: defaultTarget,
      canBeDeleted: canBeDeleted,
      id: id,
      creationTimeStamp: creationTimeStamp,
    );
  }

  Question deserializeItem(map) {
    return Question.fromSerialized(map);
  }

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'text': text,
      'section': section,
      'defaultTarget': defaultTarget.index,
      'canBeDeleted': canBeDeleted,
    };
  }

  bool hasQuestionAtLeastOneAnswer({required AllStudents students}) {
    // Make sure no student already responded to the question
    // If so, prevent from modifying it
    for (final student in students) {
      if (student.allAnswers[this]!.hasAnswer) {
        return true;
      }
    }
    return false;
  }

  // Attributes and methods
  final String text;
  final int section;
  final Target defaultTarget;
  final bool canBeDeleted;
}
