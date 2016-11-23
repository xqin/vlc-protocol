// https://www.cocoawithlove.com/2010/09/minimalist-cocoa-programming.html
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@end

@implementation AppDelegate

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent: (NSAppleEventDescriptor *)replyEvent {
  // Get URL
  NSString *fullUrl = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
  // Strip vlc://
  NSString *url = [fullUrl substringWithRange:NSMakeRange(6, [fullUrl length]-6)];

  // Only allow urls starting with http:// or https://
  if (!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])) {
    // protocol not allowed
    [NSApp terminate:nil];
    return;
  }

  // Launch VLC
  NSTask *task = [[NSTask alloc] init];
  task.launchPath = @"/Applications/VLC.app/Contents/MacOS/VLC";
  task.arguments = @[@"--open", url];
  [task launch];

  // Close this program
  [NSApp terminate:nil];
}

@end

int main() {
  // Make sure the shared application is created
  [NSApplication sharedApplication];

  AppDelegate *appDelegate = [AppDelegate new];
  NSAppleEventManager *sharedAppleEventManager = [NSAppleEventManager new];
  [sharedAppleEventManager setEventHandler:appDelegate
                               andSelector:@selector(handleAppleEvent:withReplyEvent:)
                             forEventClass:kInternetEventClass
                                andEventID:kAEGetURL];

  // I guess we need a window
  NSWindow *window = [NSWindow alloc];
  [window initWithContentRect:NSMakeRect(0, 0, 200, 200)
                    styleMask:NSWindowStyleMaskTitled
                      backing:NSBackingStoreBuffered
                        defer:NO];

  [NSApp run];
  return 0;
}
