import Capacitor
import GameKit
import UIKit

/// Loads the app's own plugins into Capacitor (used by SceneDelegate).
class AppViewController: CAPBridgeViewController {
    override func capacitorDidLoad() {
        bridge?.registerPluginInstance(GameServicesPlugin())
    }
}

/// Game Center leaderboards for the game.
/// The game calls this from JavaScript as "GameServices", the same name the Android version uses.
@objc(GameServicesPlugin)
public class GameServicesPlugin: CAPPlugin, CAPBridgedPlugin, GKGameCenterControllerDelegate {
    public let identifier = "GameServicesPlugin"
    public let jsName = "GameServices"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "signIn", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "submitScore", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "showLeaderboard", returnType: CAPPluginReturnPromise),
    ]

    private var handlerInstalled = false
    private var loginScreen: UIViewController?
    private var waiting: [(call: CAPPluginCall, silent: Bool)] = []

    /// signIn({ silent }) resolves { signedIn }.
    /// Silent never shows anything. Not silent shows Apple's Game Center sign-in if it can.
    @objc func signIn(_ call: CAPPluginCall) {
        let silent = call.getBool("silent") ?? true
        DispatchQueue.main.async {
            if GKLocalPlayer.local.isAuthenticated {
                call.resolve(["signedIn": true])
                return
            }
            if !self.handlerInstalled {
                // Apple calls this handler once now and again whenever the sign-in state changes.
                self.handlerInstalled = true
                self.waiting.append((call, silent))
                GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, _ in
                    self?.authChanged(viewController)
                }
                return
            }
            if !silent, let screen = self.loginScreen {
                self.waiting.append((call, silent))
                self.present(screen)
                return
            }
            call.resolve(["signedIn": false])
        }
    }

    private func authChanged(_ viewController: UIViewController?) {
        loginScreen = viewController
        if let viewController = viewController, waiting.contains(where: { !$0.silent }) {
            // Someone tapped to sign in: show Apple's screen. Answer the silent checks now,
            // and the tapped one when Apple calls back after the player finishes.
            present(viewController)
            waiting.filter { $0.silent }.forEach { finish($0.call) }
            waiting.removeAll { $0.silent }
            return
        }
        waiting.forEach { finish($0.call) }
        waiting.removeAll()
    }

    private func finish(_ call: CAPPluginCall) {
        call.resolve(["signedIn": GKLocalPlayer.local.isAuthenticated])
    }

    private func present(_ screen: UIViewController) {
        guard let host = bridge?.viewController, screen.presentingViewController == nil else { return }
        host.present(screen, animated: true)
    }

    /// submitScore({ leaderboardId, score }). Game Center keeps each player's best score.
    @objc func submitScore(_ call: CAPPluginCall) {
        guard let id = call.getString("leaderboardId") else { call.reject("missing leaderboardId"); return }
        let score = call.getInt("score") ?? 0
        guard GKLocalPlayer.local.isAuthenticated else { call.reject("not signed in"); return }
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [id]) { error in
            if let error = error { call.reject(error.localizedDescription) } else { call.resolve() }
        }
    }

    /// showLeaderboard({ leaderboardId }) opens Apple's leaderboard screen.
    @objc func showLeaderboard(_ call: CAPPluginCall) {
        guard let id = call.getString("leaderboardId") else { call.reject("missing leaderboardId"); return }
        DispatchQueue.main.async {
            guard let host = self.bridge?.viewController else { call.reject("no screen to show it on"); return }
            let board = GKGameCenterViewController(leaderboardID: id, playerScope: .global, timeScope: .allTime)
            board.gameCenterDelegate = self
            host.present(board, animated: true) { call.resolve() }
        }
    }

    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
