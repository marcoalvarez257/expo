#import <QuartzCore/QuartzCore.h>
#import <ABI44_0_0React/ABI44_0_0RCTConvert.h>
#import <ABI44_0_0React/ABI44_0_0RCTViewManager.h>
#import <UIKit/UIKit.h>

#import "ABI44_0_0RCTConvert+REATransition.h"
#import "ABI44_0_0REATransition.h"
#import "ABI44_0_0REATransitionValues.h"

#define DEFAULT_PROPAGATION_SPEED 3

@interface ABI44_0_0REATransitionGroup : ABI44_0_0REATransition
@property (nonatomic) BOOL sequence;
@property (nonatomic) NSArray *transitions;
- (instancetype)initWithConfig:(NSDictionary *)config;
@end

@interface ABI44_0_0REAVisibilityTransition : ABI44_0_0REATransition
@property (nonatomic) ABI44_0_0REATransitionAnimationType animationType;
- (ABI44_0_0REATransitionAnimation *)appearView:(UIView *)view inParent:(UIView *)parent;
- (ABI44_0_0REATransitionAnimation *)disappearView:(UIView *)view fromParent:(UIView *)parent;
- (instancetype)initWithConfig:(NSDictionary *)config;
@end

@interface ABI44_0_0REAInTransition : ABI44_0_0REAVisibilityTransition
- (instancetype)initWithConfig:(NSDictionary *)config;
@end

@interface ABI44_0_0REAOutTransition : ABI44_0_0REAVisibilityTransition
- (instancetype)initWithConfig:(NSDictionary *)config;
@end

@interface ABI44_0_0REAChangeTransition : ABI44_0_0REATransition
- (instancetype)initWithConfig:(NSDictionary *)config;
@end

@implementation ABI44_0_0REATransition {
  __weak UIView *_root;
  NSMutableDictionary<NSNumber *, ABI44_0_0REATransitionValues *> *_startValues;
  NSMutableDictionary<NSNumber *, ABI44_0_0REATransitionValues *> *_endValues;
}

+ (ABI44_0_0REATransition *)inflate:(NSDictionary *)config
{
  ABI44_0_0REATransitionType type = [ABI44_0_0RCTConvert ABI44_0_0REATransitionType:config[@"type"]];
  switch (type) {
    case ABI44_0_0REATransitionTypeGroup:
      return [[ABI44_0_0REATransitionGroup alloc] initWithConfig:config];
    case ABI44_0_0REATransitionTypeIn:
      return [[ABI44_0_0REAInTransition alloc] initWithConfig:config];
    case ABI44_0_0REATransitionTypeOut:
      return [[ABI44_0_0REAOutTransition alloc] initWithConfig:config];
    case ABI44_0_0REATransitionTypeChange:
      return [[ABI44_0_0REAChangeTransition alloc] initWithConfig:config];
    case ABI44_0_0REATransitionTypeNone:
    default:
      ABI44_0_0RCTLogError(@"Invalid transitioning type %@", config[@"type"]);
  }
  return nil;
}

- (instancetype)initWithConfig:(NSDictionary *)config
{
  if (self = [super init]) {
    _duration = [ABI44_0_0RCTConvert double:config[@"durationMs"]] / 1000.0;
    _delay = [ABI44_0_0RCTConvert double:config[@"delayMs"]] / 1000.0;
    _interpolation = [ABI44_0_0RCTConvert ABI44_0_0REATransitionInterpolationType:config[@"interpolation"]];
    _propagation = [ABI44_0_0RCTConvert ABI44_0_0REATransitionPropagationType:config[@"propagation"]];
  }
  return self;
}

- (void)captureRecursiveIn:(UIView *)view
                        to:(NSMutableDictionary<NSNumber *, ABI44_0_0REATransitionValues *> *)map
                   forRoot:(UIView *)root
{
  NSNumber *tag = view.ABI44_0_0ReactTag;
  if (tag != nil) {
    map[tag] = [[ABI44_0_0REATransitionValues alloc] initWithView:view forRoot:root];
    for (UIView *subview in view.ABI44_0_0ReactSubviews) {
      [self captureRecursiveIn:subview to:map forRoot:root];
    }
  }
}

- (void)startCaptureInRoot:(UIView *)root
{
  _startValues = [NSMutableDictionary new];
  [self captureRecursiveIn:root to:_startValues forRoot:root];
}

