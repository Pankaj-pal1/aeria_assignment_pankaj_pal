import 'package:assignment_aeria/cubits/box_layout_cubit.dart';
import 'package:assignment_aeria/services/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import '../custom_widget/box_container_widget.dart';

class BoxScreen extends StatefulWidget {
  const BoxScreen({super.key});

  @override
  State<BoxScreen> createState() => _BoxScreenState();
}

class _BoxScreenState extends State<BoxScreen> {
  late final _cubitInstance;
  double boxGap = 5.0;

  @override
  void initState() {
    _cubitInstance = getIt<BoxLayoutCubit>();

    super.initState();

  }

  @override
  void dispose() {
    _cubitInstance.controller.dispose();
    _cubitInstance.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BoxLayoutCubit, BoxLayoutState>(
      builder: (BuildContext context, BoxLayoutState state) {
        if (state is BoxLayoutInitial) {
          return Scaffold(
            appBar: AppBar(title: const Text('C Box Layout')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _cubitInstance.controller,
                    focusNode: _cubitInstance.focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Enter N (5-25)',
                      hintText: 'e.g., 8',
                      errorText: _cubitInstance.errorText,
                      suffixIcon: IconButton(icon: const Icon(Icons.play_arrow), onPressed: _cubitInstance.generateBoxes, tooltip: 'Generate Boxes'),
                    ),
                    onSubmitted: (_) => _cubitInstance.generateBoxes(),
                  ),
                  const SizedBox(height: 20),
                  if (_cubitInstance.n > 0)
                    Expanded(
                      child: BoxContainer(
                        n: _cubitInstance.n,
                        boxes: _cubitInstance.boxes,
                        onBoxTap: _cubitInstance.onBoxTap,
                        boxSize: MediaQuery.sizeOf(context).height*0.05,
                        boxGap: boxGap,
                        isReverting: _cubitInstance.isReverting,
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


