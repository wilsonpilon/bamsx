# bamsx: Frontend Toy para fMSX

**Versão:** 0.1.5  
**Build:** 0x6A0D0A96 (Unix UTC seconds in hexadecimal)

**Autor:** Wilson 'Barney' Pilon  
**(c)1972 Cybernostra, Inc.**  
**2026 WIB Projetos**

Este projeto é um frontend para o emulador fMSX, desenvolvido em PureBasic como experimento de GUI no Windows. Não possui fins comerciais e é mantido como projeto didático/toy.

## Ferramentas Utilizadas
- VS Code Insiders
- Windows 11
- PureBasic 6.40
- SQLite 3
- GitHub Copilot

## Sobre o Projeto
- Frontend gráfico para execução e configuração do fMSX
- Persistência de configurações em SQLite
- Montagem automática da linha de comando
- Interface com temas e janelas auxiliares de ajuda

## Novidades Recentes (v0.1.5)
- Setup redesenhado para layout mais largo e compacto, com mais opções lado a lado
- About com cards clicáveis para copiar valores individuais (ex.: Build)
- Help > CLI implementado em cards, com busca, filtros por categoria e cópia para clipboard
- Keys e About padronizados no mesmo estilo visual de cards
- Tradução da interface para Inglês

## Requisitos
- fMSX: https://fms.komkon.org/fMSX/
- sqlite3.exe na pasta do projeto (usado para bootstrap do banco)
- SQLite runtime disponível para o PureBasic (`UseSQLiteDatabase()`)

## Compilação
1. Instale o PureBasic 6.40 (https://www.purebasic.com/)
2. Abra `main.pb`
3. Compile no IDE (F5) ou via terminal:
	- `pbcompiler.exe .\main.pb`

## Operação
1. Execute o frontend compilado
2. Abra **Tools > Setup** e configure o caminho do `fmsx.exe`
3. Ajuste opções de máquina, vídeo, periféricos e arquivos
4. Clique em **Run fMSX** para iniciar com os parâmetros selecionados
5. Use **Help > CLI / Keys / About** para referência rápida

## Observações
- O frontend não distribui o executável do fMSX
- O projeto é experimental e pode receber mudanças frequentes
- Sinta-se livre para estudar e adaptar

---

## Changelog

### v0.1.5 (build 0x6A0D0A96)
- Setup mais largo e compacto
- About com cópia por card
- Nova janela Help > CLI em cards com filtro, busca e cópia
- Melhorias visuais gerais no padrão de cards
- Interface em Inglês

### v0.1.3 (build 0x665A1B80)
- Primeira versão pública

**Autor:** Projeto experimental com auxílio do GitHub Copilot
