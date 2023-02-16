//
//  ApplicationOnboardingSession.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import SAPFioriFlows
import SharedFmwk

/// Custom data handling of the application
open class ApplicationOnboardingSession: OnboardingSession {
    
    var odataControllers: [String: ODataControlling]

    public required init(flow: OnboardingFlow) {
        guard let step = flow.steps.first(where: { $0 is ODataOnboardingStep }) as? ODataOnboardingStep else {
            fatalError("ODataOnboardingStep is missing.")
        }
        guard !step.controllers.isEmpty else {
            fatalError("Controllers are missing for ODataOnboardingStep.")
        }
        odataControllers = step.controllers

        super.init(flow: flow)
    }
    
}
