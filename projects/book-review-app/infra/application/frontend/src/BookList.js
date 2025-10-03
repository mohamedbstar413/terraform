import React, { useEffect, useState } from "react";
import { getBooks } from "./api";

function BookList() {
  const [books, setBooks] = useState([]);

  useEffect(() => {
    getBooks().then(setBooks);
  }, []);

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