- (void)playInRoot:(UIView *)root
{
  _endValues = [NSMutableDictionary new];
  [self captureRecursiveIn:root to:_endValues forRoot:root];
  NSArray *animations = [self animationsForTransitioning:_startValues endValues:_endValues forRoot:root];
  for (ABI44_0_0REATransitionAnimation *animation in animations) {
    [animation play];
  }
  _startValues = nil;
  _endValues = nil;
}

- (ABI44_0_0REATransitionValues *)findStartValuesForKey:(NSNumber *)key
{
  if (_parent != nil) {
    return [_parent findStartValuesForKey:key];
  }
  return _startValues[key];
}

- (ABI44_0_0REATransitionValues *)findEndValuesForKey:(NSNumber *)key
{
  if (_parent != nil) {
    return [_parent findEndValuesForKey:key];
  }
  return _endValues[key];
}

- (CFTimeInterval)propagationDelayForTransitioning:(ABI44_0_0REATransitionValues *)startValues
                                         endValues:(ABI44_0_0REATransitionValues *)endValues
                                           forRoot:(UIView *)root
{
  if (self.propagation == ABI44_0_0REATransitionPropagationNone) {
    return 0.;
  }

  ABI44_0_0REATransitionValues *values = endValues;
  if (values == nil) {
    values = startValues;
  }

  double fraction = 0.;
  switch (self.propagation) {
    case ABI44_0_0REATransitionPropagationLeft:
      fraction = values.centerRelativeToRoot.x / root.layer.bounds.size.width;
      break;
    case ABI44_0_0REATransitionPropagationRight:
      fraction = 1. - values.centerRelativeToRoot.x / root.layer.bounds.size.width;
      break;
    case ABI44_0_0REATransitionPropagationTop:
      fraction = values.centerRelativeToRoot.y / root.layer.bounds.size.height;
      break;
    case ABI44_0_0REATransitionPropagationBottom:
      fraction = 1. - values.centerRelativeToRoot.y / root.layer.bounds.size.height;
      break;
  }

  return _duration * MIN(MAX(0., fraction), 1.) / DEFAULT_PROPAGATION_SPEED;
}

- (CAMediaTimingFunction *)mediaTiming
{
  switch (self.interpolation) {
    case ABI44_0_0REATransitionInterpolationLinear:
      return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    case ABI44_0_0REATransitionInterpolationEaseIn:
      return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    case ABI44_0_0REATransitionInterpolationEaseOut:
      return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    case ABI44_0_0REATransitionInterpolationEaseInOut:
      return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  }
}

- (ABI44_0_0REATransitionAnimation *)animationForTransitioning:(ABI44_0_0REATransitionValues *)startValues
                                            endValues:(ABI44_0_0REATransitionValues *)endValues
                                              forRoot:(UIView *)root
{
  return nil;
}

- (NSArray<ABI44_0_0REATransitionAnimation *> *)
    animationsForTransitioning:(NSMutableDictionary<NSNumber *, ABI44_0_0REATransitionValues *> *)startValues
                     endValues:(NSMutableDictionary<NSNumber *, ABI44_0_0REATransitionValues *> *)endValues
                       forRoot:(UIView *)root
{
  NSMutableArray *animations = [NSMutableArray new];
  [startValues enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ABI44_0_0REATransitionValues *startValue, BOOL *stop) {
    ABI44_0_0REATransitionValues *endValue = endValues[key];
    ABI44_0_0REATransitionAnimation *animation = [self animationForTransitioning:startValue endValues:endValue forRoot:root];
    if (animation != nil) {
      animation.animation.timingFunction = self.mediaTiming;
      animation.animation.duration = self.duration;
      [animation delayBy:self.delay];
      CFTimeInterval propagationDelay = [self propagationDelayForTransitioning:startValue
                                                                     endValues:endValue
                                                                       forRoot:root];
      [animation delayBy:propagationDelay];
      //      animation.animation.duration -= propagationDelay;
      [animations addObject:animation];
    }
  }];
  [endValues enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ABI44_0_0REATransitionValues *endValue, BOOL *stop) {
    if (startValues[key] == nil) {
      ABI44_0_0REATransitionAnimation *animation = [self animationForTransitioning:nil endValues:endValue forRoot:root];
      if (animation != nil) {
        animation.animation.timingFunction = self.mediaTiming;
        animation.animation.duration = self.duration;
        [animation delayBy:self.delay];
        CFTimeInterval propagationDelay = [self propagationDelayForTransitioning:nil endValues:endValue forRoot:root];
        [animation delayBy:propagationDelay];
        //        animation.animation.duration -= propagationDelay;
        [animations addObject:animation];
      }
    }
  }];
  return animations;
}

@end
