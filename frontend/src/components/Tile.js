import React from "react";
import "./Tile.css";

function Tile({ id, value, currentPlayer, winner, onClick }) {
  const borderClass = `
    ${[0, 1, 3, 4, 6, 7].includes(id) ? "right-border" : ""}
    ${[0, 1, 2, 3, 4, 5].includes(id) ? "bottom-border" : ""}
  `;
  const hoverClass =
    value || winner ? "disabled-tile" : `${currentPlayer.toLowerCase()}-hover`;

  return (
    <div className={`tile ${borderClass} ${hoverClass}`} onClick={onClick}>
      {value}
    </div>
  );
}

export default Tile;
