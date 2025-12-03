# Cosmos Odyssey 🌌

![Flutter CI](https://github.com/ruanhcr/cosmos_odyssey/actions/workflows/main.yml/badge.svg)

App que demonstra **Clean Architecture** no Flutter para mobile (Android & iOS) e Web, consumindo as APIs da NASA. O projeto simula um cenário de alta exigência técnica, focando em manutenibilidade, escalabilidade e robustez, utilizando padrões avançados como BLoC com transformadores de eventos, Injeção de Dependência, Testes de Regressão Visual e Programação Funcional (fpdart).

# Configuração
O projeto utiliza **Code Generation** (Retrofit, Injectable, JsonSerializable) e variáveis de ambiente seguras.

1. **Clone o repositório.**
2. **Configure as Variáveis de Ambiente:**
    Crie um arquivo `.env` na raiz do projeto e adicione sua chave da NASA:

   NASA_API_KEY=SUA_CHAVE_AQUI (ou DEMO_KEY)
   BASE_URL=[https://api.nasa.gov/](https://api.nasa.gov/)

3. **Obtenha as depedências:**
   flutter pub get
4. **Execute o gerador de código:**
   dart run build_runner build --delete-conflicting-outputs

# Development Roadmap
- [x] Clean Architecture (Domain, Data, Presentation)
- [x] Repository Pattern e Use Cases
- [x] Princípios SOLID e SRP (Single Responsibility Principle), Object Calisthenics (Guard Clauses, Early Return)
- [x] BLoC Pattern (Eventos, Estados e Fluxo Unidirecional) [Flutter Bloc](https://pub.dev/packages/flutter_bloc) 
- [x] Service Locator [get_it](https://pub.dev/packages/get_it)
- [x] Code Generation para Injeção de Dependência [Injectable](https://pub.dev/packages/injectable)
- [x] [Flutter/Dart](https://docs.flutter.dev)
- [x] [Dio](https://pub.dev/packages/dio)
- [x] [Equatable](https://pub.dev/packages/equatable)
- [x] [fpdart](https://pub.dev/packages/fpdart)
- [x] [Retrofit](https://pub.dev/packages/retrofit)
- [x] [Flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

# Qualidade & DevOps
- [x] Testes Unitários [Mocktail](https://pub.dev/packages/mocktail), [bloc_test](https://pub.dev/packages/bloc_test)
- [x] Testes de Widget
- [x] Golden Tests (Regressão Visual) [golden_toolkit](https://pub.dev/packages/golden_toolkit)
- [x] Testes de Integração (Mockando HttpClientAdapter)
- [x] DevOps: CI/CD com GitHub Actions (Linter, Tests, Web Build)
- [x] Deploy Automático (GitHub Pages)