//
//  UIColor+CTRExtensions.m
//  chessclock
//
//  Created by Dan on 2013-07-19.
//
//

#import "UIColor+CTRExtensions.h"

@implementation UIColor (CTRExtensions)

+(UIColor *)ctr_greyWithValue:(CGFloat)value;
{
    return [UIColor colorWithRed:value/255.0 green:value/255.0 blue:value/255.0 alpha:1.0];
}


+(UIColor *)ctr_blueColor;
{
    return [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
}

+(UIColor *)ctr_whiteDisabledColor;
{
    return [UIColor ctr_greyWithValue:221];
}

+(UIColor *)ctr_blackDisabledColor;
{
    return [UIColor ctr_greyWithValue:52];
}

+(UIColor *)ctr_lightGreyColor;
{
    return [UIColor ctr_greyWithValue:240];
}

+(UIColor *)ctr_greyColor;
{
    return [UIColor ctr_greyWithValue:170];
}

@end
