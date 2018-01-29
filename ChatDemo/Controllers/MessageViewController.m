//
//  MessageViewController.m
//  ChatDemo
//
//  Created by Neo on 5/18/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "MessageViewController.h"
#import "JSQMessagesViewAccessoryButtonDelegate.h"
#import "MyBubblesSizeCalculator.h"
#import "PopoverSelectionViewController.h"
#import "NewChatViewController.h"
#import "AppDelegate.h"
#import "APChatManager.h"
#import "MYMessagesCollectionViewCellIncoming.h"
#import "MYMessagesCollectionViewCellOutgoing.h"
#import "CDContact+CoreDataClass.h"
#import "MyPhotoMediaItem.h"
#import "UIView+Border.h"
#import "APTicketManager.h"

@interface MessageViewController () <JSQMessagesViewAccessoryButtonDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate, PopoverSelectionViewControllerDelegate, NewChatViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSManagedObjectContext *managedContext;
    APChatManager *chatManger;
    
    // Time formatter for bubble
    NSDateFormatter *timeFormatter, *dateFormatter;
}

@end

@implementation MessageViewController

#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:242.f/255 alpha:1];
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    /**
     *  Load up our data for the demo
     */
    self.modelData = [[MessagesModelData alloc] initWithChat:_chat];
    
    /**
     *  Set up message accessory button delegate and configuration
     */
    self.collectionView.accessoryDelegate = self;
    
    self.showLoadEarlierMessagesHeader = YES;
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
    // Replace to my custom cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYMessagesCollectionViewCellOutgoing" bundle:nil] forCellWithReuseIdentifier:self.outgoingCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYMessagesCollectionViewCellIncoming" bundle:nil] forCellWithReuseIdentifier:self.incomingCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYMessagesCollectionViewCellOutgoing" bundle:nil] forCellWithReuseIdentifier:self.outgoingMediaCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYMessagesCollectionViewCellIncoming" bundle:nil] forCellWithReuseIdentifier:self.incomingMediaCellIdentifier];
    
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont systemFontOfSize:15];
    self.collectionView.collectionViewLayout.minimumLineSpacing = 12;
    
    // Set my bubble size calculator
    [self.collectionView.collectionViewLayout setBubbleSizeCalculator:[MyBubblesSizeCalculator new]];
    
    // change default left button in toolbar
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"chats_camera"] forState:UIControlStateNormal];
    self.inputToolbar.contentView.leftBarButtonItem = cameraButton;
    
    // remove send button
    self.inputToolbar.contentView.rightBarButtonItem = nil;
    
    // Set input textview properties
    self.inputToolbar.contentView.textView.placeHolder = @"Enter message";
    self.inputToolbar.contentView.textView.font = [UIFont systemFontOfSize:15];
    self.inputToolbar.contentView.textView.backgroundColor = [UIColor colorWithWhite:242.f/255 alpha:1];
    self.inputToolbar.contentView.textView.enablesReturnKeyAutomatically = YES;
    
    // change keyboard return to send
    self.inputToolbar.contentView.textView.returnKeyType = UIReturnKeySend;
    
    // Add gesture recognizer for title view
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitle:)];
    [tapGR setNumberOfTapsRequired:1];
    [self.navigationItem.titleView addGestureRecognizer:tapGR];
    
    managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    chatManger = [APChatManager sharedManager];
    
    // init date and time formatter
    timeFormatter = [NSDateFormatter new];
    timeFormatter.dateFormat = @"HH:mm";
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMM dd";
    
    // Setup borders for ticket offers
    UIColor *separatorColor = [UITableView new].separatorColor;
    CGFloat borderWidth = 1 / [UIScreen mainScreen].scale;
    [_dealView addBottomBorderWithColor:separatorColor andWidth:borderWidth];
    [_declineTicketButton addRightBorderWithColor:separatorColor andWidth:borderWidth];
    
    [_confirmOfferView addBottomBorderWithColor:separatorColor andWidth:borderWidth];
    [_cancelOfferButton addTopBorderWithColor:separatorColor andWidth:borderWidth];
    [_confirmOfferInnerView addTopBorderWithColor:separatorColor andWidth:borderWidth];
    [_textFieldContainerView addBottomBorderWithColor:separatorColor andWidth:borderWidth];
    [_textFieldContainerView addRightBorderWithColor:separatorColor andWidth:borderWidth];
    [_minutesContainerView addBottomBorderWithColor:separatorColor andWidth:borderWidth];
    _confirmOfferButton.layer.cornerRadius = 10;
    
    _confirmOfferView.hidden = YES;
    _dealView.hidden = YES;
    
    // TODO: Show deal view if needed
    // Set offerTicketButton title to accept if needed
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_chat.chatWithContacts.count == 1) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
    
    
    [super viewWillAppear:animated];
    
    // Refresh chat for title
    [managedContext refreshObject:_chat mergeChanges:NO];
    
    // Set title
    NSDictionary *subject = (NSDictionary *)_chat.subject;
    _titleLabel.text = subject[@"subjectTitle"];
    // TODO: Set team name or sports name here
