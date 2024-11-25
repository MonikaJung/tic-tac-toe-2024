package com.jung.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GameStateRequest {

    private String[] boardState;
    private String turn;
}
