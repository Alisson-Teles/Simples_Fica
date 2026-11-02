import 'package:flutter/material.dart';

import '../../models/negocio_demo.dart';
import 'business_registration_view.dart';

class EditBusinessView extends StatelessWidget {
  final NegocioDemo negocio;

  const EditBusinessView({super.key, required this.negocio});

  @override
  Widget build(BuildContext context) {
    return BusinessFormView(negocio: negocio);
  }
}