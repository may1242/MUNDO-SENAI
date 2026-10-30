<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.senai.model.Trilha, com.senai.service.TrilhaService" %>
<%
    request.setCharacterEncoding("UTF-8");

    TrilhaService senai = (TrilhaService) application.getAttribute("TrilhaService");
    if (senai == null) {
        com.senai.repository.TrilhaRepository repo = new com.senai.repository.TrilhaRepositoryTxt();
        senai = new TrilhaService(repo);
        application.setAttribute("TrilhaService", senai);
    }

    String mensagem = null;
    String tipoMensagem = "success";

    List<Trilha> trilhas = senai.getCursos();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idRecebido = request.getParameter("id");
        try {
            int id = Integer.parseInt(idRecebido);
            if (trilhas != null) {
                for (Trilha t : trilhas) {
                    if (t.getId() == id) {
                        t.adicionarVoto();
                        mensagem = "Voto registrado com sucesso em: " + t.getNome();
                        break;
                    }
                }
            }
        } catch (NumberFormatException e) {
            mensagem = "Seleção inválida.";
            tipoMensagem = "error";
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mundo SENAI - Votação</title>
    <style>
        :root {
            --senai-blue: #004580;
            --senai-orange: #f26522;
            --senai-dark-blue: #002d54;
            --bg-light: #f4f6f9;
            --card-bg: #ffffff;
            --text-main: #333333;
            --text-sub: #666666;
            --border-color: #e0e0e0;
            --footer-bg: #002240;
        }

        body.dark-mode {
            --bg-light: #121212;
            --card-bg: #1e1e1e;
            --text-main: #e0e0e0;
            --text-sub: #aaaaaa;
            --border-color: #333333;
            --footer-bg: #0a0a0a;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            background: linear-gradient(135deg, var(--senai-blue), var(--senai-dark-blue));
            color: white;
            padding: 20px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-bottom: 4px solid var(--senai-orange);
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .logo-img {
            height: 48px;
            background-color: white;
            padding: 6px 14px;
            border-radius: 6px;
            object-fit: contain;
            border-bottom: 3px solid var(--senai-orange);
        }

        .header-controls {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .theme-toggle {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.4);
            color: white;
            padding: 8px 14px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .theme-toggle:hover {
            background: rgba(255, 255, 255, 0.35);
            transform: scale(1.05);
        }

        .timer-box {
            background-color: var(--senai-orange);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .timer-warning {
            animation: pulse-red 1s infinite alternate;
        }

        @keyframes pulse-red {
            from { background-color: var(--senai-orange); }
            to { background-color: #d32f2f; }
        }

        main {
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 20px 50px 20px;
            flex: 1;
        }

        .section-title {
            margin-bottom: 24px;
            border-left: 5px solid var(--senai-orange);
            padding-left: 12px;
        }

        .section-title h2 {
            font-size: 24px;
            color: var(--senai-blue);
        }

        body.dark-mode .section-title h2 {
            color: var(--senai-orange);
        }

        .section-title p {
            color: var(--text-sub);
            font-size: 15px;
        }

        .alert {
            padding: 14px 20px;
            border-radius: 6px;
            margin-bottom: 24px;
            font-weight: 600;
        }

        .alert.success {
            background-color: #e6f4ea;
            color: #137333;
            border: 1px solid #ceead6;
        }

        .alert.error {
            background-color: #fce8e6;
            color: #c5221f;
            border: 1px solid #fad2cf;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        @media (max-width: 1024px) { .grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 600px) { .grid { grid-template-columns: 1fr; } }

        .trilha-card {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .trilha-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background-color: var(--senai-blue);
            transition: background-color 0.3s ease;
        }

        .trilha-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.15);
            border-color: var(--senai-orange);
        }

        .trilha-card:hover::before {
            background-color: var(--senai-orange);
        }

        .number-badge {
            background-color: var(--senai-blue);
            color: white;
            width: 32px; height: 32px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: bold; font-size: 14px; margin-bottom: 12px;
        }

        .trilha-card h3 {
            font-size: 17px;
            color: var(--senai-blue);
            margin-bottom: 8px;
        }

        body.dark-mode .trilha-card h3 { color: #4da6ff; }

        .trilha-card p {
            font-size: 13px;
            color: var(--text-sub);
            line-height: 1.4;
            margin-bottom: 18px;
        }

        .btn-votar {
            background-color: var(--senai-orange);
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }

        .btn-votar:hover:not(:disabled) {
            background-color: #d95316;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(242, 101, 34, 0.3);
        }

        .btn-votar:disabled {
            background-color: #888888;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .ranking-container {
            text-align: center;
            margin-top: 40px;
        }

        .btn-ranking {
            background-color: var(--senai-blue);
            color: white;
            border: 2px solid var(--senai-orange);
            padding: 14px 32px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 16px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .btn-ranking:hover {
            background-color: var(--senai-orange);
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(242, 101, 34, 0.4);
        }

        footer {
            background-color: var(--footer-bg);
            color: #e0e0e0;
            padding: 30px 5% 20px 5%;
            margin-top: auto;
            border-top: 3px solid var(--senai-orange);
        }

        .footer-content {
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .footer-info h4 {
            color: var(--senai-orange);
            font-size: 18px;
            margin-bottom: 4px;
        }

        .footer-info p {
            font-size: 13px;
            color: #aaa;
        }

        .devs-list {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .dev-card {
            background: rgba(255,255,255,0.05);
            padding: 8px 14px;
            border-radius: 6px;
            border: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .dev-card:hover {
            border-color: var(--senai-orange);
            background: rgba(255,255,255,0.1);
        }

        .github-link {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .github-link:hover {
            color: var(--senai-orange);
        }

        .github-icon {
            width: 16px;
            height: 16px;
            fill: currentColor;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid rgba(255,255,255,0.08);
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>

    <header>
        <div class="header-brand">
            <img src="${pageContext.request.contextPath}/recursos/nova_logo-senai.png" alt="Logo SENAI" class="logo-img" onerror="this.outerHTML='<div class=\'logo-img\' style=\'font-weight:bold;color:#004580;\'>SENAI</div>'">
            <div>
                <h1>MUNDO SENAI</h1>
                <p style="font-size: 13px; opacity:0.85;">Escolha a sua trilha tecnológica</p>
            </div>
        </div>

        <div class="header-controls">
            <div class="timer-box" id="timerBox">⏱️ <span id="timer">05:00</span></div>
            <button class="theme-toggle" id="themeBtn" onclick="toggleTheme()">🌙 Escuro</button>
        </div>
    </header>

    <main>
        <div class="section-title">
            <h2>Vote na sua área favorita</h2>
            <p id="subtitulo">Ajude a montar o ranking de preferências da feira.</p>
        </div>

        <% if (mensagem != null) { %>
            <div class="alert <%= tipoMensagem %>"><%= mensagem %></div>
        <% } %>

        <% if (trilhas != null && !trilhas.isEmpty()) { %>
            <div class="grid">
                <% for (Trilha trilha : trilhas) { %>
                    <article class="trilha-card">
                        <div>
                            <div class="number-badge"><%= trilha.getId() %></div>
                            <h3><%= trilha.getNome() %></h3>
                            <p><%= trilha.getDescricao() %></p>
                        </div>
                        <form method="POST">
                            <input type="hidden" name="id" value="<%= trilha.getId() %>">
                            <button type="submit" class="btn-votar">Votar nesta trilha</button>
                        </form>
                    </article>
                <% } %>
            </div>

            <div class="ranking-container">
                <a href="resultado.jsp" class="btn-ranking" onclick="localStorage.setItem('confetti_trigger', 'true');">📊 Ver Resultado da Pesquisa</a>
            </div>
        <% } %>
    </main>

    <footer>
        <div class="footer-content">
            <div class="footer-info">
                <h4>Desenvolvimento de Sistemas</h4>
                <p>Projeto Mundo SENAI • Sistema de Votação em Tempo Real</p>
            </div>

            <div class="devs-list">
                <div class="dev-card">
                    👤 Maria Luiza
                    <a href="https://github.com/may1242" target="_blank" class="github-link">
                        <svg class="github-icon" viewBox="0 0 24 24"><path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/></svg>
                    </a>
                </div>
                <div class="dev-card">
                    👤 Sofia Glatz
                    <a href="https://github.com/sofiaglatz" target="_blank" class="github-link">
                        <svg class="github-icon" viewBox="0 0 24 24"><path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/></svg>
                    </a>
                </div>
                <div class="dev-card">
                    👤 Iohanna
                    <a href="https://github.com/iohannaoliveira-bot" target="_blank" class="github-link">
                        <svg class="github-icon" viewBox="0 0 24 24"><path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/></svg>
                    </a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            © 2026 SENAI - Todos os direitos reservados.
        </div>
    </footer>

    <script>
        function toggleTheme() {
            document.body.classList.toggle('dark-mode');
            var isDark = document.body.classList.contains('dark-mode');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            document.getElementById('themeBtn').innerHTML = isDark ? '☀️ Claro' : '🌙 Escuro';
        }

        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
            document.getElementById('themeBtn').innerHTML = '☀️ Claro';
        }

        var duracaoTotal = 300;
        var tempoRestante = localStorage.getItem('votacao_tempo');

        if (tempoRestante === null) {
            tempoRestante = duracaoTotal;
            localStorage.setItem('votacao_tempo', tempoRestante);
        } else {
            tempoRestante = parseInt(tempoRestante, 10);
        }

        var timerDisplay = document.getElementById('timer');
        var timerBox = document.getElementById('timerBox');
        var botoesVoto = document.querySelectorAll('.btn-votar');

        function atualizarTimer() {
            if (tempoRestante <= 0) {
                timerDisplay.innerText = "00:00 - Encerrado!";
                timerBox.classList.remove('timer-warning');
                botoesVoto.forEach(function(btn) {
                    btn.disabled = true;
                    btn.innerText = "Votação Encerrada";
                });
                document.getElementById('subtitulo').innerText = "Votação encerrada! Confira o resultado final abaixo.";
                localStorage.setItem('votacao_finalizada', 'true');
                return;
            }

            if (tempoRestante < 60) {
                timerBox.classList.add('timer-warning');
            }

            var minutos = Math.floor(tempoRestante / 60);
            var segundos = tempoRestante % 60;
            timerDisplay.innerText =
                (minutos < 10 ? '0' : '') + minutos + ':' + (segundos < 10 ? '0' : '') + segundos;

            tempoRestante--;
            localStorage.setItem('votacao_tempo', tempoRestante);
        }

        setInterval(atualizarTimer, 1000);
        atualizarTimer();

    window.addEventListener('keydown', function(e) {
            if (e.key === 'r' || e.key === 'R') {
                localStorage.removeItem('votacao_tempo');
                localStorage.removeItem('votacao_finalizada');
                localStorage.removeItem('confetti_trigger');
                alert('Timer e votação resetados com sucesso!');
                location.reload();
            }
        });
    </script>
    
</body>
</html>
