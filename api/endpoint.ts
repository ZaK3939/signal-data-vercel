import { neon } from '@neondatabase/serverless';

export default async (req: Request) => {
  const sql = neon(process.env.DATABASE_URL!);

  const url = new URL(req.url);
  const address = url.searchParams.get('address');

  const query = `
    SELECT
      "cred_id",
      "chain",
      "endpoint"
    FROM
      cred_verifiers
    WHERE
      "address" = '${address?.toLowerCase()}'
    ORDER BY
      "timestamp" DESC;
  `;

  try {
    const records = await sql(query);
    return new Response(JSON.stringify(records), { status: 200 });
  } catch (error) {
    console.error('Error executing query:', error);
    return new Response('Internal Server Error', { status: 500 });
  }
};

export const config = {
  runtime: 'edge',
};
