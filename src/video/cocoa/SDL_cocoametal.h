#include "../../SDL_internal.h"

#ifndef _SDL_cocoametal_h
#define _SDL_cocoametal_h

#if SDL_VIDEO_METAL

#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>

@interface SDLMetalContext : NSObject {
  id<MTLDevice>            d_device;
  SDL_Window              *d_window;
  CAMetalLayer            *d_layer;
  id<MTLTexture>           d_depthTexture;

  id<CAMetalDrawable>      d_drawable;
  MTLRenderPassDescriptor *d_passDescriptor;
}

- (id)                        initForWindow: (SDL_Window *)window;
- (void)                      dealloc;
- (MTLRenderPassDescriptor *) beginFrame;
- (void)                      endFrame;

@end

/* Metal functions */
extern SDL_MetalContext Cocoa_Metal_CreateContext (_THIS, SDL_Window * window);
extern void *           Cocoa_Metal_BeginFrame    (_THIS, SDL_MetalContext context);
extern void             Cocoa_Metal_EndFrame      (_THIS, SDL_MetalContext context);
extern void             Cocoa_Metal_DeleteContext (_THIS, SDL_MetalContext context);

#endif /* SDL_VIDEO_METAL */

#endif /* _SDL_cocoametal_h */
