//
//  ViewController.swift
//  PrebidTestDemo
//
//  Created by Olena Stepaniuk on 05.10.2021.
//

import UIKit
import MoPubSDK
import PrebidMobile

class BannerViewController: UIViewController, MPAdViewDelegate {
    
    @IBOutlet weak var bannerView: UIView!
    
    private var mopubBanner: MPAdView!
    
    private var adUnit: AdUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAndLoadMPBanner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // important to remove the time instance
        adUnit?.stopAutoRefresh()
    }
    
    func setupAndLoadMPBanner() {
        let width = 300
        let height = 250
        
        setupPBRubiconBanner(width: width, height: height)
        setupMPRubiconBanner(width: width, height: height)
        loadMPBanner()
    }
    
    /*
     * accountId, configId comes from Prebid Server
     */
    func setupPBRubiconBanner(width: Int, height: Int) {
        setupPBBanner(host: .Rubicon, accountId: "1001", configId: "1001-1", storedResponse: "1001-rubicon-300x250", width: width, height: height)
    }
    
    func setupPBBanner(host: PrebidHost, accountId: String, configId: String = "6ace8c7d-88c0-4623-8117-75bc3f0a2e45", storedResponse: String, width: Int, height: Int) {
        setupPB(host: host, accountId: accountId, storedResponse: storedResponse)
                
///     - configId (String): Prebid Server configuration ID.
        let adUnit = BannerAdUnit(configId: configId, size: CGSize(width: width, height: height))
        
        let parameters = BannerAdUnit.Parameters()

///        api - OpenRTB placement
        parameters.api = [Signals.Api.MRAID_2]

        adUnit.parameters = parameters
        
        self.adUnit = adUnit
    }
    
    func setupPB(host: PrebidHost, accountId: String, storedResponse: String) {
        Prebid.shared.prebidServerHost = host
        Prebid.shared.prebidServerAccountId = accountId
        Prebid.shared.storedAuctionResponse = storedResponse
    }
    
    // --- setup mopud
    func setupMPBanner(adUnitId: String, width: Int, height: Int) {
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitId)
        sdkConfig.globalMediationSettings = []

        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {

        }

        mopubBanner = MPAdView(adUnitId: adUnitId)
        mopubBanner.frame = CGRect(x: 0, y: 0, width: width, height: height)
        mopubBanner.delegate = self
        bannerView.addSubview(mopubBanner)
    }
    
    func setupMPRubiconBanner(width: Int, height: Int) {
        setupMPBanner(adUnitId: "2aae44d2ab91424d9850870af33e5af7", width: width, height: height)
    }
    
    func loadMPBanner() {
        mopubBanner.backgroundColor = .red

        // Do any additional setup after loading the view, typically from a nib.
        adUnit.fetchDemand(adObject: mopubBanner) { [weak self] (resultCode: ResultCode) in
            print("Prebid demand fetch for MoPub \(resultCode.name())")

            self?.mopubBanner.loadAd()
        }
    }
    
    // MARK: - MPAdViewDelegate
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
}

