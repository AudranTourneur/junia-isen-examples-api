CREATE TABLE IF NOT EXISTS example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO example (name)
SELECT 'Albert Camus'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Albert Camus');
UNION ALL
SELECT 'Socrates' 
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Socrates')
UNION ALL
SELECT 'Plato'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Plato')
UNION ALL
SELECT 'Aristotle'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Aristotle')
UNION ALL
SELECT 'Immanuel Kant'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Immanuel Kant')
UNION ALL
SELECT 'Friedrich Nietzsche'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Friedrich Nietzsche')
UNION ALL
SELECT 'René Descartes'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'René Descartes')
UNION ALL
SELECT 'John Locke'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'John Locke')
UNION ALL
SELECT 'David Hume'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'David Hume')
UNION ALL
SELECT 'Thomas Hobbes'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Thomas Hobbes')
UNION ALL
SELECT 'Jean-Paul Sartre'
WHERE NOT EXISTS (SELECT 1 FROM example WHERE name = 'Jean-Paul Sartre')
