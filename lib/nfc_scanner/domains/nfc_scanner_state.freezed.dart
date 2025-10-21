// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_scanner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NfcScannerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcScannerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NfcScannerState()';
}


}

/// @nodoc
class $NfcScannerStateCopyWith<$Res>  {
$NfcScannerStateCopyWith(NfcScannerState _, $Res Function(NfcScannerState) __);
}


/// Adds pattern-matching-related methods to [NfcScannerState].
extension NfcScannerStatePatterns on NfcScannerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Checking value)?  checking,TResult Function( _Unavailable value)?  unavailable,TResult Function( _Disabled value)?  disabled,TResult Function( _Scanning value)?  scanning,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,TResult Function( _Unsupported value)?  unsupported,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking(_that);case _Unavailable() when unavailable != null:
return unavailable(_that);case _Disabled() when disabled != null:
return disabled(_that);case _Scanning() when scanning != null:
return scanning(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _Unsupported() when unsupported != null:
return unsupported(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Checking value)  checking,required TResult Function( _Unavailable value)  unavailable,required TResult Function( _Disabled value)  disabled,required TResult Function( _Scanning value)  scanning,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,required TResult Function( _Unsupported value)  unsupported,}){
final _that = this;
switch (_that) {
case _Checking():
return checking(_that);case _Unavailable():
return unavailable(_that);case _Disabled():
return disabled(_that);case _Scanning():
return scanning(_that);case _Success():
return success(_that);case _Error():
return error(_that);case _Unsupported():
return unsupported(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Checking value)?  checking,TResult? Function( _Unavailable value)?  unavailable,TResult? Function( _Disabled value)?  disabled,TResult? Function( _Scanning value)?  scanning,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,TResult? Function( _Unsupported value)?  unsupported,}){
final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking(_that);case _Unavailable() when unavailable != null:
return unavailable(_that);case _Disabled() when disabled != null:
return disabled(_that);case _Scanning() when scanning != null:
return scanning(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _Unsupported() when unsupported != null:
return unsupported(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function()?  unavailable,TResult Function()?  disabled,TResult Function()?  scanning,TResult Function( String value)?  success,TResult Function( String message)?  error,TResult Function( Map<String, String> details)?  unsupported,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking();case _Unavailable() when unavailable != null:
return unavailable();case _Disabled() when disabled != null:
return disabled();case _Scanning() when scanning != null:
return scanning();case _Success() when success != null:
return success(_that.value);case _Error() when error != null:
return error(_that.message);case _Unsupported() when unsupported != null:
return unsupported(_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function()  unavailable,required TResult Function()  disabled,required TResult Function()  scanning,required TResult Function( String value)  success,required TResult Function( String message)  error,required TResult Function( Map<String, String> details)  unsupported,}) {final _that = this;
switch (_that) {
case _Checking():
return checking();case _Unavailable():
return unavailable();case _Disabled():
return disabled();case _Scanning():
return scanning();case _Success():
return success(_that.value);case _Error():
return error(_that.message);case _Unsupported():
return unsupported(_that.details);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function()?  unavailable,TResult? Function()?  disabled,TResult? Function()?  scanning,TResult? Function( String value)?  success,TResult? Function( String message)?  error,TResult? Function( Map<String, String> details)?  unsupported,}) {final _that = this;
switch (_that) {
case _Checking() when checking != null:
return checking();case _Unavailable() when unavailable != null:
return unavailable();case _Disabled() when disabled != null:
return disabled();case _Scanning() when scanning != null:
return scanning();case _Success() when success != null:
return success(_that.value);case _Error() when error != null:
return error(_that.message);case _Unsupported() when unsupported != null:
return unsupported(_that.details);case _:
  return null;

}
}

}

/// @nodoc


class _Checking implements NfcScannerState {
  const _Checking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NfcScannerState.checking()';
}


}




/// @nodoc


class _Unavailable implements NfcScannerState {
  const _Unavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NfcScannerState.unavailable()';
}


}




/// @nodoc


class _Disabled implements NfcScannerState {
  const _Disabled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Disabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NfcScannerState.disabled()';
}


}




/// @nodoc


class _Scanning implements NfcScannerState {
  const _Scanning();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scanning);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NfcScannerState.scanning()';
}


}




/// @nodoc


class _Success implements NfcScannerState {
  const _Success(this.value);
  

 final  String value;

/// Create a copy of NfcScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'NfcScannerState.success(value: $value)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $NfcScannerStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of NfcScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_Success(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements NfcScannerState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of NfcScannerState
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
  return 'NfcScannerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NfcScannerStateCopyWith<$Res> {
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

/// Create a copy of NfcScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Unsupported implements NfcScannerState {
  const _Unsupported(final  Map<String, String> details): _details = details;
  

 final  Map<String, String> _details;
 Map<String, String> get details {
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_details);
}


/// Create a copy of NfcScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnsupportedCopyWith<_Unsupported> get copyWith => __$UnsupportedCopyWithImpl<_Unsupported>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unsupported&&const DeepCollectionEquality().equals(other._details, _details));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'NfcScannerState.unsupported(details: $details)';
}


}

/// @nodoc
abstract mixin class _$UnsupportedCopyWith<$Res> implements $NfcScannerStateCopyWith<$Res> {
  factory _$UnsupportedCopyWith(_Unsupported value, $Res Function(_Unsupported) _then) = __$UnsupportedCopyWithImpl;
@useResult
$Res call({
 Map<String, String> details
});




}
/// @nodoc
class __$UnsupportedCopyWithImpl<$Res>
    implements _$UnsupportedCopyWith<$Res> {
  __$UnsupportedCopyWithImpl(this._self, this._then);

  final _Unsupported _self;
  final $Res Function(_Unsupported) _then;

/// Create a copy of NfcScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(_Unsupported(
null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
