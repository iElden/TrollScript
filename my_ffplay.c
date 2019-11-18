#include <SFML/Audio.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>

// Warning: This is meant to be used with the MarioKart
// script will not substitute the real ffplay

#define VERSION "1.0"

typedef struct {
	char *soundPath;
	float volume;
	bool loop;
} Options;

bool parseFakeArguments(int ac, char **av, Options *options)
{
	for (int i = 0; i < ac; i++) {
		if (strcmp(av[i], "-loop") == 0) {
			i++;
			options->loop = true;
		} else if (strcmp(av[i], "-volume") == 0) {
			if (ac - i == 1)
				return false;
			options->volume = atof(av[++i]);
		} else if (*av[i] != '-') {
			options->soundPath = av[i];
		}
	}
	return (true);
}

int playSound(Options *options)
{
	if (!options->soundPath)
		return EXIT_FAILURE;

	sfMusic *music = sfMusic_createFromFile(options->soundPath);

	if (!music)
		return EXIT_FAILURE;
	sfMusic_setLoop(music, options->loop);
	sfMusic_setVolume(music, options->volume);
	sfMusic_play(music);
	while (sfMusic_getStatus(music) == sfPlaying)
		usleep(10);
	sfMusic_destroy(music);
}

int main(int ac, char **av)
{
	if (ac == 1) {
		printf("Usage: %s [OPTION] <file>\n", av[0]);
		return EXIT_FAILURE;
	} else if (strcmp(av[1], "-version") == 0) {
		puts("my_ffplay version " VERSION);
		return EXIT_SUCCESS;
	}
	
	Options options = {
		NULL,
		100,
		false
	};

	if (!parseFakeArguments(ac - 1, av + 1, &options))
		return EXIT_FAILURE;
	return playSound(&options);
}
