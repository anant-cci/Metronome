//
//  ViewController.m
//  Metronome
//
//  Created by Anant Kannaik on 18/05/18.
//  Copyright © 2018 Anant Kannaik. All rights reserved.
//

#import "ViewController.h"
#import "MetronomeNew.h"

@interface ViewController () <MetronomeDelegate>

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;

@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *barView;

@end

@implementation ViewController {
    double tempo;
    MetronomeNew *metronome;
    BOOL moveLeftToRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    leftToRight = YES;
    NSURL *highUrl = [[NSBundle mainBundle] URLForResource:@"High" withExtension:@"wav"];
    NSURL *lowUrl = [[NSBundle mainBundle] URLForResource:@"Low" withExtension:@"wav"];
    metronome = [[MetronomeNew alloc] init:highUrl];
    metronome.delegate = self;
    
    tempo = 120;
    self.stepper.stepValue = 1;
    self.stepper.minimumValue = 40;
    self.stepper.maximumValue = 200;
    self.stepper.value = tempo;
    
    self.tempoLabel.text = [NSString stringWithFormat:@"%d", (int)tempo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPlayback:(UIButton *)sender {
    [metronome setTempo:tempo];
    [metronome start];
}

- (IBAction)stopPlayback:(UIButton *)sender {
    [metronome stop];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    tempo = self.stepper.value;
    [metronome setTempo:tempo];
    self.tempoLabel.text = [NSString stringWithFormat:@"%d", (int)tempo];
}

#pragma MetronomeDelegate methods
- (void)metronomeTicking:(MetronomeNew *)metronome bar:(SInt32)bar beat:(SInt32)beat {
    NSLog(@"%d   %d", bar, beat);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animateView:beat];
    });
}

- (void)animateView:(int)beat {
    if (moveLeftToRight) {
        CGRect rightBound = self.sliderView.frame;
        rightBound.origin.x = self.barView.frame.size.width - self.sliderView.frame.size.width;
        [UIView animateWithDuration:60.0/tempo delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sliderView.frame = rightBound;
        } completion:nil];
    } else {
        CGRect leftBound = self.sliderView.frame;
        leftBound.origin.x = 0.0;
        [UIView animateWithDuration:60.0/tempo delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sliderView.frame = leftBound;
        } completion:nil];
    }
    
    moveLeftToRight = !moveLeftToRight;
}

@end
