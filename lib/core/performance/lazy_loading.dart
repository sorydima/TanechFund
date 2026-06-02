import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Утилиты для отложенной (lazy) загрузки контента.
/// Оптимизирует память и производительность больших списков.

/// Билдер для отложенно загружаемого виджета.
/// Показывает shimmer/placeholder пока контент загружается.
class LazyWidget extends StatefulWidget {
  final Future<Widget> Function() builder;
  final Widget? placeholder;
  final Duration delay;

  const LazyWidget({
    super.key,
    required this.builder,
    this.placeholder,
    this.delay = Duration.zero,
  });

  @override
  State<LazyWidget> createState() => _LazyWidgetState();
}

class _LazyWidgetState extends State<LazyWidget> {
  Widget? _child;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  Future<void> _loadWidget() async {
    try {
      if (widget.delay > Duration.zero) {
        await Future.delayed(widget.delay);
      }

      if (!mounted) return;

      final result = await widget.builder();
      
      if (mounted) {
        setState(() {
          _child = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const _DefaultPlaceholder();
    }

    if (_error != null) {
      return _ErrorWidget(error: _error!);
    }

    return _child!;
  }
}

/// Placeholder по умолчанию.
class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Виджет ошибки.
class _ErrorWidget extends StatelessWidget {
  final Object error;

  const _ErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red[400]),
          const SizedBox(height: 8),
          Text(
            'Ошибка загрузки',
            style: TextStyle(color: Colors.red[700]),
          ),
        ],
      ),
    );
  }
}

/// Отложенная загрузка экрана.
/// Используется с Navigator для оптимизации памяти.
class LazyScreen extends StatelessWidget {
  final WidgetBuilder builder;
  final String? routeName;

  const LazyScreen({
    super.key,
    required this.builder,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

/// Пагинация для больших списков.
class PaginationController<T> extends ChangeNotifier {
  final int pageSize;
  final Future<List<T>> Function(int page, int pageSize) fetchPage;

  final List<T> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  Object? _error;

  List<T> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  Object? get error => _error;

  PaginationController({
    this.pageSize = 20,
    required this.fetchPage,
  });

  /// Загружает первую страницу.
  Future<void> loadFirstPage() async {
    _currentPage = 0;
    _items.clear();
    _hasMore = true;
    _error = null;
    await _loadPage();
  }

  /// Загружает следующую страницу.
  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;
    _currentPage++;
    await _loadPage();
  }

  Future<void> _loadPage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItems = await fetchPage(_currentPage, pageSize);
      
      if (newItems.length < pageSize) {
        _hasMore = false;
      }
      
      _items.addAll(newItems);
      AppLogger.info('Loaded page $_currentPage with ${newItems.length} items');
    } catch (e, st) {
      _error = e;
      AppLogger.error('Failed to load page $_currentPage', e, st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновляет конкретный элемент.
  void updateItem(int index, T newItem) {
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      notifyListeners();
    }
  }

  /// Удаляет элемент.
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Очищает все данные.
  void clear() {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}

/// Widget для пагинированного списка.
class PaginatedListView<T> extends StatelessWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? separatorBuilder;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const PaginatedListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.separatorBuilder,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.items.isEmpty && controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty && controller.error != null) {
          return _ErrorState(
            error: controller.error!,
            onRetry: controller.loadFirstPage,
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              if (metrics.extentAfter < 200) {
                controller.loadNextPage();
              }
            }
            return false;
          },
          child: ListView.separated(
            physics: physics ?? const AlwaysScrollableScrollPhysics(),
            padding: padding ?? const EdgeInsets.all(16),
            itemCount: controller.items.length + (controller.hasMore ? 1 : 0),
            separatorBuilder: (context, index) {
              if (separatorBuilder != null) {
                return separatorBuilder!;
              }
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              if (index >= controller.items.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return itemBuilder(context, controller.items[index], index);
            },
          ),
        );
      },
    );
  }
}

/// Состояние ошибки с кнопкой повтора.
class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

/// Оптимизированный ListView с кэшированием.
class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double cacheExtent;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.cacheExtent = 200.0,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: padding,
      cacheExtent: cacheExtent,
      itemCount: itemCount,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Оптимизированный GridView с кэшированием.
class OptimizedGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double cacheExtent;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const OptimizedGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.cacheExtent = 200.0,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: padding,
      cacheExtent: cacheExtent,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: itemCount,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
