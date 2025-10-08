import React, { useEffect, useState } from "react";
import { getBooks } from "./api";

function BookList() {
  const [books, setBooks] = useState([]);
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

  useEffect(() => {
    if (!dns) return; // wait until dns is loaded
    getBooks(dns).then(setBooks);
  }, [dns]); // run again when dns changes

  return (
    <div>
      <h2>Book List</h2>
      {books.length === 0 && <p>No books available.</p>}
      <ul>
        {books.map((b) => (
          <li key={b.id}>
            <strong>{b.title}</strong> by {b.author}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BookList;
