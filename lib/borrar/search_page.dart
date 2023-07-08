// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tmdb_challenge/movies/presentation/providers/seach_movies_provider.dart';

// class SearchPage extends ConsumerStatefulWidget {
//   const SearchPage({super.key});

//   @override
//   SearchPageState createState() => SearchPageState();
// }

// class SearchPageState extends ConsumerState<SearchPage> {
//   late TextEditingController keywordCtlr;
//   late TextEditingController fromYearCtlr;
//   late TextEditingController toYearCtlr;
//   late TextEditingController peopleCtlr;
//   late TextEditingController yearCtlr;

//   late GlobalKey<FormState> searchFormStateKey;

//   @override
//   void initState() {
//     super.initState();
//     keywordCtlr = TextEditingController();
//     fromYearCtlr = TextEditingController();
//     toYearCtlr = TextEditingController();
//     peopleCtlr = TextEditingController();
//     yearCtlr = TextEditingController();
//     searchFormStateKey = GlobalKey<FormState>();
//   }

//   DateTimeRange dateRange = DateTimeRange(
//     start: DateTime.now(),
//     end: DateTime.now().add(const Duration(days: 2)),
//   );

//   @override
//   Widget build(BuildContext context) {
//     var provider = ref.read(advancedSearchAsyncProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(title: const Text('search page')),

//       floatingActionButton: FloatingActionButton(onPressed: () {
//         provider.getData(
//           fromYear: fromYearCtlr.text,
//           keyword: keywordCtlr.text,
//           selectedCategories: ref.read(selectedCategProvider),
//           toYear: toYearCtlr.text,
//           year: yearCtlr.text,
//         );
//       }),

//       //
//       body: Form(
//         key: searchFormStateKey,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //
//               // KEYWORD
//               TextFormField(
//                 controller: keywordCtlr,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: _inputDecoration(
//                   labelText: 'Palabra clave',
//                   hintText: 'ej: "El padrino"',
//                   sufixIcon: Icons.clear_rounded,
//                   onTap: () => keywordCtlr.clear(),
//                 ),
//                 validator: (value) {
//                   if (value != null) {
//                     return 'Ingrese un valor';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),

//               // PERSONA
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: peopleCtlr,
//                 keyboardType: TextInputType.text,
//                 decoration: _inputDecoration(
//                   labelText: 'Persona',
//                   hintText: 'Christopher Nolan',
//                   sufixIcon: Icons.clear_rounded,
//                   onTap: () => keywordCtlr.clear(),
//                 ),
//                 validator: (value) => value != null ? 'Ingrese un valor' : null,
//               ),

//               // UN SOLO AÑO
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 child: Text('Buscar por un año en particular'),
//               ),
//               TextFormField(
//                 controller: yearCtlr,
//                 keyboardType: TextInputType.number,
//                 decoration: _inputDecoration(
//                   labelText: 'Año',
//                   hintText: 'ej: 1994',
//                   sufixIcon: Icons.clear_rounded,
//                   onTap: () => keywordCtlr.clear(),
//                 ),
//                 validator: (value) => value != null ? 'Ingrese un valor' : null,
//               ),

//               // DATES RANGE
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 child: Text('Buscar por un rango de años'),
//               ),
//               Row(
//                 children: [
//                   Flexible(
//                     child: TextFormField(
//                       controller: fromYearCtlr,
//                       keyboardType: TextInputType.number,
//                       decoration: _inputDecoration(
//                         labelText: 'Desde el año',
//                         hintText: 'ej: 2005',
//                         sufixIcon: Icons.clear_rounded,
//                         onTap: () => keywordCtlr.clear(),
//                       ),
//                       validator: (value) => value != null ? 'Ingrese un valor' : null,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Flexible(
//                     child: TextFormField(
//                       controller: toYearCtlr,
//                       keyboardType: TextInputType.number,
//                       decoration: _inputDecoration(
//                         labelText: 'Hasta el año',
//                         hintText: 'ej: 2010',
//                         sufixIcon: Icons.clear_rounded,
//                         onTap: () => keywordCtlr.clear(),
//                       ),
//                       validator: (value) => value != null ? 'Ingrese un valor' : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String labelText,
//     required String hintText,
//     required VoidCallback onTap,
//     required IconData sufixIcon,
//   }) {
//     const double radius = 5;
//     return InputDecoration(
//       // regular borders
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.cyan.shade800, width: 1),
//         borderRadius: const BorderRadius.all(Radius.circular(radius)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.cyan.shade800, width: 1),
//         borderRadius: const BorderRadius.all(Radius.circular(radius)),
//       ),
//       // error borders
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//         borderRadius: const BorderRadius.all(Radius.circular(radius)),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//         borderRadius: const BorderRadius.all(Radius.circular(radius)),
//       ),
//       // other properties
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//       labelText: labelText,
//       hintText: hintText,
//       suffixIcon: IconButton(
//         onPressed: () => onTap(),
//         icon: Icon(sufixIcon),
//       ),
//     );
//   }
// }
