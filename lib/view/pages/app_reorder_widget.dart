import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/controller/product_presenter.dart';
import 'package:medshop/controller/sales_presenter.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/entity/timeSeriesSales.dart';
import 'package:medshop/entity/weeklySales.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:medshop/view/shared/app_centered_view_widget.dart';
import 'package:medshop/view/shared/app_nav_bar_widget.dart';
import 'package:medshop/view/shared/custom_loader_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class AppReorderWidget extends StatefulWidget {
  AppReorderWidget();

  @override
  _AppReorderWidgetState createState() => _AppReorderWidgetState();
}

class _AppReorderWidgetState extends State<AppReorderWidget> {
  String DROPDOWN_NAME = "Product Name";
  String DROPDOWN_STOCK = "Stock";
  String DROPDOWN_REORDER = "Re-Order";

  SalesPresenter _salesPresenter;
  ProductPresenter _productPresenter;
  final columns = [
    'Month',
    'Total',
    'Week 1',
    'Week 2',
    'Week 3',
    'Week 4',
    'Week 5'
  ];
  Map<int, String> _reOrderMapper;
  Map<int, String> _stockMapper;
  List<ProductInfo> _prodReservered;
  List<ProductInfo> _products;
  List<TimeSeriesSales> _seriesList;
  List<WeeklySales> _weeklySalesList;
  Map<DateTime, List<WeeklySales>> _arrangedSales;
  ProductInfo _selectedProduct = null;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _productPresenter = ProductPresenter();
    _salesPresenter = SalesPresenter();
    _searchController = TextEditingController();
    _products = [];
    _prodReservered = [];
    _seriesList = [];
    _arrangedSales = {};
    _reOrderMapper = {};
    _stockMapper = {};
    _getData();
    //  _getSummary(2);
  }

  void _getData() {
    _productPresenter.getAllProducts().then((value) {
      setState(() {
        _prodReservered = value;
        _products.addAll(_prodReservered);
      });
    });
  }

  void _sort(String value) {
    for (int i = 0; i < _products?.length; i++) {
      ProductInfo prod = _products[i];
      _products[i].reOrderQuantity =
          double.tryParse(_reOrderMapper[prod.productAlias] ?? "0");
      _products[i].stockQuantity =
          double.tryParse(_stockMapper[prod.productAlias] ?? "0");
    }

    if (value == DROPDOWN_REORDER) {
      _products.sort((first, second) {
        return second.reOrderQuantity.compareTo(first.reOrderQuantity);
      });
    } else if (value == DROPDOWN_STOCK) {
      _products.sort((first, second) {
        return second.stockQuantity.compareTo(first.stockQuantity);
      });
    } else {
      _products.sort((first, second) {
        return first.productName.compareTo(second.productName);
      });
    }
    setState(() {});
  }

  void _getSummary(int productAlias) {
    _salesPresenter.getWeeklySales(productAlias).then((summary) {
      _weeklySalesList = summary;
      for (var element in _weeklySalesList) {
        DateTime dt = DateTime(element.year, element.month + 1);
        if (!_arrangedSales.containsKey(dt)) {
          List<WeeklySales> temp = [];
          temp.add(element);
          _arrangedSales[dt] = temp;
        } else {
          _arrangedSales[dt].add(element);
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppCenteredViewWidget(
        child: Column(
          children: [
            AppNavBarWidget(
              active: 3,
            ),
            _prodReservered == null || _prodReservered?.length <= 0
                ? CustomLoaderWidget()
                : Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _selectedProduct?.productName != null
                                ? "Showing Data For:  ${_selectedProduct?.productName} (Product Alias: ${_selectedProduct?.productAlias})"
                                    .text
                                    .bold
                                    .size(16)
                                    .make()
                                : Container(),
                            Row(
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.secondaryColor),
                                    ),
                                    onPressed: () {
                                      _productPresenter
                                          .uploadStocks()
                                          .then((value) {
                                        if (value != null &&
                                            value?.length > 0) {
                                          setState(() {
                                            _stockMapper = value;
                                          });
                                          AppCommonHelper.customToast(
                                              "Stocks Updated");
                                        }
                                      });
                                    },
                                    child: "Upload Stocks".text.white.make()),
                                const SizedBox(
                                  width: 6,
                                ),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: "Export".text.white.make())
                              ],
                            ),
                          ],
                        ),
                        AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          switchInCurve: Curves.fastOutSlowIn,
                          child: _arrangedSales?.length <= 0
                              ? Container()
                              : SizedBox(
                                  height: 258,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 7,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _buildWeeklySalesTable(),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: _buildGraph(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Products".text.bold.size(16).make(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildFilterDropdown(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _searchController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          hintText: "Search Products",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                _searchController.text = "";
                                                _products.clear();
                                                _products
                                                    .addAll(_prodReservered);
                                              });
                                            },
                                          ),
                                          isDense: true),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  SizedBox(
                                    height: 38,
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          _searchKeyword();
                                        },
                                        icon: const Icon(Icons.search),
                                        label: "Search".text.make()),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                ProductInfo prod = _products[index];
                                return _buildProductInformationWidget(prod);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 4,
                                );
                              },
                              itemCount: _products?.length ?? 0),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildFilterDropdown() {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField2<String>(
        decoration: InputDecoration(
          //Add isDense true and zero Padding.
          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          //Add more decoration as you want here
          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
        ),
        isExpanded: true,
        hint: const Text(
          'Sort By',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 48,
        buttonPadding: const EdgeInsets.only(left: 10, right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        items: [DROPDOWN_NAME, DROPDOWN_STOCK, DROPDOWN_REORDER]
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          _sort(value);
        },
      ),
    );
  }

  Widget _buildProductInformationWidget(ProductInfo prod) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProduct = prod;
          _arrangedSales.clear();
        });
        _getSummary(_selectedProduct.productAlias);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
            color: _selectedProduct?.productAlias == prod.productAlias
                ? AppColors.secondaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: _buildTextWidget(
                    "Product Name", prod.productName, prod.productAlias)),
            Expanded(
                flex: 1,
                child: _buildTextWidget("Product Alias",
                    prod.productAlias.toString(), prod.productAlias)),
            Expanded(
                flex: 1,
                child: _buildTextWidget("Stock Quantity",
                    _stockMapper[prod.productAlias] ?? "0", prod.productAlias)),
            Expanded(
                flex: 1,
                child: _buidEditTextWidget("Re-Order Quantity",
                    _reOrderMapper[prod.productAlias], prod.productAlias)),
            Expanded(
                flex: 1,
                child: _buildTextWidget(
                    "Marketing Group", prod.marketingGroup, prod.productAlias)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(String label, String value, int productAlias) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: _selectedProduct?.productAlias == productAlias
                  ? Colors.white70
                  : Colors.grey,
              fontSize: 11),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: _selectedProduct?.productAlias == productAlias
                  ? Colors.white
                  : Colors.black,
              fontSize: 12),
        )
      ],
    );
  }

  Widget _buidEditTextWidget(String label, String value, int productAlias) {
    TextEditingController _txtController =
        TextEditingController(text: value ?? "0");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: _selectedProduct?.productAlias == productAlias
                  ? Colors.white70
                  : Colors.grey,
              fontSize: 11),
        ),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          width: 50,
          child: TextField(
            controller: _txtController,
            onChanged: (value) {
              _reOrderMapper[productAlias] = value;
            },
            style: const TextStyle(fontSize: 12),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
            ),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(6),
                border: OutlineInputBorder(),
                isDense: true),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklySalesTable() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: DataTable(
        dataRowHeight: 30,
        columns: getColumns(columns),
        rows: getRows(),
      ),
    );
  }

  Widget _buildGraph() {
    return Container(
      height: 251,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: charts.TimeSeriesChart(
        [
          charts.Series<TimeSeriesSales, DateTime>(
            id: 'Sales',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            data: _seriesList,
          )
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  List<DataRow> getRows() {
    _seriesList.clear();
    List<DataRow> dataRowList = [];
    _arrangedSales.forEach((key, value) {
      List<dynamic> cells = ["", 0, 0, 0, 0, 0, 0];
      String month =
          AppCommonHelper.formatDate(key.toString(), dateFormat: "MMMM yy");
      cells[0] = month;
      for (int counter = 0; counter < value.length; counter++) {
        double qty = value[counter].quantity;
        switch (value[counter].week) {
          case 0:
            cells[2] = qty;
            break;
          case 1:
            cells[3] = qty;
            break;
          case 2:
            cells[4] = qty;
            break;
          case 3:
            cells[5] = qty;
            break;
          case 4:
            cells[6] = qty;
            break;
        }
      }
      int totalQty = _calculateTotalQty(cells);
      cells[1] = totalQty;
      _seriesList.add(TimeSeriesSales(key, totalQty));
      dataRowList.add(DataRow(cells: getCells(cells)));
    });
    return dataRowList;
  }

  int _calculateTotalQty(List<dynamic> cells) {
    int totalQty = 0;
    for (int i = 2; i < 7; i++) {
      totalQty = totalQty + cells[i];
    }
    return totalQty;
  }

  List<DataCell> getCells(List<dynamic> cells) {
    List<DataCell> dataCellList = [];
    cells.forEachIndexed(
      (index, data) => dataCellList.add(
        DataCell(
          Text(
            "$data".toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                color: index == 0
                    ? AppColors.secondaryColor
                    : Colors.grey.shade700,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500),
          ),
        ),
      ),
    );
    return dataCellList;
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String element) => DataColumn(
          label: Expanded(
            child: Text(
              element,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      )
      .toList();

  void _searchKeyword() {
    if (_searchController.text.length > 2) {
      _products.clear();
      String _txt = _searchController.text.toLowerCase();
      for (ProductInfo e in _prodReservered) {
        if (e.productName.toLowerCase().startsWith(_txt)) {
          _products.add(e);
        }
      }
      setState(() {});
    } else {
      AppCommonHelper.customToast("Less than three letters are not allowed");
    }
  }
}
