//
//  SelectTeamSportViewController.h
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PopoverCellTypeDefault,
    PopoverCellTypeSubtitle,
    PopoverCellTypeSeller,
    PopoverCellTypeOffer
} PopoverCellType;

@interface PopoverSelectionModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;   // Used as Message if Offer
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *subimage;

@property (nonatomic, assign) NSInteger rating; // Seller, Offer

@end

@protocol PopoverSelectionViewControllerDelegate <NSObject>

- (void)didSelectItem:(NSInteger)index withAction:(NSInteger)action;

@end

@interface PopoverSelectionViewController : UITableViewController
@property (weak, nonatomic) id<PopoverSelectionViewControllerDelegate> delegate;

// public setters
@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, assign) PopoverCellType cellType;

@end
