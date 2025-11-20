import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/authentication/data/authentication_repository.dart';
import 'package:test_pos_app/src/features/authentication/models/authentication_state_model.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';
import 'package:uuid/uuid.dart';

part 'authentication_bloc.freezed.dart';

/// Defines all authentication-related events handled by the bloc.
/// Each event triggers specific authentication logic.
@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  /// Triggered when the app starts to initialize authentication.
  const factory AuthenticationEvent.init() = _Authentication$InitEvent;

  /// Checks whether the user is authenticated.
  /// Includes a callback to send status messages back to the UI.
  const factory AuthenticationEvent.checkAuthentication({
    required void Function(String message) onMessage,
  }) = _Authentication$CheckAuthEvent;

  /// Handles user login using email and password.
  /// Sends results or error messages through the onMessage callback.
  const factory AuthenticationEvent.login({
    required String email,
    required String password,
    required void Function(String message) onMessage,
  }) = _Authentication$LoginEvent;

  /// Registers a new user and creates an associated establishment.
  const factory AuthenticationEvent.register({
    required String name,
    required String email,
    required String password,
    required String establishmentName,
  }) = _Authentication$RegisterEvent;

  /// Selects an establishment after successful authentication.
  const factory AuthenticationEvent.selectEstablishment({required Establishment establishment}) =
      _Authentication$SelectEstablishmentEvent;

  /// Logs the user out of the system and triggers an onLogout callback.
  const factory AuthenticationEvent.logout({required void Function() onLogout}) =
      _Authentication$LogoutEvent;
}

/// Defines all possible authentication states returned by the bloc.
/// States represent the current status of the authentication flow.
@freezed
sealed class AuthenticationState with _$AuthenticationState {
  /// Base state before any authentication action occurs.
  const factory AuthenticationState.initial(AuthenticationStateModel stateModel) =
      Authentication$InitialState;

  /// Indicates that an authentication process is currently in progress.
  const factory AuthenticationState.inProgress(AuthenticationStateModel stateModel) =
      Authentication$InProgressState;

  /// User is successfully authenticated.
  const factory AuthenticationState.authenticated(AuthenticationStateModel stateModel) =
      Authentication$AuthenticatedState;

  /// User is not authenticated or authentication has failed.
  const factory AuthenticationState.unauthenticated(AuthenticationStateModel stateModel) =
      Authentication$UnauthenticatedState;

  /// Provides the default initial state.
  static AuthenticationState get initialState =>
      AuthenticationState.initial(AuthenticationStateModel());
}

