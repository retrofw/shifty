#include "input.h"
#include <SDL.h>
#include "../states.h"

int keys[2048];

void input()
{
	static SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		switch (event.type)
		{
			case SDL_QUIT:
				quit = 1;
			break;

			case SDL_KEYDOWN:
				keys[event.key.keysym.sym] = 1;
			break;

			case SDL_KEYUP:
				keys[event.key.keysym.sym] = 0;
			break;

			default:
			break;
		}
	}
}


#define RG_A              SDLK_LCTRL
#define RG_B              SDLK_LALT
#define RG_X              SDLK_SPACE
#define RG_Y              SDLK_LSHIFT
#define RG_L              SDLK_TAB
#define RG_R              SDLK_BACKSPACE
#define RG_POWER          SDLK_END
#define RG_BACKLIGHT      SDLK_3

void defaultKeymap(int **keyMap, int playerNum)
{
	switch (playerNum)
	{
		case 1:
			keyMap[KEY_UP] =			&keys[SDLK_UP];
			keyMap[KEY_DOWN] =			&keys[SDLK_DOWN];
			keyMap[KEY_LEFT] =			&keys[SDLK_LEFT];
			keyMap[KEY_RIGHT] =			&keys[SDLK_RIGHT];
			keyMap[KEY_ROTATE_LEFT] =	&keys[RG_Y];
			keyMap[KEY_ROTATE_RIGHT] =	&keys[RG_A];
			keyMap[KEY_DROP] =			&keys[RG_B];
			keyMap[KEY_OK] =			&keys[SDLK_RETURN];
			keyMap[KEY_BACK] =			&keys[SDLK_ESCAPE];
		break;
		case 2:
			keyMap[KEY_UP] =			&keys[SDLK_i];
			keyMap[KEY_DOWN] =			&keys[SDLK_k];
			keyMap[KEY_LEFT] =			&keys[SDLK_j];
			keyMap[KEY_RIGHT] =			&keys[SDLK_l];
			keyMap[KEY_ROTATE_LEFT] =	&keys[SDLK_g];
			keyMap[KEY_ROTATE_RIGHT] =	&keys[SDLK_h];
			keyMap[KEY_DROP] =			&keys[SDLK_u];
			keyMap[KEY_OK] =			&keys[SDLK_y];
			keyMap[KEY_BACK] =			&keys[SDLK_t];
		break;

		default:
		break;
	}
}