//    _subtitleLabel.text =
    
    // Refresh right bar button
    if (_chat.chatWithContacts.count == 1) {
        // TODO: Set to real member image
        UIImage *img = [[[[JSQMessagesAvatarImageFactory alloc] initWithDiameter:34] avatarImageWithUserInitials:[[_chat.chatWithContacts.anyObject.firstName substringToIndex:1] uppercaseString]
                                                                                                 backgroundColor:[UIColor colorWithWhite:0.88f alpha:1.0f]
                                                                                                       textColor:[UIColor colorWithWhite:0.59f alpha:1.0f]
                                                                                                            font:[UIFont systemFontOfSize:17.0f]] avatarImage];
        [self.navigationItem.rightBarButtonItem setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    else
        [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"chats_group_members"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Enable cache once the view is fully loaded
    [(MyBubblesSizeCalculator *)self.collectionView.collectionViewLayout.bubbleSizeCalculator setUsesCache:YES];
}

// MARK: - Actions
- (void)tapTitle:(UITapGestureRecognizer *)tapGR {
    [self performSegueWithIdentifier:@"editChat" sender:self];
}

- (IBAction)showMembersPopover:(id)sender {
    PopoverSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSelectionViewController"];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.cellType = PopoverCellTypeDefault;
    
    NSMutableArray *arrayData = [NSMutableArray new];
    for (CDContact *contact in _chat.chatWithContacts) {
        PopoverSelectionModel *model = [PopoverSelectionModel new];
        // TODO: Set contact image here
        //        model.image = contact[@"image"];
        model.title = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        [arrayData addObject:model];
    }
    // Fill demo data
    vc.arrayData = [arrayData copy];
    
    UIPopoverPresentationController *popoverVC = vc.popoverPresentationController;
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverVC.delegate = self;
    popoverVC.barButtonItem = sender;
    
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editChat"]) {
        NewChatViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.isEditChat = YES;
        vc.isChatOwner = [_chat.isChatOwner isEqualToString:@"true"];
        vc.chat = _chat;
    }
}

#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    /**
     *  Display custom menu actions for cells.
     */
    
    [super didReceiveMenuWillShowNotification:notification];
}


#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    [self.modelData addMessage:message];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: - UIImagePicker
- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// MARK: - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
//    modelData.outgoingBubbleImageData.messageBubbleImage
    
    MyPhotoMediaItem *photoItem = [[MyPhotoMediaItem alloc] initWithImage:image withBubbleImage:self.modelData.outgoingBubbleImageData.messageBubbleImage];
    
//    CDContact *contact = _chat.chatWithContacts.anyObject;
    
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[chatManger currentUserId]
                                                   displayName:[chatManger fullName]
                                                         media:photoItem];
    
    [self.modelData addMessage:photoMessage];
    
    [self finishSendingMessageAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return chatManger.currentUserId;
}