/// Bloc responsible for handling authentication events and updating states.
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// Creates an instance of AuthenticationBloc.
  /// Accepts an authentication repository and an optional custom initial state.
  AuthenticationBloc({
    required IAuthenticationRepository authenticationRepository,
    AuthenticationState? initialState,
  }) : _iAuthenticationRepository = authenticationRepository,
       super(initialState ?? AuthenticationState.initialState) {
    /// Maps incoming events to their respective handlers.
    on<AuthenticationEvent>(
      (event, emit) => switch (event) {
        final _Authentication$InitEvent e => _authentication$InitEvent(e, emit),
        final _Authentication$CheckAuthEvent e => _authentication$CheckAuthEvent(e, emit),
        final _Authentication$LoginEvent e => _authentication$LoginEvent(e, emit),
        final _Authentication$RegisterEvent e => _authentication$RegisterEvent(e, emit),
        final _Authentication$SelectEstablishmentEvent e =>
          _authentication$SelectEstablishmentEvent(e, emit),
        final _Authentication$LogoutEvent e => _authentication$LogoutEvent(e, emit),
      },
    );
  }

  /// Internal instance of the authentication repository used for API calls.
  final IAuthenticationRepository _iAuthenticationRepository;

  /// Handles initial authentication event (currently empty).
  void _authentication$InitEvent(
    _Authentication$InitEvent event,
    Emitter<AuthenticationState> emit,
  ) async {}

  /// Handles checking the user's authentication status.
  /// Fetches user info and establishments from the repository.
  void _authentication$CheckAuthEvent(
    _Authentication$CheckAuthEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      /// Emits loading state while checking authentication.
      emit(AuthenticationState.inProgress(state.stateModel));

      final response = await _iAuthenticationRepository.user();

      /// Sends message to UI if available.
      if (response.message != null) {
        event.onMessage(response.message!);
      }

      /// If user exists, update state with user and their establishments.
      if (response.userModel != null) {
        final currentStateModel = state.stateModel.copyWith(
          userModel: () => response.userModel,
          allUserEstablishments: () => response.establishments,

          /// If there's only one establishment, select it automatically.
          establishment: () =>
              response.establishments?.length == 1 ? response.establishments?.firstOrNull : null,
        );

        emit(AuthenticationState.authenticated(currentStateModel));
      } else {
        emit(AuthenticationState.unauthenticated(state.stateModel));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles user login logic.
  void _authentication$LoginEvent(
    _Authentication$LoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      /// Prevents multiple simultaneous login attempts.
      if (state is Authentication$InProgressState) return;

      var currentStateModel = state.stateModel.copyWith();
      emit(AuthenticationState.inProgress(currentStateModel));

      final response = await _iAuthenticationRepository.login(
        email: event.email,
        password: event.password,
      );

      /// Sends messages returned from the backend.
      if (response.message != null) {
        event.onMessage(response.message!);
      }

      /// Auto-select establishment if user has exactly one.
      if (response.establishments != null && response.establishments!.length == 1) {
        currentStateModel = currentStateModel.copyWith(
          establishment: () => response.establishments!.first,
        );

        await _iAuthenticationRepository.saveEstablishment(
          establishment: response.establishments!.first,
        );
      }

      /// If login succeeded, update model with user info.
      if (response.userModel != null) {
        currentStateModel = currentStateModel.copyWith(
          userModel: () => response.userModel,
          allUserEstablishments: () => response.establishments,
        );

        emit(AuthenticationState.authenticated(currentStateModel));
      } else {
        emit(AuthenticationState.unauthenticated(state.stateModel));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles user registration.
  /// Creates a new user and establishment before sending request.
  void _authentication$RegisterEvent(
    _Authentication$RegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final establishmentId = Uuid().v4();
      final establishment = Establishment(id: establishmentId, name: event.establishmentName);

      final user = UserModel(
        id: Uuid().v4(),
        name: event.name,
        email: event.email,
        password: event.password,
        establishmentIds: [establishment.id!],
      );

      emit(AuthenticationState.inProgress(state.stateModel));

      final response = await _iAuthenticationRepository.registerUser(
        user: user,
        establishment: establishment,
      );

      /// If registration was successful, authenticate new user.
      if (response) {
        final currentStateModel = state.stateModel.copyWith(userModel: () => user);
        emit(AuthenticationState.authenticated(currentStateModel));
      } else {
        emit(AuthenticationState.unauthenticated(state.stateModel));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles selecting an establishment from the list.
  void _authentication$SelectEstablishmentEvent(
    _Authentication$SelectEstablishmentEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final updatedModel = state.stateModel.copyWith(establishment: () => event.establishment);

      await _iAuthenticationRepository.saveEstablishment(establishment: event.establishment);

      emit(AuthenticationState.authenticated(updatedModel));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles user logout.
  /// Clears user-related data and switches to unauthenticated state.
  void _authentication$LogoutEvent(
    _Authentication$LogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final success = await _iAuthenticationRepository.logout();

      if (success) {
        final clearedState = state.stateModel.copyWith(
          userModel: () => null,
          establishment: () => null,
          allUserEstablishments: () => <Establishment>[],
        );

        emit(AuthenticationState.unauthenticated(clearedState));
        event.onLogout();
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
