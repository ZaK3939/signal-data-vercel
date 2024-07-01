import { neon } from '@neondatabase/serverless';

export default async (req: Request) => {
  const sql = neon(process.env.DATABASE_URL!);

  // SQLクエリ：各クレデンシャルごとに一番直近のsupplyで大きいもの順に抽出
  const query = `
    WITH ranked_trades AS (
      SELECT
        "credId",
        MAX("block_timestamp") AS latest_timestamp,
        FIRST_VALUE("supply") OVER (PARTITION BY "credId" ORDER BY "block_timestamp" DESC) AS latest_supply,
        ROW_NUMBER() OVER (PARTITION BY "credId" ORDER BY "block_timestamp" DESC) AS rn
      FROM
        optimism_sepolia_cred_data
      WHERE
        "event_signature" = 'Trade'
      GROUP BY
        "credId", "supply", "block_timestamp"
    )
    SELECT
      "credId",
      latest_timestamp,
      latest_supply
    FROM
      ranked_trades
    WHERE
      rn = 1
    ORDER BY
      latest_supply DESC;
  `;

  const record = await sql(query);
  return new Response(JSON.stringify(record));
};

export const config = {
  runtime: 'edge',
};
