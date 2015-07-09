//
//  YSTTimer.h
//  YogaStretchingTimer
//
//  Created by Abegael Jackson on 2015-07-08.
//  Copyright (c) 2015 Abbey Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTTimer : NSObject

@property (assign, nonatomic) int timerLength;
@property (assign, nonatomic) int breakLength;

@property (assign, nonatomic) int sound;
@property (assign, nonatomic) int repeatMode;


-initWithTimer:(int)length breakLength:(int)amount sound:(int)file andRepeat:(int)mode;

@end
