abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteUpdated extends FavoriteState {}
class FavoriteLoading extends FavoriteState {
  final int productId;
  FavoriteLoading(this.productId);
}class FavoriteError extends FavoriteState{
  final String message ;
  FavoriteError(this.message);
}

