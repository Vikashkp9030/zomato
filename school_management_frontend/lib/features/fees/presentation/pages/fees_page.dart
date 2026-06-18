import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/fees_bloc.dart';
import '../bloc/fees_event.dart';
import '../bloc/fees_state.dart';

final getIt = GetIt.instance;

class FeesPage extends StatefulWidget {
  const FeesPage({Key? key}) : super(key: key);

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  late FeesBloc _feesBloc;
  String? selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _feesBloc = getIt<FeesBloc>();
    _feesBloc.add(const FetchFeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeesBloc>(
      create: (context) => _feesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fees Management'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _feesBloc.add(const FetchFeesEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<FeesBloc, FeesState>(
          builder: (context, state) {
            if (state is FeesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FeesErrorState) {
              return _buildErrorWidget(context, state.message);
            }
            if (state is FeesLoadedState) {
              return _buildFeesContent(context, state.fees);
            }
            if (state is FeeSummaryLoadedState) {
              return _buildSummaryContent(context, state.summary);
            }
            return const Center(child: Text('No data available'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateFeeDialog(context),
          tooltip: 'Add Fee',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _feesBloc.add(const FetchFeesEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesContent(BuildContext context, List<dynamic> fees) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          const Text('Fee Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...fees.map((fee) {
            return _buildFeeCard(fee);
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryContent(BuildContext context, Map<String, dynamic> summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fee Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryCard(summary),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _feesBloc.add(const FetchFeesEvent());
            },
            icon: const Icon(Icons.list),
            label: const Text('View All Fees'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter by Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('all', 'All'),
              const SizedBox(width: 8),
              _buildFilterChip('pending', 'Pending'),
              const SizedBox(width: 8),
              _buildFilterChip('paid', 'Paid'),
              const SizedBox(width: 8),
              _buildFilterChip('overdue', 'Overdue'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          selectedFilter = value;
        });
        if (value == 'all') {
          _feesBloc.add(const FetchFeesEvent());
        } else {
          _feesBloc.add(FetchFeesByStatusEvent(status: value));
        }
      },
      selectedColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: selectedFilter == value ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryCard({
          'label': 'Pending',
          'value': 5,
          'color': Colors.orange,
        }),
        _buildSummaryCard({
          'label': 'Paid',
          'value': 12,
          'color': Colors.green,
        }),
        _buildSummaryCard({
          'label': 'Overdue',
          'value': 2,
          'color': Colors.red,
        }),
      ],
    );
  }

  Widget _buildSummaryCard(dynamic data) {
    if (data is Map && data.containsKey('label')) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                data['value'].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: data['color'] as Color,
                ),
              ),
              const SizedBox(height: 4),
              Text(data['label'] as String),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildFeeCard(dynamic fee) {
    final status = fee['status'] ?? 'pending';
    final statusColor = status == 'paid'
        ? Colors.green
        : status == 'pending'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.receipt, color: statusColor),
        title: Text(fee['student_name'] ?? 'Unknown'),
        subtitle: Text('₹${fee['amount'] ?? 0}'),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withValues(alpha: 0.2),
          labelStyle: TextStyle(color: statusColor),
        ),
        onTap: () => _showFeeDetails(fee),
      ),
    );
  }

  void _showFeeDetails(dynamic fee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fee['student_name'] ?? 'Fee Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${fee['amount'] ?? 0}'),
            const SizedBox(height: 8),
            Text('Status: ${fee['status'] ?? 'pending'}'),
            const SizedBox(height: 8),
            Text('Due Date: ${fee['due_date'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            if (fee['paid_date'] != null) Text('Paid Date: ${fee['paid_date']}'),
            const SizedBox(height: 8),
            Text('Description: ${fee['description'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          if (fee['status'] == 'pending')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showPayFeeDialog(fee);
              },
              child: const Text('Pay Now'),
            ),
          if (fee['status'] == 'paid')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _feesBloc.add(FetchFeeReceiptEvent(feeId: fee['id'].toString()));
              },
              child: const Text('View Receipt'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPayFeeDialog(dynamic fee) {
    final paymentMethodController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pay Fee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Amount: ₹${fee['amount'] ?? 0}'),
            const SizedBox(height: 16),
            TextField(
              controller: paymentMethodController,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                hintText: 'e.g., Card, UPI, Bank Transfer',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _feesBloc.add(
                PayFeeEvent(
                  feeId: fee['id'].toString(),
                  paymentMethod: paymentMethodController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }

  void _showCreateFeeDialog(BuildContext context) {
    final studentIdController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Fee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(labelText: 'Student ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _feesBloc.add(
                CreateFeeEvent(
                  studentId: studentIdController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  description: descriptionController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}