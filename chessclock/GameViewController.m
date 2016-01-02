//
//  DMViewController.m
//  chessclock
//
//  Created by Dan McGinnis on 12-02-25.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
@import GameplayKit;

#import "GameViewController.h"
#import "DMClock.h"
#import "DMGame.h"
#import "DMStates.h"

#import "UIColor+CTRExtensions.h"

@interface GameViewController ()

@property(nonatomic, strong) DMClock * white;
@property(nonatomic, strong) DMClock * black;
@property(nonatomic) NSTimer *timer;
@property(nonatomic, strong) DMGame *game;
@property (nonatomic, weak) DMGameView *gameView;
@property (nonatomic, strong) NSArray *sliderTimes;
@property (nonatomic) BOOL whitePlayerHasEndedFirstTurn;


- (void)startGame;
- (IBAction)whiteSliderValueChanged:(id)sender;
- (IBAction)blackSliderValueChanged:(id)sender;
- (IBAction)whiteSliderFinishedEditing:(id)sender;
- (IBAction)blackSliderFinishedEditing:(id)sender;

- (void) updateInterface;

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                       animatable:(BOOL)animatable
                       completion:(void (^)(BOOL))completion;

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                        animatable:(BOOL)animatable;
- (IBAction)toggleTimes:(id)sender;

@end

@implementation GameViewController

#pragma mark View lifecycle

/**
 * Initialize properties not related to the view
 *
 * Why awakeFromNib and not initWithCoder or another init*?
 *
 * initWithCoder is the designated initializer for UIViewController, so it's the
 * flavour of init* to use. Apparently, though, it may not be safe to use
 * accessors in initWithCoder (see http://stackoverflow.com/a/15508256).
 * 
 * This stuff could also be done in viewDidLoad, but that feels gross.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];

    self.white = [[DMClock alloc] init];
    self.black = [[DMClock alloc] init];

    self.game = [[DMGame alloc] init];


    self.sliderTimes = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15,
                         @20, @25, @30, @35, @40, @45, @50, @55, @60,
                         @70, @80, @90, @100, @110, @120];

    self.gameView = (DMGameView *)self.view;


}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.whitePlayerHasEndedFirstTurn = NO;
    [self updateInterface];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)toggleTimes:(id)sender {
    if (self.game.state == [DMNewGameState class]) {
        [self.game enterState:[DMSettingsState class]];
    } else if (self.game.state == [DMSettingsState class]) {
        [self.game enterState:[DMNewGameState class]];
    }
}

- (IBAction)togglePaused:(id)sender {
    if ([self.game.state isKindOfClass:[DMTurnState class]]) {
        [self.game pushState:[DMPausedState class]];
    } else if (self.game.state == [DMPausedState class]) {
        [self.game popState];
    }
}

- (IBAction)toggleReset:(id)sender
{
    [self.game pushState:[DMConfirmResetState class]];
}

- (IBAction)confirmReset:(id)sender
{
    [self.game enterState:[DMNewGameState class]];
}

- (IBAction)cancelReset:(id)sender
{
    [self.game popState];
}

- (IBAction)endWhiteTurn:(id)sender {
    if ([self.game state] == [DMNewGameState class]) {
        [self.game enterState:[DMWhiteTurnState class]];
    } else if ([self.game state] == [DMWhiteTurnState class]) {
        [self.game enterState:[DMBlackTurnState class]];
    }
}

- (IBAction)endBlackTurn:(id)sender {
    if ([self.game state] == [DMBlackTurnState class]) {
        [self.game enterState:[DMWhiteTurnState class]];
    }
}

- (IBAction)whiteSliderValueChanged:(id)sender {
    int value = (int)floorf(self.whiteSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    [self.whiteButton setTitle:[NSString stringWithFormat:@"%d:00", time.intValue] forState:UIControlStateNormal];
}

- (IBAction)blackSliderValueChanged:(id)sender {
    int value = (int)floorf(self.blackSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    [self.blackButton setTitle:[NSString stringWithFormat:@"%d:00", time.intValue] forState:UIControlStateNormal];
}

- (IBAction)whiteSliderFinishedEditing:(id)sender {
    int value = (int)floorf(self.whiteSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    self.white.timeLimit = time.intValue * 60;

    [self.white reset];

    [self updateInterface];
}

- (IBAction)blackSliderFinishedEditing:(id)sender {
    int value = (int)floorf(self.blackSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    self.black.timeLimit = time.intValue * 60;

    [self.black reset];

    [self updateInterface];
}

#pragma mark -
#pragma mark Delegate methods

- (void)timeSelectionViewController:(DMSettingsViewController *)controller
                 didSetWhiteSeconds:(NSTimeInterval)whiteSeconds
                       blackSeconds:(NSTimeInterval)blackSeconds
{
    self.white.timeLimit = whiteSeconds;
    self.black.timeLimit = blackSeconds;

    [self.white reset];
    [self.black reset];

    [self dismissViewControllerAnimated:YES completion:nil];

    [self updateInterface];
}

@end
