import { neon } from '@neondatabase/serverless';

export default async (req: Request) => {
  const sql = neon(process.env.DATABASE_URL!);

  // リクエストからcredIdとcredChainIdを取得
  const url = new URL(req.url);
  const credId = url.searchParams.get('credId');
  const credChainId = url.searchParams.get('credChainId');

  // SQLクエリ：指定したcredIdとcredChainIdに紐づくartId、artAddress、artist、chain情報を取得
  const query = `
    SELECT 
      "artId",
      "artAddress",
      "artist",
      "chain"
    FROM 
      testnet_factory_art_create_data
    WHERE 
      "credId" = ${credId} AND "credChainId" = ${credChainId}
    GROUP BY
      "artId", "artAddress", "artist", "chain"
    ORDER BY
      "block_timestamp" DESC;
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
