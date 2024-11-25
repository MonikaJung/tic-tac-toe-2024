import React, { useState } from "react";
import "./StartGameArea.css";

const StartGameArea = ({ onStart }) => {
  const [usernameX, setUsernameX] = useState("");
  const [usernameO, setUsernameO] = useState("");
  return (
    <div id="start-game-area" className="visible">
      <div className="input-div">
        <label htmlFor="usernameX">Username for player X: </label>
        <input
          id="usernameX"
          value={usernameX}
          maxLength="10"
          onChange={(e) => setUsernameX(e.target.value)}
        />
      </div>
      <div className="input-div">
        <label htmlFor="usernameO">Username for player O: </label>
        <input
          id="usernameO"
          value={usernameO}
          maxLength="10"
          onChange={(e) => setUsernameO(e.target.value)}
        />
      </div>
      <button
        id="start-game"
        type="button"
        className="submit start-game-button"
        onClick={() => onStart(usernameX, usernameO)}
      >
        Start
      </button>
    </div>
  );
};

export default StartGameArea;
