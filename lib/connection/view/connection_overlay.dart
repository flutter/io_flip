import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/connection/connection.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
    final l10n = context.l10n;
    return Stack(
      children: [
        if (child != null) child!,
        Positioned.fill(
          child: Material(
            color: TopDashColors.seedScrim.withOpacity(0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error == WebSocketErrorCode.playerAlreadyConnected
                      ? l10n.playerAlreadyConnectedError
                      : l10n.unknownConnectionError,
                  style: TopDashTextStyles.mobileH1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error == WebSocketErrorCode.playerAlreadyConnected
                      ? l10n.playerAlreadyConnectedErrorBody
                      : l10n.unknownConnectionErrorBody,
                  style: TopDashTextStyles.bodyXL,
                  textAlign: TextAlign.center,
                ),
                if (error == WebSocketErrorCode.unknown) ...[
                  const SizedBox(height: 40),
                  RoundedButton.text(
                    l10n.unknownConnectionErrorButton,
                    onPressed: () => context.read<ConnectionBloc>().add(
                          const ConnectionRequested(),
                        ),
                    backgroundColor: TopDashColors.seedBlack,
                    foregroundColor: TopDashColors.seedWhite,
                    borderColor: TopDashColors.seedPaletteNeutral40,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
