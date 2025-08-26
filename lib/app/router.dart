import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/student/presentation/student_dashboard_screen.dart';
import '../features/teacher/presentation/teacher_dashboard_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/teacher/presentation/teacher_sign_in_screen.dart';
import '../features/auth/presentation/auth_landing_screen.dart';
import '../features/student/presentation/flow/course_selection_screen.dart';
import '../features/student/presentation/flow/teacher_selection_screen.dart';
import '../features/student/presentation/flow/budget_selection_screen.dart';
import '../features/student/presentation/flow/payment_method_screen.dart';

enum AppRole { student, teacher }

class AppRouter {
  AppRouter({required this.getCurrentRole});

  final AppRole? Function() getCurrentRole;

  late final GoRouter router = GoRouter(
    initialLocation: '/auth',
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthLandingScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/student/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/student',
        redirect: _guardRole(AppRole.student),
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/student/onboarding/course',
        redirect: _guardSignedIn(),
        builder: (context, state) => const CourseSelectionScreen(),
      ),
      GoRoute(
        path: '/student/onboarding/teacher',
        redirect: _guardSignedIn(),
        builder: (context, state) => const TeacherSelectionScreen(),
      ),
      GoRoute(
        path: '/student/onboarding/budget',
        redirect: _guardSignedIn(),
        builder: (context, state) => const BudgetSelectionScreen(),
      ),
      GoRoute(
        path: '/student/onboarding/payment',
        redirect: _guardSignedIn(),
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: '/teacher',
        redirect: _guardRole(AppRole.teacher),
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/teacher/signin',
        builder: (context, state) => const TeacherSignInScreen(),
      ),
    ],
  );

  String? Function(BuildContext, GoRouterState) _guardRole(AppRole role) {
    return (context, state) {
      final current = getCurrentRole();
      if (current == null) return '/role';
      if (current != role) return '/role';
      return null;
    };
  }

  String? Function(BuildContext, GoRouterState) _guardSignedIn() {
    return (context, state) {
      // For now, rely on role being set as proxy for sign-in
      final current = getCurrentRole();
      if (current == null) return '/student/signin';
      return null;
    };
  }
}


