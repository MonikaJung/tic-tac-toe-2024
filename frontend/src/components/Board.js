import React, { useState } from "react";
import Tile from "./Tile";
import GameOver from "./GameOver";
import TurnTilte from "./TurnTitle";
import "./Board.css";

function Board({ onBackendError, usernameX, usernameO, backendIP }) {
  const [tiles, setTiles] = useState(Array(9).fill(""));
  const [turn, setTurn] = useState("X");
  const [isGameOver, setGameOver] = useState(false);
  const [winner, setWinner] = useState("");
  const [strikeClass, setStrikeClass] = useState("");

  const tileClick = (index) => {
    if (isGameOver || tiles[index]) return;
    const newTiles = [...tiles];
    newTiles[index] = turn;
    setTiles(newTiles);
    setTurn(turn === "X" ? "O" : "X");
    checkWinner(newTiles);
  };

  const getPlayerName = (turn) => {
    if (turn === "X")
      return usernameX;
    else
    return usernameO;
  }

  const checkWinner = (newTiles) => {
    fetch(`http://${backendIP}:8080/tic-tac-toe/`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        boardState: newTiles,
        turn: turn,
      }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        if (data.gameOver) {
          setGameOver(true);
          if (data.win) {
            setWinner(getPlayerName(turn));
            setStrikeClass(data.strike);
          } else {
            setWinner("");
          }
        }
      })
      .catch((error) => {
        console.error("There was a problem with the fetch operation:", error);
        onBackendError();
      });
  };

  const restartGame = () => {
    setTiles(Array(9).fill(""));
    setTurn("X");
    setGameOver(false);
    setWinner("");
    setStrikeClass("");
  };

  return (
    <div id="game-area">
      {!isGameOver && <TurnTilte currentPlayer={getPlayerName(turn)}/>}
      <div id="board" className="visible">
        {tiles.map((tile, index) => (
          <Tile
            key={index}
            id={index}
            value={tile}
            currentPlayer={turn}
            winner={winner}
            onClick={() => tileClick(index)}
          />
        ))}
        <div id="strike" className={strikeClass}></div>
      </div>
      {isGameOver && <GameOver winner={winner} onRestart={restartGame} />}
    </div>
  );
}

export default Board;
