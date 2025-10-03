import React from "react";
import BookList from "./BookList";
import AddReview from "./AddReview";
import "./App.css";

function App() {
  return (
    <div className="App">
      <h1>📚 Book Review App</h1>
      <BookList />
      <AddReview />
    </div>
  );
}

export default App;
