//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation
import WebKit

public class OnboardingFlowProvider: OnboardingFlowProviding {
    // MARK: – Properties

    public static let modalUIViewControllerPresenter = ModalUIViewControllerPresenter()

    // MARK: – Init

    public init() {}

    // MARK: – OnboardingFlowProvider

    public func flow(for _: OnboardingControlling, flowType: OnboardingFlow.FlowType, completionHandler: @escaping (OnboardingFlow?, Error?) -> Void) {
        switch flowType {
        case .onboard:
            completionHandler(onboardingFlow(), nil)
        case let .restore(onboardingID):
            completionHandler(restoringFlow(for: onboardingID), nil)
        case .background:
            completionHandler(nil, nil)
        case let .reset(onboardingID):
            completionHandler(resettingFlow(for: onboardingID), nil)
        case .resetPasscode:
            completionHandler(nil, nil)
        @unknown default:
            break
        }
    }

    // MARK: – Internal

    func onboardingFlow() -> OnboardingFlow {
        let steps = onboardingSteps
        let context = OnboardingContext(presentationDelegate: OnboardingFlowProvider.modalUIViewControllerPresenter)
        let flow = OnboardingFlow(flowType: .onboard, context: context, steps: steps)
        return flow
    }

    func restoringFlow(for onboardingID: UUID) -> OnboardingFlow {
        let steps = restoringSteps
        var context = OnboardingContext(onboardingID: onboardingID, presentationDelegate: OnboardingFlowProvider.modalUIViewControllerPresenter)
        context.onboardingID = onboardingID
        let flow = OnboardingFlow(flowType: .restore(onboardingID: onboardingID), context: context, steps: steps)
        return flow
    }

    func resettingFlow(for onboardingID: UUID) -> OnboardingFlow {
        let steps = resettingSteps
        var context = OnboardingContext(onboardingID: onboardingID, presentationDelegate: OnboardingFlowProvider.modalUIViewControllerPresenter)
        context.onboardingID = onboardingID
        let flow = OnboardingFlow(flowType: .reset(onboardingID: onboardingID), context: context, steps: steps)
        return flow
    }

    // MARK: - Steps

    // NUIStyleSheetApplyStep() can be used after "OAuth2AuthenticationStep(presenter: FioriWKWebViewPresenter(webViewDelegate: self))" to apply theming without getAPIKeyAuthenticationConfig

    public var onboardingSteps: [OnboardingStep] {
        return [
            configuredWelcomeScreenStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.configuration),
            OAuth2AuthenticationStep(presenter: FioriWKWebViewPresenter(webViewDelegate: self)),
            CompositeStep(steps: SAPcpmsDefaultSteps.settingsDownload),
            CompositeStep(steps: SAPcpmsDefaultSteps.applyDuringOnboard),
            configuredUserConsentStep(),
            configuredDataCollectionConsentStep(),
            StoreManagerStep(),

            ODataOnboardingStep(),
        ]
    }

    // NUIStyleSheetApplyStep() can be used after "OAuth2AuthenticationStep(presenter: FioriWKWebViewPresenter(webViewDelegate: self))" to apply theming without getAPIKeyAuthenticationConfig

    public var restoringSteps: [OnboardingStep] {
        return [
            StoreManagerStep(),
            configuredWelcomeScreenStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.configuration),
            OAuth2AuthenticationStep(presenter: FioriWKWebViewPresenter(webViewDelegate: self)),
            CompositeStep(steps: SAPcpmsDefaultSteps.settingsDownload),
            CompositeStep(steps: SAPcpmsDefaultSteps.applyDuringRestore),
            configuredDataCollectionConsentStep(),
            ODataOnboardingStep(),
        ]
    }

    public var offlineSyncingSteps: [OnboardingStep] {
        return [
            configuredWelcomeScreenStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.settingsDownload),
            CompositeStep(steps: SAPcpmsDefaultSteps.applyDuringRestore),
        ]
    }

    public var resettingSteps: [OnboardingStep] {
        return onboardingSteps
    }

    // MARK: – Step configuration

    private func configuredWelcomeScreenStep() -> WelcomeScreenStep {
        let appParameters = FileConfigurationProvider("AppParameters").provideConfiguration().configuration
        let destinations = appParameters["Destinations"] as! NSDictionary
        let discoveryConfigurationTransformer = DiscoveryServiceConfigurationTransformer(applicationID: appParameters["Application Identifier"] as? String, authenticationPath: destinations["TaskService"] as? String)
        var providers: [ConfigurationProviding] = [FileConfigurationProvider()]

        let welcomeScreenStep = WelcomeScreenStep(transformer: discoveryConfigurationTransformer, providers: providers)

        welcomeScreenStep.welcomeScreenCustomizationHandler = { welcomeStepUI in
            welcomeStepUI.headlineLabel.text = "Todoey"
            welcomeStepUI.detailLabel.text = NSLocalizedString("keyWelcomeScreenMessage", value: "This application was generated by SAP BTP SDK Assistant for iOS" + " v9.0.4", comment: "XMSG: Message on WelcomeScreen")
            welcomeStepUI.primaryActionButton.titleLabel?.text = NSLocalizedString("keyWelcomeScreenStartButton", value: "Start", comment: "XBUT: Title of start button on WelcomeScreen")

            if let welcomeScreen = welcomeStepUI as? FUIWelcomeScreen {
                // Configuring WelcomeScreen to prefill the email domain

                welcomeScreen.emailTextField.text = "user@"
            }
        }

        return welcomeScreenStep
    }

    private func configuredUserConsentStep() -> UserConsentStep {
        let actionTitle = "Learn more about Data Privacy"
        let actionUrl = "https://www.sap.com/corporate/en/legal/privacy.html"
        let singlePageTitle = "Data Privacy"
        let singlePageText = "Detailed text about how data privacy pertains to this app and why it is important for the user to enable this functionality"

        var singlePageContent = UserConsentPageContent()
        singlePageContent.actionTitle = actionTitle
        singlePageContent.actionUrl = actionUrl
        singlePageContent.title = singlePageTitle
        singlePageContent.body = singlePageText
        let singlePageFormContent = UserConsentFormContent(version: "1.0", isRequired: true, pages: [singlePageContent])

        return UserConsentStep(userConsentFormsContent: [singlePageFormContent])
    }

    private func configuredDataCollectionConsentStep() -> DataCollectionConsentStep {
        return DataCollectionConsentStep()
    }
}

// MARK: - SAPWKNavigationDelegate

// The WKWebView occasionally returns an NSURLErrorCancelled error if a redirect happens too fast.
// In case of OAuth with SAP's identity provider (IDP) we do not treat this as an error.
extension OnboardingFlowProvider: SAPWKNavigationDelegate {
    public func webView(_: WKWebView, handleFailed _: WKNavigation!, withError error: Error) -> Error? {
        if isCancelledError(error) {
            return nil
        }
        return error
    }

    public func webView(_: WKWebView, handleFailedProvisionalNavigation _: WKNavigation!, withError error: Error) -> Error? {
        if isCancelledError(error) {
            return nil
        }
        return error
    }

    private func isCancelledError(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain &&
            nsError.code == NSURLErrorCancelled
    }
}
