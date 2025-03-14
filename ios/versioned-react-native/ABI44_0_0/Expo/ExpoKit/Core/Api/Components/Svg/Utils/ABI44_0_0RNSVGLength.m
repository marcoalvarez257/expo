#import <Foundation/Foundation.h>
#import "ABI44_0_0RNSVGLength.h"

@implementation ABI44_0_0RNSVGLength

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _value = 0;
        _unit = SVG_LENGTHTYPE_UNKNOWN;
    }
    return self;
}

+ (instancetype) lengthWithNumber:(CGFloat)number
{
    ABI44_0_0RNSVGLength *length = [[self alloc] init];
    length.unit = SVG_LENGTHTYPE_NUMBER;
    length.value = number;
    return length;
}

+ (instancetype) lengthWithString: (NSString *) lengthString {
    NSString *length = [lengthString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger stringLength = [length length];
    NSInteger percentIndex = stringLength - 1;
    ABI44_0_0RNSVGLength *output = [ABI44_0_0RNSVGLength alloc];
    if (stringLength == 0) {
        output.unit = SVG_LENGTHTYPE_UNKNOWN;
        output.value = 0;
        return output;
    } else if ([length characterAtIndex:percentIndex] == '%') {
        output.unit = SVG_LENGTHTYPE_PERCENTAGE;
        output.value = (CGFloat)[[length substringWithRange:NSMakeRange(0, percentIndex)] doubleValue];
    } else {
        NSInteger twoLetterUnitIndex = stringLength - 2;
        ABI44_0_0RNSVGLengthUnitType unit = SVG_LENGTHTYPE_NUMBER;
        if (twoLetterUnitIndex > 0) {
            NSString *lastTwo = [length substringFromIndex:twoLetterUnitIndex];
            NSUInteger end = twoLetterUnitIndex;
            if ([lastTwo isEqualToString:@"px"]) {
                unit = SVG_LENGTHTYPE_PX;
            } else if ([lastTwo isEqualToString:@"em"]) {
                unit = SVG_LENGTHTYPE_EMS;
            } else if ([lastTwo isEqualToString:@"ex"]) {
                unit = SVG_LENGTHTYPE_EXS;
            } else if ([lastTwo isEqualToString:@"pt"]) {
                unit = SVG_LENGTHTYPE_PT;
            } else if ([lastTwo isEqualToString:@"pc"]) {
                unit = SVG_LENGTHTYPE_PC;
            } else if ([lastTwo isEqualToString:@"mm"]) {
                unit = SVG_LENGTHTYPE_MM;
            } else if ([lastTwo isEqualToString:@"cm"]) {
                unit = SVG_LENGTHTYPE_CM;
            } else if ([lastTwo isEqualToString:@"in"]) {
                unit = SVG_LENGTHTYPE_IN;
            } else {
                end = stringLength;
            }
            output.value = (CGFloat)[[length substringWithRange:NSMakeRange(0, end)] doubleValue];
        } else {
            output.value = (CGFloat)[length doubleValue];
        }
        output.unit = unit;
    }
    return output;
}

- (BOOL) isEqualTo: (ABI44_0_0RNSVGLength *)other {
    return self.unit == other.unit && self.value == other.value;
}

@end
