//
//  YSTTimer.m
//  YogaStretchingTimer
//
//  Created by Abegael Jackson on 2015-07-08.
//  Copyright (c) 2015 Abbey Jackson. All rights reserved.
//

#import "YSTTimer.h"

@implementation YSTTimer


-initWithTimer:(int)length breakLength:(int)amount sound:(int)file andRepeat:(int)mode{
    self = [super init];
    if (self) {
        _timerLength = length;
        _breakLength = amount;
        _sound = file;
        _repeatMode = mode;
    }
    return self;
}

@end
