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
    if (self.game.state == DMNotStarted) {
        self.game.state = DMChangeTimes;
        [self selectTimesButton];
        [self.timesButton layoutIfNeeded];
        [self updateInterfaceWithChanges:^{
            [self showSliders];
            [self disablePlayerButtonInteraction];
            [self enableBlackButton];
            [self hideStartGameLabel];

            [self.view layoutIfNeeded];
        }];
    } else {
        self.game.state = DMNotStarted;
        [self deselectTimesButton];
        [self.timesButton layoutIfNeeded];
        [self updateInterfaceWithChanges:^{
            [self enablePlayerButtonInteraction];
            [self hideSliders];
            [self disableBlackButton];
            [self showStartGameLabel];

            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)togglePaused:(id)sender {
    if (self.game.state == DMWhiteTurn || self.game.state == DMBlackTurn) {
        [self pauseGame];
    }
    else {
        [self resumeGame];
    }
}

- (IBAction)toggleReset:(id)sender
{
    [self updateInterfaceWithChanges:^{
        [self showConfirmResetArea];
        self.resetButton.alpha = 0.0f;
        self.pauseButton.alpha = 0.0f;

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)confirmReset:(id)sender
{
    [self.white reset];
    [self.black reset];

    // Reset the game state
    self.game.state = DMNotStarted;

    self.whitePlayerHasEndedFirstTurn = NO;

    self.winnerButton = nil;
    self.loserButton = nil;

    [self updateInterface];

    self.pauseButton.enabled = NO;
    self.pauseButton.selected = NO;
    self.resetButton.enabled = NO;

    [self enablePlayerButtonInteraction];

    [self.pauseButton invalidateIntrinsicContentSize];

    [self resetStartGameLabelContent];

    [self updateInterfaceWithChanges:^{
        [self hideConfirmResetArea];
        [self enableWhiteButton];
        [self disableBlackButton];
        [self showStartGameLabel];
        [self showTimesButton];
        [self hideResetButton];
        [self hidePauseButton];
        [self resetPlayerButtonColors];

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancelReset:(id)sender
{
    [self updateInterfaceWithChanges:^{
        self.resetButton.alpha = 1.0f;
        self.pauseButton.alpha = 1.0f;

        [self hideConfirmResetArea];

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)whiteButtonPressed:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToTimes];
    }
    else {
        [self disableWhiteButton];
        [self.view layoutIfNeeded];
    }
}

- (IBAction)whiteButtonPressCancelled:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self updateInterfaceWithChanges:^{
            [self enableWhiteButton];
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)endWhiteTurn:(id)sender {
    if (self.game.state == DMNotStarted) {

        [self updateInterfaceWithChanges:^{
            [self hideStartGameLabel];
            [self enableWhiteButton];

            [self.view layoutIfNeeded];
        } animatable:YES completion:^(BOOL finished){
            [self replaceStartGameLabelContent];

            [self updateInterfaceWithChanges:^{
                [self showStartGameLabel];

                [self.view layoutIfNeeded];
            }];

        }];

        [self startGame];
    }
    else if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self.white stop];

        self.game.state = DMBlackTurn;

        self.whitePlayerHasEndedFirstTurn = YES;

        [self updateInterfaceWithChanges:^{
            [self enableBlackButton];
            [self hideStartGameLabel];

            [self.view layoutIfNeeded];
        }];

        [self.black start];
    }
}

- (IBAction)blackButtonPressed:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToTimes];
    }
    else {
        [self disableBlackButton];
        [self.view layoutIfNeeded];
    }
}

- (IBAction)blackButtonPressCancelled:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self updateInterfaceWithChanges:^{
            [self enableBlackButton];
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)endBlackTurn:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self.black stop];

        self.game.state = DMWhiteTurn;

        [self updateInterfaceWithChanges:^{
            [self enableWhiteButton];

            [self.view layoutIfNeeded];
        }];

        [self.white start];
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
