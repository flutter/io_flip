import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/connection/connection.dart';
import 'package:top_dash/l10n/l10n.dart';

class ConnectionOverlay extends StatelessWidget {
  const ConnectionOverlay({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, ConnectionState>(
      builder: (context, state) {
        if (state is ConnectionFailure) {
          return _ConnectionOverlayFailure(
            error: state.error,
            child: child,
          );
        }

        return child ?? const SizedBox.shrink();
      },
    );
  }
}

class _ConnectionOverlayFailure extends StatelessWidget {
  const _ConnectionOverlayFailure({
    required this.error,
    required this.child,
  });

  final WebSocketErrorCode error;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        Positioned.fill(
          child: ColoredBox(
            color: Colors.white.withOpacity(0.9),
            child: Center(
              child: Text(
                error == WebSocketErrorCode.playerAlreadyConnected
                    ? context.l10n.playerAlreadyConnectedError
                    : context.l10n.unknownConnectionError,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
