import { neon } from '@neondatabase/serverless';

export default async (req: Request) => {
  const sql = neon(process.env.DATABASE_URL!);

  if (req.method === 'POST') {
    const data = await req.json();
    console.log(data);
    if (
      data.op === 'INSERT' &&
      (data.data_source === 'cred-base-sepolia/1.0.0' ||
        data.data_source === 'cred-sepolia/1.0.0' ||
        data.data_source === 'cred-optimism-sepolia/1.0.0')
    ) {
      const newData = data.data.new;
      const chain = data.data_source.split('/')[0].replace('cred-', '');

      try {
        const response = await fetch(newData.cred_url);
        const credData = await response.json();
        console.log(credData);
        if (credData.verification.type === 'SIGNATURE') {
          const verifierListResponse = await fetch(credData.verification.verifier_list);
          const verifierList = await verifierListResponse.json();

          for (const verifier of verifierList.verifier_list) {
            const query = `
              INSERT INTO cred_verifiers (
                cred_id,
                chain,
                address,
                endpoint,
                timestamp
              )
              VALUES (
                '${newData.cred_id}',
                '${chain}',
                '${verifier.address}',
                '${verifier.endpoint}',
                '${newData.timestamp}'
              );
            `;

            await sql(query);
          }
        }

        return new Response('Data inserted successfully', { status: 200 });
      } catch (error) {
        console.error('Error executing query:', error);
        return new Response('Internal Server Error', { status: 500 });
      }
    }
  }

  return new Response('Bad Request', { status: 400 });
};

export const config = {
  runtime: 'edge',
};
