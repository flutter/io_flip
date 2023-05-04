import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class GameCardSuitsStory extends StatelessWidget {
  const GameCardSuitsStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Game Card Suits',
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            children: [
              GameCard(
                image:
                    'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                name: 'Air Dash',
                suitName: 'air',
                description: 'The best air hockey player in all the Dashland',
                power: 57,
              ),
              SizedBox(height: 16),
              GameCard(
                image:
                    'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                name: 'Fire Dash',
                suitName: 'fire',
                description: 'The hottest Dash in all the Dashland',
                power: 57,
              ),
              SizedBox(height: 16),
              GameCard(
                image:
                    'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                name: 'Water Dash',
                suitName: 'water',
                description: 'The best swimmer in all the Dashland',
                power: 57,
              ),
              SizedBox(height: 16),
              GameCard(
                image:
                    'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                name: 'Metal Dash',
                suitName: 'metal',
                description: 'The most heavy metal Dash in all the Dashland',
                power: 57,
              ),
              SizedBox(height: 16),
              GameCard(
                image:
                    'https://firebasestorage.googleapis.com/v0/b/top-dash-dev.appspot.com/o/public%2FDash_pirate_trumpets_field.png?alt=media',
                name: 'Dash the rock',
                suitName: 'earth',
                description: 'The most rock and roll Dash in all the Dashland',
                power: 57,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
