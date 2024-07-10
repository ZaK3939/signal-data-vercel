goldsky command
goldsky subgraph deploy "test-base-f-cred/1.0.0" --from-abi <config-path>
goldsky subgraph delete xxx

- download abi from etherscan

  - prepare-abi.sh

- goldsky subgraph deploy

  - make-config.sh

- add webhook
  - add-webhook.sh

creating DB ( cred_verifiers ) by neon sql editor

- pls copy and paste create_table.sql

- bun install -g neonctl
- neon auth
- neon databases create --name cred_verifiers --owner-name prd_owner

  webhook->neondb

- verifier.ts

neondb -> response
