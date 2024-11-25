import React from 'react';
import "./GameOver.css";

function GameOver({ winner, onRestart }) {
  return (
    <div id="game-over-area" className="visible">
      <h2 id="game-over-text">{winner ? `The winner is ${winner}!` : 'Draw!'}</h2>
      <button id="play-again" onClick={onRestart}>Play again</button>
    </div>
  );
}

export default GameOver;
