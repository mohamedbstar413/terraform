import React, { useState , useEffect} from "react";
import { addReview } from "./api";

function AddReview() {
  const [bookId, setBookId] = useState("");
  const [review, setReview] = useState("");
  const [message, setMessage] = useState("");

  const [dns, setDns] = useState("");

  useEffect(() => {
    fetch("/lb_dns.txt")
      .then((response) => {
        if (!response.ok) throw new Error("Failed to load DNS file");
        return response.text();
      })
      .then((text) => {
        // remove any newline characters
        setDns(text.trim());
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  if (!dns) return <p>Loading...</p>;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!bookId || !review) {
      setMessage("Both fields required.");
      return;
    }
    await addReview(dns, bookId, review);
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
