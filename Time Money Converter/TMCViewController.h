//
//  TMCViewController.h
//  Time Money Converter
//
//  Created by Johnathan Ross on 2/25/14.
//  Copyright (c) 2014 JDR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMCViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *startYearButton;
@property (strong, nonatomic) IBOutlet UIButton *endYearButton;
@property (strong, nonatomic) IBOutlet UISlider *startYearSliderLabel;
@property (strong, nonatomic) IBOutlet UISlider *endYearSliderLabel;
@property (strong, nonatomic) NSMutableArray *fullCPIList;
@property (strong, nonatomic) IBOutlet UILabel *finalConvertedValue;
@property (strong, nonatomic) IBOutlet UITextField *dollarAmount;

- (IBAction)tapInField:(UITapGestureRecognizer *)sender;
- (IBAction)startYearSlider:(UISlider *)sender;
- (IBAction)endYearSlider:(UISlider *)sender;
- (IBAction)startYearButtonPressed:(UIButton *)sender;
- (IBAction)endYearButtonPressed:(UIButton *)sender;
- (IBAction)convertButtonPressed:(UIButton *)sender;
- (IBAction)aboutButtonPressed:(UIButton *)sender;


@end
