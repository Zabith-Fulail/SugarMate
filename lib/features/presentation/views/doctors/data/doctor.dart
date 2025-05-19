// class Doctor {
//   final String id; // Unique ID for the doctor
//   final String name;
//   final String specialization;
//   final int experience; // in years
//   final double rating; // out of 5
//   final String profileImageUrl; // For displaying doctor's photo
//   final String description; // Short bio or about doctor
//   final String email;
//   final String phone;
//
//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     required this.experience,
//     required this.rating,
//     required this.profileImageUrl,
//     required this.description,
//     required this.email,
//     required this.phone,
//   });
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String specialization;
  final String qualifications;
  final String email;
  final String mobile;
  final List<String> hospitals;
  final List<String> chanellingCentres;
  final String image;
  final int experience;

  Doctor({
    required this.name,
    required this.specialization,
    required this.qualifications,
    required this.email,
    required this.mobile,
    required this.hospitals,
    required this.chanellingCentres,
    required this.image,
    required this.experience,
  });

  @override
  String toString() {
    return 'Doctor{name: $name, qualifications: $qualifications, email: $email, mobile: $mobile, hospitals: $hospitals, chanellingCentres: $chanellingCentres, image: $image}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // 'specialization': specialization,
      'qualifications': qualifications,
      'email': email,
      'mobile': mobile,
      'hospitals': hospitals,
      'chanellingCentres': chanellingCentres,
      'image': image,
    };
  }
  factory Doctor.fromFirestore(Map<String, dynamic> data) {
    return Doctor(
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      qualifications: data['qualifications'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      hospitals: List<String>.from(data['hospitals'] ?? []),
      chanellingCentres: List<String>.from(data['chanellingCentres'] ?? []),
      image: data['image'] ?? '',
      experience: data['experience'] ?? 0,
    );
  }
  Future<void> uploadDoctorsToFirestore(List<Doctor> doctors) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference doctorCollection =
        firestore.collection('doctors');

    for (Doctor doctor in doctors) {
      try {
        await doctorCollection.add({
          'name': doctor.name,
          // 'specialization': doctor.specialization,
          'qualifications': doctor.qualifications,
          'email': doctor.email,
          'mobile': doctor.mobile,
          'hospitals': doctor.hospitals,
          'chanellingCentres': doctor.chanellingCentres,
          'image': doctor.image,
          // 'experience': doctor.experience,
        });
        print('Uploaded: ${doctor.name}');
      } catch (e) {
        print('Failed to upload ${doctor.name}: $e');
      }
    }
  }
}

