package com.jung.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GameStateResponse {
    private boolean gameOver;
    private boolean win;
    private String strike;
    private String winner;
}
