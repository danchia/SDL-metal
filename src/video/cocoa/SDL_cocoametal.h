#include "../../SDL_internal.h"

#ifndef _SDL_cocoametal_h
#define _SDL_cocoametal_h

#if SDL_VIDEO_METAL

#import <Metal/Metal.h>

/* Metal functions */
extern SDL_MetalContext Cocoa_Metal_CreateContext(_THIS, SDL_Window * window);
extern void             Cocoa_Metal_DeleteContext(_THIS, SDL_MetalContext context);

#endif /* SDL_VIDEO_METAL */

#endif /* _SDL_cocoametal_h */
