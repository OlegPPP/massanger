//
//  SelectTeamSportViewController.m
//  ChatDemo
//
//  Created by Neo on 5/17/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "PopoverSelectionViewController.h"
#import "PopoverSelectionSubtitleCell.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "PopoverSelectionSellerCell.h"
#import "PopoverSelectionOfferCell.h"

@interface PopoverSelectionViewController () <PopoverSelectionOfferCellDelegate> {
    JSQMessagesAvatarImageFactory *imageFactory;
}
@end

@implementation PopoverSelectionModel

@end

@implementation PopoverSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    imageFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:34];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopoverSelectionModel *model = _arrayData[indexPath.row];
    
    NSString *cellReuseIdentifier;

    if (_cellType == PopoverCellTypeSeller) {
        cellReuseIdentifier = @"PopoverCellTypeSeller";
    } else if (_cellType == PopoverCellTypeOffer) {
        cellReuseIdentifier = @"PopoverCellTypeOffer";
    } else if (_cellType == PopoverCellTypeSubtitle) {
        if (model.subimage != nil)
            cellReuseIdentifier = @"PopoverCellTypeSubtitle";
        else
            cellReuseIdentifier = @"PopoverCellTypeSubtitle2";
    } else {
        cellReuseIdentifier = @"PopoverCellTypeDefault";
    }

    PopoverSelectionSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    cell.mainTextLabel.text = model.title;
    
    if (model.image) {
        cell.mainImageView.image = [UIImage imageNamed:model.image];
    } else {
        cell.mainImageView.image = [[imageFactory avatarImageWithUserInitials:[[cell.mainTextLabel.text substringToIndex:1] uppercaseString]
                                   backgroundColor:[UIColor colorWithWhite:0.88f alpha:1.0f]
                                         textColor:[UIColor colorWithWhite:0.59f alpha:1.0f]
                                                                         font:[UIFont systemFontOfSize:17.0f]] avatarImage];
    }
    
    if (_cellType == PopoverCellTypeSubtitle) {
        cell.subTextLabel.text = model.subtitle;
        cell.subImageView.image = [UIImage imageNamed:model.subimage];
    } else {
        cell.mainImageView.layer.cornerRadius = CGRectGetWidth(cell.mainImageView.frame) / 2;
        cell.mainImageView.clipsToBounds = YES;
    }
    
    if (_cellType == PopoverCellTypeSeller) {
        for (UIImageView *imageView in [(PopoverSelectionSellerCell *)cell starImageViews]) {
            if (imageView.tag <= model.rating) {
                imageView.image = [UIImage imageNamed:@"tickets_star_yellow"];
            } else {
                imageView.image = [UIImage imageNamed:@"tickets_star_grey"];
            }
        }
    } else if (_cellType == PopoverCellTypeOffer) {
        PopoverSelectionOfferCell *offerCell = (PopoverSelectionOfferCell *)cell;
        for (UIImageView *imageView in [offerCell starImageViews]) {
            if (imageView.tag <= model.rating) {
                imageView.image = [UIImage imageNamed:@"tickets_star_yellow"];
            } else {
                imageView.image = [UIImage imageNamed:@"tickets_star_grey"];
            }
        }
        
//        offerCell.textView.text =
        offerCell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellType != PopoverCellTypeOffer) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_delegate respondsToSelector:@selector(didSelectItem:withAction:)]) {
            [_delegate didSelectItem:indexPath.row withAction:0];
        }
    }
}

// MARK: - PopoverSelectionOfferCellDelegate
- (void)openChat:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([_delegate respondsToSelector:@selector(didSelectItem:withAction:)]) {
        [_delegate didSelectItem:indexPath.row withAction:2];
    }
}

- (void)declineOffer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([_delegate respondsToSelector:@selector(didSelectItem:withAction:)]) {
        [_delegate didSelectItem:indexPath.row withAction:1];
    }
}

- (void)dealOffer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([_delegate respondsToSelector:@selector(didSelectItem:withAction:)]) {
        [_delegate didSelectItem:indexPath.row withAction:0];
    }
}

@end
