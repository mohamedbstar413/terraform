//const API_BASE = "127.0.0.1:5000"; // replace with ALB DNS in AWS

export async function getBooks() {
  const res = await fetch(`http://127.0.0.1:5000/books`);
  console.log(res);
  return res.json();
}

export async function addReview(bookId, review) {
  const res = await fetch(`http://127.0.0.1:5000/reviews`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ book_id: bookId, review }),
  });
  return res.json();
}
