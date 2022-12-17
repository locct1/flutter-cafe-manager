import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/total_expense.dart';
import '../shared/dialog_utils.dart';
import 'totalexpenses_manager.dart';

class EditTotalExpenseScreen extends StatefulWidget {
  static const routeName = '/edit-totalexpense';

  EditTotalExpenseScreen(
    TotalExpense? totalexpense, {
    super.key,
  }) {
    if (totalexpense == null) {
      this.totalexpense = TotalExpense(
        id: null,
       price:0,
       description:''
      );
    } else {
      this.totalexpense = totalexpense;
    }
  }
  late final TotalExpense totalexpense;
  @override
  State<EditTotalExpenseScreen> createState() => _EditTotalExpenseScreenState();
}

class _EditTotalExpenseScreenState extends State<EditTotalExpenseScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late TotalExpense _editedTotalExpense;
  var _isLoading = false;
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        } // Ành hop lê Vē lai màn hinh dê hiên preview
        setState(() {});
      }
    });
    _editedTotalExpense = widget.totalexpense;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final categoriesManager = context.read<TotalExpensesManager>();
      if (_editedTotalExpense.id != null) {
        await categoriesManager.updateTotalExpense(_editedTotalExpense);
      } else {
        await categoriesManager.addTotalExpense(_editedTotalExpense);
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiệu chỉnh chi phí'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildDescriptionField(),
                    buildPriceField(),
                  ],
                ),
              ),
            ),
    );
  }
TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedTotalExpense.price.toString(),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a price.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number.';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTotalExpense = _editedTotalExpense.copyWith(price: double.parse(value!));
      },
    );
  }
  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedTotalExpense.description,
      decoration: const InputDecoration(labelText: 'Miêu tả'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 2) {
          return 'Should be at least 2 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTotalExpense = _editedTotalExpense.copyWith(description: value);
      },
    );
  }
}
