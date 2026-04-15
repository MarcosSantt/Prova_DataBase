# Respostas da Prova Prática - SigaEdu

## 1. Modelagem e Arquitetura

**SGBD Relacional (MySQL):**
A escolha pelo **MySQL** justifica-se pela necessidade de garantir a integridade referencial e a consistência rigorosa dos dados acadêmicos. Através das propriedades **ACID** (Atomicidade, Consistência, Isolamento e Durabilidade), asseguramos que operações críticas, como o lançamento de notas e registros de matrículas, sejam executadas de forma segura, evitando corrupção de dados que modelos NoSQL poderiam permitir em cenários de alta complexidade relacional.

**Uso de Schemas:**
A separação em namespaces (`academico` e `seguranca`) foi aplicada para seguir as melhores práticas de **Governança de Dados**. Isso permite isolar responsabilidades: o módulo de segurança gerencia dados sensíveis de usuários, enquanto o módulo acadêmico foca na operação educacional. Essa estrutura facilita a manutenção, a aplicação de políticas de backup distintas e a escala do sistema.

## 5. Transações e Concorrência

No cenário de dois operadores tentando alterar a mesma nota simultaneamente, o MySQL utiliza os conceitos de **Isolamento** e **Locks (Bloqueios)** de linha. 

Quando o primeiro operador inicia um `UPDATE`, o motor do banco de dados (InnoDB) bloqueia aquela linha específica. O segundo operador entra em uma fila de espera. Somente após o `COMMIT` (confirmação) da primeira transação, a segunda é processada. Isso evita o conflito de **"Lost Update"** (Atualização Perdida), garantindo que a base de dados reflita sempre o último estado válido e consistente.