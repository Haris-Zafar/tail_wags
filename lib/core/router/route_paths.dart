
class RoutePaths {
  RoutePaths._();

  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const signUp = 'sign-up';
  static const login = 'login';
  static const forgotPassword = 'forgot-password';

  // Bottom-nav tabs (each is its own StatefulShellBranch)
  static const home = 'home';
  static const features = 'features';
  static const community = 'community';
  static const favorites = 'favorites';
  static const settings = 'settings';

  // Pushed on top of a tab's own stack
  static const createEvent = 'create-event';
  static const eventDetail = 'event-detail';
  static const createPoll = 'create-poll';
  static const groupProfile = 'group-profile';
  static const editUsername = 'edit-username';
  static const notifications = 'notifications';
}
