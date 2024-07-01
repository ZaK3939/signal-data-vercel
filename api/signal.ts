import { neon } from '@neondatabase/serverless';
import type { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(request: NextApiRequest, res: NextApiResponse) {
  const sql = neon(process.env.DATABASE_URL!);
  // const posts = await sql('SELECT * FROM posts WHERE id = $1', [postId]);
  const record = await sql('SELECT * FROM optimism_sepolia_cred_events');
  return res.status(200).send(record);
}
