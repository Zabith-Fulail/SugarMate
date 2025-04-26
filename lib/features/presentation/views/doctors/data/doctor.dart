class Doctor {
  final String id; // Unique ID for the doctor
  final String name;
  final String specialization;
  final int experience; // in years
  final double rating; // out of 5
  final String profileImageUrl; // For displaying doctor's photo
  final String description; // Short bio or about doctor
  final String email;
  final String phone;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.profileImageUrl,
    required this.description,
    required this.email,
    required this.phone,
  });
}
