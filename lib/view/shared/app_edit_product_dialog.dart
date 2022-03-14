import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/controller/product_presenter.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:velocity_x/velocity_x.dart';

class AppEditProductDialog extends StatefulWidget {
  ProductInfo product;
  Function func;

  AppEditProductDialog(this.product, this.func);

  @override
  AppEditProductDialogState createState() => AppEditProductDialogState();
}

class AppEditProductDialogState extends State<AppEditProductDialog> {
  ProductPresenter _productPresenter;
  Map<String, TextEditingController> _controllerMapper = {};

  @override
  void initState() {
    super.initState();
    _productPresenter = ProductPresenter();
    _controllerMapper["productName"] =
        TextEditingController(text: widget.product.productName ?? "");
    _controllerMapper["productAlias"] = TextEditingController(
        text: widget.product.productAlias != null
            ? widget.product.productAlias.toString()
            : "");
    _controllerMapper["marketingGroup"] =
        TextEditingController(text: widget.product.marketingGroup ?? "");
    _controllerMapper["vendor"] =
        TextEditingController(text: widget.product.vendor ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.product.id == null ? "Add Product" : "Edit Product",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
            _buildTextWidget(
                "Product Name (*)", _controllerMapper["productName"]),
            _buildTextWidget(
                "Product Alias (*)", _controllerMapper["productAlias"],
                isReadOnly: widget.product.id == null ? false : true),
            _buildTextWidget(
                "Marketing Group", _controllerMapper["marketingGroup"]),
            _buildTextWidget("Vendor", _controllerMapper["vendor"]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.secondaryColor),
                  ),
                  onPressed: () {
                    _save();
                  },
                  child: const Text("Save"),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(String label, TextEditingController controller,
      {bool isReadOnly}) {
    isReadOnly ??= false;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6),
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _save() {
    widget.product.productName = _controllerMapper["productName"].text;
    widget.product.marketingGroup = _controllerMapper["marketingGroup"].text;
    widget.product.vendor = _controllerMapper["vendor"].text;
    if (widget.product.id == null) {
      widget.product.productAlias =
          int.tryParse(_controllerMapper["productAlias"].text);
    }

    if (widget.product.productName.isEmptyOrNull) {
      AppCommonHelper.customToast("Please Provide Product Name");
      return;
    } else if (widget.product.productAlias.isNull ||
        widget.product.productAlias <= 0) {
      AppCommonHelper.customToast("Please Provide Product Alias");
      return;
    }

    _productPresenter.saveProduct(widget.product).then((value) {
      if (value) {
        widget.func(value);
        Navigator.pop(context);
      }
    });
  }
}
