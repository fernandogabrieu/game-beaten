# gamebeaten

Registre os games que já jogou, está jogando ou quer jogar em um único lugar.
Game Beaten é um aplicativo desenvolvido em Flutter para ajudar os usuários a organizar seus jogos. 
Com este app, você pode pesquisar jogos, salvá-los localmente e categorizá-los em diferentes status: "Estou Jogando", "Vou Jogar" e "Já Joguei". 

## Funcionalidades

- **Pesquisar jogos**: Utiliza a API do RAWG para buscar e adicionar jogos.
- **Categorias**: Organiza os jogos em "Estou Jogando", "Vou Jogar" e "Já Joguei".
- **Detalhes do jogo**: Exibe informações completas, como gênero, desenvolvedores, distribuidores e data de lançamento.
- **Modo claro/escuro**: Altera entre os temas claro e escuro facilmente.
- **Persistência de dados**: Salva e recupere seus jogos localmente usando Floor.
- **Verificação de conectividade**: Checa a conexão de internet antes de buscar na API.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma.
- **Floor**: Persistência de dados local.
- **Retrofit**: Consumo de API.
- **Provider**: Gerenciamento de estado.
- **Platform Channel**: Comunicação com código nativo (Android).
- **API RAWG**: Fonte de dados para informações dos jogos.
