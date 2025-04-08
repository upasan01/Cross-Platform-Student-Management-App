import 'package:flutter/cupertino.dart';

class CustomDropDown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final void Function(String selected) onTap;

  const CustomDropDown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onTap,
  });


  void _showDropDown(BuildContext context) {

    final initialItem = selectedValue != null
        ? options.indexOf(selectedValue!)
        :0;
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 40,
          backgroundColor: CupertinoColors.systemBackground,
          scrollController: FixedExtentScrollController(
            initialItem: initialItem
          ),
          onSelectedItemChanged: (index) {
            onTap(options[index]);
          },
          children: options.map((option) => Text(option)).toList(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
        style: TextStyle(fontSize: 16, color: CupertinoColors.label),),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showDropDown(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue?? 'Select $label',
                  style: TextStyle(
                    color: selectedValue != null?
                    CupertinoColors.label
                    :CupertinoColors.placeholderText,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down,size: 20),
              ],
            ),

          )
        ),
        const SizedBox(height: 20),

      ],
    );
  }
}