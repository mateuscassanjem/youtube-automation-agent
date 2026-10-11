# AgentTube — instalação privada em VPS (fase inicial)

Esta proposta prepara o alojamento de um **único operador**. Não disponibilizar o dashboard publicamente sem autenticação forte e revisão das rotas.

## Requisitos
- VPS Linux x86_64 com Docker Engine + Docker Compose.
- Google Cloud com YouTube Data API e credenciais OAuth de aplicação desktop.
- Chave de pelo menos um fornecedor de IA.
- Referência inicial: 4 vCPU / 8 GB RAM / 80 GB SSD (ajustar após medir uso real).

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

Os dados persistentes incluem `data/` (SQLite e vídeos), `config/` (tokens OAuth e credenciais), `uploads/`, `output/` e `logs/`. A criação do volume `config` usa a semântica de bind mount do Docker: se existirem ficheiros de configuração distribuídos com o repositório, assegurar que continuam disponíveis no diretório montado.

A porta `3456` apenas aceita conexões do próprio VPS, via `127.0.0.1`. Para acesso por SSH, a partir do computador:
```bash
ssh -L 3456:127.0.0.1:3456 utilizador@IP_DO_VPS
```
Abrir `http://localhost:3456` no computador. Futuramente, usar Cloudflare Tunnel + Access com política restrita.

## YouTube OAuth
O fluxo original utiliza OAuth de aplicação de computador e endereço de retorno loopback. O emparelhamento remoto pode requerer iniciar a autorização num computador local e transferir tokens por canal seguro. Não guardar tokens no repositório; confirmar primeiro os caminhos usados pelo código.

## Testes antes de publicar
1. Executar `npm run walkthrough` onde o processo OAuth possa abrir o navegador.
2. No dashboard, correr Production readiness.
3. Gerar MP4 curto, conferir som e imagem; aprovar direitos e proveniência.
4. Testar upload **privado**; só depois permitir programação de conteúdos.
5. Observar consumo e configurar alertas e limites no fornecedor IA.

## Backups
O script `backup.sh` para temporariamente o serviço, compacta `data`, `config`, `uploads`, `output`, `logs` e o `.env`, e volta a iniciar o serviço. **Atenção:** o backup contém segredos; cifrar e copiar para fora do servidor.

## Pendências de produção
- Contratar/configurar VPS e o acesso SSH.
- Validar autenticação do painel e endpoints para eventual acesso por domínio.
- Configurar Google OAuth, IA e credenciais privadas fora do Git.
- Testar build, geração e upload privados no servidor escolhido.
