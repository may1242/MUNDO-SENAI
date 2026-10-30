<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Quiz Interativo</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;800;900&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #F2F2F2;
            overflow-x: hidden;
        }

        /* Cores temáticas no estilo Kahoot */
        .bg-kahoot-red { background-color: #E21B3C; }
        .bg-kahoot-blue { background-color: #1368CE; }
        .bg-kahoot-yellow { background-color: #D89E00; }
        .bg-kahoot-green { background-color: #26890C; }
        .bg-kahoot-purple { background-color: #46178F; }

        /* Sombra dos botões para efeito 3D */
        .kahoot-btn {
            box-shadow: 0px 6px 0px rgba(0, 0, 0, 0.2);
            transition: all 0.1s ease-in-out;
        }

        .kahoot-btn:active {
            transform: translateY(6px);
            box-shadow: 0px 0px 0px rgba(0, 0, 0, 0.2);
        }

        .kahoot-btn:hover {
            filter: brightness(1.1);
        }

        /* Efeitos visuais para respostas */
        .correct-answer {
            animation: pulse-green 1s infinite;
        }

        .wrong-answer {
            opacity: 0.5;
            filter: grayscale(80%);
        }

        @keyframes pulse-green {
            0% { box-shadow: 0 0 0 0 rgba(38, 137, 12, 0.7); }
            70% { box-shadow: 0 0 0 20px rgba(38, 137, 12, 0); }
            100% { box-shadow: 0 0 0 0 rgba(38, 137, 12, 0); }
        }

        /* Barra de tempo */
        .time-bar {
            transition: width 1s linear;
        }

        /* Utilitário para esconder telas */
        .hidden-screen {
            display: none !important;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">

<header class="bg-white shadow-md p-4 flex justify-between items-center z-10 relative">
    <div class="text-3xl font-black text-gray-800 tracking-tighter flex items-center gap-2">
        <span class="text-[#E21B3C]">S</span>
        <span class="text-[#1368CE]">U</span>
        <span class="text-[#D89E00]">P</span>
        <span class="text-[#26890C]">E</span>
        <span class="text-[#46178F]">R</span>
        <span class="ml-2">QUIZ</span>
    </div>
    <div id="header-score-container" class="hidden font-bold text-xl text-gray-600 bg-gray-200 px-4 py-2 rounded-lg">
        Pontos: <span id="header-score">0</span>
    </div>
</header>

<main class="flex-grow flex flex-col justify-center relative w-full max-w-5xl mx-auto p-4 md:p-6">

    <!-- ================= TELA INICIAL ================= -->
    <section id="start-screen" class="flex flex-col items-center justify-center text-center w-full bg-white p-8 md:p-16 rounded-2xl shadow-xl">
        <h1 class="text-4xl md:text-6xl font-black mb-6 text-gray-800">Pronto para testar seus conhecimentos?</h1>
        <p class="text-lg md:text-xl text-gray-600 mb-10">Responda rápido para ganhar mais pontos!</p>

        <button id="start-btn" class="bg-kahoot-purple text-white text-2xl md:text-3xl font-bold py-4 px-12 rounded-lg kahoot-btn w-full md:w-auto">
            Entrar no Jogo
        </button>
    </section>

    <!-- ================= TELA DO QUIZ ================= -->
    <section id="quiz-screen" class="hidden-screen flex-col w-full h-full">

        <!-- Pergunta e Informações -->
        <div class="bg-white rounded-2xl shadow-lg p-6 md:p-10 mb-6 text-center relative overflow-hidden">
            <div class="flex justify-between items-center mb-4 text-gray-500 font-bold">
                <span id="question-counter" class="text-lg">Pergunta 1 de 8</span>
                <div class="flex items-center gap-2 text-2xl">
                    ⏱️ <span id="time-display">20</span>
                </div>
            </div>

            <h2 id="question-text" class="text-2xl md:text-4xl font-bold text-gray-800 mt-4 mb-8">
                Carregando pergunta...
            </h2>

            <!-- Barra de progresso do tempo -->
            <div class="w-full bg-gray-200 h-3 absolute bottom-0 left-0">
                <div id="time-bar" class="bg-kahoot-purple h-full time-bar w-full"></div>
            </div>
        </div>

        <div id="answers-grid" class="grid grid-cols-1 md:grid-cols-2 gap-4 flex-grow">

            <!-- Botão 1: Triângulo Vermelho -->
            <button class="answer-btn bg-kahoot-red text-white text-left p-6 rounded-lg kahoot-btn flex items-center gap-6 group" data-index="0">
                <div class="w-12 h-12 flex-shrink-0 flex items-center justify-center">
                    <svg viewBox="0 0 32 32" fill="white" class="w-10 h-10 drop-shadow-md"><path d="M16 4 L30 28 L2 28 Z"/></svg>
                </div>
                <span class="answer-text text-xl md:text-2xl font-bold drop-shadow-sm flex-grow">Opção 1</span>
            </button>

            <!-- Botão 2: Losango Azul -->
            <button class="answer-btn bg-kahoot-blue text-white text-left p-6 rounded-lg kahoot-btn flex items-center gap-6 group" data-index="1">
                <div class="w-12 h-12 flex-shrink-0 flex items-center justify-center">
                    <svg viewBox="0 0 32 32" fill="white" class="w-10 h-10 drop-shadow-md"><path d="M16 2 L30 16 L16 30 L2 16 Z"/></svg>
                </div>
                <span class="answer-text text-xl md:text-2xl font-bold drop-shadow-sm flex-grow">Opção 2</span>
            </button>

            <!-- Botão 3: Círculo Amarelo -->
            <button class="answer-btn bg-kahoot-yellow text-white text-left p-6 rounded-lg kahoot-btn flex items-center gap-6 group" data-index="2">
                <div class="w-12 h-12 flex-shrink-0 flex items-center justify-center">
                    <svg viewBox="0 0 32 32" fill="white" class="w-10 h-10 drop-shadow-md"><circle cx="16" cy="16" r="14"/></svg>
                </div>
                <span class="answer-text text-xl md:text-2xl font-bold drop-shadow-sm flex-grow">Opção 3</span>
            </button>

            <!-- Botão 4: Quadrado Verde -->
            <button class="answer-btn bg-kahoot-green text-white text-left p-6 rounded-lg kahoot-btn flex items-center gap-6 group" data-index="3">
                <div class="w-12 h-12 flex-shrink-0 flex items-center justify-center">
                    <svg viewBox="0 0 32 32" fill="white" class="w-10 h-10 drop-shadow-md"><rect x="4" y="4" width="24" height="24" rx="2"/></svg>
                </div>
                <span class="answer-text text-xl md:text-2xl font-bold drop-shadow-sm flex-grow">Opção 4</span>
            </button>

        </div>
    </section>

    <!-- ================= TELA DE RESULTADOS ================= -->
    <section id="result-screen" class="hidden-screen flex flex-col items-center justify-center w-full bg-white p-8 md:p-16 rounded-2xl shadow-xl text-center">
        <h2 class="text-4xl md:text-5xl font-black text-gray-800 mb-4" id="result-title">Fim de Jogo!</h2>

        <div class="bg-kahoot-purple text-white p-8 rounded-2xl shadow-lg my-8 w-full max-w-md transform scale-105">
            <p class="text-lg font-bold mb-2 uppercase opacity-80">Pontuação Final</p>
            <p id="final-score" class="text-6xl md:text-7xl font-black">0</p>
        </div>

        <div class="flex flex-col md:flex-row gap-4 md:gap-12 mb-10 text-xl font-bold text-gray-600">
            <div>Acertos: <span id="correct-count" class="text-kahoot-green text-2xl">0</span></div>
            <div>Erros: <span id="wrong-count" class="text-kahoot-red text-2xl">0</span></div>
        </div>

        <button id="restart-btn" class="bg-gray-800 hover:bg-gray-900 text-white text-xl font-bold py-4 px-10 rounded-lg kahoot-btn w-full md:w-auto">
            Jogar Novamente
        </button>
    </section>

</main>

<script>
    // --- 1. BANCO DE PERGUNTAS ---
    const allQuestions = [
        {
            question: "Qual é o maior planeta do Sistema Solar?",
            options: ["Terra", "Marte", "Júpiter", "Saturno"],
            correctAnswer: 2
        },
        {
            question: "Quem pintou a obra-prima 'Mona Lisa'?",
            options: ["Vincent van Gogh", "Leonardo da Vinci", "Pablo Picasso", "Michelangelo"],
            correctAnswer: 1
        },
        {
            question: "Qual é o símbolo químico do Ouro?",
            options: ["Au", "Ag", "O", "Or"],
            correctAnswer: 0
        },
        {
            question: "Em que ano o homem pisou na Lua pela primeira vez?",
            options: ["1959", "1969", "1971", "1980"],
            correctAnswer: 1
        },
        {
            question: "Qual órgão do corpo humano é responsável por bombear o sangue?",
            options: ["Pulmão", "Fígado", "Coração", "Cérebro"],
            correctAnswer: 2
        },
        {
            question: "Qual é a capital do Japão?",
            options: ["Seul", "Pequim", "Tóquio", "Kyoto"],
            correctAnswer: 2
        },
        {
            question: "Quem é o criador do personagem Mickey Mouse?",
            options: ["Walt Disney", "Stan Lee", "Steven Spielberg", "George Lucas"],
            correctAnswer: 0
        },
        {
            question: "Qual é o metal cujo estado natural é líquido à temperatura ambiente?",
            options: ["Chumbo", "Mercúrio", "Cobre", "Alumínio"],
            correctAnswer: 1
        }
    ];

    // --- 2. VARIÁVEIS DE ESTADO ---
    let currentQuestions = [];
    let currentQuestionIndex = 0;
    let score = 0;
    let correctAnswersCount = 0;
    let timerInterval;
    let timeLeft;
    const TIME_LIMIT = 20; // 20 segundos por pergunta
    let isAnsweringAllowed = true;

    // --- 3. SELEÇÃO DE ELEMENTOS DOM ---
    const screens = {
        start: document.getElementById('start-screen'),
        quiz: document.getElementById('quiz-screen'),
        result: document.getElementById('result-screen')
    };

    const ui = {
        startBtn: document.getElementById('start-btn'),
        restartBtn: document.getElementById('restart-btn'),
        questionText: document.getElementById('question-text'),
        answerTexts: document.querySelectorAll('.answer-text'),
        answerBtns: document.querySelectorAll('.answer-btn'),
        timeDisplay: document.getElementById('time-display'),
        timeBar: document.getElementById('time-bar'),
        questionCounter: document.getElementById('question-counter'),
        headerScoreContainer: document.getElementById('header-score-container'),
        headerScore: document.getElementById('header-score'),
        finalScore: document.getElementById('final-score'),
        correctCount: document.getElementById('correct-count'),
        wrongCount: document.getElementById('wrong-count'),
        resultTitle: document.getElementById('result-title')
    };

    // --- 4. FUNÇÕES DO SISTEMA DO JOGO ---

    function switchScreen(screenName) {
        Object.values(screens).forEach(screen => screen.classList.add('hidden-screen'));
        screens[screenName].classList.remove('hidden-screen');
        screens[screenName].classList.add('flex'); // Garante que o display flex volte
    }

    function shuffleArray(array) {
        // Cria uma cópia embaralhada do array para não repetir a mesma ordem
        return array.slice().sort(() => Math.random() - 0.5);
    }

    function initGame() {
        // Reseta variáveis
        currentQuestionIndex = 0;
        score = 0;
        correctAnswersCount = 0;
        updateScoreDisplay();

        // Pega 5 a 8 perguntas aleatórias do banco
        currentQuestions = shuffleArray(allQuestions).slice(0, 8);

        ui.headerScoreContainer.classList.remove('hidden');
        switchScreen('quiz');
        loadQuestion();
    }

    function loadQuestion() {
        isAnsweringAllowed = true;

        // Limpa classes de respostas anteriores
        ui.answerBtns.forEach(btn => {
            btn.classList.remove('correct-answer', 'wrong-answer');
            btn.style.pointerEvents = 'auto'; // Reativa os cliques
        });

        const currentQ = currentQuestions[currentQuestionIndex];
        ui.questionText.innerText = currentQ.question;
        ui.questionCounter.innerText = `Pergunta ${currentQuestionIndex + 1} de ${currentQuestions.length}`;

        // Carrega textos das respostas
        ui.answerBtns.forEach((btn, index) => {
            ui.answerTexts[index].innerText = currentQ.options[index];
        });

        startTimer();
    }

    function startTimer() {
        timeLeft = TIME_LIMIT;
        ui.timeDisplay.innerText = timeLeft;
        ui.timeBar.style.width = '100%';
        ui.timeBar.style.transition = 'none'; // Reseta transição instantaneamente

        // Força um reflow para garantir que a barra inicie cheia antes de animar
        void ui.timeBar.offsetWidth;

        ui.timeBar.style.transition = `width ${TIME_LIMIT}s linear`;
        ui.timeBar.style.width = '0%';

        clearInterval(timerInterval);
        timerInterval = setInterval(() => {
            timeLeft--;
            ui.timeDisplay.innerText = timeLeft;

            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                handleTimeOut();
            }
        }, 1000);
    }

    function handleAnswerClick(e) {
        if (!isAnsweringAllowed) return;

        const btn = e.currentTarget;
        const selectedIndex = parseInt(btn.getAttribute('data-index'));
        checkAnswer(selectedIndex, btn);
    }

    function handleTimeOut() {
        if (!isAnsweringAllowed) return;
        isAnsweringAllowed = false;

        // Revelar resposta correta
        const correctIndex = currentQuestions[currentQuestionIndex].correctAnswer;
        ui.answerBtns.forEach((btn, index) => {
            if (index === correctIndex) {
                btn.classList.add('correct-answer');
            } else {
                btn.classList.add('wrong-answer');
            }
            btn.style.pointerEvents = 'none';
        });

        setTimeout(nextQuestion, 2500);
    }

    function checkAnswer(selectedIndex, selectedBtn) {
        isAnsweringAllowed = false;
        clearInterval(timerInterval);

        // Pausa a animação da barra de tempo onde estiver
        const currentWidth = ui.timeBar.getBoundingClientRect().width;
        const parentWidth = ui.timeBar.parentElement.getBoundingClientRect().width;
        const percentage = (currentWidth / parentWidth) * 100;
        ui.timeBar.style.transition = 'none';
        ui.timeBar.style.width = `${percentage}%`;

        const correctIndex = currentQuestions[currentQuestionIndex].correctAnswer;
        const isCorrect = selectedIndex === correctIndex;

        if (isCorrect) {
            // Calcula pontuação baseada no tempo restante (Mínimo 500, Máximo 1000)
            const timeRatio = timeLeft / TIME_LIMIT;
            const pointsEarned = Math.round(500 + (500 * timeRatio));
            score += pointsEarned;
            correctAnswersCount++;
            updateScoreDisplay();

            selectedBtn.classList.add('correct-answer');
        } else {
            selectedBtn.classList.add('wrong-answer');
            // Destaca a correta
            ui.answerBtns[correctIndex].classList.add('correct-answer');
        }

        // Esmaece as outras opções
        ui.answerBtns.forEach((btn, index) => {
            btn.style.pointerEvents = 'none';
            if (index !== correctIndex && index !== selectedIndex) {
                btn.classList.add('wrong-answer');
            }
        });

        // Aguarda 2.5s antes da próxima pergunta
        setTimeout(nextQuestion, 2500);
    }

    function updateScoreDisplay() {
        ui.headerScore.innerText = score;
    }

    function nextQuestion() {
        currentQuestionIndex++;
        if (currentQuestionIndex < currentQuestions.length) {
            loadQuestion();
        } else {
            endGame();
        }
    }

    function endGame() {
        ui.headerScoreContainer.classList.add('hidden');

        ui.finalScore.innerText = score;
        ui.correctCount.innerText = correctAnswersCount;
        ui.wrongCount.innerText = currentQuestions.length - correctAnswersCount;

        const percentage = (correctAnswersCount / currentQuestions.length) * 100;
        if (percentage === 100) {
            ui.resultTitle.innerText = "Perfeito! Você é um gênio!";
        } else if (percentage >= 70) {
            ui.resultTitle.innerText = "Muito Bom!";
        } else if (percentage >= 40) {
            ui.resultTitle.innerText = "Bom esforço!";
        } else {
            ui.resultTitle.innerText = "Mais sorte na próxima!";
        }

        switchScreen('result');
    }

    // Configuração dos Event Listeners
    ui.startBtn.addEventListener('click', initGame);
    ui.restartBtn.addEventListener('click', initGame);

    ui.answerBtns.forEach(btn => {
        btn.addEventListener('click', handleAnswerClick);
    });

</script>
</body>
</html>