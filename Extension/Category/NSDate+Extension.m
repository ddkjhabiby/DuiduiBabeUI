//
//  NSDate+Extension.m
//  Musk
//
//  Created by yangjie on 2020/9/11.
//  Copyright © 2020 Elon. All rights reserved.
//

#import "NSDate+Extension.h"
#import <Foundation/Foundation.h>

@implementation NSDate (Extension)

- (NSString *)momentTimeString {
    // 和现在时间比较
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self];
    NSString *timeString = @"";
    // 刚刚
    if (timeInterval <= 60) {
        timeString = @"刚刚";
    }
    // 1小时以内
    else if (timeInterval <= 60 * 60) {
        int mins = timeInterval / 60;
        timeString = [NSString stringWithFormat:@"%d分钟前", mins];
    }
    // 在1天内的
    else if(timeInterval <= 60 * 60 * 24) {
        int hour = timeInterval / 60 / 60;
        timeString = [NSString stringWithFormat:@"%d小时前", hour];
    } else {
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        });
        
        timeString = [dateFormatter stringFromDate:self];
    }
    
    return timeString;
}

@end
