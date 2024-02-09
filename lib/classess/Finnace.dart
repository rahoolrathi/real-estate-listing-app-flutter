import 'package:flutter/cupertino.dart';

class Finnace{
  double advanceAmount=0;
  double installmentAmount=0;
  int noOfInstallments=0;
  Finnace(
      );

  Finnace.full({
   required this.advanceAmount,
   required this.installmentAmount,
    required this.noOfInstallments
  });

  factory Finnace.fromMap(Map<String, dynamic> map) {
    return Finnace.full(
      advanceAmount:map['downpayment']!=null? map['downpayment'].toDouble():0.toDouble(),
      installmentAmount: map['installmentAmount']!=null?map['installmentAmount'].toDouble():0,
      noOfInstallments:map['noOfInstallments']!=null?map['noOfInstallments']:0,
    );
  }
  setAdvanceAmount(double d){
    advanceAmount=d;
  }
  setInstallmentAmount(double i){
    installmentAmount=i;
}
  setNoofInstallment(int n){
    noOfInstallments=n;
  }
  Map<String, dynamic> toMap() {
    return {
      'advanceAmount': advanceAmount,
      'installmentAmount':installmentAmount ,
      'noOfInstallments': noOfInstallments,
    };
  }

}