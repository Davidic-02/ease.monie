import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/models/maps/atm.dart';

class MapSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool showSuggestions;
  final VoidCallback onShowSuggestions;
  final VoidCallback onHideSuggestions;
  final MapState mapState;
  final Color surfaceColor;

  const MapSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.showSuggestions,
    required this.onShowSuggestions,
    required this.onHideSuggestions,
    required this.mapState,
    required this.surfaceColor,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.mapState.isSearchingFromCustomLocation ? 119 : 125,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: AppColors.shadowColor, blurRadius: 10),
              ],
            ),
            child: TextField(
              controller: widget.searchController,
              focusNode: widget.searchFocusNode,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search ATM...',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.greyColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.greyColor,
                ),
                suffixIcon: widget.mapState.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.greyColor,
                        ),
                        onPressed: () {
                          widget.searchController.clear();
                          widget.onHideSuggestions();
                          context.read<MapBloc>().add(
                            const MapEvent.searchCleared(),
                          );
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  widget.onShowSuggestions();
                } else {
                  widget.onHideSuggestions();
                }
                context.read<MapBloc>().add(MapEvent.searchChanged(query));
              },
              onTap: () {
                if (widget.searchController.text.isNotEmpty) {
                  widget.onShowSuggestions();
                }
              },
            ),
          ),
          if (widget.showSuggestions &&
              widget.mapState.displayedATMs.isNotEmpty)
            _buildSuggestionsList(context),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: widget.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.mapState.displayedATMs.length.clamp(0, 6),
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: AppColors.greyColor.withOpacity(.2)),
        itemBuilder: (context, index) {
          final atm = widget.mapState.displayedATMs[index];
          return _buildSuggestionTile(context, atm);
        },
      ),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, ATM atm) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withOpacity(.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.atm, color: AppColors.secondaryColor, size: 18),
      ),
      title: Text(
        atm.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        atm.address ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: atm.isOpen
              ? AppColors.greenColor.withOpacity(.12)
              : AppColors.redColor.withOpacity(.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          atm.isOpen ? 'Open' : 'Closed',
          style: TextStyle(
            color: atm.isOpen ? AppColors.greenColor : AppColors.redColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () {
        widget.searchController.text = atm.name;
        widget.onHideSuggestions();
        FocusScope.of(context).unfocus();
        context.read<MapBloc>().add(MapEvent.atmSelected(atm));
      },
    );
  }
}
