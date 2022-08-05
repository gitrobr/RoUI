//
//  MessageLooper.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 28.05.22.
//

import Foundation

/// Protokol um Messages zu empfangen
public protocol MessageLooperReceiver: AnyObject {
    func messageDelivery(_ message: MessageLooper.Message)
}

public typealias MessageCallback = () -> Void

/// Erlaupt es Nachrichten innerhalb der Applikation zu senden
///
/// Der Empfänger wird mit registerReceivers registriert und muss MessageLooperReceiver implementieren
open class MessageLooper {
    /// initialisiere der Loopers
    public init() {
    }
    /// Registriert einen Empfänger
    /// - Parameters:
    ///   - receiver: Der Empfänger
    ///   - priority: Die Priorität
    public func registerReceivers(_ receiver: MessageLooperReceiver, priority: Int = 99) {
        let rec = LooperRecord(receiver: receiver, priority: priority)
        pReceivers.append(rec)
        pReceivers.sort()
    }
    /// Eine Message senden.
    /// - Parameters:
    ///   - message: Die Message
    ///   - delay: Die Message wird nach soviel Sekunden gesendet ( Default: nil - sofort )
    ///   - callback: Callback wenn die Message überall verarbeitet wurde( Default: nil )
    public func sendMessage(_ message: MessageLooper.Message, delay: Double? = nil, callback: MessageCallback? = nil) {
        if let delay = delay {
            pSendMessageWithDelay(message, delay: delay, callback: callback)
        } else {
            pSendMessage(message, callback: callback)
        }
    }
    public func pSendMessage(_ message: MessageLooper.Message, callback: MessageCallback? = nil) {
        pReceivers.forEach({
            if !($0 === message.sender) { $0.receiver.messageDelivery(message) }
        })
        if let callb = callback { callb() }
    }
    public func pSendMessageWithDelay(_ message: MessageLooper.Message, delay: Double, callback: MessageCallback? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.pReceivers.forEach({
                if !($0 === message.sender) { $0.receiver.messageDelivery(message) }
            })
            if let callb = callback { callb() }
        }
    }
    private var pReceivers: [LooperRecord] = []

}

extension MessageLooper {
    /// Definier die aktion der Nachricht
    ///
    /// Items werde wie folgt hinzugefügt
    /// ```
    ///  extension MessageLooper.MessageType {
    ///     static let startUpApplication = MessageLooper.MessageType(rawValue: "startUpApplication")!
    ///  }
    ///  ```
    public struct MessageType: RawRepresentable, Equatable {
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        public var rawValue: String
    }
    /// Eine Message die versendet / empfangen wird
    public class Message {
        /// Initialisier eine Message
        /// - Parameters:
        ///   - sender: Der Absender
        ///   - type: Der Messagetype
        public init(sender: AnyObject, type: MessageType) {
            self.sender = sender
            self.type = type
        }
        /// Der Absender der Nachricht
        public let sender: AnyObject
        /// Die Nachricht
        public let type: MessageType
    }
    /// Interne Struktur zum festhalten der registrierten Empfänger
    class LooperRecord: Comparable {
        static func < (lhs: MessageLooper.LooperRecord, rhs: MessageLooper.LooperRecord) -> Bool {
            lhs.priority < rhs.priority
        }

        static func == (lhs: MessageLooper.LooperRecord, rhs: MessageLooper.LooperRecord) -> Bool {
            lhs.priority == rhs.priority
        }

        let priority: Int
        let receiver: MessageLooperReceiver

        init(receiver: MessageLooperReceiver, priority: Int) {
            self.priority = priority
            self.receiver = receiver
        }
    }
}
