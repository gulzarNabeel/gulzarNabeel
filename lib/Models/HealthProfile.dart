
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

enum DiabetesType{
  Type1,Type2,Gestational,PreDiabetic,None
}

class HealthProfile {
  DiabetesType type = DiabetesType.None;
  DateTime? startedYearDiab;
  bool hyperTension = false;
  DateTime? startedYearBP;
  bool nephroPathy = false;
  DateTime? startedYearNephro;
  bool retinopthy = false;
  DateTime? startedYearRetina;
  bool cardioPathy = false;
  DateTime? startedYearCardio;
  bool neuropathy = false;
  DateTime? startedYearNeuro;


  HealthProfile(this.type,this.startedYearDiab,this.hyperTension,this.startedYearBP,this.nephroPathy,this.startedYearNephro,this.retinopthy,this.startedYearRetina,this.cardioPathy,this.startedYearCardio,this.neuropathy,this.startedYearNeuro);


  updateData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('UsersHealth');
    FirebaseAuth auth = FirebaseAuth.instance;
    String formattedDateDiab = startedYearDiab == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearDiab!);
    String formattedDateBP = startedYearBP == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearBP!);
    String formattedDateNephro = startedYearNephro == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearNephro!);
    String formattedDateCardio = startedYearCardio == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearCardio!);
    String formattedDateRetina = startedYearRetina == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearRetina!);
    String formattedDateNeuro = startedYearNeuro == null ? '' : DateFormat('yyyy-MM-dd').format(startedYearNeuro!);

    users.doc(auth.currentUser?.uid).set({
      'type': type.name,
      'startedYearDiab': formattedDateDiab,
      'hyperTension': hyperTension,
      'startedYearBP': formattedDateBP,
      'nephroPathy': nephroPathy,
      'startedYearNephro': formattedDateNephro,
      'retinopthy' : retinopthy,
      'startedYearRetina' : formattedDateRetina,
      'cardioPathy' : cardioPathy,
      'startedYearCardio' : formattedDateCardio,
      'neuropathy' : neuropathy,
      'startedYearNeuro' : formattedDateNeuro
    }).then((_) {
      Map<String, dynamic> document = {
        'type': type.name,
        'startedYearDiab': formattedDateDiab,
        'hyperTension': hyperTension,
        'startedYearBP': formattedDateBP,
        'nephroPathy': nephroPathy,
        'startedYearNephro': formattedDateNephro,
        'retinopthy' : retinopthy,
        'startedYearRetina' : formattedDateRetina,
        'cardioPathy' : cardioPathy,
        'startedYearCardio' : formattedDateCardio,
        'neuropathy' : neuropathy,
        'startedYearNeuro' : formattedDateNeuro
      };
      Utility().saveUserHealthData(document);
    });
  }
}