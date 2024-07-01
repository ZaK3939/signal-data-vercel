import { neon } from '@neondatabase/serverless';

export default async (req: Request) => {
  const sql = neon(process.env.DATABASE_URL!);
  // const posts = await sql('SELECT * FROM posts WHERE id = $1', [postId]);
  const record = await sql('SELECT * FROM optimism_sepolia_cred_events');
  return new Response(JSON.stringify(record));
};

export const config = {
  runtime: 'edge',
};
