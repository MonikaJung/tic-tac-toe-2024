package com.jung.controller;

import com.jung.model.GameStateRequest;
import com.jung.model.GameStateResponse;
import com.jung.model.Strike;
import jakarta.annotation.PostConstruct;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/tic-tac-toe")
public class GameStateController {
    private static final Map<int[], Strike> winningCombinations = new HashMap<>();

    @PostConstruct
    public void init() {
        winningCombinations.put(new int[]{1, 2, 3}, Strike.ROW1);
        winningCombinations.put(new int[]{4, 5, 6}, Strike.ROW2);
        winningCombinations.put(new int[]{7, 8, 9}, Strike.ROW3);
        winningCombinations.put(new int[]{1, 4, 7}, Strike.COL1);
        winningCombinations.put(new int[]{2, 5, 8}, Strike.COL2);
        winningCombinations.put(new int[]{3, 6, 9}, Strike.COL3);
        winningCombinations.put(new int[]{1, 5, 9}, Strike.DIA1);
        winningCombinations.put(new int[]{3, 5, 7}, Strike.DIA2);
    }

    @GetMapping ("/")
    public static String checkBackendResponse() {
        return "Backend is working :)";
    }

    @PostMapping("/")
    public static GameStateResponse checkGameState(@RequestBody GameStateRequest request) {
        boolean isBoardFull = isBoardFull(request.getBoardState());
        Strike winStrike = findStrike(request.getBoardState());
        String winner = request.getTurn();

        if (!isBoardFull && winStrike == null)
            return getGameStateResponse(false, false, "", "");

        if (isBoardFull && winStrike == null)
            return getGameStateResponse(true, false, "", "");

        return getGameStateResponse(true, true, winner, winStrike.getCssClass());
    }

    private static GameStateResponse getGameStateResponse(boolean gameOver, boolean win, String winner, String strike) {
        GameStateResponse response = new GameStateResponse();
        response.setGameOver(gameOver);
        response.setWin(win);
        response.setWinner(winner);
        response.setStrike(strike);
        return response;
    }

    public static boolean isBoardFull(String[] board) {
        for (String tile : board)
            if (tile.isEmpty())
                return false;
        return true;
    }

    public static Strike findStrike(String[] board) {
        for (int[] key : winningCombinations.keySet()) {
            String tile1Value = board[key[0] - 1];
            String tile2Value = board[key[1] - 1];
            String tile3Value = board[key[2] - 1];

            if (!tile1Value.isEmpty() && tile1Value.equals(tile2Value) && tile1Value.equals(tile3Value)) {
                return winningCombinations.get(key);
            }
        }
        return null;
    }
}
