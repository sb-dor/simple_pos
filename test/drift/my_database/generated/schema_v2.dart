// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class CustomerInvoices extends Table
    with TableInfo<CustomerInvoices, CustomerInvoicesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CustomerInvoices(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> waiterId = GeneratedColumn<int>(
    'waiter_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> tableId = GeneratedColumn<String>(
    'table_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> totalQty = GeneratedColumn<double>(
    'total_qty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> invoiceDatetime = GeneratedColumn<String>(
    'invoice_datetime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    waiterId,
    tableId,
    total,
    totalQty,
    status,
    invoiceDatetime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_invoices';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerInvoicesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerInvoicesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      waiterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}waiter_id'],
      ),
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_id'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      ),
      totalQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_qty'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      invoiceDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_datetime'],
      ),
    );
  }

  @override
  CustomerInvoices createAlias(String alias) {
    return CustomerInvoices(attachedDatabase, alias);
  }
}

class CustomerInvoicesData extends DataClass
    implements Insertable<CustomerInvoicesData> {
  final int id;
  final int? waiterId;
  final String? tableId;
  final double? total;
  final double? totalQty;
  final String? status;
  final String? invoiceDatetime;
  const CustomerInvoicesData({
    required this.id,
    this.waiterId,
    this.tableId,
    this.total,
    this.totalQty,
    this.status,
    this.invoiceDatetime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || waiterId != null) {
      map['waiter_id'] = Variable<int>(waiterId);
    }
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<String>(tableId);
    }
    if (!nullToAbsent || total != null) {
      map['total'] = Variable<double>(total);
    }
    if (!nullToAbsent || totalQty != null) {
      map['total_qty'] = Variable<double>(totalQty);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || invoiceDatetime != null) {
      map['invoice_datetime'] = Variable<String>(invoiceDatetime);
    }
    return map;
  }

  CustomerInvoicesCompanion toCompanion(bool nullToAbsent) {
    return CustomerInvoicesCompanion(
      id: Value(id),
      waiterId: waiterId == null && nullToAbsent
          ? const Value.absent()
          : Value(waiterId),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      total: total == null && nullToAbsent
          ? const Value.absent()
          : Value(total),
      totalQty: totalQty == null && nullToAbsent
          ? const Value.absent()
          : Value(totalQty),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      invoiceDatetime: invoiceDatetime == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceDatetime),
    );
  }

  factory CustomerInvoicesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerInvoicesData(
      id: serializer.fromJson<int>(json['id']),
      waiterId: serializer.fromJson<int?>(json['waiterId']),
      tableId: serializer.fromJson<String?>(json['tableId']),
      total: serializer.fromJson<double?>(json['total']),
      totalQty: serializer.fromJson<double?>(json['totalQty']),
      status: serializer.fromJson<String?>(json['status']),
      invoiceDatetime: serializer.fromJson<String?>(json['invoiceDatetime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'waiterId': serializer.toJson<int?>(waiterId),
      'tableId': serializer.toJson<String?>(tableId),
      'total': serializer.toJson<double?>(total),
      'totalQty': serializer.toJson<double?>(totalQty),
      'status': serializer.toJson<String?>(status),
      'invoiceDatetime': serializer.toJson<String?>(invoiceDatetime),
    };
  }

  CustomerInvoicesData copyWith({
    int? id,
    Value<int?> waiterId = const Value.absent(),
    Value<String?> tableId = const Value.absent(),
    Value<double?> total = const Value.absent(),
    Value<double?> totalQty = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> invoiceDatetime = const Value.absent(),
  }) => CustomerInvoicesData(
    id: id ?? this.id,
    waiterId: waiterId.present ? waiterId.value : this.waiterId,
    tableId: tableId.present ? tableId.value : this.tableId,
    total: total.present ? total.value : this.total,
    totalQty: totalQty.present ? totalQty.value : this.totalQty,
    status: status.present ? status.value : this.status,
    invoiceDatetime: invoiceDatetime.present
        ? invoiceDatetime.value
        : this.invoiceDatetime,
  );
  CustomerInvoicesData copyWithCompanion(CustomerInvoicesCompanion data) {
    return CustomerInvoicesData(
      id: data.id.present ? data.id.value : this.id,
      waiterId: data.waiterId.present ? data.waiterId.value : this.waiterId,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      total: data.total.present ? data.total.value : this.total,
      totalQty: data.totalQty.present ? data.totalQty.value : this.totalQty,
      status: data.status.present ? data.status.value : this.status,
      invoiceDatetime: data.invoiceDatetime.present
          ? data.invoiceDatetime.value
          : this.invoiceDatetime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerInvoicesData(')
          ..write('id: $id, ')
          ..write('waiterId: $waiterId, ')
          ..write('tableId: $tableId, ')
          ..write('total: $total, ')
          ..write('totalQty: $totalQty, ')
          ..write('status: $status, ')
          ..write('invoiceDatetime: $invoiceDatetime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    waiterId,
    tableId,
    total,
    totalQty,
    status,
    invoiceDatetime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerInvoicesData &&
          other.id == this.id &&
          other.waiterId == this.waiterId &&
          other.tableId == this.tableId &&
          other.total == this.total &&
          other.totalQty == this.totalQty &&
          other.status == this.status &&
          other.invoiceDatetime == this.invoiceDatetime);
}

class CustomerInvoicesCompanion extends UpdateCompanion<CustomerInvoicesData> {
  final Value<int> id;
  final Value<int?> waiterId;
  final Value<String?> tableId;
  final Value<double?> total;
  final Value<double?> totalQty;
  final Value<String?> status;
  final Value<String?> invoiceDatetime;
  const CustomerInvoicesCompanion({
    this.id = const Value.absent(),
    this.waiterId = const Value.absent(),
    this.tableId = const Value.absent(),
    this.total = const Value.absent(),
    this.totalQty = const Value.absent(),
    this.status = const Value.absent(),
    this.invoiceDatetime = const Value.absent(),
  });
  CustomerInvoicesCompanion.insert({
    this.id = const Value.absent(),
    this.waiterId = const Value.absent(),
    this.tableId = const Value.absent(),
    this.total = const Value.absent(),
    this.totalQty = const Value.absent(),
    this.status = const Value.absent(),
    this.invoiceDatetime = const Value.absent(),
  });
  static Insertable<CustomerInvoicesData> custom({
    Expression<int>? id,
    Expression<int>? waiterId,
    Expression<String>? tableId,
    Expression<double>? total,
    Expression<double>? totalQty,
    Expression<String>? status,
    Expression<String>? invoiceDatetime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (waiterId != null) 'waiter_id': waiterId,
      if (tableId != null) 'table_id': tableId,
      if (total != null) 'total': total,
      if (totalQty != null) 'total_qty': totalQty,
      if (status != null) 'status': status,
      if (invoiceDatetime != null) 'invoice_datetime': invoiceDatetime,
    });
  }

  CustomerInvoicesCompanion copyWith({
    Value<int>? id,
    Value<int?>? waiterId,
    Value<String?>? tableId,
    Value<double?>? total,
    Value<double?>? totalQty,
    Value<String?>? status,
    Value<String?>? invoiceDatetime,
  }) {
    return CustomerInvoicesCompanion(
      id: id ?? this.id,
      waiterId: waiterId ?? this.waiterId,
      tableId: tableId ?? this.tableId,
      total: total ?? this.total,
      totalQty: totalQty ?? this.totalQty,
      status: status ?? this.status,
      invoiceDatetime: invoiceDatetime ?? this.invoiceDatetime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (waiterId.present) {
      map['waiter_id'] = Variable<int>(waiterId.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<String>(tableId.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (totalQty.present) {
      map['total_qty'] = Variable<double>(totalQty.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (invoiceDatetime.present) {
      map['invoice_datetime'] = Variable<String>(invoiceDatetime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('waiterId: $waiterId, ')
          ..write('tableId: $tableId, ')
          ..write('total: $total, ')
          ..write('totalQty: $totalQty, ')
          ..write('status: $status, ')
          ..write('invoiceDatetime: $invoiceDatetime')
          ..write(')'))
        .toString();
  }
}

class CustomerInvoicesDetails extends Table
    with TableInfo<CustomerInvoicesDetails, CustomerInvoicesDetailsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CustomerInvoicesDetails(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> customerInvoiceId = GeneratedColumn<int>(
    'customer_invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customer_invoices (id)',
    ),
  );
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerInvoiceId,
    productId,
    price,
    qty,
    total,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_invoices_details';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerInvoicesDetailsData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerInvoicesDetailsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_invoice_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      ),
    );
  }

  @override
  CustomerInvoicesDetails createAlias(String alias) {
    return CustomerInvoicesDetails(attachedDatabase, alias);
  }
}

class CustomerInvoicesDetailsData extends DataClass
    implements Insertable<CustomerInvoicesDetailsData> {
  final int id;
  final int? customerInvoiceId;
  final int? productId;
  final double? price;
  final double? qty;
  final double? total;
  const CustomerInvoicesDetailsData({
    required this.id,
    this.customerInvoiceId,
    this.productId,
    this.price,
    this.qty,
    this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || customerInvoiceId != null) {
      map['customer_invoice_id'] = Variable<int>(customerInvoiceId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || qty != null) {
      map['qty'] = Variable<double>(qty);
    }
    if (!nullToAbsent || total != null) {
      map['total'] = Variable<double>(total);
    }
    return map;
  }

  CustomerInvoicesDetailsCompanion toCompanion(bool nullToAbsent) {
    return CustomerInvoicesDetailsCompanion(
      id: Value(id),
      customerInvoiceId: customerInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerInvoiceId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      qty: qty == null && nullToAbsent ? const Value.absent() : Value(qty),
      total: total == null && nullToAbsent
          ? const Value.absent()
          : Value(total),
    );
  }

  factory CustomerInvoicesDetailsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerInvoicesDetailsData(
      id: serializer.fromJson<int>(json['id']),
      customerInvoiceId: serializer.fromJson<int?>(json['customerInvoiceId']),
      productId: serializer.fromJson<int?>(json['productId']),
      price: serializer.fromJson<double?>(json['price']),
      qty: serializer.fromJson<double?>(json['qty']),
      total: serializer.fromJson<double?>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerInvoiceId': serializer.toJson<int?>(customerInvoiceId),
      'productId': serializer.toJson<int?>(productId),
      'price': serializer.toJson<double?>(price),
      'qty': serializer.toJson<double?>(qty),
      'total': serializer.toJson<double?>(total),
    };
  }

  CustomerInvoicesDetailsData copyWith({
    int? id,
    Value<int?> customerInvoiceId = const Value.absent(),
    Value<int?> productId = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<double?> qty = const Value.absent(),
    Value<double?> total = const Value.absent(),
  }) => CustomerInvoicesDetailsData(
    id: id ?? this.id,
    customerInvoiceId: customerInvoiceId.present
        ? customerInvoiceId.value
        : this.customerInvoiceId,
    productId: productId.present ? productId.value : this.productId,
    price: price.present ? price.value : this.price,
    qty: qty.present ? qty.value : this.qty,
    total: total.present ? total.value : this.total,
  );
  CustomerInvoicesDetailsData copyWithCompanion(
    CustomerInvoicesDetailsCompanion data,
  ) {
    return CustomerInvoicesDetailsData(
      id: data.id.present ? data.id.value : this.id,
      customerInvoiceId: data.customerInvoiceId.present
          ? data.customerInvoiceId.value
          : this.customerInvoiceId,
      productId: data.productId.present ? data.productId.value : this.productId,
      price: data.price.present ? data.price.value : this.price,
      qty: data.qty.present ? data.qty.value : this.qty,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerInvoicesDetailsData(')
          ..write('id: $id, ')
          ..write('customerInvoiceId: $customerInvoiceId, ')
          ..write('productId: $productId, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, customerInvoiceId, productId, price, qty, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerInvoicesDetailsData &&
          other.id == this.id &&
          other.customerInvoiceId == this.customerInvoiceId &&
          other.productId == this.productId &&
          other.price == this.price &&
          other.qty == this.qty &&
          other.total == this.total);
}

class CustomerInvoicesDetailsCompanion
    extends UpdateCompanion<CustomerInvoicesDetailsData> {
  final Value<int> id;
  final Value<int?> customerInvoiceId;
  final Value<int?> productId;
  final Value<double?> price;
  final Value<double?> qty;
  final Value<double?> total;
  const CustomerInvoicesDetailsCompanion({
    this.id = const Value.absent(),
    this.customerInvoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.total = const Value.absent(),
  });
  CustomerInvoicesDetailsCompanion.insert({
    this.id = const Value.absent(),
    this.customerInvoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.total = const Value.absent(),
  });
  static Insertable<CustomerInvoicesDetailsData> custom({
    Expression<int>? id,
    Expression<int>? customerInvoiceId,
    Expression<int>? productId,
    Expression<double>? price,
    Expression<double>? qty,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerInvoiceId != null) 'customer_invoice_id': customerInvoiceId,
      if (productId != null) 'product_id': productId,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
      if (total != null) 'total': total,
    });
  }

  CustomerInvoicesDetailsCompanion copyWith({
    Value<int>? id,
    Value<int?>? customerInvoiceId,
    Value<int?>? productId,
    Value<double?>? price,
    Value<double?>? qty,
    Value<double?>? total,
  }) {
    return CustomerInvoicesDetailsCompanion(
      id: id ?? this.id,
      customerInvoiceId: customerInvoiceId ?? this.customerInvoiceId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerInvoiceId.present) {
      map['customer_invoice_id'] = Variable<int>(customerInvoiceId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerInvoicesDetailsCompanion(')
          ..write('id: $id, ')
          ..write('customerInvoiceId: $customerInvoiceId, ')
          ..write('productId: $productId, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class EstablishmentTable extends Table
    with TableInfo<EstablishmentTable, EstablishmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EstablishmentTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, documentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'establishment_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  EstablishmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EstablishmentTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      ),
    );
  }

  @override
  EstablishmentTable createAlias(String alias) {
    return EstablishmentTable(attachedDatabase, alias);
  }
}

class EstablishmentTableData extends DataClass
    implements Insertable<EstablishmentTableData> {
  final String id;
  final String? name;
  final String? documentId;
  const EstablishmentTableData({required this.id, this.name, this.documentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<String>(documentId);
    }
    return map;
  }

  EstablishmentTableCompanion toCompanion(bool nullToAbsent) {
    return EstablishmentTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
    );
  }

  factory EstablishmentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EstablishmentTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      documentId: serializer.fromJson<String?>(json['documentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'documentId': serializer.toJson<String?>(documentId),
    };
  }

  EstablishmentTableData copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> documentId = const Value.absent(),
  }) => EstablishmentTableData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    documentId: documentId.present ? documentId.value : this.documentId,
  );
  EstablishmentTableData copyWithCompanion(EstablishmentTableCompanion data) {
    return EstablishmentTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EstablishmentTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentId: $documentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, documentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EstablishmentTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.documentId == this.documentId);
}

class EstablishmentTableCompanion
    extends UpdateCompanion<EstablishmentTableData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> documentId;
  final Value<int> rowid;
  const EstablishmentTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.documentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EstablishmentTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.documentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<EstablishmentTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? documentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (documentId != null) 'document_id': documentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EstablishmentTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? documentId,
    Value<int>? rowid,
  }) {
    return EstablishmentTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      documentId: documentId ?? this.documentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstablishmentTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentId: $documentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class OrderTableDbTable extends Table
    with TableInfo<OrderTableDbTable, OrderTableDbTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OrderTableDbTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> establishmentId = GeneratedColumn<String>(
    'establishment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<bool> vip = GeneratedColumn<bool>(
    'vip',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vip" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<i2.Uint8List> image =
      GeneratedColumn<i2.Uint8List>(
        'image',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<bool> changed = GeneratedColumn<bool>(
    'changed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("changed" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    establishmentId,
    name,
    vip,
    updatedAt,
    colorValue,
    image,
    changed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_table_db_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  OrderTableDbTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderTableDbTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      establishmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}establishment_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      vip: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vip'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}image'],
      ),
      changed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}changed'],
      )!,
    );
  }

  @override
  OrderTableDbTable createAlias(String alias) {
    return OrderTableDbTable(attachedDatabase, alias);
  }
}