///list of doctors to add manually
// allDoctors.addAll([
//   Doctor(
//     name: "Dr Dimuthu Muthukuda",
//     specialization: "Consultant Endocrinologist and Diabetologist",
//     qualifications: "MBBS, MD, MRCP, FACE, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Sri Jayewardenepura General Hospital(https://maps.app.goo.gl/qgUKSYAMNDGBiZvF6?g_st=com.google.maps.preview.copy), Sri Jayewardenepura",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Hemas Hospital - Thalawathugoda(https://maps.app.goo.gl/z1QLB1mXvHrgfvFM9?g_st=com.google.maps.preview.copy), Thalawathugoda",
//       "", "", "", "", "", "", "", "", "", "", "", ""
//     ],
//     chanellingCentres: [
//       "https://sjgh.health.gov.lk/channeling.php?doctorname=&specificity=89&search=",
//       "https://endocrinesl.org/dr-dimuthu-muthukuda/",
//       "", "", "", ""
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dimuthu-madam.jpg", experience: 2, rating: 3,
//   ),
//   Doctor(
//     name: "Dr Noel Somasundaram",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, FRCP, FCCP, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Nawaloka Elite Centre - Colombo 02(https://maps.app.goo.gl/WM1r91Uo5FwHQn9o6?g_st=com.google.maps.preview.copy), Colombo 02",
//       "", "", "", "", "", "", "", "", "", "", "", ""
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-noel-somasundaram/",
//       "https://www.doc.lk/channel/5300?doctor=&hospital=70&specialization=0&date=&gad_source=1&gbraid=0AAAAAqDOdRj1IVHjyvRH0t2OirVmHIpVp&gclid=EAIaIQobChMI2M7Xob_3jAMVQyeDAx33ghbgEAAYAiAAEgJNM_D_BwE",
//       "", "", "", ""
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2022/12/Image.jpg", experience: 2, rating: 3,
//   ),
//   Doctor(
//     name: "Prof. Prasad Katulanda",
//     specialization: "Hon. Consultant Endocrinologist",
//     qualifications: "MBBS, MD, DPhil(Oxford), FSLCE",
//     email: "prasad.katulanda@clinmed.cmb.ac.lk",
//     mobile: "0112 679 204, 0112 883 422",
//     hospitals: [
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "CDEM Hospital - Norris Canal Road - Colombo 10(https://maps.app.goo.gl/NTdbNB6fK8Do1BkS7?g_st=com.google.maps.preview.copy), Colombo 10",
//       "CDEM - Kadawatha(https://maps.app.goo.gl/J9LP7R98hwseQAMF9?g_st=com.google.maps.preview.copy), Kadawatha",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Nawaloka Elite Centre - Colombo 02(https://maps.app.goo.gl/WM1r91Uo5FwHQn9o6?g_st=com.google.maps.preview.copy), Colombo 02",
//       "", "", "", "", "", "", "", "", ""
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/vidya-jyothi-prof-prasad-katulanda/",
//       "https://www.res.cmb.ac.lk/medicine/prasad-katulanda/",
//       "", "", "", ""
//     ],
//     image: "https://www.res.cmb.ac.lk/medicine/prasad-katulanda/wp-content/uploads/sites/183/2022/02/02-a.jpg",
//     experience: 28,
//     rating: 4.9,
//   ),
//   Doctor(
//     name: "Dr Uditha Bulugahapitiya",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, FCCP, FRCP, FACE, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Aayu by Nawaloka Care PREMIER - Colombo 07(https://maps.app.goo.gl/QPpati8pYNiwNize9?g_st=com.google.maps.preview.copy), Colombo 07",
//       "Asiri Medical Hospital - Kirula Road - Colombo 05(https://maps.app.goo.gl/7LCucgwY6NXbRUM99?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Kings Hospital - Colombo 05(https://maps.app.goo.gl/qRo8ACYFd4qpEf5g7?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Nawaloka Elite Centre - Colombo 02(https://maps.app.goo.gl/WM1r91Uo5FwHQn9o6?g_st=com.google.maps.preview.copy), Colombo 02",
//       "", "", "", "", "", "", "", "", ""
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-uditha-bulugahapitiya/",
//       "https://www.doc.lk/channel/4910?",
//       "", "", "", ""
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2024/03/Dr-Uditha.jpg",
//     experience: 25,
//     rating: 4.7,
//   ),
//   Doctor(
//     name: "Dr Sajith Siyambalapitiya",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP, FRCP, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Hemas Hospital - Wattala(https://maps.app.goo.gl/BjUkRqY45zNrQ7dX8?g_st=com.google.maps.preview.copy), Wattala",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "", "", "", "", "", "", "", "", "", "", "", "", ""
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-sajith-siyambalapitiya/",
//       "https://www.doc.lk/channel/7812?",
//       "", "", "", ""
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Sajith.jpg",
//     experience: 18,
//     rating: 4.5,
//   ),
//   Doctor(
//     name: "Dr Charles Antonypillai",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP, FSLCE",
//     email: "",
//     mobile: "077 799 0990, 081 777 0700",
//     hospitals: [
//       "Asiri Hospital - Kandy(https://maps.app.goo.gl/jG9b4uYgPXz2gVt39), Kandy",
//     ],
//     chanellingCentres: [
//       "Channeled Consultation Center - Kandy(https://maps.app.goo.gl/w3bFUfyUYhziZWLL8), Kandy",
//       "https://endocrinesl.org/dr-charles-anthonypillai/",
//       "https://www.doc.lk/channel/10233?doctor=&hospital=86&specialization=0&date=",
//       "https://lankadoctor.com/specialist/specialist-2/endocrinologist.php"
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-CHarles.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Manilka Sumanatilleke",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP, FRCP, FACE, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Aayu by Nawaloka Care PREMIER - Colombo 07(https://maps.app.goo.gl/QPpati8pYNiwNize9?g_st=com.google.maps.preview.copy), Colombo 07",
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Asiri Hospital - Galle(https://maps.app.goo.gl/2CWvq1d3hnr5fX9x7), Galle",
//       "Asiri Medical Hospital - Kirula Road - Colombo 05(https://maps.app.goo.gl/7LCucgwY6NXbRUM99?g_st=com.google.maps.preview.copy), Colombo 05",
//       "CDEM Hospital - Norris Canal Road - Colombo 10(https://maps.app.goo.gl/NTdbNB6fK8Do1BkS7?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "GALLE CO-OPERATIVE HOSPITAL LTD(https://maps.app.goo.gl/99rhhy51wzLpqGxz9), Galle",
//       "Hemas Hospital - Thalawathugoda(https://maps.app.goo.gl/z1QLB1mXvHrgfvFM9?g_st=com.google.maps.preview.copy), Thalawathugoda",
//       "Kings Hospital - Colombo 05(https://maps.app.goo.gl/qRo8ACYFd4qpEf5g7?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Medihelp Wellness Centre - Colombo 07(https://maps.app.goo.gl/qgsfB1BJ62n6vDbu8), Colombo 07",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Ninewells Family Wellness - Colombo 07(https://maps.app.goo.gl/8Kg1rjprpW9zgqZ47), Colombo 07",
//       "Queensbury Hospitals (Pvt) Ltd - Galle(https://maps.app.goo.gl/Ba9XQFnvYtd92rUMA), Galle",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-manilka-sumanatilleke/",
//       "https://www.echannelling.com/doctor-search/D1215?gad_source=1&gbraid=0AAAAA9hcKs47Fk0I1pPjqNtj-fOl8bAnY&gclid=EAIaIQobChMI6qGU1s73jAMVFsc8Ah2F_jyYEAAYASAAEgLJS_D_BwE",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-manilka.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Chaminda Garusinghe",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP, FACE, FSLCE",
//     email: "",
//     mobile: "011 550 6000",
//     hospitals: [
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Asiri Medical Hospital - Kirula Road - Colombo 05(https://maps.app.goo.gl/7LCucgwY6NXbRUM99?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Asiri Surgical Hospital - Kirimandala Mw - Colombo 05(https://maps.app.goo.gl/BJUWzZpbdsJpVSPt7), Colombo 05",
//       "Blue Cross Hospital - Rajagiriya(https://maps.app.goo.gl/Pk5onhTRwAuzGkUC8), Rajagiriya",
//       "Ceymed Healthcare Services (Pvt) Ltd - Nugegoda(https://maps.app.goo.gl/B2Awm8nZbqbtfK5S6), Nugegoda",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Hemas Hospital - Thalawathugoda(https://maps.app.goo.gl/z1QLB1mXvHrgfvFM9?g_st=com.google.maps.preview.copy), Thalawathugoda",
//       "K M G Suwasewa Hospital - Hettipola(https://maps.app.goo.gl/GfTV18h7GT4waYeV9), Hettipola",
//       "Kings Hospital - Colombo 05(https://maps.app.goo.gl/qRo8ACYFd4qpEf5g7?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Medihelp Hospitals - Moratuwa(https://maps.app.goo.gl/od7mvXEt8K2zqX6QA), Moratuwa",
//       "Medihelp Hospitals - Piliyandala(https://maps.app.goo.gl/ss9nTRd8nSGqDxc29), Piliyandala",
//       "Medihelp Wellness Centre - Colombo 07(https://maps.app.goo.gl/qgsfB1BJ62n6vDbu8), Colombo 07",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Nawaloka Hospital - Negombo(https://maps.app.goo.gl/U3pQYuyPDKrvKJ2r7), Negombo",
//       "New Delmon Hospital - Colombo 06(https://maps.app.goo.gl/LFV49dKCC1Na2vycA), Colombo 06",
//       "Sushila Healthcare - Panadura(https://maps.app.goo.gl/Hk6SNGgZ4Q4i2Qqi9), Panadura",
//       "Suwa Piyasa Medical Centre - Narammala(https://maps.app.goo.gl/X8fzHH8FGyU2n6fF9), Narammala",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-chaminda-garusinghe/",
//       "https://www.echannelling.com/doctor-search/D4853",
//       "https://lankadoctor.com/specialist/specialist-2/endocrinologist.php",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Chaminda.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Niranjala Meegoda Widanege",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP, FSLCE",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Ceymed Healthcare Services (Pvt) Ltd - Nugegoda(https://maps.app.goo.gl/B2Awm8nZbqbtfK5S6), Nugegoda",
//       "Dr Neville Fernando Teaching Hospital - Malabe(https://maps.app.goo.gl/yqMqL79duPabMMYr6), Malabe",
//       "Hemas Hospital - Wattala(https://maps.app.goo.gl/6c8jVmMs6RbL56XVA), Wattala",
//       "Hemas Hospital - Thalawathugoda(https://maps.app.goo.gl/z1QLB1mXvHrgfvFM9?g_st=com.google.maps.preview.copy), Thalawathugoda",
//       "Kings Hospital - Colombo 05(https://maps.app.goo.gl/qRo8ACYFd4qpEf5g7?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Medihelp Hospitals - Bandaragama(https://maps.app.goo.gl/9rnny5TbnHVqAmDA7), Bandaragama",
//       "Medihelp Hospitals - Horana(https://maps.app.goo.gl/rWEXRCGqP8aAACZY9), Horana",
//       "Medihelp Hospitals - Piliyandala(https://maps.app.goo.gl/ss9nTRd8nSGqDxc29), Piliyandala",
//       "Medihelp Hospitals - Ingiriya(https://maps.app.goo.gl/DtnYmjfgtCeXbFmW7), Ingiriya",
//       "Medihelp Wellness Centre - Colombo 07(https://maps.app.goo.gl/qgsfB1BJ62n6vDbu8), Colombo 07",
//       "Mount Lotus Eye and ENT Hospital - Mount Lavinia(https://maps.app.goo.gl/aBzcZ4ShKeHLGGGaA), Mount Lavinia",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Ninewells Hospital - Colombo 05(https://maps.app.goo.gl/AfSKJ87EqdJRtShQ8), Colombo 05",
//       "Winlanka Hospital - Kohuwala(https://maps.app.goo.gl/CfgZUjGpT7gbKWPN7), Kohuwala",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-niranjala-meegoda-widanege/",
//       "https://www.echannelling.com/doctor-search/D1834",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Niranjala.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Navoda Atapattu",
//     specialization: "Consultant Paediatric Endocrinologist",
//     qualifications: "MBBS, MD, DCH, MRCPCH, FRCPCH",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "Ninewells Hospital - Colombo 05(https://maps.app.goo.gl/AfSKJ87EqdJRtShQ8), Colombo 05",
//       "Joseph Fraser Ninewells - Colombo 05(https://maps.app.goo.gl/csrjutZRCbVxyDiR6), Colombo 05",
//       "Lady Ridgeway Hospital for Children (LRH) - Colombo 08(https://maps.app.goo.gl/9BsSniv83q3j2fqHA), Colombo 08",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-navoda-atapattu/",
//       "https://www.echannelling.com/doctor-search/D4362",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2024/05/Dr-Navoda.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Muditha Indumali Weerakkody",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP(UK)",
//     email: "",
//     mobile: "",
//     hospitals: [
//       "Asiri Central Hospital - Norris Canal Road-Colombo 10(https://maps.app.goo.gl/45ZV3SRfx5tveF969?g_st=com.google.maps.preview.copy), Colombo 10",
//       "Asiri Hospital - Galle(https://maps.app.goo.gl/2CWvq1d3hnr5fX9x7), Galle",
//       "GALLE CO-OPERATIVE HOSPITAL LTD(https://maps.app.goo.gl/99rhhy51wzLpqGxz9), Galle",
//       "Queensbury Hospitals (Pvt) Ltd - Galle(https://maps.app.goo.gl/Ba9XQFnvYtd92rUMA), Galle",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-muditha-weerakkody/",
//       "https://www.echannelling.com/doctor-search/D4880",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Muditha.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Karuppiah Dharshini",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP(UK)",
//     email: "",
//     mobile: "065 222 3642",
//     hospitals: [
//       "Co-Op Hospital - Eravur(https://maps.app.goo.gl/a9s6P2tkjVgsXJrH6), Eravur",
//       "Habeeba Medical Center - Kattankudy 01(https://maps.app.goo.gl/kn3Lc8U2UytV3rw67), Kattankudy 01",
//       "New Pioneer Hospital - Kalmunai(https://maps.app.goo.gl/ZUdLDVrqmCd6T4Zr6), Kalmunai",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-dharshini-karuppiah/",
//       "https://www.echannelling.com/doctor-search/D4326",
//       "https://lankadoctor.com/specialist/specialist-2/endocrinologist.php",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Karuppiah.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Sivathrshya Pathmanathan",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD",
//     email: "",
//     mobile: "034 222 2888",
//     hospitals: [
//       "My Clinic By Hemas Hospitals - Wellawatta(https://maps.app.goo.gl/vhbjRZk1aZaFp4FC8), Wellawatte",
//       "Ceymed Healthcare Services (Pvt) Ltd - Nugegoda(https://maps.app.goo.gl/B2Awm8nZbqbtfK5S6), Nugegoda",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Hemas Hospital - Wattala(https://maps.app.goo.gl/6c8jVmMs6RbL56XVA), Wattala",
//       "Lanka Hospitals - Colombo 05(https://maps.app.goo.gl/s9jkpjfTJcXf1Ps17?g_st=com.google.maps.preview.copy), Colombo 05",
//       "Medihelp Hospitals - Kohuwala(https://maps.app.goo.gl/aBDg6jFAkPzLxp9b7), Kohuwala",
//       "Nawaloka Hospital - Colombo 02(https://maps.app.goo.gl/3RL53aqgSmweJyvf8?g_st=com.google.maps.preview.copy), Colombo 02",
//       "New Philip Hospitals - Kalutara(https://maps.app.goo.gl/9oYPzMNhvmoQeiBs7), Kalutara",
//       "Joseph Fraser Ninewells - Colombo 05(https://maps.app.goo.gl/csrjutZRCbVxyDiR6), Colombo 05",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-sivatharshya-pathmanathan/",
//       "https://www.doc.lk/channel/6832?",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Dharshi.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
//   Doctor(
//     name: "Dr Shaminda Kahandawa",
//     specialization: "Consultant Endocrinologist",
//     qualifications: "MBBS, MD, MRCP",
//     email: "",
//     mobile: "011 214 0000",
//     hospitals: [
//       "Arogya Hospital - Gampaha(https://maps.app.goo.gl/uhkKL7WWsadVoxUp6), Gampaha",
//       "Durdans Hospital - Colombo - 03(https://maps.app.goo.gl/XkYbP72kirb6PXxaA?g_st=com.google.maps.preview.copy), Colombo - 03",
//       "Gampaha Co-Operative Hospital Society Ltd - Gampaha(https://maps.app.goo.gl/UjYpzT3vo3B75G7GA), Gampaha",
//       "Nawaloka Medicare - Gampaha(https://maps.app.goo.gl/GoTx3BmNz2fLqUUP9), Gampaha",
//       "Hemas Hospital - Wattala(https://maps.app.goo.gl/6c8jVmMs6RbL56XVA), Wattala",
//       "Esse Hospital - Kadawatha(https://maps.app.goo.gl/5BgBdLQMkD4Y4fSWA), Kadawatha",
//     ],
//     chanellingCentres: [
//       "https://endocrinesl.org/dr-shyaminda-kahandawa/",
//       "https://www.echannelling.com/doctor-search/D3953",
//     ],
//     image: "https://endocrinesl.org/wp-content/uploads/2023/01/Dr-Kahadawa.jpg",
//     experience: 0, // Update experience based on available information
//     rating: 0, // Update rating based on available information
//   ),
// ]);
