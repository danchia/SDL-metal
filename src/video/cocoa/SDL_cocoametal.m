#include "../../SDL_internal.h"

#if SDL_VIDEO_METAL
#include "SDL_cocoavideo.h"
#include "SDL_cocoametal.h"

SDL_MetalContext
Cocoa_Metal_CreateContext(_THIS, SDL_Window * window)
{ @autoreleasepool {
    NSLog(@"Cocoa_Metal_CreateContext");

    return NULL;
}
}

void
Cocoa_Metal_DeleteContext(_THIS, SDL_MetalContext context)
{ @autoreleasepool {
    NSLog(@"Cocoa_Metal_DeleteContext");
}
}

#endif /* SDL_VIDEO_METAL */

