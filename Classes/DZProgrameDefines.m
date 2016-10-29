//
//  DZProgramDefines.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZProgrameDefines.h"
#import <objc/runtime.h>




Class DZGetCurrentClassInvocationSEL(NSString* functionString)
{
    
    if (functionString.length == 0) {
        return nil;
    }
    
    NSRange rangeStart = [functionString rangeOfString:@"["];
    NSRange rangeEnd = [functionString rangeOfString:@" "];
    if (rangeStart.location == NSNotFound || rangeEnd.location == NSNotFound) {
        return nil;
    }
    NSInteger start = rangeStart.location + rangeStart.length;
    if (rangeEnd.location - start <= 0) {
        return nil;
    }
    NSRange classRange = NSMakeRange(start, rangeEnd.location - start);
    NSString *classString = [functionString substringWithRange:classRange];
    return NSClassFromString(classString);
}

BOOL DZCheckSuperResponseToSelector(Class cla, SEL selector) {
    Class superClass = class_getSuperclass(cla);
    return class_respondsToSelector(superClass, selector);
}



void swizzInstance(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
