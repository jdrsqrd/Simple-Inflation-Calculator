//
//  TMCViewController.m
//  Time Money Converter
//
//  Created by Johnathan Ross on 2/25/14.
//  Copyright (c) 2014 JDR. All rights reserved.
//

#import "TMCViewController.h"

@interface TMCViewController ()

@end

@implementation TMCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.startYearSliderLabel.hidden = YES;
    self.endYearSliderLabel.hidden = YES;
    
    //get CPI data into string
    NSString *cpiPercentString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CPIData" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    //turn string into array
    NSArray *cpiPercentArray = [cpiPercentString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    
    self.fullCPIList = [[NSMutableArray alloc]init];
    NSInteger rangeStart = 0, rangeLength = 14,rangeCheck;
    NSRange cpiRange = NSMakeRange(rangeStart, rangeLength);
    
    
    for (int startYear = 1913; startYear <= 2014; startYear++) {
        //add each year to the full list
        [self.fullCPIList addObject:[[NSArray alloc]initWithArray:[cpiPercentArray subarrayWithRange:cpiRange]]];
        cpiRange = NSMakeRange(rangeStart+=rangeLength, rangeLength);
        //check that I won't overstep bounds of CPI Table
        rangeCheck=rangeStart+rangeLength;
        if (rangeCheck >= cpiPercentArray.count) {
            rangeLength = cpiPercentArray.count-rangeStart;
            cpiRange = NSMakeRange(rangeStart, rangeLength);
        }
    }
   
    //NSLog(@"%@",fullCPIList);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons and Sliders

- (IBAction)tapInField:(UITapGestureRecognizer *)sender {
    self.endYearSliderLabel.hidden = YES;
    self.startYearSliderLabel.hidden = YES;
    [self.dollarAmount resignFirstResponder];
}

- (IBAction)startYearSlider:(UISlider *)sender
{
    [self.startYearButton setTitle:[NSString stringWithFormat:@"%.0f",sender.value] forState:UIControlStateNormal];
    //NSLog(@"%.0f",sender.value);
}

- (IBAction)endYearSlider:(UISlider *)sender
{
    [self.endYearButton setTitle:[NSString stringWithFormat:@"%.0f",sender.value] forState:UIControlStateNormal];
}

- (IBAction)startYearButtonPressed:(UIButton *)sender {
    if (self.endYearSliderLabel.hidden==NO) {
        self.endYearSliderLabel.hidden=YES;
    }
    self.startYearSliderLabel.hidden = !self.startYearSliderLabel.hidden;
    [self.dollarAmount resignFirstResponder];
}

- (IBAction)endYearButtonPressed:(UIButton *)sender {
    if (self.startYearSliderLabel.hidden==NO) {
        self.startYearSliderLabel.hidden=YES;
    }
    self.endYearSliderLabel.hidden = !self.endYearSliderLabel.hidden;
    [self.dollarAmount resignFirstResponder];
}

- (IBAction)convertButtonPressed:(UIButton *)sender {
    int startYear = (int)self.startYearSliderLabel.value;
    int endYear = (int)self.endYearSliderLabel.value;
    int offSet = 1913;
    int months = 1, monthsEnd=13;
    float finalCPI=0;
    NSMutableArray *dividedCPI=[[NSMutableArray alloc]init];
    
    //account for current year (arry is not full if the year is the current year)
    if (endYear==2014 || startYear==2014) {
        monthsEnd = 2;
    }
    //get start and end CPI arrays
    NSArray *startCPIArray = [[NSArray alloc]initWithArray:[self.fullCPIList objectAtIndex:startYear-offSet]];
    NSArray *endCPIArray = [[NSArray alloc]initWithArray:[self.fullCPIList objectAtIndex:endYear-offSet]];
    
    //Get the value of the endYear cpi divided by the startYear CPI for each month into an array
    for (months = 1; months<monthsEnd; months++) {
        [dividedCPI addObject:[NSString stringWithFormat:@"%.2f",[[endCPIArray objectAtIndex:months] floatValue]/[[startCPIArray objectAtIndex:months]floatValue]]];
    }
    
    //correct the end for the next peice
    monthsEnd = 12;
    if (endYear==2014 || startYear==2014) {
        monthsEnd = 1;
    }
    
    //sum that divided CPI array
    for (months = 0; months<monthsEnd; months++) {
        finalCPI+=[[dividedCPI objectAtIndex:months] floatValue];
    }
    
    //output the value based on CPI to screen
    
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.finalConvertedValue.text = [NSString stringWithFormat:@"$%.2f",(finalCPI/monthsEnd)*[self.dollarAmount.text floatValue]];
    } completion:^(BOOL finished) {
        
    }];
    
    //self.finalConvertedValue.text = [NSString stringWithFormat:@"$%.2f",(finalCPI/monthsEnd)*[self.dollarAmount.text floatValue]];
    
    //hide sliders and keyboard
    self.endYearSliderLabel.hidden = YES;
    self.startYearSliderLabel.hidden = YES;
    [self.dollarAmount resignFirstResponder];
    
}

- (IBAction)aboutButtonPressed:(UIButton *)sender {
    UIAlertView *infoPannel = [[UIAlertView alloc]initWithTitle:@"About" message:@"Tap either year to adjust the from and to year. Tap convert to see the conversion rate (an amount must be entered for best results).\n\nThis App uses simple calculations and information based on CPI tables from the U.S. Department of Labor Bureau of Labor Statistics website. These are only rough estimations." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [infoPannel show];
}

@end
