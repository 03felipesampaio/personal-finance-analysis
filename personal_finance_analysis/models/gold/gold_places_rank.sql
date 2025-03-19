-- Trying to find the places where I expended the most and how much I spent.
WITH places as ( 
SELECT
  place,
  COUNT(*) num_transactions,
  SUM(amount*-1) sum_transactions
FROM {{ ref("transactions") }} as transactions
JOIN {{ ref("place_dimension") }} as place_dimension
  ON transactions.place_id = place_dimension.place_id
WHERE amount < 0
GROUP BY place
)
SELECT
  DENSE_RANK() OVER (ORDER BY places.sum_transactions DESC) as rank,
  *
FROM places
ORDER BY rank