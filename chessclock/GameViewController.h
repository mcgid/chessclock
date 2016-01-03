//
//  DMViewController.h
//  chessclock
//
//  Created by Dan McGinnis on 12-02-25.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMGameView.h"

@interface GameViewController : UIViewController <DMGameViewDelegate>

- (void)pauseGame;

@end
