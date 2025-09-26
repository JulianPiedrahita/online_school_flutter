class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String address;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.address,
    this.createdAt,
  });

  // Constructor factory para crear User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'])
        : null,
    );
  }

  // Método para convertir User a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'address': address,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Método para obtener el nombre completo
  String get fullName => '$firstName $lastName';

  // Método copyWith para crear copias modificadas
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? address,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Clase para las credenciales de login
class LoginCredentials {
  final String email;
  final String password;

  LoginCredentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// Clase para el registro de usuario
class RegisterData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String address;
  final String password;
  final String confirmPassword;

  RegisterData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'address': address,
      'password': password,
    };
  }

  // Validación básica
  bool get isValid {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           email.isNotEmpty &&
           phone.isNotEmpty &&
           city.isNotEmpty &&
           address.isNotEmpty &&
           password.isNotEmpty &&
           confirmPassword.isNotEmpty &&
           password == confirmPassword;
  }
}

// Clase para manejar respuestas de Firebase Auth
class FirebaseAuthResponse {
  final String? idToken;
  final String? refreshToken;
  final String? localId; // Firebase UID
  final String? email;
  final String? displayName;
  final bool? emailVerified;
  final String? expiresIn;
  final bool? registered;

  FirebaseAuthResponse({
    this.idToken,
    this.refreshToken,
    this.localId,
    this.email,
    this.displayName,
    this.emailVerified,
    this.expiresIn,
    this.registered,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) {
    return FirebaseAuthResponse(
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
      localId: json['localId'],
      email: json['email'],
      displayName: json['displayName'],
      emailVerified: json['emailVerified'] == true || json['emailVerified'] == 'true',
      expiresIn: json['expiresIn'],
      registered: json['registered'] == true || json['registered'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'refreshToken': refreshToken,
      'localId': localId,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'expiresIn': expiresIn,
      'registered': registered,
    };
  }
}

// Clase para manejar errores de Firebase
class FirebaseAuthError {
  final String code;
  final String message;
  final List<FirebaseErrorDetail> errors;

  FirebaseAuthError({
    required this.code,
    required this.message,
    this.errors = const [],
  });

  factory FirebaseAuthError.fromJson(Map<String, dynamic> json) {
    final errorData = json['error'] ?? json;
    return FirebaseAuthError(
      code: (errorData['code'] ?? 400).toString(),
      message: errorData['message'] ?? 'Unknown error',
      errors: (errorData['errors'] as List?)
          ?.map((e) => FirebaseErrorDetail.fromJson(e))
          .toList() ?? [],
    );
  }
}

// Detalle de errores específicos de Firebase
class FirebaseErrorDetail {
  final String domain;
  final String reason;
  final String message;

  FirebaseErrorDetail({
    required this.domain,
    required this.reason,
    required this.message,
  });

  factory FirebaseErrorDetail.fromJson(Map<String, dynamic> json) {
    return FirebaseErrorDetail(
      domain: json['domain'] ?? 'global',
      reason: json['reason'] ?? 'unknown',
      message: json['message'] ?? 'Unknown error',
    );
  }
}