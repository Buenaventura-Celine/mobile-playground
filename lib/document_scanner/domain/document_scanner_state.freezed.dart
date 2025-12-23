// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_scanner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentScannerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentScannerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentScannerState()';
}


}

/// @nodoc
class $DocumentScannerStateCopyWith<$Res>  {
$DocumentScannerStateCopyWith(DocumentScannerState _, $Res Function(DocumentScannerState) __);
}


/// Adds pattern-matching-related methods to [DocumentScannerState].
extension DocumentScannerStatePatterns on DocumentScannerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Checking value)?  checking,TResult Function( _Ready value)?  ready,TResult Function( _Capturing value)?  capturing,TResult Function( _Preview value)?  preview,TResult Function( _Processing value)?  processing,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking(_that);case _Ready() when ready != null:
return ready(_that);case _Capturing() when capturing != null:
return capturing(_that);case _Preview() when preview != null:
return preview(_that);case _Processing() when processing != null:
return processing(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Checking value)  checking,required TResult Function( _Ready value)  ready,required TResult Function( _Capturing value)  capturing,required TResult Function( _Preview value)  preview,required TResult Function( _Processing value)  processing,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Checking():
return checking(_that);case _Ready():
return ready(_that);case _Capturing():
return capturing(_that);case _Preview():
return preview(_that);case _Processing():
return processing(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Checking value)?  checking,TResult? Function( _Ready value)?  ready,TResult? Function( _Capturing value)?  capturing,TResult? Function( _Preview value)?  preview,TResult? Function( _Processing value)?  processing,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking(_that);case _Ready() when ready != null:
return ready(_that);case _Capturing() when capturing != null:
return capturing(_that);case _Preview() when preview != null:
return preview(_that);case _Processing() when processing != null:
return processing(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function( CameraDescription selectedCamera,  FlashMode flashMode,  double zoomLevel)?  ready,TResult Function()?  capturing,TResult Function( XFile imageFile)?  preview,TResult Function()?  processing,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking();case _Ready() when ready != null:
return ready(_that.selectedCamera,_that.flashMode,_that.zoomLevel);case _Capturing() when capturing != null:
return capturing();case _Preview() when preview != null:
return preview(_that.imageFile);case _Processing() when processing != null:
return processing();case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function( CameraDescription selectedCamera,  FlashMode flashMode,  double zoomLevel)  ready,required TResult Function()  capturing,required TResult Function( XFile imageFile)  preview,required TResult Function()  processing,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Checking():
return checking();case _Ready():
return ready(_that.selectedCamera,_that.flashMode,_that.zoomLevel);case _Capturing():
return capturing();case _Preview():
return preview(_that.imageFile);case _Processing():
return processing();case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function( CameraDescription selectedCamera,  FlashMode flashMode,  double zoomLevel)?  ready,TResult? Function()?  capturing,TResult? Function( XFile imageFile)?  preview,TResult? Function()?  processing,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking();case _Ready() when ready != null:
return ready(_that.selectedCamera,_that.flashMode,_that.zoomLevel);case _Capturing() when capturing != null:
return capturing();case _Preview() when preview != null:
return preview(_that.imageFile);case _Processing() when processing != null:
return processing();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Checking implements DocumentScannerState {
  const _Checking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentScannerState.checking()';
}


}




/// @nodoc


class _Ready implements DocumentScannerState {
  const _Ready({required this.selectedCamera, required this.flashMode, required this.zoomLevel});
  

 final  CameraDescription selectedCamera;
 final  FlashMode flashMode;
 final  double zoomLevel;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadyCopyWith<_Ready> get copyWith => __$ReadyCopyWithImpl<_Ready>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ready&&(identical(other.selectedCamera, selectedCamera) || other.selectedCamera == selectedCamera)&&(identical(other.flashMode, flashMode) || other.flashMode == flashMode)&&(identical(other.zoomLevel, zoomLevel) || other.zoomLevel == zoomLevel));
}


@override
int get hashCode => Object.hash(runtimeType,selectedCamera,flashMode,zoomLevel);

@override
String toString() {
  return 'DocumentScannerState.ready(selectedCamera: $selectedCamera, flashMode: $flashMode, zoomLevel: $zoomLevel)';
}


}

/// @nodoc
abstract mixin class _$ReadyCopyWith<$Res> implements $DocumentScannerStateCopyWith<$Res> {
  factory _$ReadyCopyWith(_Ready value, $Res Function(_Ready) _then) = __$ReadyCopyWithImpl;
@useResult
$Res call({
 CameraDescription selectedCamera, FlashMode flashMode, double zoomLevel
});




}
/// @nodoc
class __$ReadyCopyWithImpl<$Res>
    implements _$ReadyCopyWith<$Res> {
  __$ReadyCopyWithImpl(this._self, this._then);

  final _Ready _self;
  final $Res Function(_Ready) _then;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedCamera = null,Object? flashMode = null,Object? zoomLevel = null,}) {
  return _then(_Ready(
selectedCamera: null == selectedCamera ? _self.selectedCamera : selectedCamera // ignore: cast_nullable_to_non_nullable
as CameraDescription,flashMode: null == flashMode ? _self.flashMode : flashMode // ignore: cast_nullable_to_non_nullable
as FlashMode,zoomLevel: null == zoomLevel ? _self.zoomLevel : zoomLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Capturing implements DocumentScannerState {
  const _Capturing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Capturing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentScannerState.capturing()';
}


}




/// @nodoc


class _Preview implements DocumentScannerState {
  const _Preview(this.imageFile);
  

 final  XFile imageFile;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewCopyWith<_Preview> get copyWith => __$PreviewCopyWithImpl<_Preview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Preview&&(identical(other.imageFile, imageFile) || other.imageFile == imageFile));
}


@override
int get hashCode => Object.hash(runtimeType,imageFile);

@override
String toString() {
  return 'DocumentScannerState.preview(imageFile: $imageFile)';
}


}

/// @nodoc
abstract mixin class _$PreviewCopyWith<$Res> implements $DocumentScannerStateCopyWith<$Res> {
  factory _$PreviewCopyWith(_Preview value, $Res Function(_Preview) _then) = __$PreviewCopyWithImpl;
@useResult
$Res call({
 XFile imageFile
});




}
/// @nodoc
class __$PreviewCopyWithImpl<$Res>
    implements _$PreviewCopyWith<$Res> {
  __$PreviewCopyWithImpl(this._self, this._then);

  final _Preview _self;
  final $Res Function(_Preview) _then;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imageFile = null,}) {
  return _then(_Preview(
null == imageFile ? _self.imageFile : imageFile // ignore: cast_nullable_to_non_nullable
as XFile,
  ));
}


}

/// @nodoc


class _Processing implements DocumentScannerState {
  const _Processing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Processing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentScannerState.processing()';
}


}




/// @nodoc


class _Error implements DocumentScannerState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DocumentScannerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DocumentScannerStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DocumentScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
