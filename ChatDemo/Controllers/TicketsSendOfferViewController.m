//
//  TicketsSendOfferViewController.m
//  ChatDemo
//
//  Created by Neo on 5/31/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "TicketsSendOfferViewController.h"
#import <UITextView+Placeholder.h>
#import "UIView+Border.h"

@interface TicketsSendOfferViewController ()

@end

@implementation TicketsSendOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textView.placeholder = @"Short description of your offer. Where and when can you meet the seller?";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIColor *separatorColor = [UITableView new].separatorColor;
    
    [_fixtureContainerView addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
    
    [_descContainerView addBottomBorderWithColor:separatorColor andWidth:1 / [UIScreen mainScreen].scale];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)send:(id)sender {
    if ([_delegate respondsToSelector:@selector(sendOffer:)]) {
        [_delegate sendOffer:_textView.text];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardSize = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    _textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0);
}

- (void)keyboardWillHide:(NSNotification *)note {
    _textView.contentInset = UIEdgeInsetsZero;
}


@end
