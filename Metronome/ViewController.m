//
//  ViewController.m
//  Metronome
//
//  Created by Anant Kannaik on 18/05/18.
//  Copyright © 2018 Anant Kannaik. All rights reserved.
//

#import "ViewController.h"
#import "Metronome.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;

@end

@implementation ViewController {
    double tempo;
    Metronome *metronome;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *highUrl = [[NSBundle mainBundle] URLForResource:@"High" withExtension:@"wav"];
    NSURL *lowUrl = [[NSBundle mainBundle] URLForResource:@"Low" withExtension:@"wav"];
    metronome = [[Metronome alloc] init:highUrl accentedClickFile:lowUrl];
    
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
    [metronome play:tempo];
}

- (IBAction)stopPlayback:(UIButton *)sender {
    [metronome stop];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    tempo = self.stepper.value;
    [metronome play:tempo];
    self.tempoLabel.text = [NSString stringWithFormat:@"%d", (int)tempo];
}

@end
