package com.jung.controller;

import com.jung.model.GameStateRequest;
import com.jung.model.GameStateResponse;
import com.jung.model.Strike;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class GameStatControllerTests {
    private final String X_LETTER = "X";
    private final String O_LETTER = "O";
    private final static String[] boardXRow1 = new String[]{"X", "X", "X", "O", "O", "", "", "", ""};
    private final static String[] boardORow2 = new String[]{"X", "X", "", "O", "O", "O", "X", "", ""};
    private final static String[] boardXRow3 = new String[]{"O", "O", "", "", "", "", "X", "X", "X"};
    private final static String[] boardOCol1 = new String[]{"O", "X", "", "O", "", "", "O", "X", "X"};
    private final static String[] boardXCol2 = new String[]{"O", "X", "", "", "X", "", "O", "X", ""};
    private final static String[] boardXCol3 = new String[]{"O", "", "X", "", "", "X", "O", "", "X"};
    private final static String[] boardXDia1 = new String[]{"X", "", "O", "", "X", "", "O", "", "X"};
    private final static String[] boardODia2 = new String[]{"X", "X", "O", "X", "O", "", "O", "", ""};
    private final static String[] boardX1 = new String[]{"X", "", "O", "O", "X", "", "X", "O", ""};
    private final static String[] boardO1 = new String[]{"X", "", "", "", "O", "O", "", "", ""};
    private final static String[] boardDraw1 = new String[]{"X", "X", "O", "O", "X", "X", "X", "O", "O"};
    private final static String[] boardDraw2 = new String[]{"X", "O", "O", "O", "X", "X", "X", "X", "O"};
    private final static String[] boardDraw3 = new String[]{"X", "O", "X", "X", "O", "O", "O", "X", "X"};

    private final static GameStateRequest gameStateRequest = new GameStateRequest();

    @Nested
    public class FindStrikeTests {
        @Test
        void findRow1Strike() {
            Assertions.assertEquals(Strike.ROW1, GameStateController.findStrike(boardXRow1));
        }

        @Test
        void findRow2Strike() {
            Assertions.assertEquals(Strike.ROW2, GameStateController.findStrike(boardORow2));
        }

        @Test
        void findRow3Strike() {
            Assertions.assertEquals(Strike.ROW3, GameStateController.findStrike(boardXRow3));
        }

        @Test
        void findCol1Strike() {
            Assertions.assertEquals(Strike.COL1, GameStateController.findStrike(boardOCol1));
        }

        @Test
        void findCol2Strike() {
            Assertions.assertEquals(Strike.COL2, GameStateController.findStrike(boardXCol2));
        }

        @Test
        void findCol3Strike() {
            Assertions.assertEquals(Strike.COL3, GameStateController.findStrike(boardXCol3));
        }

        @Test
        void findDia1Strike() {
            Assertions.assertEquals(Strike.DIA1, GameStateController.findStrike(boardXDia1));
        }

        @Test
        void findDia2Strike() {
            Assertions.assertEquals(Strike.DIA2, GameStateController.findStrike(boardODia2));
        }
    }

    @Nested
    public class CheckGameStateTests {
        @Test
        void createResponseForStrike() {
            testCreateResponse(boardXRow1, X_LETTER, true, true, X_LETTER, Strike.ROW1.getCssClass());
            testCreateResponse(boardXRow3, X_LETTER, true, true, X_LETTER, Strike.ROW3.getCssClass());
            testCreateResponse(boardXCol2, X_LETTER, true, true, X_LETTER, Strike.COL2.getCssClass());
            testCreateResponse(boardXCol3, X_LETTER, true, true, X_LETTER, Strike.COL3.getCssClass());
            testCreateResponse(boardXDia1, X_LETTER, true, true, X_LETTER, Strike.DIA1.getCssClass());
            testCreateResponse(boardORow2, O_LETTER, true, true, O_LETTER, Strike.ROW2.getCssClass());
            testCreateResponse(boardOCol1, O_LETTER, true, true, O_LETTER, Strike.COL1.getCssClass());
            testCreateResponse(boardODia2, O_LETTER, true, true, O_LETTER, Strike.DIA2.getCssClass());
        }

        private void testCreateResponse(String[] board, String player, boolean gameOver, boolean win, String winner, String strike) {
            gameStateRequest.setBoardState(board);
            gameStateRequest.setTurn(player);

            GameStateResponse expectedResponse = getGameStateResponse(gameOver, win, winner, strike);
            GameStateResponse response = GameStateController.checkGameState(gameStateRequest);

            Assertions.assertEquals(expectedResponse.isGameOver(), response.isGameOver());
            Assertions.assertEquals(expectedResponse.isWin(), response.isWin());
            Assertions.assertEquals(expectedResponse.getStrike(), response.getStrike());
            Assertions.assertEquals(expectedResponse.getWinner(), response.getWinner());
        }

        private static GameStateResponse getGameStateResponse(boolean gameOver, boolean win, String winner, String strike) {
            GameStateResponse expectedResponse = new GameStateResponse();
            expectedResponse.setGameOver(gameOver);
            expectedResponse.setWin(win);
            expectedResponse.setWinner(winner);
            expectedResponse.setStrike(strike);
            return expectedResponse;
        }

        @Test
        void createResponseForDraw() {
            testCreateResponse(boardDraw1, X_LETTER, true, false, "", "");
            testCreateResponse(boardDraw2, X_LETTER, true, false, "", "");
            testCreateResponse(boardDraw3, X_LETTER, true, false, "", "");
        }


        @Test
        void createResponseForGameInProgress() {
            testCreateResponse(boardO1, X_LETTER, false, false, "", "");
            testCreateResponse(boardX1, O_LETTER, false, false, "", "");
        }
    }
}
