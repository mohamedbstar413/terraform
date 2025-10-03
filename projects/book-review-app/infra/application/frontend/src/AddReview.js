import React, { useState } from "react";
import { addReview } from "./api";

function AddReview() {
  const [bookId, setBookId] = useState("");
  const [review, setReview] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!bookId || !review) {
      setMessage("Both fields required.");
      return;
    }
    await addReview(bookId, review);
    setMessage("Review added successfully!");
    setBookId("");
    setReview("");
  };

  return (
    <div>
      <h2>Add Review</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Book ID"
          value={bookId}
          onChange={(e) => setBookId(e.target.value)}
        />
        <br />
        <textarea
          placeholder="Your review"
          value={review}
          onChange={(e) => setReview(e.target.value)}
        />
        <br />
        <button type="submit">Submit</button>
      </form>
      <p>{message}</p>
    </div>
  );
}

export default AddReview;
