//
//  BaseViewController.swift
//  rss-reader
//
//  Created by yusuf_kildan on 10.09.2019.
//  Copyright © 2019 Yusuf Kıldan. All rights reserved.
//

import UIKit

private struct NavigationBarTextAttributes {
    public static var regular: [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.font] = UIFont.avenirNextBoldFont(withSize: 22.0)
        attributes[NSAttributedString.Key.foregroundColor] = ColorPalette.Primary.Dark.text
        return attributes
    }

    public static var large: [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.font] = UIFont.avenirNextBoldFont(withSize: 25.0)
        attributes[NSAttributedString.Key.foregroundColor] = ColorPalette.Primary.Dark.text
        return attributes
    }
}

enum ControllerState: Int {
    case none
    case loading
    case error
}

enum KeyboardAction: Int {
    case show
    case hide
}

class BaseViewController: UIViewController {

    var subComponentsHolderView: UIView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var emptyStateView: EmptyStateView!

    private(set) var state = ControllerState.none

    // MARK: - Init / Deinit

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let dnc = NotificationCenter.default
        dnc.addObserver(self,
                        selector: #selector(BaseViewController.didReceiveKeyboardWillShowNotification(_:)),
                        name: UIResponder.keyboardWillShowNotification,
                        object: nil)
        dnc.addObserver(self,
                        selector: #selector(BaseViewController.didReceiveKeyboardWillHideNotification(_:)),
                        name: UIResponder.keyboardWillHideNotification,
                        object: nil)
        dnc.addObserver(self,
                        selector: #selector(BaseViewController.didReceiveKeyboardDidShowNotification(_:)),
                        name: UIResponder.keyboardDidShowNotification,
                        object: nil)
        dnc.addObserver(self,
                        selector: #selector(BaseViewController.didReceiveKeyboardDidHideNotification(_:)),
                        name: UIResponder.keyboardDidHideNotification,
                        object: nil)

        view.backgroundColor = ColorPalette.Primary.Light.background

        subComponentsHolderView = UIView()
        subComponentsHolderView.translatesAutoresizingMaskIntoConstraints = false
        subComponentsHolderView.backgroundColor = ColorPalette.Primary.Light.background

        view.addSubview(subComponentsHolderView)

        subComponentsHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subComponentsHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subComponentsHolderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        subComponentsHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        emptyStateView = EmptyStateView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.actionButton.addTarget(self,
                                              action: #selector(_emptyStateViewActionButtonTapped(_:)),
                                              for: UIControl.Event.touchUpInside)
        emptyStateView.isHidden = true

        subComponentsHolderView.addSubview(emptyStateView)

        emptyStateView.leadingAnchor.constraint(equalTo: subComponentsHolderView.leadingAnchor).isActive = true
        emptyStateView.trailingAnchor.constraint(equalTo: subComponentsHolderView.trailingAnchor).isActive = true
        emptyStateView.topAnchor.constraint(equalTo: subComponentsHolderView.topAnchor).isActive = true
        emptyStateView.bottomAnchor.constraint(equalTo: subComponentsHolderView.safeAreaLayoutGuide.bottomAnchor).isActive = true

        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true

        subComponentsHolderView.addSubview(loadingIndicator)

        loadingIndicator.centerXAnchor.constraint(equalTo: subComponentsHolderView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: subComponentsHolderView.centerYAnchor).isActive = true

        setSubComponents(Visible: false, animated: false, completion: nil)

