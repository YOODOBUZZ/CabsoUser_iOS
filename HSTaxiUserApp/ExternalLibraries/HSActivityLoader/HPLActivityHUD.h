//
//  HPLActivityHUD.h
//  FreshBrix
//
//  Created by QBUser on 10/10/14.
//  Copyright (c) 2014 HomeProLog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger, HPLActivityMaskType) {
    HPLActivityWithMask,
    HPLActivityWithOutMask,
};

@interface HPLActivityHUD : NSObject

/**
 *   @author Robert
 *   @brief  This will show activity view in the key window. activity view will be an animated lottie logo.
 *   @param maskType (HPLActivityMaskType) - Whether we need to mask the screen or not.
 *   @return void
 */

+ (void)showActivityWithMaskType:(HPLActivityMaskType)maskType;

/**
 *   @author Robert
 *   @brief Dismiss activity view from the keywindow
 *   @param nil
 *   @return void
 */

+ (void)dismiss;

/**
 *   @author Robert
 *   @brief Dismiss activity view from the keywindow
 *   @param point
 *   @return void
 */
+ (void)showActivityWithPosition:(CGPoint)point;
/**
 *   @author Robert
 *   @brief show activity with particular place
 *   @param nil
 *   @return void
 */
@end
