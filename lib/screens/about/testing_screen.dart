import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Palette.darkBlue,
            size: 28.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ScreenTitle(title: 'Testiranje'),
                SizedBox(height: 24.0),
                AboutParagraph(
                    text:
                        'Testiranje se provodi na temelju uputnice liječnika obiteljske medicine, epidemiologa ili uputnice liječnika specijaliste te se tada ne plaća. Termin testiranja ovisi o datumu za koji je nalaz potreban.\nUkoliko imate uputnicu naručujete se na testiranje preko e-maila: covid@hzjz.hr'),
                SizedBox(height: 12.0),
                AboutParagraph(
                    text:
                        'Ako nemate uputnicu, testiranje je moguće na osobni zahtjev uz plaćanje. U tom slučaju možete se naručiti na ovoj aplikaciji. U slučaju osobnog zahtjeva, preporučamo avansno plaćanje Internet bankarstvom ili uplatnicom.'),
                SizedBox(height: 12.0),
                AboutParagraph(text: 'Cijena PCR testa je 390,00 kn.'),
                SizedBox(height: 12.0),
                AboutParagraph(
                    text: 'Cijena brzog antigenskog testa je 150,00 kn.'),
                SizedBox(height: 12.0),
                AboutParagraph(
                    text:
                        'Cijena kompletnog prijevoda nalaza na engleski jezik je 125,00 kn.'),
                SizedBox(height: 12.0),
                AboutParagraph(
                    text:
                        'Plaćanje je moguće karticom (VISA, MAESTRO, MASTERCARD), avansnim plaćanjem Internet bankarstvom ili uplatnicom.'),
                SizedBox(height: 12.0),
                AboutParagraph(
                    text:
                        'Nalaze dostavljamo e-mailom za PCR test u roku od 24 sata, a za antigenski test u najkraćem mogućem roku.'),
                SizedBox(height: 24.0),
                AboutParagraph(
                    text:
                        'Uzimanje uzoraka provodi se po principu DRIVE-IN ispred montažnog objekta u dvorištu Hrvatskog zavoda za javno zdravstvo, Rockefellerova 2, svakog radnog dana od 7.30 – 9.30 sati te subotom od 8.00 – 10.00 sati. Objekt je smješten na prvom kolnom ulazu desno nakon ulaska u Rockefellerovu ulicu (vidjeti sliku). Ukoliko dolazite automobilom stanite ispred rampe i pričekajte ulaz, nakon ulaska parkirajte se ispod šatora te ugasite vozilo. Ne izlazite iz automobila. Ako dolazite pješke, potražite kolni ulaz i šator kod zgrade u Rockefellerovoj 2. Na testiranje je potrebno doći S MASKOM.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
