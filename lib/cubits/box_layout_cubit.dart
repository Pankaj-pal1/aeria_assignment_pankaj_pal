import 'package:assignment_aeria/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/box_model.dart';

part 'box_layout_state.dart';

class BoxLayoutCubit extends Cubit<BoxLayoutState> {
  BoxLayoutCubit() : super(BoxLayoutInitial());
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? errorText;
  int n = 0;
  List<BoxData> boxes = [];
  List<int> clickOrder = [];
  bool isReverting = false;





  void generateBoxes() {
    focusNode.unfocus();
    final String inputText = controller.text;
    if (inputText.isEmpty) {
      errorText = 'Please enter a number.';
      n = 0;
      boxes = [];
      clickOrder = [];
      emit(BoxLayoutInitial());
      return;
    }

    final int? parsedN = int.tryParse(inputText);
    if (parsedN == null) {
      errorText = 'Please enter a valid integer.';
      n = 0;
      boxes = [];
      clickOrder = [];
      emit(BoxLayoutInitial());
      return;
    }

    if (parsedN < 5 || parsedN > 25) {
      errorText = 'Number must be between 5 and 25.';
      n = 0;
      boxes = [];
      clickOrder = [];
      emit(BoxLayoutInitial());
      return;
    }

    errorText = null;
    n = parsedN;
    isReverting = false;
    clickOrder = [];
    boxes = List.generate(n, (index) => BoxData(id: index, color: Colors.red));
    emit(BoxLayoutInitial());
  }



  void onBoxTap(int index) {
    if (isReverting || boxes[index].color == Colors.green) return;

    boxes[index].color = Colors.green;
    clickOrder.add(index);
    emit(BoxLayoutInitial());

    if (clickOrder.length == n) {
      startReverting();
    }
  }



  void startReverting() async {
    showMessage();
    isReverting = true;
    emit(BoxLayoutInitial());
    List<int> reverseClickOrder = List.from(clickOrder.reversed);
    for (int boxIndex in reverseClickOrder) {
      await Future.delayed(const Duration(seconds: 1));
      boxes[boxIndex].color = Colors.red;
      emit(BoxLayoutInitial());
    }
    isReverting = false;
    clickOrder.clear(); // Clear click order for the next cycle
    emit(BoxLayoutInitial());
  }

  showMessage(){
    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
      SnackBar(
        content: Text('Reverting your Taps after every 1 second'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(navigatorKey.currentState!.context).clearSnackBars();
          },
        ),
      ),
    );

  }


}
