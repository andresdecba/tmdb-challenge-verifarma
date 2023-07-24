import 'package:flutter/material.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/custom_textfield.dart';

class Years extends StatefulWidget {
  const Years({
    super.key,
    required this.fromYearCtlr,
    required this.toYearCtlr,
    required this.yearCtlr,
  });

  final TextEditingController fromYearCtlr;
  final TextEditingController toYearCtlr;
  final TextEditingController yearCtlr;

  @override
  State<Years> createState() => _YearsState();
}

class _YearsState extends State<Years> {
  late GlobalKey<FormState> yearsFormStateKey;

  @override
  void initState() {
    super.initState();
    yearsFormStateKey = GlobalKey<FormState>();
  }

  bool isYearDisable = false;
  bool isRangeDisable = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // UN AÑO //
          const Text(
            'Buscar por un año en particular',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            txtController: widget.yearCtlr,
            keyboardType: TextInputType.number,
            leading: const Icon(Icons.numbers),
            hintText: 'ej: 2012',
            onTap: () {
              setState(() {
                isYearDisable = false;
                isRangeDisable = true;
                widget.fromYearCtlr.clear();
                widget.toYearCtlr.clear();
              });
            },
          ),
          const SizedBox(height: 20),

          // RANGO DE AÑOS //
          const Text(
            'Buscar por un rango de años',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        'desde:',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    CustomTextField(
                      txtController: widget.fromYearCtlr,
                      keyboardType: TextInputType.number,
                      leading: const Icon(Icons.numbers),
                      hintText: 'ej: 2002',
                      onTap: () {
                        setState(() {
                          isYearDisable = true;
                          isRangeDisable = false;
                          widget.yearCtlr.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        'hasta:',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    CustomTextField(
                      txtController: widget.toYearCtlr,
                      keyboardType: TextInputType.number,
                      leading: const Icon(Icons.numbers),
                      hintText: 'ej: 2012',
                      onTap: () {
                        setState(() {
                          isYearDisable = true;
                          isRangeDisable = false;
                          widget.yearCtlr.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
