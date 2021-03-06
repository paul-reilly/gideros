//
//  AdsAdmob.m
//  Ads
//
//  Created by Arturs Sosins on 6/25/13.
//  Copyright (c) 2013 Gideros Mobile. All rights reserved.
//
#include "gideros.h"
#import "AdsAdmob.h"
#import "AdsClass.h"


@implementation AdsAdmob
-(id)init{
    self.testID = @"";
    self.currentType = &kGADAdSizeBanner;
    self.currentSize = @"banner";
    self.appKey = @"";
    self.interstitialId = @"";
    self.rewardedVideoId = @"";
    self.mngr = [[AdsManager alloc] init];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    return self;
}

-(const GADAdSize*)getAdType:(NSString*)type orientation:(NSString*)orientation{
    if([type isEqual:@"banner"])
    {
        return &kGADAdSizeBanner;
    }
    else if([type isEqual:@"iab_mrect"])
    {
        return &kGADAdSizeMediumRectangle;
    }
    else if([type isEqual:@"iab_banner"])
    {
        return &kGADAdSizeFullBanner;
    }
    else if([type isEqual:@"iab_leaderboard"])
    {
        return &kGADAdSizeLeaderboard;
    }
    else if([type isEqual:@"smart_banner"] || [type isEqual:@"auto"])
    {
        /*
        if ([AdsClass isPortrait])
        {
            return &kGADAdSizeSmartBannerPortrait;
        }
        else
        {
            return &kGADAdSizeSmartBannerLandscape;
        }
        */
        if (orientation == nil){
            if ([AdsClass isPortrait])
            {
                return &kGADAdSizeSmartBannerPortrait;
            }
            else
            {
                return &kGADAdSizeSmartBannerLandscape;
            }
        }
        else{
            if ([orientation isEqual:@"landscapeLeft"] || [orientation isEqual:@"landscapeRight"])
                return &kGADAdSizeSmartBannerLandscape;
            else
                return &kGADAdSizeSmartBannerPortrait;
        }
    }
    return &kGADAdSizeBanner;
}

-(void)destroy{
    [self.mngr destroy];
     self.mngr = nil;
    
    self.currentSize = nil;
    self.appKey = nil;
    self.interstitialId = nil;
    self.rewardedVideoId = nil;
    self.testID = nil;
}

-(void)setKey:(NSMutableArray*)parameters{
    self.appKey = [parameters objectAtIndex:0];  //the first is banner id
    
    if ([parameters count] > 1) //the second is app id
    {
        [GADMobileAds configureWithApplicationID:[parameters objectAtIndex:1]];
    }
}

-(void)loadAd:(NSMutableArray*)parameters{
    NSString *type = [parameters objectAtIndex:0];
    NSString *placeId = nil;
    if([parameters count] > 1)
    {
        placeId = [parameters objectAtIndex:1];
    }
    else
    {
        placeId = self.appKey;
    }
    if ([type isEqualToString:@"interstitial"]) {
        //release it after closed
        if([self.mngr get:type] != nil){
            [self.mngr reset:type];
        }
        
        self.interstitialId = placeId;
        GADInterstitial *interstitial_ = [[GADInterstitial alloc] initWithAdUnitID:placeId];
        
        AdsStateChangeListener *listener = [[AdsStateChangeListener alloc] init];
        [listener setShow:^(){
            if (interstitial_.isReady){
                [AdsClass adDisplayed:[self class] forType:type];
                [interstitial_ presentFromRootViewController:[AdsClass getRootViewController]];
            }
        }];
        [listener setDestroy:^(){
            [self hideAd:type];
        }];
        [listener setHide:^(){
        	//NOTE release is forbidden with ARC, but should we do something else ?
            //interstitial_=nil;            
        }];
        [self.mngr set:interstitial_ forType:type withListener:listener];

        [interstitial_ setDelegate:self];
        [self.mngr setPreload:true forType:type];
        
        //is it OK  to release the interstitial_ when it is showing the ads if set autokill to true?
        [self.mngr setAutoKill:false forType:type];
        
        GADRequest *request = [GADRequest request];
        if(![self.testID isEqualToString:@""])
        {
            request.testDevices = @[self.testID];
        }
        [interstitial_ loadRequest:request];
    }
    else if([type isEqualToString:@"rewarded"]){
        
        if([self.mngr get:type] == nil){
            self.rewardedVideoId = placeId;
            
            AdsStateChangeListener *listener = [[AdsStateChangeListener alloc] init];
            [listener setShow:^(){
                if ([[GADRewardBasedVideoAd sharedInstance] isReady]){
                    [AdsClass adDisplayed:[self class] forType:type];
                    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:[AdsClass getRootViewController]];
                    AdsState *state = [self.mngr getState:type];
                    if(state != nil)
                        [state reset:false];
                }
            }];
            [listener setDestroy:^(){
               
            }];
            [listener setHide:^(){
               
            }];
            [self.mngr set:[GADRewardBasedVideoAd sharedInstance] forType:type withListener:listener];
            
            [self.mngr setPreload:true forType:type];
            
            [self.mngr setAutoKill:false forType:type];
        }
        
        GADRequest *request = [GADRequest request];
        if(![self.testID isEqualToString:@""])
        {
            request.testDevices = @[self.testID];
        }
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:self.rewardedVideoId];
    }
    else
    {
        if([self.mngr get:type] == nil)
        {
            NSString *orientation = nil;
            if ([parameters count] > 2)
                orientation = [parameters objectAtIndex:2];
            
            self.currentType = [self getAdType:type orientation:orientation];
            
            GADBannerView *view_ = [[GADBannerView alloc] initWithAdSize:*self.currentType];
            view_.adUnitID = placeId;
            view_.rootViewController = [AdsClass getRootViewController];
            
            AdsStateChangeListener *listener = [[AdsStateChangeListener alloc] init];
            [listener setShow:^(){
                self.currentSize = type;
                [AdsClass adDisplayed:[self class] forType:type];
                [view_.rootViewController.view addSubview:view_];
            }];
            [listener setDestroy:^(){
                [self hideAd:type];
                if(view_ != nil)
                {
                    view_.delegate = nil;
                    //view_=nil;
                }
            }];
            [listener setHide:^(){
                if(view_ != nil)
                {
                    [view_ removeFromSuperview];
                    [AdsClass adDismissed:[self class] forType:type];
                }

            }];
            [self.mngr set:view_ forType:type withListener:listener];
            [view_ setDelegate:[[AdsAdmobListener alloc] init:[self.mngr getState:type] with:self]];
            [self.mngr setAutoKill:false forType:type];
            GADRequest *request = [GADRequest request];
            if(![self.testID isEqualToString:@""])
            {
                request.testDevices = @[self.testID];
            }
            [view_ loadRequest:request];
        }
    }
}

