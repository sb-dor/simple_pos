import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/uikit/circle_selected_widget.dart';

class DropDownSelectionWidget<T> extends StatelessWidget {
  const DropDownSelectionWidget({
    required this.listOfDropdownEntries, required this.title, required this.onSelect, super.key,
    this.initialSelection,
    this.textController,
    this.singleItemInfo,
    this.selected,
    this.isError = false,
    this.singleBoxDecoration,
    this.multipleBoxDecoration,
    this.maximumSize = const Size(200, 200),
    this.dropdownMenuCloseBehavior = DropdownMenuCloseBehavior.all,
    this.checkForEmpty = true,
    this.enableSearch = true,
    this.requestFocusOnTap = true,
  });

  final List<DropdownMenuEntry<T>> listOfDropdownEntries;
  final String title;
  final T? initialSelection;
  final ValueChanged<T> onSelect;
  final TextEditingController? textController;
  final String? singleItemInfo;
  final bool? selected;
  final bool isError;
  final Decoration? singleBoxDecoration;
  final InputDecorationTheme? multipleBoxDecoration;
  final Size maximumSize;
  final DropdownMenuCloseBehavior dropdownMenuCloseBehavior;
  final bool checkForEmpty;
  final bool enableSearch;
  final bool requestFocusOnTap;

  @override
  Widget build(BuildContext context) {
    if (checkForEmpty && listOfDropdownEntries.isEmpty) return const SizedBox.shrink();
    if (checkForEmpty && listOfDropdownEntries.length == 1) {
      return Container(
        padding: const EdgeInsets.only(right: 7, left: 10, top: 8, bottom: 8),
        decoration:
            singleBoxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.grey, offset: Offset(0.1, 0.1), blurRadius: 1),
              ],
              border: Border.all(color: isError ? Colors.red : Colors.grey, width: 0.5),
            ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -16,
              child: SizedBox(
                height: 14,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(child: Container(color: Theme.of(context).cardColor)),
                          Expanded(child: Container(color: Theme.of(context).cardColor)),
                        ],
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          title,
                          style: const TextStyle(height: 0, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    listOfDropdownEntries.first.label.trim(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(width: 5),
                if (singleItemInfo != null)
                  Text(
                    singleItemInfo!,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                GestureDetector(
                  onTap: () {
                    onSelect(listOfDropdownEntries.first.value);
                  },
                  child: CircleSelectedWidget(selected: selected ?? false),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return DropdownMenu<T>(
        closeBehavior: dropdownMenuCloseBehavior,
        initialSelection: initialSelection,
        label: Text(title),
        trailingIcon: const Icon(Icons.arrow_drop_down),
        inputDecorationTheme:
            multipleBoxDecoration ??
            InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              // Match container background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isError ? Colors.green : Colors.grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isError ? Colors.green : Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isError ? Colors.green : Colors.grey, width: 1),
              ),
            ),
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          maximumSize: WidgetStatePropertyAll(maximumSize),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
        ),
        width: MediaQuery.of(context).size.width,
        onSelected: (data) {
          if (data != null) {
            onSelect(data);
          }
        },
        // textStyle: TextStyle(color: appTheme.appColors.textColor),
        controller: textController,
        dropdownMenuEntries: listOfDropdownEntries,
        enableSearch: enableSearch,
        requestFocusOnTap: requestFocusOnTap,
      );
    }
  }
}
