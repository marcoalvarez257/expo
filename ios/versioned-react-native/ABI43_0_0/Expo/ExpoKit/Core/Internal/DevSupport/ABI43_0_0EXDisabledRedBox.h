// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI43_0_0ReactCommon/ABI43_0_0RCTTurboModule.h>
#import <ABI43_0_0React/ABI43_0_0RCTRedBox.h>

@interface ABI43_0_0EXDisabledRedBox : ABI43_0_0RCTRedBox <ABI43_0_0RCTTurboModule>

- (void)showError:(NSError *)message;
- (void)showErrorMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message withDetails:(NSString *)details;
- (void)showErrorMessage:(NSString *)message withRawStack:(NSString *)rawStack;
- (void)showErrorMessage:(NSString *)message withRawStack:(NSString *)rawStack errorCookie:(int)errorCookie;
- (void)showErrorMessage:(NSString *)message withStack:(NSArray<NSDictionary *> *)stack;
- (void)updateErrorMessage:(NSString *)message withStack:(NSArray<NSDictionary *> *)stack;
- (void)showErrorMessage:(NSString *)message withStack:(NSArray<NSDictionary *> *)stack showIfHidden:(BOOL)shouldShow;
- (void)showErrorMessage:(NSString *)message withStack:(NSArray<NSDictionary *> *)stack errorCookie:(int)errorCookie;
- (void)updateErrorMessage:(NSString *)message withStack:(NSArray<NSDictionary *> *)stack errorCookie:(int)errorCookie;
- (void)showErrorMessage:(NSString *)message withParsedStack:(NSArray<id> *)stack;
- (void)updateErrorMessage:(NSString *)message withParsedStack:(NSArray<id> *)stack;
- (void)showErrorMessage:(NSString *)message
         withParsedStack:(NSArray<id> *)stack
             errorCookie:(int)errorCookie;
- (void)updateErrorMessage:(NSString *)message
           withParsedStack:(NSArray<id> *)stack
               errorCookie:(int)errorCookie;

- (void)dismiss;

- (void)setOverrideReloadAction:(dispatch_block_t __unused)block;

@end
