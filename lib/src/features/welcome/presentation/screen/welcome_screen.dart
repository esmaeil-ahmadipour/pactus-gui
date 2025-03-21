import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gui/src/core/common/cubits/app_accent_color_cubit.dart';
import 'package:gui/src/core/common/widgets/accent_color_picker_widget.dart';
import 'package:gui/src/core/common/widgets/adaptive_text_button.dart';
import 'package:gui/src/core/common/widgets/theme_switcher.dart';
import 'package:gui/src/core/router/route_name.dart';
import 'package:gui/src/core/utils/gen/assets/assets.gen.dart';
import 'package:gui/src/core/utils/gen/localization/locale_keys.dart';
import 'package:gui/src/features/main/language/core/localization_extension.dart';
import 'package:gui/src/features/main/theme/bloc/theme_bloc.dart';
import 'package:pactus_gui_widgetbook/app_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(70),
            Image.asset(
              Assets.images.welcomePic.path,
              width: double.infinity,
              height: 459,
            ),
            const Gap(40),
            Text(
              context.tr(LocaleKeys.welcome_title),
              style: InterTextStyles.bodyBold.copyWith(
                color: AppTheme.of(context).extension<DarkPallet>()!.dark900,
              ),
            ),
            const Gap(16),
            Text(
              context.tr(LocaleKeys.welcome_description),
              style: InterTextStyles.smallRegular.copyWith(
                color: AppTheme.of(context).extension<DarkPallet>()!.dark900,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            const Gap(16),

            /// to-do #117: these ThemeSwitcher & text & AccentColorPicker
            /// widgets are temporary so after we codeing setting screen
            /// they shit to there.
            BlocConsumer<AppThemeCubit, bool>(
              listener: (context, isDarkTheme) {
                if (isDarkTheme) {
                  context.read<AppAccentColorCubit>().replaceAccentColor();
                }
              },
              builder: (context, isDarkMode) {
                return const ThemeSwitcher();
              },
            ),
            const Gap(16),
            Text(
              'choose your Accent Color:',
              style: InterTextStyles.smallRegular.copyWith(
                color: AppTheme.of(context).extension<DarkPallet>()!.dark900,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            const AccentColorPicker(),
            const Gap(16),
            AdaptiveTextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color?>(
                  FluentTheme.of(context).accentColor,
                ),
              ),
              text: LocaleKeys.start_button_text,
              textColor: AppTheme.of(context)
                  .extension<OnAccentPallet>()!
                  .onAccentColor,
              onPressed: () {
                context.go(
                  '${AppRoute.welcome.fullPath}/${AppRoute.initializeMode.path}',
                );
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
