import React from 'react';
// import "./TurnTilte.css";

function TurnTilte({ currentPlayer }) {
  return (
    <div id="turn-title-area" className="visible">
      <h2 id="turn-text">{`Turn:  ${currentPlayer} `}</h2>
    </div>
  );
}

export default TurnTilte;
