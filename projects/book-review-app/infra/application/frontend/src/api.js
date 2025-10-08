//const API_BASE = "127.0.0.1:5000"; // replace with ALB DNS in AWS

export async function getBooks(dns) {
  if (!dns) throw new Error("DNS not loaded yet");
  const res = await fetch(`${dns}/books`);
  return res.json();
}


export async function addReview(dns, bookId, review) {
  console.log('dns is ', dns)
  const res = await fetch(`${dns}/reviews`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ book_id: bookId, review }),
  });
  return res.json();
}
