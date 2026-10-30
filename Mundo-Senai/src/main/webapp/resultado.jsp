<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Collections, java.util.Comparator, com.senai.model.Trilha, com.senai.service.TrilhaService" %>
<%
    TrilhaService senai = (TrilhaService) application.getAttribute("TrilhaService");
    List<Trilha> ordenadas = new ArrayList<>();
    int totalGeralVotos = 0;

    if (senai != null && senai.getCursos() != null) {
        ordenadas.addAll(senai.getCursos());

        Collections.sort(ordenadas, new Comparator<Trilha>() {
            @Override
            public int compare(Trilha t1, Trilha t2) {
                return Integer.compare(t2.getVotos(), t1.getVotos());
            }
        });

        for (Trilha t : ordenadas) {
            totalGeralVotos += t.getVotos();
        }
    }

    Trilha primeiro = ordenadas.size() > 0 ? ordenadas.get(0) : null;
    Trilha segundo = ordenadas.size() > 1 ? ordenadas.get(1) : null;
    Trilha terceiro = ordenadas.size() > 2 ? ordenadas.get(2) : null;
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Mundo SENAI - Resultado</title>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <style>
        :root {
            --senai-blue: #004580;
            --senai-orange: #f26522;
            --bg-light: #f4f6f9;
            --card-bg: #ffffff;
            --text-main: #333333;
        }

        body.dark-mode {
            --bg-light: #121212;
            --card-bg: #1e1e1e;
            --text-main: #e0e0e0;
        }

        * {
            box-sizing: border-box;
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-main);
            padding: 30px 20px;
        }

        .card-container {
            max-width: 850px;
            margin: 0 auto;
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        h1 {
            text-align: center;
            color: var(--senai-blue);
            margin-bottom: 25px;
        }

        body.dark-mode h1 { color: var(--senai-orange); }

        .podium {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            gap: 15px;
            margin-bottom: 35px;
            padding-top: 20px;
        }

        .step {
            flex: 1;
            max-width: 180px;
            text-align: center;
            border-radius: 8px 8px 0 0;
            padding: 15px 10px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }

        .step:hover {
            transform: translateY(-5px);
        }

        .step.first {
            height: 180px;
            background: linear-gradient(180deg, #ffd700, #d4af37);
            order: 2;
        }

        .step.second {
            height: 140px;
            background: linear-gradient(180deg, #c0c0c0, #999999);
            order: 1;
        }

        .step.third {
            height: 110px;
            background: linear-gradient(180deg, #cd7f32, #a0522d);
            order: 3;
        }

        .step-position { font-size: 26px; font-weight: 900; }
        .step-title { font-weight: 700; font-size: 14px; margin: 6px 0; }
        .step-votes { font-size: 12px; background: rgba(0,0,0,0.25); padding: 4px 8px; border-radius: 12px; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td { padding: 12px 15px; text-align: left; }
        th { background-color: var(--senai-blue); color: white; }

        body.dark-mode tr:nth-child(even) { background-color: #2a2a2a; }
        body.dark-mode tr.highlight { background-color: #003366; }

        tr:nth-child(even) { background-color: #f8f9fa; }
        tr.highlight { background-color: #e8f4fc; font-weight: bold; }

        .total-box {
            background-color: var(--senai-orange);
            color: white;
            padding: 15px;
            border-radius: 6px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }

        .back-link {
            display: block;
            text-align: center;
            color: var(--senai-blue);
            font-weight: bold;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .back-link:hover {
            color: var(--senai-orange);
        }

        body.dark-mode .back-link { color: var(--senai-orange); }
    </style>
</head>
<body>

    <div class="card-container">
        <h1>🏆 Resultado da Votação</h1>

        <% if (!ordenadas.isEmpty()) { %>
            <div class="podium">
                <% if (segundo != null) { %>
                    <div class="step second">
                        <div class="step-position">2º</div>
                        <div class="step-title"><%= segundo.getNome() %></div>
                        <div class="step-votes"><%= segundo.getVotos() %> votos</div>
                    </div>
                <% } %>

                <% if (primeiro != null) { %>
                    <div class="step first">
                        <div class="step-position">1º</div>
                        <div class="step-title"><%= primeiro.getNome() %></div>
                        <div class="step-votes"><%= primeiro.getVotos() %> votos</div>
                    </div>
                <% } %>

                <% if (terceiro != null) { %>
                    <div class="step third">
                        <div class="step-position">3º</div>
                        <div class="step-title"><%= terceiro.getNome() %></div>
                        <div class="step-votes"><%= terceiro.getVotos() %> votos</div>
                    </div>
                <% } %>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Número</th>
                        <th>Nome</th>
                        <th>Total de Votos</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Trilha t : ordenadas) { %>
                        <tr class="<%= (primeiro != null && t.getId() == primeiro.getId()) ? "highlight" : "" %>">
                            <td><%= t.getId() %></td>
                            <td><%= t.getNome() %></td>
                            <td><%= t.getVotos() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="total-box">
                Total Geral de Votos: <%= totalGeralVotos %>
            </div>
        <% } %>

        <a href="index.jsp" class="back-link">← Voltar para a Tela de Votação</a>
    </div>

    <script>
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
        }

        // CONFETES SÓ SE CLICAR NO BOTÃO DE VER RESULTADOS OU QUANDO FINALIZADO
        window.onload = function() {
            var triggerConfetti = localStorage.getItem('confetti_trigger');
            var finalizado = localStorage.getItem('votacao_finalizada');

            if (triggerConfetti === 'true' || finalizado === 'true') {
                confetti({
                    particleCount: 150,
                    spread: 80,
                    origin: { y: 0.6 }
                });
                localStorage.removeItem('confetti_trigger');
            }
        };
    </script>

</body>
</html>