        if shouldHideKeyboardWhenTappedArround {
            let recognizer = UITapGestureRecognizer(target: self,
                                                    action: #selector(didTapArround(_:)))
            recognizer.cancelsTouchesInView = false

            view.addGestureRecognizer(recognizer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarAppearance()
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Keyboard

    var shouldHideKeyboardWhenTappedArround: Bool {
        return false
    }

    // MARK: - Navigation Bar

    var shouldShowNavigationBar: Bool {
        return true
    }

    var shouldShowLargeNavigationBar: Bool {
        return false
    }

    var shouldShowShadowUnderNavigationBar: Bool {
        return true
    }

    private func updateNavigationBarAppearance() {
        guard let controller = navigationController else { return }
        navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)

        let navigationBar = controller.navigationBar
        navigationBar.prefersLargeTitles = shouldShowLargeNavigationBar
        navigationItem.largeTitleDisplayMode = .automatic

        navigationBar.largeTitleTextAttributes = NavigationBarTextAttributes.large

        navigationBar.titleTextAttributes = NavigationBarTextAttributes.regular

        navigationBar.barTintColor = ColorPalette.Primary.Light.background
        navigationBar.backgroundColor = ColorPalette.Primary.Light.background

        if shouldShowShadowUnderNavigationBar {
            navigationBar.shadowImage = UIImage(named: "gradientBackgroundBlackTopToBottomSmall")
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        } else {
            navigationBar.shadowImage = UIImage()
        }

        navigationBar.isTranslucent = false
    }

    // MARK: - Interface

    private func setSubComponents(Visible visible: Bool, animated: Bool, completion: (() -> Void)?) {
        func set(Visible visible: Bool) {
            subComponentsHolderView.alpha = visible ? 1.0 : 0.0
        }

        if visible {
            subComponentsHolderView.isHidden = false
        }

        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                set(Visible: visible)
            }, completion: { (completed) in
                self.subComponentsHolderView.isHidden = !visible

                if let completion = completion {
                    completion()
                }
            })
        } else {
            set(Visible: visible)

            if let completion = completion {
                completion()
            }
        }
    }

    private func updateUI(withState state: ControllerState, andMessage message: String?) {
        switch state {
        case ControllerState.loading:
            startLoading()
        case ControllerState.error:
            setSubComponents(Visible: true, animated: true, completion: {
                self.emptyStateView.isHidden = false
                self.emptyStateView.title = "Oops!"
                self.emptyStateView.icon = UIImage(named: "iconUnknownError")
                self.emptyStateView.subtitle = message ?? String.localize("unknown_error_description")
                self.emptyStateView.actionButtonTitle = String.localize("retry")

                self.stopLoading()
            })
        case ControllerState.none:
            emptyStateView.isHidden = true
            emptyStateView.title = nil
            emptyStateView.subtitle = nil
            emptyStateView.actionButtonTitle = nil
            emptyStateView.icon = nil

            setSubComponents(Visible: false, animated: true, completion: {
                self.stopLoading()
            })
        }
    }

    // MARK: - Load Data

    func loadData(withRefresh refresh: Bool) {
        if (state == ControllerState.loading) {
            return
        }

        updateControllerState(withState: ControllerState.loading, andMessage: nil)
    }

    func updateControllerState(withState state: ControllerState,
                               andMessage message: String? = nil) {
        updateUI(withState: state, andMessage: message)
        self.state = state
    }

    private func startLoading() {
        emptyStateView.isHidden = true

        emptyStateView.title = nil
        emptyStateView.subtitle = nil
        emptyStateView.actionButtonTitle = nil
        emptyStateView.icon = nil

        loadingIndicator.isHidden = false

        loadingIndicator.startAnimating()

        setSubComponents(Visible: true, animated: true, completion: nil)
    }

    private func stopLoading() {
        loadingIndicator.stopAnimating()
    }

    // MARK: - Insets

    func defaultTopInset() -> CGFloat {
        var topInset: CGFloat = 0.0

        let application = UIApplication.shared

        if application.isStatusBarHidden == false {
            topInset += application.statusBarFrame.size.height
        }

        if shouldShowNavigationBar {
            if let controller = navigationController {
                topInset += controller.navigationBar.frame.size.height
            }
        }

        topInset += Utils.safeAreaInsets.top

        return topInset
    }

    func defaultBottomInset() -> CGFloat {
        var bottomInset: CGFloat = 0.0

        bottomInset += Utils.safeAreaInsets.bottom

        return bottomInset
    }

    // MARK: - Notifications

    @objc func didReceiveKeyboardWillShowNotification(_ notification: Notification) {

    }

    @objc func didReceiveKeyboardWillHideNotification(_ notification: Notification) {

    }

    @objc func didReceiveKeyboardDidShowNotification(_ notification: Notification) {

    }

    @objc func didReceiveKeyboardDidHideNotification(_ notification: Notification) {

    }

    func handleInsetsOf(ScrollView scrollView: UIScrollView,
                        forAction action: KeyboardAction,
                        withNotification notification: Notification) {
        if ((self.isViewLoaded == true && self.view.window != nil) == false) {
            return
        }

        let application = UIApplication.shared

        if application.applicationState != UIApplication.State.active {
            return
        }

        var insets = scrollView.contentInset

        switch action {
        case KeyboardAction.show:
            guard let keyboardFrame = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] else {
                return
            }

            let keyboardHeight = (keyboardFrame as AnyObject).cgRectValue.size.height

            var bottomInset = keyboardHeight
            bottomInset -= defaultBottomInset()
            insets.bottom = bottomInset

            scrollView.scrollIndicatorInsets = insets

            insets.bottom += 10.0
        case KeyboardAction.hide:
            insets.bottom = defaultBottomInset()

            scrollView.scrollIndicatorInsets = insets
        }

        scrollView.contentInset = insets
    }

    // MARK: - Gesture Recognizers
    
    @objc func didTapArround(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Actions

    @objc private func _emptyStateViewActionButtonTapped(_ button: UIButton) {
        if state == ControllerState.error {
            loadData(withRefresh: true)
        }
    }
}