-(void)showAd:(NSMutableArray*)parameters{
    NSString *type = [parameters objectAtIndex:0];
    if([self.mngr get:type] == nil)
        [self loadAd:parameters];
    [self.mngr show:type];
}

-(void)hideAd:(NSString*)type{
    [self.mngr hide:type];
}


-(void)enableTesting{
    NSString *test;
    if (NSClassFromString(@"ASIdentifierManager")) {
        test = [[[ASIdentifierManager sharedManager]
                advertisingIdentifier] UUIDString];
        // Create pointer to the string as UTF8
        const char *ptr = [test UTF8String];
        
        // Create byte array of unsigned chars
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
        
        // Convert MD5 value in the buffer to NSString of hex values
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x",md5Buffer[i]];
        self.testID = output;
    }
}

-(UIView*)getView{
    return (UIView*)[self.mngr get:self.currentSize];
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [AdsClass adReceived:[self class] forType:@"interstitial"];
    [self.mngr load:@"interstitial"];
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [AdsClass adFailed:[self class] with:[error localizedDescription] forType:@"interstitial"];
    [self.mngr reset:@"interstitial"];
    //we should delay to call loadAd to avoid too many requests.
    //[self loadAd:[NSMutableArray arrayWithObjects:@"interstitial",self.interstitialId, nil]];
}

-(void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [AdsClass adActionBegin:[self class] forType:@"interstitial"];
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    [AdsClass adDismissed:[self class] forType:@"interstitial"];
    //preload interstitial automatically
    [self loadAd:[NSMutableArray arrayWithObjects:@"interstitial",self.interstitialId, nil]];
}


#pragma mark GADRewardBasedVideoAdDelegate implementation

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    int amount = [reward.amount intValue];
    [AdsClass adRewarded:[self class] forType:@"rewarded" withAmount:amount];
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %d",
     reward.type,
     amount];
    NSLog(@"%@", rewardMessage);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
    [AdsClass adReceived:[self class] forType:@"rewarded"];
    [self.mngr load:@"rewarded"];

}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
    
    [AdsClass adActionBegin:[self class] forType:@"rewarded"];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
    
    [AdsClass adDismissed:[self class] forType:@"rewarded"];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:self.rewardedVideoId];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
    [AdsClass adFailed:[self class] with:[error localizedDescription] forType:@"rewarded"];
}

@end


@implementation AdsAdmobListener

-(id)init:(AdsState*)state with:(AdsAdmob*)instance{
    self.state = state;
    self.instance = instance;
    return self;
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    [AdsClass adReceived:[self.instance class] forType:[self.state getType]];
    [self.state load];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    [AdsClass adFailed:[self.instance class] with:[error localizedDescription] forType:[self.state getType]];
    //the banner view should be valid and can continue to use
	//[self.state reset];
    
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView{
    [AdsClass adActionBegin:[self.instance class] forType:[self.state getType]];
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    [AdsClass adActionEnd:[self.instance class] forType:[self.state getType]];
}

@end