- (NSString *)senderDisplayName {
    return [chatManger fullName];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.modelData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.modelData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.modelData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.modelData.outgoingBubbleImageData;
    }
    
    return self.modelData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chat.chatWithContacts.count == 1)
        return nil;
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.modelData.messages objectAtIndex:indexPath.item];
    
    return [self.modelData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)attributedTimestampForDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    
    return [[NSAttributedString alloc] initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:[dateFormatter stringFromDate:date] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor colorWithWhite:98.f/255 alpha:1]}]];
    
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.modelData.messages objectAtIndex:indexPath.item];
    
    if (indexPath.item == 0) {
        return [self attributedTimestampForDate:message.date];
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.modelData.messages objectAtIndex:indexPath.item - 1];
        
        if ([message.date timeIntervalSinceDate:previousMessage.date] / 60 > 1) {
            return [self attributedTimestampForDate:message.date];
        }
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chat.chatWithContacts.count == 1)
        return nil;
    
    // return nil for 1:1 chat
    JSQMessage *message = [self.modelData.messages objectAtIndex:indexPath.item];
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.modelData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        cell.textView.textColor = [UIColor blackColor];
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    // Username label
    cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsZero;
    cell.messageBubbleTopLabel.font = [UIFont systemFontOfSize:15];
    cell.messageBubbleTopLabel.textColor = [UIColor blackColor];
    
    cell.cellTopLabel.backgroundColor = [UIColor colorWithWhite:217.f/255 alpha:1];
    cell.cellTopLabel.textInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.cellTopLabel.layer.cornerRadius = 12;
    
    // Hide share button
    cell.accessoryButton.hidden = YES;
    
    // Add time
    if ([cell isKindOfClass:[MYMessagesCollectionViewCellIncoming class]]) {
        // Bring time label to front(for media)
        [cell.messageBubbleContainerView bringSubviewToFront:((MYMessagesCollectionViewCellIncoming *)cell).timeLabel];
        ((MYMessagesCollectionViewCellIncoming *)cell).timeLabel.text = [timeFormatter stringFromDate:msg.date];
        ((MYMessagesCollectionViewCellIncoming *)cell).timeLabel.textColor = (!msg.isMediaMessage) ? [UIColor colorWithWhite:95.f/255 alpha:1] : [UIColor whiteColor];
    } else if ([cell isKindOfClass:[MYMessagesCollectionViewCellOutgoing class]]) {
        [cell.messageBubbleContainerView bringSubviewToFront:((MYMessagesCollectionViewCellIncoming *)cell).timeLabel];
        ((MYMessagesCollectionViewCellOutgoing *)cell).timeLabel.text = [timeFormatter stringFromDate:msg.date];
        ((MYMessagesCollectionViewCellIncoming *)cell).timeLabel.textColor = (!msg.isMediaMessage) ? [UIColor colorWithWhite:95.f/255 alpha:1] : [UIColor whiteColor];
    }    
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage]);
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}


#pragma mark - JSQMessages collection view flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    
    return CGSizeMake(size.width, size.height);
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return 24;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.modelData.messages objectAtIndex:indexPath.item - 1];
        JSQMessage *message = [self.modelData.messages objectAtIndex:indexPath.item];
        
        if ([message.date timeIntervalSinceDate:previousMessage.date] / 60 > 1) {
            return 24;
        }
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    // return 0 for 1:1 chat
    if (_chat.chatWithContacts.count == 1) {
        if ([self collectionView:collectionView attributedTextForCellTopLabelAtIndexPath:indexPath] == nil)
            return 0;
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    [self.modelData loadMoreMessages];
    
    [collectionView reloadData];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        MyPhotoMediaItem *item = [[MyPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image withBubbleImage:_modelData.outgoingBubbleImageData.messageBubbleImage];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.modelData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.inputToolbar.delegate messagesInputToolbar:self.inputToolbar didPressRightBarButton:nil];
        return NO;
    }
    
    return YES;
}

// MARK: - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// MARK: - PopoverSelectionViewControllerDelegate
- (void)didSelectItem:(NSInteger)index withAction:(NSInteger)action {
    // selected specific member
    NSLog(@"Selected contact %d", index);
}

// MARK: - NewChatViewControllerDelegate
- (void)shouldRefreshChat {
    [_modelData forceRefresh];
    [self.collectionView reloadData];
}

// MARK: - Tickets
- (IBAction)declineTickets:(id)sender {
    [self.view endEditing:YES];
    _dealView.hidden = YES;
    
    NSDictionary *subject = (NSDictionary *)_chat.subject;
    [[APTicketManager sharedManager] buyerTicketOfferDeclined:subject[@"subjectPostedTicketsId"] success:nil failure:nil];
}

- (IBAction)offerTickets:(id)sender {
    [self.view endEditing:YES];
    _confirmOfferView.hidden = NO;
    
    NSDictionary *subject = (NSDictionary *)_chat.subject;
    [[APTicketManager sharedManager] buyerTicketOfferAccepted:subject[@"subjectPostedTicketsId"] success:nil failure:nil];
}

- (IBAction)selectMinutes:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)confirmOffer:(id)sender {
    [self.view endEditing:YES];
    _confirmOfferView.hidden = YES;
    _dealView.hidden = YES;
    
    API_TicketsOfferAccepted *api = [API_TicketsOfferAccepted new];
    api.offerTimeOutMinutes = @([[_timeTextField text] integerValue]);
    api.postedTicketsId = [(NSDictionary *)_chat.subject objectForKey:@"subjectPostedTicketsId"];
    // TODO: Set buyer
//    api.buyer;
    [[APTicketManager sharedManager] sellerTicketOfferAccepted:api success:nil failure:nil];
}

- (IBAction)cancelOffer:(id)sender {
    [self.view endEditing:YES];
    _confirmOfferView.hidden = YES;
}
@end
