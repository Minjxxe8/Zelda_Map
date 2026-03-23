String translateAuthError(String error) {
  final e = error.toLowerCase();

  if (e.contains('invalid format') || e.contains('invalid email')) {
    return "L'adresse email n'est pas valide.";
  }
  if (e.contains('invalid login credentials')) {
    return "Email ou mot de passe incorrect.";
  }
  if (e.contains('password should be at least')) {
    return "Le mot de passe doit contenir au moins 6 caractères.";
  }
  if (e.contains('user already exists')) {
    return "Cette adresse email est déjà utilisée.";
  }
  if (e.contains('weak password')) {
    return "Le mot de passe est trop simple.";
  }

  if (e.contains('user already exists') || e.contains('email already registered')) {
    return "Cette adresse email est déjà utilisée.";
  }

  if (e.contains('profiles_username_key') || e.contains('unique constraint') && e.contains('username')) {
    return "Ce pseudonyme est déjà pris, choisis-en un autre !";
  }

  if (e.contains('network') || e.contains('timeout') || e.contains('500') || e.contains('fetch')) {
    return "Une erreur est survenue, veuillez réessayer plus tard.";
  }

  // Erreur par défaut si on ne connaît pas le message précis
  return "Une erreur inattendue est survenue.";
}
