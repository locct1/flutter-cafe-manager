import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../shared/dialog_utils.dart';
import 'products_manager.dart';
import 'products_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../categories/categories_manager.dart';
import '../../models/category.dart';
enum Importance {
  init,
  low,
  medium,
  high,
}

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  // String CategorySelect = '';
  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        category: '',
        price: 0,
        description: '',
        imageUrl: '',
      );
    } else {
      this.product = product;
      // CategorySelect = product.category;
    }
  }
  late final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  String _importance = '';
  String _selectedCategory = '';
  late Product _editedProduct;
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
    _editedProduct = widget.product;
     _importance = _editedProduct.category;
    _imageUrlController.text = _editedProduct.imageUrl;
    final _showCategory = ValueNotifier<String>('');
    late Future<void> _fetchCategories;
    _fetchCategories = context.read<CategoriesManager>().fetchCategories();
    
    
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
      final productsManager = context.read<ProductsManager>();
      _selectedCategory = _importance;
      _editedProduct = _editedProduct.copyWith(category: _selectedCategory);
      if (_editedProduct.id != null) {
        await productsManager.updateProduct(_editedProduct);
      } else {
        await productsManager.addProduct(_editedProduct);
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
        title: const Text('Edit Product'),
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
                    buildTitleField(),
                    buildPriceField(),
                    buildTestField(context),
                    buildDescriptionField(),
                    buildProductPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }

  TextFormField buildCategoryField() {
    return TextFormField(
      initialValue: _editedProduct.category,
      decoration: const InputDecoration(labelText: 'Category'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(category: value);
      },
    );
  }

  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
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
        _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Lưu ý'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 5) {
          return 'Should be at least 5 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  Widget buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Nhập đường dẫn ảnh')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }

  Widget buildTestField(BuildContext context) {
     final categoriesManager = new CategoriesManager();
    // Đọc ra danh sách các product sẽ được hiển thị từ ProductsManager
    final categories = context.select<CategoriesManager, List<CategoryModel>>(
        (categoriesManager) => categoriesManager.items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == 'Do an',
              label: const Text(
                'low',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onSelected: (selected) {
                setState(() => _importance = 'Do an');
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == 'do uong',
              label: const Text(
                'medium',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onSelected: (selected) {
                setState(() => _importance = 'do uong');
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == 'che',
              label: const Text(
                'high',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onSelected: (selected) {
                setState(() => _importance = 'che');
              },
            )
          ],
        )
      ],
    );
  }
}
