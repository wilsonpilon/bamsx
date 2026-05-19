# bamsx: Frontend Toy para fMSX

**Versão:** 0.1.3
**Build:** 0x665A1B80 (Unix UTC)

**Autor:** Wilson 'Barney' Pilon
**(c)1972 Cybernostra, Inc.**
**2026 WIB Projetos**

Este projeto é um frontend simples para o emulador fMSX, desenvolvido em PureBasic como um experimento para avaliar a viabilidade da linguagem em aplicações GUI modernas no Windows. O projeto não tem fins comerciais e serve apenas como estudo/toy project.

## Ferramentas Utilizadas
- **VS Code Insiders** (edição e integração)
- **Windows 11** (ambiente de desenvolvimento e execução)
- **PureBasic 6.3** (linguagem e compilador principal)
- **Copilot** (auxílio de IA para automação e geração de código)
- **GitHub** (controle de versão e colaboração)

## Sobre o Projeto
- Frontend gráfico para o emulador fMSX
- Interface amigável para configuração e execução do fMSX
- Persistência de configurações via SQLite
- Suporte a múltiplas opções de linha de comando do fMSX
- Projeto didático/toy, sem pretensão de uso profissional

## Requisitos
- **fMSX**: Baixe o executável em: https://fms.komkon.org/fMSX/
- **SQLite3 DLL**: Baixe a DLL em: https://www.sqlite.org/download.html (coloque `sqlite3.dll` na mesma pasta do executável)
- **Opcional**: Baixe o frontend (este projeto) via GitHub

## Compilação
1. Instale o PureBasic 6.3 (https://www.purebasic.com/)
2. Abra o arquivo `main.pb` no PureBasic ou edite no VS Code
3. Certifique-se de que `sqlite3.dll` está no mesmo diretório do executável
4. Compile usando o PureBasic (F5 ou menu Compiler > Compile/Run)

## Operação
1. Execute o frontend compilado
2. No menu **Tools > Setup**, configure o caminho do `fmsx.exe` e demais opções desejadas
3. Use os botões Browse/Create para selecionar ou criar arquivos de imagem, logs, etc.
4. Clique em **Run** para iniciar o fMSX com as opções selecionadas
5. Use o menu **Help** para acessar informações de CLI, teclas e sobre o projeto

## Observações
- O frontend não distribui o fMSX nem a DLL do SQLite, apenas facilita o uso
- O projeto é experimental e pode conter bugs ou limitações
- Sinta-se livre para modificar, estudar ou adaptar para outros experimentos

---

## Changelog

### v0.1.3 (build 0x665A1B80)
- Primeira versão pública
- Interface gráfica completa para fMSX
- Suporte a múltiplas opções de linha de comando
- Persistência de configurações via SQLite
- UI com navegação, criação de arquivos e múltiplos discos
- Menu Help com CLI, Keys e About

**Autor:** Projeto experimental com auxílio do GitHub Copilot
