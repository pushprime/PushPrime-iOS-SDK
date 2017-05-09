//
//  PPViewController.m
//  PushPrime
//
//  Created by PushPrime on 09/19/2016.
//  Copyright (c) 2016 PushPrime. All rights reserved.
//

#import "PPViewController.h"

@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)bootOptInClicked:(id)sender{
    [[PushPrime sharedHandler] bootOptIn];
}

@end
