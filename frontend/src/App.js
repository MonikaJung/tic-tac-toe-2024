import React, { useState } from "react";
import Board from "./components/Board";
import StartGameArea from "./components/StartGameArea";
import "./App.css";

function App() {
  const [isGameStarted, setGameStarted] = useState(false);
  const [isBackendWorking, setIsBackendWorking] = useState(true);
  const [isUsernameEntered, setIsUsernameEntered] = useState(true);
  const [isUsernameUnique, setIsUsernameUnique] = useState(true);
  const [usernameX, setUsernameX] = useState("");
  const [usernameO, setUsernameO] = useState("");

  const handleStart = (usernameX, usernameO) => {
    if (!usernameX || !usernameO) {
      setIsUsernameEntered(false);
    } else if (usernameO === usernameX) {
      setIsUsernameEntered(true);
      setIsUsernameUnique(false);
    } else {
      setGameStarted(true);
      setIsUsernameEntered(true);
      setIsUsernameUnique(true);
      setUsernameO(usernameO);
      setUsernameX(usernameX);
    }
  };

  const handleBackendError = () => {
    setIsBackendWorking(false);
  };

  return (
    <div className="App">
      <h1>Tic Tac Toe - MJ</h1>
      <div id="error-popup" className={isBackendWorking ? "hidden" : "visible"}>
        Oops! Backend is not working...
      </div>
      <div id="error-popup" className={isUsernameEntered ? "hidden" : "visible"}>
        Oops! You have to enter both usernames :)
      </div>
      <div id="error-popup" className={isUsernameUnique ? "hidden" : "visible"}>
        Oops! Players' usernames must be different :)
      </div>
      {!isGameStarted ? (
        <StartGameArea onStart={handleStart} />
      ) : (
        <Board
          onBackendError={handleBackendError}
          usernameX={usernameX}
          usernameO={usernameO}
          backendAddress={process.env.REACT_APP_BACKEND_URL} // on EC2 IPv4 of backend, locally "localhost"
        />
      )}
    </div>
  );
}

export default App;
