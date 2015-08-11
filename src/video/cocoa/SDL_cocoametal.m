#include "../../SDL_internal.h"

#if SDL_VIDEO_METAL
#include "SDL_cocoavideo.h"
#include "SDL_cocoametal.h"

@implementation SDLMetalContext : NSObject

- (id)initForWindow: (SDL_Window *)sdlwindow
{
  self = [super init];

  d_device = MTLCreateSystemDefaultDevice();
  NSLog(@"Hello metal: %@", [d_device name]);

  d_window = sdlwindow;

  d_layer = [[CAMetalLayer layer] retain];
  d_layer.device      = d_device;
  d_layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

  SDL_WindowData *sdlwindowdata = (SDL_WindowData *)sdlwindow->driverdata;
  [[sdlwindowdata->nswindow contentView] setWantsLayer:YES];
  [[sdlwindowdata->nswindow contentView] setLayer:d_layer];

  d_passDescriptor = nil;

  return self;
}

- (void) dealloc
{
  NSLog(@"Goodbye metal: %@", [d_device name]);

  SDL_WindowData *sdlwindowdata = (SDL_WindowData *)d_window->driverdata;
  [[sdlwindowdata->nswindow contentView] setWantsLayer:NO];
  [[sdlwindowdata->nswindow contentView] setLayer:nil];

  [d_layer release];

  [super dealloc];
}

- (id<MTLDevice>) device
{
  return d_device;
}

- (MTLRenderPassDescriptor *) beginFrame
{
  if (d_passDescriptor == nil) {
    d_passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];

    d_drawable = [d_layer nextDrawable];
    id<MTLTexture> texture = d_drawable.texture;

    // Color attachment:
    MTLRenderPassColorAttachmentDescriptor *color = d_passDescriptor.colorAttachments[0];
    color.texture = texture;
    color.loadAction = MTLLoadActionClear;
    color.clearColor = MTLClearColorMake(0.25f, 0.0f, 0.0f, 1.0f);

    // Depth & stencil attachment:
    //
    // Create the depth texture if necessary:
    if (!d_depthTexture ||
	d_depthTexture.width != texture.width ||
	d_depthTexture.height != texture.height) {
      MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: MTLPixelFormatDepth32Float
							 width: texture.width
							 height: texture.height
							 mipmapped: NO];
      desc.resourceOptions = MTLResourceStorageModePrivate;

      d_depthTexture = [d_device newTextureWithDescriptor: desc];
    }

    MTLRenderPassDepthAttachmentDescriptor *depth = d_passDescriptor.depthAttachment;
    depth.texture = d_depthTexture;
    depth.loadAction = MTLLoadActionClear;
    depth.storeAction = MTLStoreActionDontCare;
    depth.clearDepth = 1.0;
  }

  return d_passDescriptor;
}

- (void) presentCommandBuffer: (id<MTLCommandBuffer>)commandBuffer
{
  [commandBuffer presentDrawable: d_drawable];
}

- (void) endFrame
{
  if (d_passDescriptor) {
    d_drawable = nil;
    d_passDescriptor = nil;
  }
}

@end

SDL_MetalContext
Cocoa_Metal_CreateContext(_THIS, SDL_Window * window)
{ @autoreleasepool {
    NSLog(@"Cocoa_Metal_CreateContext");

    SDLMetalContext *nscontext;

    nscontext = [[SDLMetalContext alloc] initForWindow:window];

    return nscontext;
}}

void *
Cocoa_Metal_GetDevice(_THIS, SDL_MetalContext context)
{
  SDLMetalContext *nscontext = (SDLMetalContext *)context;
  return [nscontext device];
}

void *
Cocoa_Metal_BeginFrame(_THIS, SDL_MetalContext context)
{
  SDLMetalContext *nscontext = (SDLMetalContext *)context;
  return [nscontext beginFrame];
}

void
Cocoa_Metal_PresentCommandBuffer(_THIS, SDL_MetalContext context, void * commandBuffer)
{
  SDLMetalContext *nscontext = (SDLMetalContext *)context;
  id<MTLCommandBuffer> mtlcommandBuffer = (id<MTLCommandBuffer>)commandBuffer;
  [nscontext presentCommandBuffer: mtlcommandBuffer];
}

void
Cocoa_Metal_EndFrame(_THIS, SDL_MetalContext context)
{
  SDLMetalContext *nscontext = (SDLMetalContext *)context;
  [nscontext endFrame];
}

void
Cocoa_Metal_DeleteContext(_THIS, SDL_MetalContext context)
{ @autoreleasepool {
    NSLog(@"Cocoa_Metal_DeleteContext");

    SDLMetalContext *nscontext = (SDLMetalContext *)context;

    [nscontext release];
}}

#endif /* SDL_VIDEO_METAL */

