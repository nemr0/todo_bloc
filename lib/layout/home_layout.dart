import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/modules/archived_tasks/archived_view.dart';
import 'package:todo_bloc/modules/done_tasks/done_view.dart';
import 'package:todo_bloc/modules/tasks/tasks_view.dart';
import 'package:todo_bloc/modules/theme_fab.dart';
import 'package:todo_bloc/shared/cubit/home_cubit.dart';

import '../shared/components/custom_text_field.dart';

/// Layout of Home Page includes :
/// - [AppBar].
/// - body (refers to [TasksView],[DoneView],[ArchivedView]).
/// - Floating Action Button.
class HomeLayout extends StatelessWidget {
  HomeLayout({
    super.key,
  });

  /// [PageController] for [PageView]
  final PageController _bodyPageController = PageController();
  final PageController _appBarPageController = PageController();

  /// Text Editing Controllers for Bottom Sheet
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  /// On [BottomNavigationBar] Icon Press or [PageView] switch in [AppBar] or
  /// body
  void _onSwitch(int index, HomeCubit hc, bool? isBody) => {
        hc.isBodySetter(isBody),
        // setting new index
        hc.setIndex(index),
        hc.isBodySetter(null),
      };

  /// Scaffold key to control bottomSheet and more...
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Form Key to Validate
  final formKey = GlobalKey<FormState>();

  /// overriding build method for [HomeLayout]
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..createOrOpenDB(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeChangeScreenState) {
            int index = HomeCubit.get(context).index;
            _bodyPageController.animateToPage(index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.decelerate);
            _appBarPageController.animateToPage(index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.decelerate);
          }
        },
        builder: (context, state) {
          HomeCubit hc = HomeCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: MediaQuery.of(context).size.height * .09,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  title: SizedBox(
                    height: 50,
                    child: PageView.builder(
                      onPageChanged: hc.isBody != true
                          ? (i) => _onSwitch(i, hc, false)
                          : null,
                      itemBuilder: (context, index) => Center(
                        child: Text(
                          hc.labels[hc.index],
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      itemCount: hc.bodyWidgets.length,
                      controller: _appBarPageController,
                    ),
                  )),
              body: GestureDetector(
                onTap: () {
                  if (hc.bottomSheetController != null) {
                    hc.bottomSheetController?.close();
                    hc.isBottomSheetShownSetter(false);
                  }
                },
                child: PageView.builder(
                  onPageChanged: (i) =>
                      hc.isBody != false ? _onSwitch(i, hc, true) : null,
                  itemBuilder: (context, index) => hc.bodyWidgets[index],
                  itemCount: hc.bodyWidgets.length,
                  controller: _bodyPageController,
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeModeFAB(),
                  const SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () => onFABPress(context),
                    tooltip: 'Insert Task',
                    child: Icon(hc.isBottomSheetShown
                        ? Icons.add
                        : Icons.circle_outlined),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      label: 'Tasks',
                      icon: Icon(
                        Icons.menu_open_outlined,
                      )),
                  BottomNavigationBarItem(
                      label: 'Done',
                      icon: Icon(
                        Icons.check_circle_outline_outlined,
                      )),
                  BottomNavigationBarItem(
                      label: 'Archived',
                      icon: Icon(
                        Icons.archive_outlined,
                      )),
                ],
                currentIndex: hc.index,
                onTap: (i) => _onSwitch(i, hc, null),
              ));
        },
      ),
    );
  }

  /// ON [FloatingActionButton] Pressed
  onFABPress(BuildContext context) {
    {
      HomeCubit hc = HomeCubit.get(context);
      // If Bottom Sheet is Open
      if (hc.isBottomSheetShown) {
        // If title, time and date are valid (not empty)
        if (formKey.currentState?.validate() == true) {
          // insert task
          hc.insertTaskToDB(
              titleController.text, timeController.text, dateController.text);
          titleController.text = '';
          timeController.text = '';
          dateController.text = '';
          // close Bottom Sheet
          Navigator.pop(context);
          hc.isBottomSheetShownSetter(false);

          // setState(() => isBottomSheetShown = false);
        }
      }
      // if bottom sheet is closed
      else {
        // open it
        hc.bottomSheetController = scaffoldKey.currentState?.showBottomSheet(
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomTextField(
                      icon: const Icon(Icons.watch_later_rounded),
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      label: 'Title',
                      hintText: 'New Task Title',
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Title';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      isClickable: false,
                      icon: const Icon(Icons.calendar_today_outlined),
                      controller: timeController,
                      keyboardType: TextInputType.datetime,
                      label: 'Time',
                      hintText: 'HH:MM AM',
                      onTap: () {
                        showTimePicker(
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                context: context,
                                initialTime: TimeOfDay.now(),
                                helpText: 'Please Specify The Task Time')
                            .then((value) => timeController.text = value == null
                                ? timeController.text.isEmpty
                                    ? ''
                                    : timeController.text
                                : value.format(context));
                        // .then((value) =>
                        // setState(
                        //     () => timeController.text = value == null
                        //         ? timeController.text.isEmpty
                        //             ? ''
                        //             : timeController.text
                        // : value.format(context))
                        // );
                      },
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Time';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      isClickable: false,
                      icon: const Icon(Icons.calendar_month_outlined),
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      label: 'Date',
                      hintText: 'DD/MM/YYYY',
                      onTap: () {
                        DateTime now = DateTime.now();
                        const Duration addedOrSubtracted = Duration(days: 30);
                        showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now.subtract(addedOrSubtracted),
                                lastDate: now.add(addedOrSubtracted))
                            .then((value) => dateController.text = value == null
                                ? dateController.text.isEmpty
                                    ? ''
                                    : dateController.text
                                : value.toString().substring(0, 10));
                      },
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Date';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        );
        hc.isBottomSheetShownSetter(true);
      }
    }
  }
}
