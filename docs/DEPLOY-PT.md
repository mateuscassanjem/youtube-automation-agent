# AgentTube — instalação privada em VPS (fase inicial)

Esta proposta prepara o alojamento de um **único operador**. Não disponibilizar o dashboard publicamente sem autenticação forte, revisão das rotas e confirmação de que todos os diretórios/tokens estão persistidos.

## Requisitos
- VPS Linux com Docker Engine + Docker Compose.
- Google Cloud com YouTube Data API e credenciais OAuth de aplicação desktop.
- Chave de pelo menos um fornecedor de IA.
- Como referência inicial, 4 vCPU / 8 GB RAM / 80 GB SSD (ajustar após medir uso real).

## Instalação
```bash
git clone https://github.com/mateuscassanjem/youtube-automation-agent.git
cd youtube-automation-agent
cp .env.example .env
chmod 600 .env
# Editar .env localmente: chave IA, canal, DEFAULT_PRIVACY_STATUS=private e API_KEY forte.
docker compose up -d --build
docker compose logs --tail=100
```

A porta `3456` apenas aceita conexões do próprio VPS, via `127.0.0.1`. Para acesso por SSH, a partir do computador:
```bash
ssh -L 3456:127.0.0.1:3456 utilizador@IP_DO_VPS
```
Abrir `http://localhost:3456` no computador. Futuramente, usar Cloudflare Tunnel + Access com política restrita.

## YouTube OAuth
O fluxo original utiliza OAuth de aplicação de computador e endereço de retorno loopback. O emparelhamento remoto pode requerer iniciar a autorização num computador local e transferir tokens por canal seguro. Não guardar tokens no repositório; confirmar primeiro os caminhos usados pelo código.

## Testes antes de publicar
1. Executar `npm run walkthrough` onde o processo OAuth possa abrir o navegador (ou executar o walkthrough pelo ambiente apropriado).
2. No dashboard, correr Production readiness.
3. Gerar MP4 curto, conferir som e imagem; aprovar direitos e proveniência.
4. Testar upload **privado**; só depois permitir programação de conteúdos.
5. Observar consumo e configurar alertas e limites no fornecedor IA.

## Backups
O script `backup.sh` para temporariamente o serviço, compacta `data`, `uploads`, `output` e o `.env`, e volta a iniciar o serviço. **Atenção:** o backup contém segredos; cifrar e copiar para fora do servidor. Validar os caminhos reais dos vídeos e tokens antes de confiar no backup.

## Pendências de produção
- Configurar VPS e DNS/Cloudflare Access ou acesso exclusivo via SSH.
- Validar volumes de todos os diretórios utilizados efetivamente na aplicação.
- Confirmar política de autenticação do painel e endpoints.
- Configurar Google OAuth, IA e credenciais privadas fora do Git.
- Testar build, geração e upload privados no servidor escolhido.
