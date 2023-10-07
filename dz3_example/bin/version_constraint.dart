import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';
import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  final packages = <PubPackage>[];
  final packageConstraints = <Map<Version, Map<int, VersionConstraint>>>[];
  final notFound = <String>{};
  final versionsSet = <Version>{};

  // Fetch package info from Pub

  void visitVersionConstraint(VersionConstraint constraint) {
    if (constraint is Version) {
      versionsSet.add(constraint);
    } else if (constraint is VersionRange) {
      if (constraint.min != null) {
        versionsSet.add(constraint.min!);
      }
      if (constraint.max != null) {
        versionsSet.add(constraint.max!);
      }
    } else if (constraint is VersionUnion) {
      constraint.ranges.forEach(visitVersionConstraint);
    } else {
      throw ArgumentError('Unknown constraint type: $constraint');
    }
  }

  final currentDartVersion = Version.parse('3.2.0');
  bool isCompatibleSdkConstraint(VersionConstraint constraint) {
    if (constraint is! VersionRange) {
      // Exact version probably not compatible.
      return constraint == currentDartVersion;
    } else if ((constraint.min?.major ?? 0) < 2) {
      // Pre-2.0 versions are not compatible.
      return false;
    } else if (!constraint.allows(currentDartVersion) &&
        (constraint.allowsAny(VersionConstraint.parse('<2.12.0')) ||
            (constraint.max != Version.parse('3.0.0-0')))) {
      // Versions before 2.12.0 are not compatible.
      return false;
    } else {
      return true;
    }
  }

  final pubClient = PubClient();
  Future<void> addPackage(String name) async {
    if (packages.any((p) => p.name == name)) {
      return;
    }
    late final PubPackage info;
    try {
      info = await pubClient.packageInfo(name);
    } on NotFoundException {
      notFound.add(name);
      return;
    }
    final constraints = <Version, Map<int, VersionConstraint>>{};
    packages.add(info);
    packageConstraints.add(constraints);
    for (final ver in info.versions) {
      final sdkConstraint = ver.pubspec.environment?.sdkConstraint;
      if (sdkConstraint == null || !isCompatibleSdkConstraint(sdkConstraint)) {
        continue;
      }
      versionsSet.add(Version.parse(ver.version));
      final verConstraints = <int, VersionConstraint>{};
      constraints[Version.parse(ver.version)] = verConstraints;
      for (final dep in ver.pubspec.dependencies.entries) {
        final ref = dep.value;
        if (ref is HostedReference) {
          visitVersionConstraint(ref.versionConstraint);
          await addPackage(dep.key);
          if (notFound.contains(dep.key)) {
            // If a dependency is not found, just remove the whole version.
            constraints.remove(Version.parse(ver.version));
            break;
          } else {
            verConstraints[packages.indexWhere((p) => p.name == dep.key)] =
                ref.versionConstraint;
          }
        }
      }
    }
  }

  print('Fetching package info...');
  await addPackage('json_serializable');

  pubClient.close();

  // Sort all versions in ascending order, this simplifies the work of
  // comparisons, otherwise we would need to build a function in z3 that
  // parses a semver.
  final versions = versionsSet.toList()..sort();
  final versionsInv = {
    for (var i = 0; i < versions.length; i++) versions[i]: i,
  };

  final s = solver();

  // Map from index of package to index of version
  final maybeInt = declareMaybe(intSort);
  final solution = constVar('solution', arraySort(intSort, maybeInt.sort));

  // Enforce our desired version of json_serializable
  s.add(solution[packages.indexWhere((p) => p.name == 'json_serializable')]
      .eq(maybeInt.just(versionsInv[Version.parse('6.7.1')]!)));

  Expr constrainVersion(Expr expr, VersionConstraint constraint) {
    if (constraint.isEmpty) {
      return expr.notEq(expr);
    } else if (constraint is Version) {
      return expr.eq(maybeInt.just(versionsInv[constraint]!));
    } else if (constraint is VersionRange) {
      final v = maybeInt.value(expr);
      return andN([
        maybeInt.isJust(expr),
        if (constraint.min != null)
          constraint.includeMin
              ? v >= versionsInv[constraint.min]!
              : v > versionsInv[constraint.min]!,
        if (constraint.max != null)
          constraint.includeMax
              ? v <= versionsInv[constraint.max]!
              : v < versionsInv[constraint.max]!,
      ]);
    } else if (constraint is VersionUnion) {
      return orN(constraint.ranges.map((r) => constrainVersion(expr, r)));
    } else {
      throw ArgumentError('Unknown constraint type: $constraint');
    }
  }

  for (var i = 0; i < packages.length; i++) {
    s.add(orN([
      solution[i].eq(maybeInt.nothing),
      for (final ver in packageConstraints[i].keys)
        solution[i].eq(maybeInt.just(versionsInv[ver]!)),
    ]));
    for (final ver in packageConstraints[i].entries) {
      final constraints = <Expr>[];
      for (final constraint in ver.value.entries) {
        constraints.add(
          constrainVersion(solution[constraint.key], constraint.value),
        );
      }
      s.add(solution[i]
          .eq(maybeInt.just(versionsInv[ver.key]!))
          .implies(andN(constraints)));
    }
  }

  final score = constVar('score', intSort);

  s.add(score.eq(addN([
    for (var i = 0; i < packages.length; i++)
      maybeInt.isJust(solution[i]).thenElse(
            maybeInt.value(solution[i]),
            versions.length, // Maximum reward for not using a package
          ),
  ])));

  // Maximize the versions of all of the packages
  // s.maximize(score);

  print('Solving...');

  Model? model;
  var total = 0.0;
  for (;;) {
    final result = s.check();
    if (result == false) {
      break;
    } else if (result == null) {
      print('Unknown (${s.getReasonUnknown()})');
    }
    total += s.getStats().getData()['time'] ?? 0;
    model = s.getModel();
    s.add(score > model[score]);
  }

  if (model == null) {
    print('No solution found');
  } else {
    print('\ndependencies:');
    for (var i = 0; i < packages.length; i++) {
      final package = packages[i];
      if (model[maybeInt.isJust(solution[i])].toBool()) {
        print(
          '  ${package.name}: ${versions[model[maybeInt.value(solution[i])].toInt()]}',
        );
      }
    }
  }

  print('\nTook ${total}s');
}