class OrderTableDbTableData extends DataClass
    implements Insertable<OrderTableDbTableData> {
  final String id;
  final String establishmentId;
  final String? name;
  final bool? vip;
  final DateTime? updatedAt;
  final int? colorValue;
  final i2.Uint8List? image;
  final bool changed;
  const OrderTableDbTableData({
    required this.id,
    required this.establishmentId,
    this.name,
    this.vip,
    this.updatedAt,
    this.colorValue,
    this.image,
    required this.changed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['establishment_id'] = Variable<String>(establishmentId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || vip != null) {
      map['vip'] = Variable<bool>(vip);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<i2.Uint8List>(image);
    }
    map['changed'] = Variable<bool>(changed);
    return map;
  }

  OrderTableDbTableCompanion toCompanion(bool nullToAbsent) {
    return OrderTableDbTableCompanion(
      id: Value(id),
      establishmentId: Value(establishmentId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      vip: vip == null && nullToAbsent ? const Value.absent() : Value(vip),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      changed: Value(changed),
    );
  }

  factory OrderTableDbTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderTableDbTableData(
      id: serializer.fromJson<String>(json['id']),
      establishmentId: serializer.fromJson<String>(json['establishmentId']),
      name: serializer.fromJson<String?>(json['name']),
      vip: serializer.fromJson<bool?>(json['vip']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      image: serializer.fromJson<i2.Uint8List?>(json['image']),
      changed: serializer.fromJson<bool>(json['changed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'establishmentId': serializer.toJson<String>(establishmentId),
      'name': serializer.toJson<String?>(name),
      'vip': serializer.toJson<bool?>(vip),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'colorValue': serializer.toJson<int?>(colorValue),
      'image': serializer.toJson<i2.Uint8List?>(image),
      'changed': serializer.toJson<bool>(changed),
    };
  }

  OrderTableDbTableData copyWith({
    String? id,
    String? establishmentId,
    Value<String?> name = const Value.absent(),
    Value<bool?> vip = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<int?> colorValue = const Value.absent(),
    Value<i2.Uint8List?> image = const Value.absent(),
    bool? changed,
  }) => OrderTableDbTableData(
    id: id ?? this.id,
    establishmentId: establishmentId ?? this.establishmentId,
    name: name.present ? name.value : this.name,
    vip: vip.present ? vip.value : this.vip,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    image: image.present ? image.value : this.image,
    changed: changed ?? this.changed,
  );
  OrderTableDbTableData copyWithCompanion(OrderTableDbTableCompanion data) {
    return OrderTableDbTableData(
      id: data.id.present ? data.id.value : this.id,
      establishmentId: data.establishmentId.present
          ? data.establishmentId.value
          : this.establishmentId,
      name: data.name.present ? data.name.value : this.name,
      vip: data.vip.present ? data.vip.value : this.vip,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      image: data.image.present ? data.image.value : this.image,
      changed: data.changed.present ? data.changed.value : this.changed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderTableDbTableData(')
          ..write('id: $id, ')
          ..write('establishmentId: $establishmentId, ')
          ..write('name: $name, ')
          ..write('vip: $vip, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('colorValue: $colorValue, ')
          ..write('image: $image, ')
          ..write('changed: $changed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    establishmentId,
    name,
    vip,
    updatedAt,
    colorValue,
    $driftBlobEquality.hash(image),
    changed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderTableDbTableData &&
          other.id == this.id &&
          other.establishmentId == this.establishmentId &&
          other.name == this.name &&
          other.vip == this.vip &&
          other.updatedAt == this.updatedAt &&
          other.colorValue == this.colorValue &&
          $driftBlobEquality.equals(other.image, this.image) &&
          other.changed == this.changed);
}

class OrderTableDbTableCompanion
    extends UpdateCompanion<OrderTableDbTableData> {
  final Value<String> id;
  final Value<String> establishmentId;
  final Value<String?> name;
  final Value<bool?> vip;
  final Value<DateTime?> updatedAt;
  final Value<int?> colorValue;
  final Value<i2.Uint8List?> image;
  final Value<bool> changed;
  final Value<int> rowid;
  const OrderTableDbTableCompanion({
    this.id = const Value.absent(),
    this.establishmentId = const Value.absent(),
    this.name = const Value.absent(),
    this.vip = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.image = const Value.absent(),
    this.changed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderTableDbTableCompanion.insert({
    required String id,
    required String establishmentId,
    this.name = const Value.absent(),
    this.vip = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.image = const Value.absent(),
    this.changed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       establishmentId = Value(establishmentId);
  static Insertable<OrderTableDbTableData> custom({
    Expression<String>? id,
    Expression<String>? establishmentId,
    Expression<String>? name,
    Expression<bool>? vip,
    Expression<DateTime>? updatedAt,
    Expression<int>? colorValue,
    Expression<i2.Uint8List>? image,
    Expression<bool>? changed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (establishmentId != null) 'establishment_id': establishmentId,
      if (name != null) 'name': name,
      if (vip != null) 'vip': vip,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (colorValue != null) 'color_value': colorValue,
      if (image != null) 'image': image,
      if (changed != null) 'changed': changed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderTableDbTableCompanion copyWith({
    Value<String>? id,
    Value<String>? establishmentId,
    Value<String?>? name,
    Value<bool?>? vip,
    Value<DateTime?>? updatedAt,
    Value<int?>? colorValue,
    Value<i2.Uint8List?>? image,
    Value<bool>? changed,
    Value<int>? rowid,
  }) {
    return OrderTableDbTableCompanion(
      id: id ?? this.id,
      establishmentId: establishmentId ?? this.establishmentId,
      name: name ?? this.name,
      vip: vip ?? this.vip,
      updatedAt: updatedAt ?? this.updatedAt,
      colorValue: colorValue ?? this.colorValue,
      image: image ?? this.image,
      changed: changed ?? this.changed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (establishmentId.present) {
      map['establishment_id'] = Variable<String>(establishmentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (vip.present) {
      map['vip'] = Variable<bool>(vip.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (image.present) {
      map['image'] = Variable<i2.Uint8List>(image.value);
    }
    if (changed.present) {
      map['changed'] = Variable<bool>(changed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderTableDbTableCompanion(')
          ..write('id: $id, ')
          ..write('establishmentId: $establishmentId, ')
          ..write('name: $name, ')
          ..write('vip: $vip, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('colorValue: $colorValue, ')
          ..write('image: $image, ')
          ..write('changed: $changed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final CustomerInvoices customerInvoices = CustomerInvoices(this);
  late final CustomerInvoicesDetails customerInvoicesDetails =
      CustomerInvoicesDetails(this);
  late final EstablishmentTable establishmentTable = EstablishmentTable(this);
  late final OrderTableDbTable orderTableDbTable = OrderTableDbTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customerInvoices,
    customerInvoicesDetails,
    establishmentTable,
    orderTableDbTable,
  ];
  @override
  int get schemaVersion => 2;
}
