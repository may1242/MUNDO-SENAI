package com.senai.service;

import com.senai.model.Trilha;
import com.senai.repository.TrilhaRepository;
import java.util.List;

public class TrilhaService {

    private final TrilhaRepository repository;
    private final List<Trilha> trilhas;

    public TrilhaService(TrilhaRepository repository) {
        this.repository = repository;
        this.trilhas = repository.carregarCursos();
    }

    public List<Trilha> getCursos() {
        return trilhas;
    }

    public Trilha getVencedor() {
        if (trilhas == null || trilhas.isEmpty()) {
            return null;
        }

        Trilha vencedor = trilhas.get(0);
        for (Trilha t : trilhas) {
            if (t.getVotos() > vencedor.getVotos()) {
                vencedor = t;
            }
        }
        return vencedor;
    }

    public int getTotalVotosGerais() {
        if (trilhas == null) return 0;
        int total = 0;
        for (Trilha t : trilhas) {
            total += t.getVotos();
        }
        return total;
    }
}