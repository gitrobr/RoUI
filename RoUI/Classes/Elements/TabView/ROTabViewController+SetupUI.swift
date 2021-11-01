//
//  ROTabViewController+SetupUI.swift
//  RoUI
//
//  Created by seco on 05.04.21.
//

import Cocoa

extension ROTabViewController {

    func setupUI() {
        self.pSetupUIElements()
        self.pSetupView()
    }

    private func pSetupUIElements() {
        cntlrTab.delegate = self
    }

    private func pSetupView() {

        self.view.addSubviewsForAutoLayout([
            cntlrTab.view,
            viewContrainer
        ])

        self.view.addConstraints([
            cntlrTab.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            cntlrTab.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cntlrTab.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            viewContrainer.topAnchor.constraint(equalTo: cntlrTab.view.bottomAnchor),
            viewContrainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewContrainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            viewContrainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            cntlrTab.view.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
