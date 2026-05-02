import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...package

import 'providers/advertisements.dart';
//...providers

class AdRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  BuildContext buildContext;

  AdRouteObserver(
    this.buildContext,
  );

  void _nextAdvert() {
    Provider.of<Advertisements>(buildContext, listen: false).nextItem();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute && previousRoute != null) {
      _nextAdvert();
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute is Route) {
      _nextAdvert();
    }
    super.didReplace();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute && route is PageRoute) {
      _nextAdvert();
    }
    super.didPop(route, previousRoute);
  }
}
