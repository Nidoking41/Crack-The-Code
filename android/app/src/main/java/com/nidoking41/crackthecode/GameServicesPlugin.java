package com.nidoking41.crackthecode;

import android.content.Intent;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.games.PlayGamesSdk;

/**
 * Google Play Games leaderboards for the game.
 * The game calls this from JavaScript as "GameServices", the same name the iPhone version uses.
 */
@CapacitorPlugin(name = "GameServices")
public class GameServicesPlugin extends Plugin {
    private static final int SHOW_LEADERBOARD = 9004;
    private boolean started = false;

    private void startSdk() {
        if (!started) {
            PlayGamesSdk.initialize(getContext());
            started = true;
        }
    }

    /** signIn({ silent }) resolves { signedIn }. Not silent shows Google's sign-in if needed. */
    @PluginMethod
    public void signIn(PluginCall call) {
        startSdk();
        boolean silent = Boolean.TRUE.equals(call.getBoolean("silent", true));
        GamesSignInClient client = PlayGames.getGamesSignInClient(getActivity());
        (silent ? client.isAuthenticated() : client.signIn()).addOnCompleteListener(task -> {
            JSObject result = new JSObject();
            result.put("signedIn", task.isSuccessful() && task.getResult().isAuthenticated());
            call.resolve(result);
        });
    }

    /** submitScore({ leaderboardId, score }). Play Games keeps each player's best score. */
    @PluginMethod
    public void submitScore(PluginCall call) {
        String id = call.getString("leaderboardId");
        Long score = call.getLong("score");
        if (id == null || score == null) { call.reject("missing leaderboardId or score"); return; }
        startSdk();
        PlayGames.getLeaderboardsClient(getActivity()).submitScoreImmediate(id, score)
            .addOnSuccessListener(r -> call.resolve())
            .addOnFailureListener(e -> call.reject(e.getMessage()));
    }

    /** showLeaderboard({ leaderboardId }) opens Google's leaderboard screen. */
    @PluginMethod
    public void showLeaderboard(PluginCall call) {
        String id = call.getString("leaderboardId");
        if (id == null) { call.reject("missing leaderboardId"); return; }
        startSdk();
        PlayGames.getLeaderboardsClient(getActivity()).getLeaderboardIntent(id)
            .addOnSuccessListener(intent -> {
                getActivity().startActivityForResult(intent, SHOW_LEADERBOARD);
                call.resolve();
            })
            .addOnFailureListener(e -> call.reject(e.getMessage()));
    }
}
